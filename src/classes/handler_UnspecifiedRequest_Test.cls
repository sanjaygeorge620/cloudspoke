@isTest(seealldata=true)
private class handler_UnspecifiedRequest_Test {

	static refedge__Reference_Request__c testMainRequest {get;set;}

	static refedge__Unspecified_Request__c testRequest {get;set;}
	static refedge__Unspecified_Request__c testRequest2 {get;set;}
	static refedge__Unspecified_Request__c testRequest3 {get;set;}
	static refedge__Unspecified_Request__c testRequest4 {get;set;}
	static refedge__Unspecified_Request__c testRequest5 {get;set;}
	static refedge__Unspecified_Request__c testRequest6 {get;set;}

    static testMethod void myUnitTest() {
        
        init();
    }

    static void init() {

    	Set<String> userProfile = new Set<String>();
        userProfile.add('Sales');
        userProfile.add('Sales Admin');
        userProfile.add('Sales Management');
     	userProfile.add('Marketing');
        userProfile.add('Marketing Admin');
        userProfile.add('Accounting');
      
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                  ProfileIds.add(profile.id);
        }
        
        List<User> newUserList = Data_User.createUser(6, profileIds);

        newUserList[1].LX_Geo__c = 'North America';
        newUserList[1].Email = 'test@lexmark.com';

		newUserList[2].LX_Geo__c = 'Latin America';
        newUserList[2].Email = 'test@lexmark.com';

		newUserList[3].LX_Geo__c = 'EMEA';
        newUserList[3].Email = 'test@lexmark.com'; 

		newUserList[4].LX_Geo__c = 'Asia Pacific';
        newUserList[4].Email = 'test@lexmark.com'; 

		newUserList[5].LX_Country__c = 'Australia';
        newUserList[5].Email = 'test@lexmark.com';  

        update newUserList;       

        testMainRequest = new refedge__Reference_Request__c();
        insert testMainRequest;

        testRequest = new refedge__Unspecified_Request__c();
        testRequest.refedge__Requester__c = newUserList[0].Id;
        testRequest.refedge__Reference_Request__c = testMainRequest.Id;
        insert testRequest;

        testRequest2 = new refedge__Unspecified_Request__c();
        testRequest2.refedge__Requester__c = newUserList[1].Id;
        testRequest2.refedge__Reference_Request__c = testMainRequest.Id;
        insert testRequest2;

        testRequest3 = new refedge__Unspecified_Request__c();
        testRequest3.refedge__Requester__c = newUserList[2].Id;
        testRequest3.refedge__Reference_Request__c = testMainRequest.Id;
        insert testRequest3;

        testRequest4 = new refedge__Unspecified_Request__c();
        testRequest4.refedge__Requester__c = newUserList[3].Id;
        testRequest4.refedge__Reference_Request__c = testMainRequest.Id;
        insert testRequest4;

        testRequest5 = new refedge__Unspecified_Request__c();
        testRequest5.refedge__Requester__c = newUserList[4].Id;
        testRequest5.refedge__Reference_Request__c = testMainRequest.Id;
        insert testRequest5;

        testRequest6 = new refedge__Unspecified_Request__c();
        testRequest6.refedge__Requester__c = newUserList[5].Id;
        testRequest6.refedge__Reference_Request__c = testMainRequest.Id;
        insert testRequest6;
    }
}