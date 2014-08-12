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
@isTest(seeAllData=true)
private class LX_Test_CheckClosedOpportunities {

	static LX_Shipto_Billto_Cntrl billShipCntrl;
    static Account OppAccount,ParentAccount;
    static Opportunity soldToOpp;
    static Sales_Organization__c salesOrg;
    static LX_SAP_Record__c soldToSAP;
    static LX_SAP_Record_Sales_Org__c oppSoldTo;
    static LX_CustomSoldtoLookup custLookup;


	//Load the data into the test enviornment.
    static testMethod void loadData() {
       	//Create Opportunity data.
       	OppAccount  = LX_TestData.createAccountForOpportunity(); 
        salesOrg    = LX_TestData.createSalesOrgForOpportunity();
        soldToSAP   = LX_TestData.createSAPsoldTo();
        oppSoldTo   = LX_TestData.createOppSoldTo();
        soldToOpp   = LX_TestData.createOpportunity();
    }
    
    static testMethod void closedOpp(){
    	loadData();
    	ApexPages.StandardController  controller = new ApexPages.StandardController(soldToOpp); 
    	Apexpages.currentPage().getParameters().Put('Id',soldToOpp.id);
    	LX_CheckClosedOpportunities testPage = new LX_CheckClosedOpportunities(controller);
    	system.assertEquals(testPage.opp.id, soldToOpp.id);
    	soldToOpp.LX_Sold_To_New__c  = null;
    	update soldToOpp;

    }
}