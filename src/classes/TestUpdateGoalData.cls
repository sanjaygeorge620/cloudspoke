@isTest(seeAllData = true)
public with sharing class TestUpdateGoalData{
    public testmethod static void goalDataTest(){
        ApexPages.StandardController stdController;

        Date startDate =  date.newInstance(2013, 10, 1);
        Date endDate =  date.newInstance(2013, 12, 31);

        Goal__c goalObj = new Goal__c(Asia_Pacific_MQL_CP_EA_Goal__c = 10, Asia_Pacific_SQO_CP_EA_Goal__c = 5, Banking_MQL_CP_NA_Goal__c = 3,
                    Banking_SQO_CP_NA_Goal__c = 6, Capture_MQL_EA_Goal__c = 3, Capture_MQL_NA_Goal__c = 2, Capture_SQO_EA_Goal__c = 4, 
                    Capture_SQO_NA_Goal__c = 1, Content_Process_MQL_EA_Goal__c = 7, Content_Process_MQL_NA_Goal__c = 6, Content_Process_SQO_EA_Goal__c = 2,
                    Content_Process_SQO_NA_Goal__c = 2, DACHEE_MQL_CP_EA_Goal__c = 3, DACHEE_SQO_CP_EA_Goal__c = 2, Education_MQL_CP_NA_Goal__c = 1, 
                    Education_SQO_CP_NA_Goal__c = 5, FRA_ITA_MQL_CP_EA_Goal__c = 3, FRA_ITA_SQO_CP_EA_Goal__c = 6, Healthcare_MQL_CP_NA_Goal__c = 4,
                    Healthcare_SQO_CP_NA_Goal__c = 8, Insurance_MQL_CP_NA_Goal__c = 4, Insurance_SQO_CP_NA_Goal__c = 5, Retail_MQL_CP_NA_Goal__c = 5,
                    Retail_SQO_CP_NA_Goal__c = 8, Search_MQL_EA_Goal__c = 3, Search_MQL_NA_Goal__c = 4, Search_SQO_EA_Goal__c = 8, Search_SQO_NA_Goal__c = 9,
                    State_Local_MQL_CP_NA_Goal__c = 3, State_Local_SQO_CP_NA_Goal__c = 2, Start_Date__c = startDate, End_Date__c = endDate,
                    Name = 'Goal 2013 Q4');
        insert goalObj;
        System.debug('**** goalObj '+goalObj);
        UpdateGoalData updateGoals = new UpdateGoalData(stdController);
        Apexpages.CurrentPage().getParameters().put('id', goalObj.id);
        
        PageReference pageRef;
        
        pageRef = updateGoals.updateGoals();
        System.assertNotEquals(pageRef, null);
         
        pageRef = updateGoals.displayReportData();
        System.assertEquals(pageRef, null);
        
        pageRef = updateGoals.displayChart();
        System.assertEquals(pageRef, null);
        
        //Call remaining methods which display charts
        updateGoals.getChartData();
        updateGoals.getSectorWiseChartData();
        updateGoals.getLAChartData();
        updateGoals.getNAMqlChartData();
        updateGoals.getNASqoChartData();
        updateGoals.getNAAdsChartData();
        updateGoals.getNASectorMqlChartData();
        updateGoals.getNASectorSqoChartData();
        updateGoals.getNASectorAdsChartData();
        updateGoals.getLAMqlChartData();
        updateGoals.getLASqoChartData();
        updateGoals.getLAAdsChartData();
        updateGoals.getRenderPdf();  
        
    }

}