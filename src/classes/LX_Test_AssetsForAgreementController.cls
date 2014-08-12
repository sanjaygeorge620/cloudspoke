/*
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 5/08/2013
 *
 * Author : Rahul
 * 
 * Description : This is the test method for the AssetsForAgreementController class.
 * 
 */
@isTest
private class LX_Test_AssetsForAgreementController {
		
	//This is the class
	public static Agreement__c testAgreement;
		
		
	/*
	This is a method to create an dummy agreement for the Assets class.
	*/	
    static testMethod void setUpData() {
        testAgreement = new Agreement__c();
        insert testAgreement;
        
    }
    
    /*
    This is a method to call the standard controller and ensure that the variables are initailised.
    */
    static testMethod void testassetItems(){
    	//Create a dummy record.
    	setUpData();
    	//Initialise the StandardController
    	ApexPages.StandardController testControl = new ApexPages.StandardController(testAgreement);
    	//Call the constructor of the Standard Page
    	AssetsForAgreementController testPage 	= new AssetsForAgreementController(testControl);
    	
    	//Assert that the class variable is not null
    	system.assertNotEquals(testPage.assetItems, null);
    }
}