/*
 * Class to setup the New Order Summary page for printing.
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-09-21
 */
public class NewOrderSummary {
  /* Data structure to hold contact information */
  public class NewOrderSummaryData {
    /* Contact data */
    public String primaryName {get;set;}
    public String primaryPhone {get;set;}
    public String primaryEmail {get;set;}

    /* User data */
    public String AEXName {get;set;}
    public String ISRName {get;set;}
    public String ManagerName {get;set;}
  }

  public Opportunity opportunity {get; set;}
  public NewOrderSummaryData contacts {get; set;}
  public List<OpportunityLineItem> lineItems {get; set;}
  public Concession_Form__c concessionForm {get; set;}
  
  /* Constructor, sets up the variables */
  public NewOrderSummary() {
    /* setup opportunity */
    setupOpportunity(ApexPages.currentPage().getParameters().get('o'));

    /* if success, proceed */
    if (opportunity != null && opportunity.id != null) {
        setupContacts();
        setupRoles();    
        loadLineItems();
        loadConcessionForms();
    }
  }
  
  /* Instantiate our opportunity */
  public void setupOpportunity(Id opportunityId) {
    try {
            List<Opportunity> opportunities = [
            select 
                account.name, 
                name, 
                sector__c, 
                type, 
                Tax_Exempt__c,
                closedate, 
                amount,
                currencyIsoCode,
                license_revenue__c,
                BPQ_License__c,
                Partner_Referral_Fee_Applicable__c,
                Special_Notes__c,
                ISR__c,
                ISR__r.Name,
                Owner.Name,
                Owner.Manager.Name,
                Project_Contact__r.Name,
                Project_Contact__r.Phone,
                Project_Contact__r.Email ,
                Bill_To__r.Name,
                Bill_To__r.Phone,
                Bill_To__r.Email,
                Ship_To__r.Name,
                Ship_To__r.Phone,
                Ship_To__r.Email,
                BPQ_Professional_Services__c,
                BPQ_Managed_Services__c,
                Book_Database_Services__c,
                BPQ_Platform_Services__c,
                BPQ_Third_Party__c,
                BPQ_Training__c,
                BPQ_Subscription__c,
                BPQ_Platform__c,
                BPQ_SMSA__c,
                Bill_To_Name__c,
                LX_Bill_To_Email_Address__c,
                Ship_To_Name__c    
                
                
            from 
                opportunity 
            where 
                id = :opportunityId];
        if (opportunities.size() == 1) {
            opportunity = opportunities.get(0);
        }
    }catch(Exception ex){
        System.debug('Exception'+ex);
        LX_CommonUtilities.createExceptionLog(ex);
    }
  }
  
  /* Setup contacts that we require which are associated with this opportunity */
  public void setupContacts() {
    contacts = new NewOrderSummaryData();
    List<OpportunityContactRole> opportunityRoles = [
            select 
                contact.name, 
                contact.phone, 
                contact.email
            from 
                OpportunityContactRole 
            where 
                OpportunityId = :opportunity.id and isPrimary = true];
    if (opportunityRoles.size() == 1) {
        OpportunityContactRole opportunityRole = opportunityRoles.get(0);
        contacts.primaryName  = opportunityRole.contact.name;
        contacts.primaryPhone = opportunityRole.contact.phone;
        contacts.primaryEmail = opportunityRole.contact.email;
    }
  }

  /* Setup users that we require who are associated with this opportunity */
   public void setupRoles() {
     if (opportunity.ISR__c != null){
         contacts.ISRName = opportunity.ISR__r.name;
     }
     contacts.AEXName = opportunity.owner.name;
     if(opportunity.Owner.ManagerId != null){        
        contacts.ManagerName = opportunity.Owner.Manager.name;
     }
  }
  
  /* */
  public void loadLineItems() {
      lineItems = new List<OpportunityLineItem>();
      lineItems = [
            select 
                id,
                PricebookEntry.Name,
                UnitPrice, 
                Quantity, 
                TotalPrice 
            From 
                OpportunityLineItem 
            where 
                opportunityId = :opportunity.Id];
  } 
  
  /* */
  public void loadConcessionForms() {
       concessionForm = new Concession_Form__c();
       List<Concession_Form__c> concessions = [
            select 
                Id,
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
                Prof_Srvcs_Concession_Comment__c,
                Remote_Admin_Difference__c,
                Remote_Admin_Percent__c,
                Remote_Admin_Concession_Comment__c,
                SMSA_Percent__c,
                SMSA_Concession_Comment__c,
                SMSA_Difference__c,
                Subscription_Difference__c,
                Subscription_Percent__c,
                Subscription_Concession_Comment__c,
                Tech_Srvcs_Difference__c,
                Tech_Srvcs_Percent__c,
                Tech_Srvcs_Concession_Comment__c,
                Training_Difference__c,
                Training_Percent__c,
                Training_Concession_Comment__c,
                X3rd_Party_Difference__c,
                X3rd_Party_Percent__c,
                Database_Srvc__c,
                X3rd_Party_Concession_Comment__c
            from 
                Concession_Form__c 
            where
                opportunity__c = :opportunity.Id and
                primary__c = true];
       if(concessions.size() == 1) {
           concessionForm = concessions.get(0);
       }
  }
}