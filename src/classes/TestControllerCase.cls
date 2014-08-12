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
private class TestControllerCase {

    static testMethod void myUnitTest() {
    /*    Account acct = new Account();
            acct.name = 'My Test Account';
        insert acct;  */
        
        Account acct = Data_Account.createAccount();
        
            
/*        Case parentCase = new Case();
            parentCase.subject = 'New Case Test';
            parentCase.Description = 'New Case Description';
        insert parentCase;

        Case newCase = new Case();
            newCase.subject = 'New Case Test';
            newCase.Description = 'New Case Description';
            newCase.ParentId = parentCase.Id;
        insert newCase;
  */
  
         List<Contact> contacts = Data_Contact.createContacts(acct.Id,3); 
         List<Case> cases = Data_Case.createCase(acct, contacts[0] , 'Product Support', 2);  
         
         Case newCase = cases[0];
         Case parentCase = cases[1];
                   
        
        Server__c server = new Server__c();
            server.account__c = acct.id;
            server.Database_Text__c = null;
            server.Database_Version_Text__c = '9i';
            server.Platform_Text__c = 'HP/UX';
            server.Platform_Version_Text__c = '11.11';
            server.Brand_Text__c = 'ImageNow';
            server.Release_Text__c = '6.5.1';
            server.Server_Name__c = 'Server'; 
        insert server;
        
        newCase.Server__c = server.id;
        parentCase.Server__c = server.id;
        
        Test.setCurrentPageReference(new PageReference('Page.CaseRelatedList'));
        
        ApexPages.currentPage().getParameters().put('Id',parentCase.id);
        
        Case insertedCase = [select id, createdDate, subject, status, ownerid, owner.name, casenumber from Case where id=:parentCase.id limit 1];
                
        ApexPages.StandardController sc = new ApexPages.StandardController(insertedCase); 
        ControllerCase extensionController = new ControllerCase(sc);  
        List<Case> relatedCases = extensionController.getRelatedCases();
        
        //System.assert(relatedCases.size()>0);
        boolean showRows = extensionController.getShowRows();
                
        
    }
}