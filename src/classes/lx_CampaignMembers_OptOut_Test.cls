@isTest
private class lx_CampaignMembers_OptOut_Test {
	
	static Campaign testCampaign {get;set;}
	static Lx_SetRecordIDs__c testCustomSettingRecordIds {get;set;}
	static Lx_SetRecordIDs__c testCustomSettingRecordIds2 {get;set;}
	static Account testAccount {get;set;}
	static Contact testContact {get;set;}
	static CampaignMember testCampaignMember {get;set;}
	
	static testMethod void myUnitTest_first() {
		
		init();
		
		test.startTest();
		
		Test.setCurrentPageReference(new PageReference('Page.ManageCampaignMember')); 
		ApexPages.currentPage().getParameters().put('cid', testCampaign.Id);
		
		lx_CampaignMembers_OptOut controller = new lx_CampaignMembers_OptOut(); 
		
		test.stopTest();
	}
	
	static void init() {
		
		testCampaign = new Campaign();
		testCampaign.Name = 'Test Campaign';
		testCampaign.RecordTypeId = '012i0000000LjzX';
		insert testCampaign;
		
		testCustomSettingRecordIds = new Lx_SetRecordIDs__c();
		testCustomSettingRecordIds.Name = 'NonMDMRecordTypeName';
		testCustomSettingRecordIds.Value__c = 'Non-MDM Account';
		insert testCustomSettingRecordIds;
		
		testCustomSettingRecordIds2 = new Lx_SetRecordIDs__c();
		testCustomSettingRecordIds2.Name = 'PSEProjProfRecType';
		testCustomSettingRecordIds2.Value__c = 'PSEProjProfRecType';
		insert testCustomSettingRecordIds2;
		
		
		testAccount = new Account();
		testAccount.Name = 'Test Account';
		testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry  = 'USA';
        //testAccount.RecordTypeId = LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
		insert testAccount;
		
		testContact = new Contact();
		testContact.FirstName = 'First Name';
		testContact.LastName = 'Last Name';
		testContact.AccountId = testAccount.Id;
		insert testContact;
		
		testCampaignMember = new CampaignMember();
		testCampaignMember.CampaignId = testCampaign.Id;
		testCampaignMember.ContactId = testContact.Id;
		testCampaignMember.Status = 'Opt-Out Requested';
		insert testCampaignMember;
		
		
	}
}