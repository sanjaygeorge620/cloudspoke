public class EditNewOrderRequest_Extension {
      public LX_New_Order_Request__c thisReq{get;set;}
      public ID newOrderReqID {get;set;}
      public ID OppID {get;set;}
      ApexPages.standardController m_sc;
    
      public EditNewOrderRequest_Extension(ApexPages.standardController sc){
          m_sc = sc;
          newOrderReqID = ApexPages.currentPage().getParameters().get('id');
          thisReq = [Select LX_Account_Name__c, LX_Bill_To_ID__c, LX_Ship_To_ID__c, LX_Opportunity__c, LX_SAP_Contract_Number__c, LX_License_End_User__c, License_Contact__c, LX_SMSA_End_Date__c, LX_SMSA_Start_Date__c, LX_PO_Number__c, LX_Special_Billing_Instructions__c from LX_New_Order_Request__c where id =:newOrderReqID];
      }
    
      public PageReference doCancel(){
          return m_sc.cancel();
      }
      public PageReference saveNewReq(){ 
        Pagereference pg = null;
         try{
                update thisReq;
            pg = new Pagereference('/'+thisReq.Id);
         }catch(Exception ex){
           ApexPages.addMessages(ex);
         }
         return pg;
      }
}