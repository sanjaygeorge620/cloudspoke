@isTest
private class Test_CaseChannelSubmitted {

    static testMethod void Test_CaseChannelSubmitted() {

        Account acc = Data_Account.createAccount();
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);     
        
        List<Case> cases = Data_Case.createCase(acc, contacts[0], 'Partner-Channel', 1);    
        URL_Parameter__c obj = new URL_Parameter__c();
        obj.name = 'Test 1 Org Host';
        obj.URL_Value__c = 'tes12233t.com';
        insert obj;
        CaseChannelSubmitted.CaseChannelSubmitted(cases[0], contacts[0]);
  

    }
}