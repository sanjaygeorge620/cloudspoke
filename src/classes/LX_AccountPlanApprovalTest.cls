@isTest(SeeAllData = True)
private class LX_AccountPlanApprovalTest {

    static TestMethod void Test2_TestMultipleValues() {
        List<String> values = new List<String>();
        for (integer i = 0; i < 100; i++) {
            values.add('Test' + i);
        }

        insertAccountsWithField2Values(values);

        List<Account> objects = [Select Name, Hidden_Submitter_ManagerId__c from Account where Name in : values Order By Name];

        for (Account obj: objects) {
            System.assertEquals(obj.Name, obj.Hidden_Submitter_ManagerId__c, 'Account' + obj.Name + 'Name and Hidden_Submitter_ManagerId__c differ');
        }
    }
    

    private static void insertAccountsWithField2Values(List<String> fieldValues) {
        integer i = 0;
        List<Account> objs = new List<Account>();
        for (string value: fieldValues) {
            Account obj = new Account();
            obj.Hidden_Submitter_ManagerId__c = value;
            obj.Name = 'Test' + i;
            obj.BillingCountry = 'USA';
            obj.Physical_Country__c = obj.BillingCountry;
            objs.add(obj);
            i++;
        }
        insert objs;
    }
}