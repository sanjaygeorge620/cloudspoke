/*
Class Name : LX_MasterQuoteExtn
Description : controller class to delete mqli to display and delte mqli records with same parent Id as and child Opp id as the one
             being delted by overwriting the delete button
Created By : Veenu Trehan(vtrehan@deloitte.com)
Created Date :12/11/2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan     12/11/2013         1000                   Initial Version
                
*************************************************************************/
public class LX_MasterQuoteExtn {

    private LX_Master_Quote_Line_Item__c MQrecd;
    public List<LX_Master_Quote_Line_Item__c> del_MQList{set;get;}//list to store records to be deleted
    
    //controller 
    public LX_MasterQuoteExtn(ApexPages.StandardController controller) {
        del_MQList=new List<LX_Master_Quote_Line_Item__c>();
        MQrecd =(LX_Master_Quote_Line_Item__c ) controller.getrecord();
        string idval = MQrecd.id;
        //querring the mqli record and its parentid which is being deleted
        MQrecd =[select id, name,LX_Opportunity__c,LX_ParentID__c   from LX_Master_Quote_Line_Item__c where id=:idval  limit 1  ];
        if(MQrecd != null){
          If(MQrecd.LX_ParentID__c!=null && MQrecd.LX_ParentID__c!=''){   
          //  Commented : Sumedha due to error 1/31: del_MQList = database.query(String.escapeSingleQuotes(getquery()));
           del_MQList = database.query(getquery());
          }
            system.debug(del_MQList +'******');
        }else{
           ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,Label.LX_No_Record);
           ApexPages.addMessage(message);
        }
    }
    //getting the list of fieldset to display fields of reocrds on the vf page
     public List<Schema.FieldSetMember> getFields() {
        return SObjectType.LX_Master_Quote_Line_Item__c.FieldSets.DeletePageColoumn.getFields();
    }
    //creating the query
    private String getquery() {
        String query = 'SELECT ';
        boolean flag= false;
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
            if(f.getFieldPath()=='LX_Opportunity__c')
                flag = true;
        }
        
        if(flag){
            query += 'Id FROM LX_Master_Quote_Line_Item__c where LX_ParentID__c=\''+MQrecd.LX_ParentID__c+'\' and LX_Opportunity__c=\''+MQrecd.LX_Opportunity__c+'\'';
       }
        else{
            query += 'Id,LX_Opportunity__c, LX_ParentID__c  FROM LX_Master_Quote_Line_Item__c where LX_ParentID__c=\''+MQrecd.LX_ParentID__c+'\' and LX_Opportunity__c=\''+MQrecd.LX_Opportunity__c+'\'';
        }
         system.debug(query+'@@@@' );
        return query ;
       
    }
    
    //method called to delte the list of records and redirect to the Opportunity record
    public  pagereference deleteList(){
    try{
        delete  del_MQList ;
        pagereference pg = new Pagereference('/'+MQrecd.LX_Opportunity__c);
        pg .setRedirect(true);
        
        return pg;
    }catch(exception ex){
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Couldnt delete the records.'));
         LX_CommonUtilities.createExceptionLog(ex);
        return null;
    }
    
    }
    
    //if there is only one record with the parent id then the method is called to delete the single reocrd
     public  pagereference deleteSingle(){
        try{
            
            delete  MQrecd;
            pagereference pg = new Pagereference('/'+MQrecd.LX_Opportunity__c);
            pg.setRedirect(true);
            return pg;
        }catch(exception ex){
          //  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Couldnt delete the records.'));
             LX_CommonUtilities.createExceptionLog(ex);
            return null;
        }
    
    }
    //to redirect to the opportunity on clicking the cancel button
    public pagereference Cancel(){
        pagereference pg = new Pagereference('/'+MQrecd.LX_Opportunity__c);
        pg.setRedirect(true);
        return pg;
    }


}