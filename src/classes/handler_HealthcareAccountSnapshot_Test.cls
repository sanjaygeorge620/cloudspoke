@isTest(seealldata=true)
public with sharing class handler_HealthcareAccountSnapshot_Test {
	
	static Account testAccount {get;set;}
	static AccountTeamMember testAccountTeamMember {get;set;}
	static Healthcare_Account_Snapshot__c testHCAcctSnapshot {get;set;}
	
	static testMethod void unitTest() {
		
		init();
	}
	
	static void init() {
		
		//TestFactory_CustomSettings.createRecordTypeSettings();
    	
    	Schema.DescribeSObjectResult d = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('Location Partner').getRecordTypeId();
    	
    	
    	Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
      
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                  ProfileIds.add(profile.id);
        }
        
        List<User> newUserList = Data_User.createUser(3, profileIds);
    	
    	testAccount = new Account();
		testAccount.Name = 'Test Account';
		testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry  = 'USA';
        testAccount.RecordTypeID = recordTypeId;
        testAccount.OwnerId = newUserList[0].Id;
		insert testAccount;
		
		testAccountTeamMember = new AccountTeamMember();
		testAccountTeamMember.AccountId = testAccount.Id;
		testAccountTeamMember.UserId = newUserList[1].Id;
		insert testAccountTeamMember;
		
		testHCAcctSnapshot = new Healthcare_Account_Snapshot__c();
		testHCAcctSnapshot.Account__c = testAccount.Id;
		testHCAcctSnapshot.Department__c = 'Accounting';
		insert testHCAcctSnapshot;
		
		update testHCAcctSnapshot;
		
		delete testHCAcctSnapshot;
	}
}