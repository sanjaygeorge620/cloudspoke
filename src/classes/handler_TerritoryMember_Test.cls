@isTest
private class handler_TerritoryMember_Test {
	
	static Account testAccount {get;set;}
	static Opportunity testOpportunity {get;set;}
	static LX_Territory_Member__c testTerritoryMember {get;set;}
	
    static testMethod void myUnitTest() {
        
		init();
		
		testTerritoryMember.LX_DefaultFlag__c = false;
		update testTerritoryMember;
		
		testTerritoryMember.LX_DefaultFlag__c = true;
		update testTerritoryMember;
    }
    
    static void init() {
    	
    	TestFactory_CustomSettings.createRecordTypeSettings();
    	
    	Schema.DescribeSObjectResult d = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('Location Partner').getRecordTypeId();
    	
    	testAccount = new Account();
		testAccount.Name = 'Test Account';
		testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry  = 'USA';
        testAccount.RecordTypeID = recordTypeId;
		insert testAccount;
		
		testOpportunity = new Opportunity();
		testOpportunity.AccountId = testAccount.Id;
		testOpportunity.Name = 'Test Opportunity';
		testOpportunity.CloseDate = system.today().addDays(3);
		testOpportunity.StageName = 'Qualifying';
		insert testOpportunity;
		
		testTerritoryMember = new LX_Territory_Member__c();
		testTerritoryMember.LX_User__c = testOpportunity.OwnerId;
		testTerritoryMember.LX_DefaultFlag__c = true;
		insert testTerritoryMember;
    }
}