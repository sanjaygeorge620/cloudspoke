@isTest
private class MigrationRequest_Extension_Test {
	
	static Migration_Request__c newMR {get;set;}
	static Migration_Request_User_Story_Junction__c newMRUSJ {get;set;}
	static Rally_Integration_Access__c customSetting {get;set;}

	static testmethod void test_method_one() {
		
		init();

		//perform test logic
        test.startTest();
        
 		MigrationRequest_Extension controller = new MigrationRequest_Extension(new ApexPages.StandardController(newMR));
 		
 		controller.newUserStoryToggle();
 		controller.runFilter();
 		controller.performUpdate();
 		
 		
 		test.stopTest();
	}

	static void init() {

		newMR = new Migration_Request__c();
		newMR.Source_Org__c = 'QA';
		newMR.Target_Org__c = 'Production';
		newMR.Release__c = 'Release 1B';
		newMR.LX_Code_Migration__c = 'No';
		newMR.LX_Schema_Change__c = 'No';
		newMR.Overall_Status__c = 'Planned';
		newMR.Requested_By__c = UserInfo.getUserId();
		insert newMR;

		newMRUSJ = new Migration_Request_User_Story_Junction__c();
		newMRUSJ.Migration_Request__c = newMR.Id;
		newMRUSJ.Rally_User_Story_Id__c = 'US2222';
		insert newMRUSJ;
    	
    	customSetting = new Rally_Integration_Access__c();
    	customSetting.Create_UserStory__c = true;
    	customSetting.SetupOwnerId = UserInfo.getUserId();
    	insert customSetting;
	}
	
}