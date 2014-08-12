public class CreateNewOrderRequest_Extension {
      public LX_New_Order_Request__c newReq{get;set;}
      public ID sapContractID {get;set;}
      public ID OppID {get;set;} 
      ApexPages.standardController m_sc = null;
    
      public CreateNewOrderRequest_Extension (ApexPages.standardController sc){
          sapContractID = ApexPages.currentPage().getParameters().get('sapContractId');
          OppID = ApexPages.currentPage().getParameters().get('oppId');
          newReq = new LX_New_Order_Request__c(LX_Opportunity__c = oppId,LX_SAP_Contract__c=sapContractID);
          m_sc = sc;
      }
    
      public PageReference doCancel(){
         // return m_sc.cancel();
        PageReference pageRef = new PageReference('/' + sapContractID);
        pageRef.setRedirect(true);
        return pageRef;
      }
      public PageReference saveNewReq(){ 
        Pagereference pg = null;
         try{
            insert newReq;
            pg = new Pagereference('/'+newReq.Id);
         }catch(Exception ex){
           ApexPages.addMessages(ex);
         }
         return pg;
      }
}