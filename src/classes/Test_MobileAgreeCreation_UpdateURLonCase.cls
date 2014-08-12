@isTest
private class Test_MobileAgreeCreation_UpdateURLonCase {
    static testMethod void Test_MobileAgreementRecord_Creation() {
        
        Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
        Id MRrtId = rtMap.get('Mobile Request').getRecordTypeId();
        Test.startTest();
        Account acc = Data_account.createAccount2();
        List<Contact> lstcon = Data_Contact.createContacts(acc.Id,2);
        Contact con;
        con = lstcon[0];
        Case c = new Case(RecordTypeId = MRrtId,Status = 'New',Type = 'Request',ContactId = con.Id);
        insert c;
        //c.Status = 'Open-Needs Customer Attention';
        //update c;
        Test.stopTest();
    
    }
}