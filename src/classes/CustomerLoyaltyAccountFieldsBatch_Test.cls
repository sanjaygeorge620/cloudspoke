@isTest
private class CustomerLoyaltyAccountFieldsBatch_Test {
	
	static Lx_SetRecordIDs__c testCustomSettingRecordIds2 {get;set;}
	static Account testAccount {get;set;}
	static Survey_MKT_Customer_Loyalty__c testSurveyDetractor {get;set;}
	static Survey_MKT_Customer_Loyalty__c testSurveyPassive {get;set;}
	static Survey_MKT_Customer_Loyalty__c testSurveyPromoter {get;set;}
	
    static testMethod void myUnitTest() {
        
        init();
        
        test.startTest();
        
        CustomerLoyaltyAccountFieldsBatch b = new CustomerLoyaltyAccountFieldsBatch();
    	ID batchprocessid = Database.executeBatch(b);
        
        test.stopTest();
        
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
		
		testSurveyDetractor = new Survey_MKT_Customer_Loyalty__c();
		testSurveyDetractor.Account_Name__c = testAccount.Id;
		testSurveyDetractor.Likelihood_to_Recommend__c = 5;
		insert testSurveyDetractor;
		
		testSurveyPassive = new Survey_MKT_Customer_Loyalty__c();
		testSurveyPassive.Account_Name__c = testAccount.Id;
		testSurveyPassive.Likelihood_to_Recommend__c = 7;
		insert testSurveyPassive;
		
		testSurveyPromoter = new Survey_MKT_Customer_Loyalty__c();
		testSurveyPromoter.Account_Name__c = testAccount.Id;
		testSurveyPromoter.Likelihood_to_Recommend__c = 9;
		insert testSurveyPromoter;
    }
}