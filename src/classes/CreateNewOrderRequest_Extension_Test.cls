@isTest
private class CreateNewOrderRequest_Extension_Test {
	
	static LX_SAP_Record__c testSAPRecord {get;set;}
	static LX_New_Order_Request__c testNewOrderRequest {get;set;}
	
    static testMethod void myUnitTest_Cancel() {
        
        //generate test data
        init();
        
        //perform test logic
        test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testNewOrderRequest);
 		CreateNewOrderRequest_Extension controller = new CreateNewOrderRequest_Extension(sc);
 		
 		controller.doCancel();
 		
 		test.stopTest();
 		
 		//assert results
 	
	}
	
    static testMethod void myUnitTest_SuccessfulInsert() {
        
        init();
        
        test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testNewOrderRequest);
 		CreateNewOrderRequest_Extension controller = new CreateNewOrderRequest_Extension(sc);
 		
 		controller.newReq.LX_License_End_User__c = testSAPRecord.Id;
 		controller.saveNewReq();
 		
 		test.stopTest();
 		
 		//system.assert()
    }
    
    static testMethod void myUnitTest_FailInsertCatchBlock() {
        
        init();
        
        test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testNewOrderRequest);
 		CreateNewOrderRequest_Extension controller = new CreateNewOrderRequest_Extension(sc);
 		
 		controller.saveNewReq();
 		
 		test.stopTest();
    }
    
    static void init() {
    	
    	testSAPRecord = new LX_SAP_Record__c();
    	insert testSAPRecord;
    	
    	
    	testNewOrderRequest = new LX_New_Order_Request__c();
    	testNewOrderRequest.LX_License_End_User__c = testSAPRecord.Id;
    	insert testNewOrderRequest;
    }
}