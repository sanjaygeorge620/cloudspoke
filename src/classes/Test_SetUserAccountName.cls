/**
 * Name: Test_SetUserAccountName
 *
 * Purpose: to provide code coverage the setuserAccountName trigger
 *
 * Date: 09/04/2010
 */
@isTest
private class Test_SetUserAccountName {

    static testMethod void mySetUserAccountName_Test() {
        // TO DO: implement unit test
        
        //add account record
        Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Type = 'Customer';
        acctRec.Sector__c = 'Federal';
        acctRec.Physical_Country__c = 'USA'; 
        acctRec.BillingCountry = 'USA';
        insert acctRec;
        
        //add contact record
        Contact contactRec = new Contact();
        contactRec.LastName = 'TestingLastName';
        contactRec.FirstName = 'TestingFirstName';
        contactRec.Region__c = 'NA';
        contactRec.Contact_Role__c = 'User';
        contactRec.Email = 'testing@acme.com';
        contactRec.AccountId = acctRec.id;
         insert contactRec;
         
        string userRecRecordType = [select id from RecordType where Name = 'Multi-Account'].id;
         
        User_Registration__c regRec = New User_Registration__c();
        regRec.Master_Contact__c = contactRec.id;
        regRec.RecordTypeId = userRecRecordType;
        regRec.User_Contact__c = contactRec.id;
        insert regRec;
        
      //VT 8/25:Commented system.assertEquals(AcctRec.Id, 
                // [select user_account__c from User_Registration__c where id = :regRec.id].user_account__c);
                 
        
        
    }
}