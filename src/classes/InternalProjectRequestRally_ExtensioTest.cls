@isTest
private class InternalProjectRequestRally_ExtensioTest {
	
	static SFDC_Projects__c newIPR {get;set;}
	static Rally_Integration_Access__c customSetting {get;set;}
	
    static testMethod void myUnitTest() {
        
        init();
        
        //perform test logic
        test.startTest();
        
 		InternalProjectRequestRally_Extension controller = new InternalProjectRequestRally_Extension(new ApexPages.StandardController(newIPR));
 		
 		controller.nullPR();
 		controller.newUserStoryToggle();
 		controller.performSave();
 		
 		test.stopTest();
    }
    
    static void init() {
    	
    	
    	newIPR = new SFDC_Projects__c();
    	newIPR.Name = 'testIPR';
    	newIPR.Type__c = 'Enhancement';
    	newIPR.Project_Sponsor__c = UserInfo.getUserId();
    	newIPR.Sponsor_Department__c = 'Marketing';
    	newIPR.Description__c = 'testDescription';
    	insert newIPR;
    	
    	customSetting = new Rally_Integration_Access__c();
    	customSetting.Create_UserStory__c = true;
    	customSetting.SetupOwnerId = UserInfo.getUserId();
    	insert customSetting;
    }
}