@isTest(seeAllData=true)
private class Test_CreateCaseOnAccountingContact1
{    
    static testmethod void vaidate_CreateCaseOnAccountingContact()
    {
        Account acc_1 = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc_1;
        recordtype rec =[SELECT id from recordtype where name='resource contact' AND Sobjecttype='Contact'];
        recordtype rec2 =[SELECT id from recordtype where Sobjecttype='Case' limit 1];
        Contact con_1 = new Contact(recordtypeId=rec.id,accountId=acc_1.id,lastname='test', firstname = 'test');
        insert con_1;
        Contact con_2 = new Contact(recordtypeId=rec.id,accountId=acc_1.id,lastname='test2', firstname = 'test');
        insert con_2;
        set<id> s = new set<id>();
        s.add(con_1.id);
        CreateCaseOnAccountingContact.isAccountingContactUpdated(con_1,con_2);
        CreateCaseOnAccountingContact.createCase(s,rec2.id);
    }
}