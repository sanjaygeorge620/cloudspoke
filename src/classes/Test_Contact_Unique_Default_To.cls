/*
Modified for Story US1382 on 19th June 2012
Adding the condition on after update to create the case when "Accounting Contact" = True AND "Preferred Language" is modified.
*/

@isTest
private class Test_Contact_Unique_Default_To {

static testMethod void  AccountingContact(){
 Account a = Data_Account.createAccount();
         
//a.Primary_Sector_Focus__c = 'Manufacturing';
//update a;

    Contact c = new Contact();
    c.LastName = 'Test Contact';
    c.AccountId = a.Id;
    c.Accounting_Contact__c = false;
    c.Default_Bill_To__c = true;
    c.Contact_Role__c = 'User';
    c.Language__c = 'French';
c.Lx_Lexmark_Vertical__c = 'Manufacturing';
c.Phone = '11223344';
c.MobilePhone = '3323232323';
c.email = 'test33@test.com';
    insert c;
    
    c.Accounting_Contact__c = true;
    c.Language__c = 'English';
    update c;
    
    Contact c1 = new Contact();
    c1.LastName = 'Test Contact1';
    c1.AccountId = a.Id;
    c1.Default_Bill_To__c = true;
    c1.Contact_Role__c = 'User';
    c1.Lx_Lexmark_Vertical__c = 'Manufacturing';
c1.Phone = '112232344';
c1.MobilePhone = '33223232323';
c1.email = 'test323@test.com';
    insert c1;
        }
}