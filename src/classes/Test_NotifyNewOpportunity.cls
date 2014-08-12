@isTest
private class Test_NotifyNewOpportunity {

    static testMethod void Test_NotifyNewOpportunity() {

        Account acc = Data_Account.createAccount();
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);     
        
        List<ID> ContactEmailList = new List<ID>();
        
        contactEmailList.add(contacts[0].id);
        
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1); 
        id opportunityID = test_opportunities[0].id;
        
        NotifyNewOpportunity.NotifyNewOpportunity(contactEmailList, opportunityID);
  

    }
}