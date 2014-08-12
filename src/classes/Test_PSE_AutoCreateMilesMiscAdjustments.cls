/***************************************************************************
Class Name   : Test_PSE_AutoCreateMilesMiscAdjustments
Created by   : Appirio
Created Date : December 18, 2009
Purpose      : Test Class for Trigger PSE_AutoCreateMilesStoneMiscAdjustments
*****************************************************************************/
@isTest
private class Test_PSE_AutoCreateMilesMiscAdjustments {

    static ID userId ;
    static  Date todayDate ;
    
    static testMethod void testTrigger() {

        userId = UserInfo.getUserId();
        todayDate = Date.today();
         //Insert region 
        pse__Region__c parentpse_region = new pse__Region__c();
        parentpse_region.Name = 'Corporate Region';
        parentpse_region.CurrencyIsoCode = 'USD';
        insert parentpse_region;
        
        pse__Practice__c parentpse_practice = new pse__Practice__c(Name = 'Corporate Practice');
        parentpse_practice.CurrencyIsoCode = 'USD';
        insert parentpse_practice;
        
        /*pse__Region__c pse_region = new pse__Region__c();
        pse_region.Name = 'test region';
        pse_region.CurrencyIsoCode = 'USD';
        pse__Region__c parentRegion = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1];
        pse_region.pse__Parent_Region__c = parentRegion.Id;
        insert pse_region;
        system.assert(pse_region.Id != null);
        
        //Insert Practice
        pse__Practice__c pse_practice = new pse__Practice__c(Name = 'test practice');
        pse_practice.CurrencyIsoCode = 'USD';
        pse__Practice__c parentPractice = [Select id from pse__Practice__c where pse__Parent_Practice__c = null or Name like '%Corporate Practice%' limit 1];
        pse_practice.pse__Parent_Practice__c = parentPractice.Id;
        insert pse_practice;*/
        
        
        /* get a Region and Practice */
        pse__Region__c pse_region = [Select id from pse__Region__c where Name like '%Corporate Region%' limit 1];
        pse__Practice__c pse_practice = [Select id from pse__Practice__c where Name like '%Corporate Practice%' limit 1];
        
        /* build project with basics, note, proj must be both active=true and billable=true  and billing_type=null */
        List<pse__Proj__c> Projects = Data_Project.createProject(1);
        
        Test.startTest();
             
        /* set the billing_type to 'Fixed Price' to fire the update trigger that creates Milestones and Misc. Adjustments */     
        for(pse__Proj__c proj1 : projects){
            proj1.pse__Billing_Type__c = 'Fixed Price';
        }    
        update projects;
         
        Test.stopTest();
    }
}