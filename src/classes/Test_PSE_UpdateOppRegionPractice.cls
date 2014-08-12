/***************************************************************************
Class Name   : Test_PSE_UpdateOppRegionPractice
Created by   : Appirio
Created Date : December 11, 2009
Purpose      : for code coverage of trigger PSE_UpdateOppRegionPractice.
*****************************************************************************/
@isTest
private class Test_PSE_UpdateOppRegionPractice {

    static testMethod void Test_PSE_UpdateOppRegionPractice() {
    
        //creating test data
        //insert an account
        Account acct = new Account(name='test'+String.valueOf(DateTime.now().getTime()));
        acct.Physical_Country__c = 'USA';
        acct.BillingCountry = 'USA';
        acct.TR_Status__c ='Off';
        insert acct;

        //insert an opportunity
        Opportunity testOpp = new Opportunity();
            testOpp.AccountId = acct.ID;
            testOpp.Name = 'testOpp';
            testOpp.StageName = 'won';        
            testOpp.CloseDate = System.today();
            testOpp.currencyISOCode = 'USD';
            testOpp.MPS__C=true;
            testopp.LX_Product_Type__c ='Software';
            testopp.LX_Sales_Type__c='New Project';
        insert testOpp; 

        //insert a pse region1
        pse__Region__c testRegion1 = new pse__Region__c(Name='test region 1');
            testRegion1.CurrencyIsoCode = 'USD';
            testRegion1.pse__Billable_External_Hours__c = 2;
            pse__Region__c parentRegion1 = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1];
            testRegion1.pse__Parent_Region__c = parentRegion1 .Id;
        insert testRegion1;

        //insert a pse region2
        pse__Region__c testRegion2 = new pse__Region__c(Name='test region 2');
            testRegion2.CurrencyIsoCode = 'USD';
            testRegion2.pse__Billable_External_Hours__c = 2;
            pse__Region__c parentRegion2 = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1];
            testRegion2.pse__Parent_Region__c = parentRegion2 .Id;
        insert testRegion2;
        //insert a pse practice1
        pse__Practice__c testPractice1 = new pse__Practice__c(Name = 'test practice 1');
            testPractice1.CurrencyIsoCode = 'USD';
            testPractice1.pse__Action_Update_Current_Time_Period__c = true;
            pse__Practice__c parentPractice1 = [Select id from pse__Practice__c where pse__Parent_Practice__c = null or Name like '%Corporate Practice%' limit 1];
            testPractice1.pse__Parent_Practice__c = parentPractice1.Id;
        insert testPractice1;

        //insert a pse practice2
        pse__Practice__c testPractice2 = new pse__Practice__c(Name = 'test practice 2');
            testPractice2.CurrencyIsoCode = 'USD';
            testPractice2.pse__Action_Update_Current_Time_Period__c = true;
            pse__Practice__c parentPractice2 = [Select id from pse__Practice__c where pse__Parent_Practice__c = null or Name like '%Corporate Practice%' limit 1];
            testPractice2.pse__Parent_Practice__c = parentPractice2.Id;
        insert testPractice2;

        //insert a pse project
        pse__Proj__c testProject = new pse__Proj__c(Name='test project');
            testProject.CurrencyIsoCode = 'USD';
            testProject.pse__Opportunity__c = testOpp.ID;
            testProject.pse__Opportunity__r = testOpp;
            testProject.pse__Region__c = testRegion1.ID;
            testProject.pse__Region__r = testRegion1;
            testProject.pse__Practice__c = testPractice1.ID;
            testProject.pse__Practice__r = testPractice1;
            //testProject.pse__Project_Type__c = 'Fixed Price';
            testProject.pse__Credited_Non_Billable_Internal_Hours__c = 2;
            testProject.pse__Allow_Expenses_Without_Assignment__c = true;
            testProject.pse__Is_Active__c = true;
        insert testProject;
        
        Test.startTest();
        
        //updating test project
        if(testProject.ID != null){
            testProject.pse__Region__c = testRegion2.ID;
            testProject.pse__Region__r = testRegion2;
            testProject.pse__Practice__c = testPractice2.ID;
            testProject.pse__Practice__r = testPractice2;
        }
        update testProject;
        
        Test.stopTest();
    }
}