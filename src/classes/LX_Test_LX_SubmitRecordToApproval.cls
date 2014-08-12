/** 
 Test class for LX_SubmitRecordToApproval 
 */
@isTest(seeAllData=true)
public class LX_Test_LX_SubmitRecordToApproval {
    
    static Account acc;
    static void testData() {
        // TO DO: implement unit test
        acc = new Account(name = 'testSubmitRecordToApproval',BillingCountry = 'USA',Physical_Country__c = 'USA');
        insert acc;
    }
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();  
        testData(); 
        system.assertNotEquals(acc.id,null);            
        LX_SubmitRecordToApproval.approvalID(acc.id);
        test.stopTest();
    }
}