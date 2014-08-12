/* Class Name   : LX_Evaluation_Form
    * Description   : This class is a controller for "LX_Evaluation_Form" page to provide 
    *                a selection of evaluation products (from evaluation unit detail) to be
    *                sold or replaced or returned
    * Created By   : Sumedha K.
    * Created Date : 11-20-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            11-20-2013               1000                Initial Version    
    */
public class LX_Evaluation_Form{
   // List to add evaluation unit detail records
    public List<lineItems> wrevalDetailList{get;set;}
   // variable to store form record to which changes are made
    public LX_Evaluation_Unit_Disposition_Forms__c form{get;set;}
   // variable to store the sales price of a product entered by the user. 
   // variable to store evaluation unit detail record
    public List<LX_Evaluation_Unit_Details__c> evalDetailList; 
    
  
    // variable to store the evaluation Unit field ID to autofill the value from the query
    public ID evalUnitID = ApexPages.currentPage().getParameters().get(label.lx_evaluationunit);
    // variable to store the record type selected by the user on the evaluation form
    public ID recTypeID = ApexPages.currentPage().getParameters().get(Label.LX_RecordType); 
   
    
    public boolean showField{get; set;}
    public LX_Evaluation_Form(ApexPages.StandardController controller) {
    
    System.debug('>>>>>>>>>>>>>evaluation unit id >>>>>>>>>>'+evalUnitID);
     // query for all detail records based on evaluation unit ID and whose status is 'open' or 'requested return'
        evalDetailList = [SELECT LX_Evaluation_Product__c, LX_Evaluation_Product__r.LX_Seed_Order_Request__c, Name, 
                             LX_Part_Number__c, LX_Order_number__c, LX_Product_Description__c,LX_Ship_Date__c, 
                             LX_Status__c,LX_Evaluation_Product__r.LX_Product__r.Cost__c,LX_Sales_Price__c
                        FROM LX_Evaluation_Unit_Details__c
                        WHERE LX_Evaluation_Product__r.LX_Seed_Order_Request__c =:evalUnitID AND LX_Status__c IN ('Open','Requested Return')];
         
         System.debug('>>>>>>>evalDetailList >>>>>>>>'+evalDetailList );
        if(recTypeID != null){
            Recordtype rec = [Select id, name from Recordtype where id=:recTypeId];
            if(rec.Name != 'Sell')
                showField = false;
            else
                showField = true;    
        }              
        System.debug('^^^^^^^^^^^^^'+evalDetailList );
        wrevalDetailList = new List<lineItems>();
       // creating a form records and displaying on VF page
        form = new LX_Evaluation_Unit_Disposition_Forms__c(LX_Evaluation_Unit__c = evalUnitID,RecordTypeId=recTypeID);
       // add the detail records queried to wrapper variable and use it to display the records with checkbox on vf page
       system.debug(evalDetailList.size()+'######size');
        if(evalDetailList.size()>0){
          for(LX_Evaluation_Unit_Details__c eprod : evalDetailList){
              lineItems wr = new lineItems(false,eprod,form.id);
              wrevalDetailList.add(wr);
          }
          // display error if the detail record does not return queries
          if(wrevalDetailList.size()==0){
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'Sorry, there are no evaluation unit details for this evaluation uinit.');
            ApexPages.addMessage(message);
          }
        } 
                   
    }
    
   /*
     * 
     * Description : This action method is called when a user tries to save a evaluation unit detail record
     * Param   : null
     * Returns :  pagereference
    */
    public Pagereference saveForm(){
    List<LX_Evaluation_Unit_Details__c> evalDetailSaveList = new List<LX_Evaluation_Unit_Details__c>();
    Pagereference page;
      if(wrevalDetailList.size()>0){
      System.debug('wrevalDetailList '+wrevalDetailList);
          try{
          // Inserting the form which is displayed on the VF page. This is the header object
             insert form;
          }catch(Exception ex){
           ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'We are not able to save the form. Please check the data entered.');
            ApexPages.addMessage(message);
            System.debug('Please contact Admin'+ex.getMessage());
          }
          for(lineItems wr : wrevalDetailList){ 
           System.debug('>>>>>>>>>>here');
           // Add all the detail records selected from the page block table and add it to a different list
             if(wr.isSelected == TRUE){
               System.debug('>>>>>>>>>>here');
               wr.evalDetail.LX_Evaluation_Unit_Disposition_Form__c = form.id;
              // LX_Evaluation_Unit_Details__c  evalDSave = new LX_Evaluation_Unit_Details__c (LX_Order_Number__c='',LX_Sales_Price__c=salesprice,LX_Evaluation_Unit_Disposition_Form__c=form.id,LX_Evaluation_Product__c = wr.evalDetail.LX_Evaluation_Product__c);
               evalDetailSaveList.add(wr.evalDetail);
             }
          }
          try{
          // save the evaluation unit detail records list
              upsert evalDetailSaveList;
              System.debug('Evaluation Detail List'+evalDetailSaveList);
              page = new Pagereference('/'+form.Id);
          }catch(Exception ex){
           ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'We are not able to save the form. Please check the data entered.');
            ApexPages.addMessage(message);
             System.debug('Please contact admin');
          }
      }
      System.debug('Page : '+page);
      return page;
    }
    
    /*
     * 
     * Description : This is a wrapper class used to add evaluation unit detail records
     * Param   : null
     * Returns :  null
    */
    public class lineItems{
      public LX_Evaluation_Unit_Details__c evalDetail{get;set;}
      public Boolean isSelected {get;set;}
      public lineItems(Boolean check,LX_Evaluation_Unit_Details__c evalDet,ID evalID){
       this.evalDetail = evalDet;
       this.isSelected = check;
       evalDetail.LX_Evaluation_Unit_Disposition_Form__c = evalID;
      }
    }
    
}