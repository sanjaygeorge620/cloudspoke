/*******************************************************
Class Name : Test_createTaskAndNotificationOnOpp
Created Date : 19th June 2012
Related Story : US1347
Author : Appirio Offshore(Hemant)
Purpose : Test class for class "createTaskAndNotificationOnOpp"
**********************************************************/

@isTest(seeAllData = true)
private class Test_createTaskAndNotificationOnOpp {

    static testMethod void createTaskTest() {
        String [] stageList = new List<String>();
        stageList.add('Negotiation');

        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
        if(test_opportunities.size() > 0){
            Opportunity testOpp = test_opportunities[0];
            testOpp.Submitted_for_Review__c = true;
            update testOpp;
           //VT 8/25 Commented system.assert([select id from task where whatId = :testOpp.id].size() > 0);
        }
    }
}