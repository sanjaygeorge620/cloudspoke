/* Class Name    : LX_OfferingExtension 
 * Description   : This is an extension for the offering related list vf page "LX_Offering_Related_List"
 * Created By    : Veenu Trehan (Deloitte)
 * Created Date  : 9-24-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                  Date        Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
  * Veenu Trehan            9-24-2013                          Initial Version                 
 */

public class LX_OfferingExtension {
    public string id{get;set;}
    public String SelectedOfferingId{get;set;}
    public Opportunity OppRec{get;set;}
    public list<Solution_Business_Process__c> OfferingList{get;set;}
    
        public LX_OfferingExtension(ApexPages.StandardController stdController) {
            
             if(stdController.getId() != null){
             OppRec=new Opportunity ();
             OfferingList=new list<Solution_Business_Process__c>();
             OppRec=[SELECT Id,Name from Opportunity
                     WHERE ID=:stdController.getId()];
             id= stdController.getId();                     
             OfferingList=[SELECT Id,Account__r.Name,Account__c,Sector__c,Business_Solution__c,Solution_Status__c,Opportunity__c,CreatedDate,RecordTypeId,RecordType.Name 
                           FROM Solution_Business_Process__c
                           WHERE Opportunity__c = :id
                           ORDER BY CreatedDate DESC];
             }
    
        }
        
         public pagereference DeleteOffering()  {
   
      // find the record within the collection
      Solution_Business_Process__c tobeDeleted = new Solution_Business_Process__c(id=SelectedOfferingId);
      system.debug('>>>>>>>>>>>>>>>>>>SelectedAccountId>>>>>>>>'+SelectedOfferingId);
      
      //if record found delete it
      if (SelectedOfferingId!= null) {
       Delete tobeDeleted;
      
      }
             OfferingList=[SELECT Id,Account__r.Name,Account__c,Sector__c,Business_Solution__c,Solution_Status__c,Opportunity__c,CreatedDate,RecordTypeId,RecordType.Name 
                           FROM Solution_Business_Process__c
                           WHERE Opportunity__c = :id
                           ORDER BY CreatedDate DESC];
        
      return null;
}
    

}