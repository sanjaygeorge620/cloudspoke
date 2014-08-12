/**
 * Name: Test_AutoCreated_Enable
 *
 * Description: to provide code coverage for AutoCreated_Enable trigger
 *
 * Created Date: 1/12/2012
 */
@isTest
private class Test_AutoCreated_Enable {

    static testMethod void Test_AutoCreated_Enable() {
        Test.startTest();        
        //add account record
        Account acctRec = new Account();
        acctRec.Name = 'Accounttest';
        acctRec.Type = 'Customer';
        acctRec.Sector__c = 'Federal';
        acctRec.Physical_Country__c = 'USA'; acctRec.BillingCountry = 'USA';
        insert acctRec;
        
        //add contact record
        Contact contactRec = new Contact();
        contactRec.LastName = 'LastNameTesting';
        contactRec.FirstName = 'FirstNameTesting';
        contactRec.Region__c = 'NA';
        contactRec.Contact_Role__c = 'User';
        contactRec.Email = 'testing1@acme.com';
        contactRec.AccountId = acctRec.id;
        insert contactRec;
         
        string userRecRecordType = [select id from RecordType where Name = 'Multi-Account'].id;
         
        User_Registration__c regRec = New User_Registration__c();
        regRec.Master_Contact__c = contactRec.id;
        regRec.RecordTypeId = userRecRecordType;
        regRec.User_Contact__c = contactRec.id;
        regRec.Auto_Created__c = True;
        regRec.Workflow_Status__c = 'Submitted';
        regRec.Application__c = 'Channel Partner';        
        regRec.Profile__c = 'User';
        insert regRec;
        
        Test.stopTest();        
    }
}