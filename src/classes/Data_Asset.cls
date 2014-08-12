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
@isTest(SeeAllData=true)
private class Data_Asset {


    /*
        This method creates a list of Assets and returns it back to the user.
    
    */
    static testMethod list<Asset_Item__c> createRandomAssets() {
        createAsset();
        
        return null;
    }
    
    
    static Asset createAsset(){
        
        //Create a testAccount for the Asset
        Account testAccount  = Data_Account.createAccount();
        
        //Crate a testContactfor the Asset
        Contact testContact;
        for(Contact con :Data_Contact.createContacts(testAccount.Id, 1)){
            testContact = con;
            break;
        }
        
        Asset testAsset = new Asset(
                                Name        = 'Test Asset',
                                ContactId   = testContact.id,
                                AccountId   = testAccount.id );
        insert testAsset;
        return testAsset;
    }
}