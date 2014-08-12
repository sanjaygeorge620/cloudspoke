@isTest(seeAllData = true)
Public class LX_Test_LX_AccountTriggerUtil{
    public static Map<String, String> testmap;
    public static Map<Id,Account> oldAccMap;
    public static Map<Id,Account> newAccMap;
    public static List<Id> testList;
    public static List<Account> testAccList;
    public static ActionPlan__c testAccPlan;
    public static List<ActionPlan__c> testAccPlanList;
    
    public static testmethod void testFunc(){
    test.startTest();
        oldAccMap = new Map<Id,Account>();
        newAccMap = new Map<Id,Account>();
        testAccList = new List<Account>();
        testAccPlanList = new List<ActionPlan__c>();
        testAccList = [Select id,name from Account where Originating_Partner__c = null AND Type = 'Customer' limit 200];
        testList = new List<Id>();
        for(Account a3: testAccList){
            testAccPlan = new ActionPlan__c();
            testAccPlan.Account__c = a3.Id;
            testAccPlanList.add(testAccPlan);
        }
        insert testAccPlanList;
        
        for(Account a1: testAccList){
            oldAccMap.put(a1.id,a1);
        }
        for(Account a : testAccList){
            testList.add(a.id);
            a.Type = 'Prospect';
        }
        Update testAccList;
        for(Account a2 : testAccList){
            newAccMap.put(a2.id,a2);
        }
        testmap = new map<String,String>();
        LX_AccountTriggerUtil testinstance = new LX_AccountTriggerUtil();
        LX_AccountTriggerUtil.getPerceptiveConfigDetails(testmap );
        testinstance.accountActionPlanDelete(testAccList );
        testinstance.accountActionPlanUnDelete(testAccList );
        testinstance.updateOriginatingPartner(testAccList ,oldAccMap ,newAccMap);
        //LX_SetRecordIDs.CaseHelpDeskRecordTypeId = '012i0000000NgS0AAK';
        //testinstance.createCaseWithBillDetails(testAccList );
        FirstRun_Check.FirstRun_UpdateCSA = True;
        testinstance.updateCSA(testAccList );
        
        //Added to test UserStoryTriggerClass
        Map<Id,String> mapStoryACHistory = new Map<Id,String>();
        List<Requirements__c> tempUserList = new List<Requirements__c>();
        tempUserList  = [Select id from Requirements__c limit 200];
        for(Requirements__c u : tempUserList ){
            mapStoryACHistory.put(u.id,'Sample');
        }
        UserStoryTriggerClass.createNewACHistoryRecord(mapStoryACHistory);
        
    test.stopTest();
    }

}