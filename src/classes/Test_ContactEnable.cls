/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ContactEnable {

    static testMethod void TestContactEnable() {
        
        //add account record
        Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Type = 'Customer';
        acctRec.Sector__c = 'Federal';
        acctRec.Physical_Country__c = 'USA'; acctRec.BillingCountry = 'USA';
        insert acctRec;
        
        //create masterContact
        Contact masterContactRec = new Contact();
        masterContactRec.LastName = 'TestingLastName';
        masterContactRec.FirstName = 'TestingFirstName';
        masterContactRec.Region__c = 'NA';
        masterContactRec.Contact_Role__c = 'User';
        masterContactRec.Email = 'testing@acme.com';
        masterContactRec.AccountId = acctRec.id;
        insert masterContactRec;
        
        Contact contactRec = [select firstName, LastName, id, email from Contact where id = :masterContactRec.id];
        
        //create User Registration
        User_Registration__c UserRegistrationRec = new User_Registration__c();
        UserRegistrationRec.Master_Contact__c = contactRec.id;
        UserRegistrationRec.Application__c = 'Community';
        insert UserRegistrationRec;
            
            contactEnable.EnableCallout(UserRegistrationRec.id, MasterContactRec.id, masterContactRec.id, 'Community', '');
                
        

    }
}