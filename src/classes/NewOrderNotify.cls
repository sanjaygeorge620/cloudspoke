/*
 * Controller for a component to create an email summarizing order data.
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-09-23
 */
public class NewOrderNotify {
    public Opportunity opportunity {get; set;}
    public String opportunityId;
    public NewOrderNotifyData orderNotifyData{get;set;}
    public String opportunityViewURL{get;set;}
    public String orderViewURL{get;set;}
    private String baseURL;
    private String imageNowHost;
    
     public class NewOrderNotifyData{
        public String primaryContact {get; set;}
        public Concession_Form__c concessionForm{get;set;}
        public String AEXName {get;set;}
        public String ISRName {get;set;}
        public String ManagerName {get;set;}
        public List<LineItemWrapper> lineItems {get; set;}
        
        public NewOrderNotifyData(){
            AEXName = '';
            ISRName = '';
            ManagerName ='';
        }
    }  
    
    public class LineItemWrapper{
        public OpportunityLineItem lineItem{get;set;}
        public String productName{get;set;}
        public LineItemWrapper(OpportunityLineItem lineItem,String productName){
            this.lineItem = lineItem;
            this.productName = productName;
        }
    }    
    public String getOpportunityId() {
        return opportunityId;
    }
    
    public void setOpportunityId(String op) {
        try {
            /*List<Opportunity> opportunities = [
                    select 
                        id,
                        Name,
                        Account.Name,
                        currencyIsoCode,
                        Amount,
                        Sector__c,
                        Type,
                        CloseDate,
                        BPQ_License__c,
                        License_Revenue__c,
                        Opportunity_Number__c,
                        ISR__c,
                        ISR__r.Name,
                        Owner.Name,
                        Owner.Manager.Name,
                        BPQ_Professional_Services__c,
                        Book_Database_Services__c,
                        BPQ_Managed_Services__c,
                        BPQ_Platform_Services__c,
                        BM_Third_Party__c,
                        BM_Training__c,
                        BM_Subscription__c,
                        BPQ_Platform__c,
                        BPQ_Remote_Admin__c,
                        BPQ_SMSA__c,
                        BM_Platform__c,
                        BM_Remote_Admin__c,
                        BM_SMSA__c
                        
                    from 
                        opportunity 
                    where 
                        id = :op];*/
                        
                        //opplist = (List<Opportunity>)(database.query('Select
                        
            List<Opportunity> opportunities = (List<Opportunity>)(database.query('Select id,Name,Account.Name,currencyIsoCode,Amount,Sector__c,Type,CloseDate,BPQ_License__c,License_Revenue__c,Opportunity_Number__c,ISR__c,ISR__r.Name,Owner.Name,Owner.Manager.Name,BPQ_Professional_Services__c,Book_Database_Services__c,BPQ_Managed_Services__c,BPQ_Platform_Services__c,BM_Third_Party__c,BM_Training__c,BM_Subscription__c,BPQ_Platform__c,BPQ_Remote_Admin__c,BPQ_SMSA__c,BM_Platform__c,BM_Remote_Admin__c,BM_SMSA__c from opportunity where id =: op'));
            
            if (opportunities.size() == 1) {
                opportunity = opportunities.get(0);
                opportunityId = op;
                init();
            } 
        }
        catch(Exception e) {
            System.debug('Exception caught '+e);
        }
    }

    public void setupPrimaryContact() {
        List<OpportunityContactRole> opportunityRoles = [
                select 
                    contact.name, 
                    contact.phone, 
                    isPrimary
                from 
                    OpportunityContactRole 
                where 
                    OpportunityId = :opportunity.id and isPrimary = true];
        if (opportunityRoles.size() == 1) {
            OpportunityContactRole opportunityRole = opportunityRoles.get(0);
            orderNotifyData.primaryContact = opportunityRole.Contact.Name + ', ' + opportunityRole.Contact.Phone;
        }
            
    }
    
    public void loadConcessionForm(){
        List<Concession_Form__c> ConcessionForms = [
                select 
                    Id, 
                    Name,
                    Database_Srvc__c,
                    Total_Amount_Difference__c,
                    Total_Amount_Percent__c,
                    License_Difference__c,
                    License_Amount_Percent__c,
                    License_Conc_Comment__c,
                    Mngd_Srvc_Diference__c,
                    Mngd_Srvc_Percent__c,
                    Mngd_Srvc_Concession_Comment__c,
                    Platform_Difference__c,
                    Platform_Percent__c,
                    Platform_Concession_Comment__c,
                    Platform_Srvc_Difference__c,
                    Platform_Srvc_Percent__c,
                    Platform_Srvc_Concession_Comment__c,
                    Prof_Srvcs_Difference__c,
                    Prof_Srvcs_Percent__c,
                    Tech_Srvcs_Difference__c,
                    Tech_Srvcs_Percent__c,
                    Tech_Srvcs_Concession_Comment__c,
                    Remote_Admin_Difference__c,
                    Remote_Admin_Percent__c,
                    Remote_Admin_Concession_Comment__c,
                    SMSA_Percent__c,
                    SMSA_Concession_Comment__c,
                    SMSA_Difference__c,
                    Subscription_Difference__c,
                    Subscription_Percent__c,
                    Subscription_Concession_Comment__c,
                    Training_Difference__c,
                    Training_Percent__c,
                    Training_Concession_Comment__c,
                    X3rd_Party_Difference__c,
                    X3rd_Party_Percent__c,
                    X3rd_Party_Concession_Comment__c 
                from
                    Concession_Form__c 
                where 
                    Opportunity__c =: opportunity.Id and
                    primary__c = true];
       if(ConcessionForms != null && ConcessionForms.size() > 0){
            orderNotifyData.concessionForm = ConcessionForms.get(0);
       }
   }
   
   public void loadSalesTeam() {
      if (opportunity.ISR__c != null){
          orderNotifyData.ISRName = opportunity.ISR__r.name;
      }
      orderNotifyData.AEXName = opportunity.owner.name;
      if(opportunity.Owner.ManagerId != null){        
        orderNotifyData.ManagerName = opportunity.Owner.Manager.name;
      }
    
  }
  
   public void loadLineItems() {
      orderNotifyData.lineItems = new List<LineItemWrapper>();
      for(OpportunityLineItem lineItem : [
            select 
                id,
                PricebookEntry.Name,
                UnitPrice, 
                Quantity, 
                TotalPrice 
            From 
                OpportunityLineItem
            where 
                opportunityId = :opportunity.Id]){
                    orderNotifyData.lineItems.add(new LineItemWrapper(lineItem,wrapProductName(lineItem.PricebookEntry.Name)));
                }
  }
  /*
  private String loadBaseURL(){
    if (baseURL != null) {
        return baseURL;
    }
    
    URL_Parameter__c param = [
            select
                URL_Value__c
            from
                URL_Parameter__c
            where
                name = 'Org Host'
            limit 1];
    
    if(param != null){
        baseURL = param.URL_Value__c;
    }
    return baseURL;
  }*/
  private String loadImageNowURL() {
    if (imageNowHost != null) {
        return imageNowHost;
    }
    
    URL_Parameter__c param = [
            select
                URL_Value__c
            from
                URL_Parameter__c
            where
                name = 'ImageNow Host'
            limit 1];
    
    if(param != null){
        imageNowHost = param.URL_Value__c;
    }
    return imageNowHost;
  }
  
  private void init(){
    orderNotifyData = new NewOrderNotifyData();
    setupPrimaryContact();
    loadConcessionForm();
    loadSalesTeam();
    loadLineItems();
    opportunityViewURL = URL.getSalesforceBaseUrl().toExternalForm()+ '/' + opportunityId;
    orderViewURL = loadImageNowURL() + '/webnow/index.jsp?action=document&field3='+opportunity.get('Opportunity_Number__c');
  }

  private String wrapProductName(String productName){
    String wrappedProductName = '';
    if(productName != null && productName.length() > 20){
        String[] splitProductName = productName.split(' ');
        String tempProductName = '';
        for(String str : splitProductName){
            tempProductName += str +' ';
            if(tempProductName.length() > 20){
                wrappedProductName += tempProductName +'<br/>';
                tempProductName  = '';
            }
        }
        wrappedProductName += tempProductName;
    }else{
        wrappedProductName = productName;
    }
        System.debug('------String------'+wrappedProductName); 
        return wrappedProductName;
  }
    // Method written to improve test coverage
    public void callwrapProductName(String productName){
        wrapProductName(productName);
    }
  
}