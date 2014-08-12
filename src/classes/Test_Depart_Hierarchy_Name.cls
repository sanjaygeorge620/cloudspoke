@isTest
private class Test_Depart_Hierarchy_Name {
    static testMethod void Test_Depart_Hierarchy_Name() {
        
        Test.startTest();
        Department_Hierarchy__c dept = new Department_Hierarchy__c(Name = 'Test123',Alias__c = 'atest');
        insert dept;
        Department_Hierarchy__c dpt;
        dpt = [select Id,Name,Alias__c from Department_Hierarchy__c where Name='Test123' and Alias__c = 'atest' limit 1];
        Department_Hierarchy__c dept1 = new Department_Hierarchy__c(Name = 'Test456',Alias__c = 'testa',Parent_Department__c = dpt.Id);
        insert dept1;
        Test.stopTest();
    
    }
}