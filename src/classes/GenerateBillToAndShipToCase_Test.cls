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
 
@isTest(seealldata=True)
private class GenerateBillToAndShipToCase_Test {
    private static Account account;
    private static Contact con,con2;
    private static list<RecordType>  testRecordTypes;
    private static Id recordTypeId;
    
    private static void createTestData(){
    account = new Account(Name = 'testAcc' , MDM_Sold_To_Number__c = '40',BillingCountry='USA',Physical_Country__c = 'USA');
    con = new Contact(LastName = 'testContact' , Accounting_Contact__c =true,Phone = '04022334455',Email = 'test@test.com',MobilePhone = '9876543210');
    con2= new Contact(LastName= 'testContact2',Phone = '04022334455',Email = 'test@test.com',MobilePhone = '9876543210');     
    insert account;
    System.debug('----accName before update'+account.Name);
    con.AccountId = account.Id;
    con2.AccountId =account.Id;
   // FlexeraAccount__c newFleeraAcc = new FlexeraAccount__c(Name ='Perceptive Software' , Flexera_Account_ID__c =account.Id);
   // insert newFleeraAcc;
    insert con;
    insert con2; 
    }
    
    static testMethod void myUnitTest() { 
        // TO DO: implement unit test
        list<Case> createdCases ;
        
        createTestData();
        account = [select Id,name from Account where Id = : account.Id limit 1];
        account.Name = 'test8';
        update account;
        System.debug('----accName after update'+account.Name);
        
        
    }
}