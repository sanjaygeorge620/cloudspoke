/*********************************************************************
Class Name   : Test_PSE_BillingEventSetLaborCategAccNo
Created by   : Appirio
Created Date : December 11, 2009
Purpose      : For code coverage of trigger PSE_BillingEventItemSetLaborCategAccNo.
***********************************************************************/
@isTest
private class Test_PSE_BillingEventSetLaborCategAccNo {

    static ID userId ;
    static  Date todayDate ;
    static pse__Proj__c project ;
    static Contact resource ;
    static pse__Timecard_Header__c timecardHeader;
    static pse__Timecard__c timecard;
    static pse__Miscellaneous_Adjustment__c miscAdjustment;
    
    static testMethod void testTrigger() {
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
/* pse__Region__c parentRegion = new pse__Region__c();
    insert parentRegion;
*/
pse__Region__c parentRegion = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1];

    pse__Region__c region = new pse__Region__c();
    region.pse__Parent_Region__c = parentRegion.Id;
    insert region;
        
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.Physical_Country__c = 'USA';
        acc.BillingCountry = 'USA'; 
        insert acc;
        
        pse__Work_Calendar__c workCalendar = new pse__Work_Calendar__c();
        insert workCalendar;
        
        resource = new Contact();
        resource.LastName = 'LastName';
        resource.AccountId = acc.Id;
        resource.pse__Resource_Role__c = 'Consultant';
        resource.pse__Work_Calendar__c = workCalendar.Id;
        resource.pse__Is_Resource__c = resource.pse__Is_Resource_Active__c = true;
        resource.pse__Default_Cost_Rate__c = 0;
        resource.pse__Region__c = parentRegion.Id;
        resource.pse__Resource_Role__c = 'Consultant';
        resource.pse__Default_Cost_Rate__c = 25.0;
        resource.phone='1234567890';
        insert resource;
           
        project = new pse__Proj__c();
        project.pse__Closed_for_Time_Entry__c
                = project.pse__Closed_for_Expense_Entry__c
                = false;
        project.pse__Allow_Expenses_Without_Assignment__c
                = project.pse__Allow_Timecards_Without_Assignment__c
                = project.pse__Is_Active__c
                = true;
        project.pse__Is_Billable__c = false;
        project.pse__Account__c = acc.Id;
        project.pse__Project_Status__c = 'Green';
        project.pse__Start_Date__c = todayDate.addMonths(-1);
        project.pse__End_Date__c = todayDate.addMonths(4);
        project.pse__Region__c = region.Id;
        project.pse__Billing_Type__c = 'Adminstrative';
        project.PO_Number__c = '302021';
        project.OwnerId = userId;
        project.CurrencyIsoCode ='USD';
        project.Product_Line_s__c ='ISS';
        insert project;
      
        List<pse__Permission_Control__c> perControlList = new List<pse__Permission_Control__c>();
        
        pse__Permission_Control__c perControl = new pse__Permission_Control__c();
        perControl.pse__User__c = userId;
        perControl.pse__Resource__c = resource.Id;
        perControl.pse__Start_Date__c = todayDate;
        perControl.pse__End_Date__c = todayDate.addDays(10);
        perControl.pse__Staffing__c
               = perControl.pse__Expense_Entry__c
               = perControl.pse__Expense_Ops_Edit__c
               = perControl.pse__Timecard_Entry__c
               = perControl.pse__Timecard_Ops_Edit__c
               = perControl.pse__Billing__c
               = perControl.pse__Invoicing__c
               = true;
        perControlList.add(perControl);
        
        perControl = new pse__Permission_Control__c();
        perControl.pse__User__c = userId;
        perControl.pse__Project__c = project.Id;
        perControl.pse__Start_Date__c = todayDate;
        perControl.pse__End_Date__c = todayDate.addDays(10);
        perControl.pse__Staffing__c
               = perControl.pse__Expense_Entry__c
               = perControl.pse__Expense_Ops_Edit__c
               = perControl.pse__Timecard_Entry__c
               = perControl.pse__Timecard_Ops_Edit__c
               = perControl.pse__Billing__c
               = perControl.pse__Invoicing__c
               = true;
        perControlList.add(perControl);
        
        perControl = new pse__Permission_Control__c();
        perControl.pse__User__c = userId;
        perControl.pse__Region__c = parentRegion.Id;
        perControl.pse__Start_Date__c = todayDate;
        perControl.pse__End_Date__c = todayDate.addDays(10);
        perControl.pse__Staffing__c
               = perControl.pse__Expense_Entry__c
               = perControl.pse__Expense_Ops_Edit__c
               = perControl.pse__Timecard_Entry__c
               = perControl.pse__Timecard_Ops_Edit__c
               = perControl.pse__Billing__c
               = perControl.pse__Invoicing__c
               = true;
        perControlList.add(perControl);
        
        perControl = new pse__Permission_Control__c();
        perControl.pse__User__c = userId;
        perControl.pse__Region__c = region.Id;
        perControl.pse__Start_Date__c = todayDate;
        perControl.pse__End_Date__c = todayDate.addDays(10);
        perControl.pse__Staffing__c
               = perControl.pse__Expense_Entry__c
               = perControl.pse__Expense_Ops_Edit__c
               = perControl.pse__Timecard_Entry__c
               = perControl.pse__Timecard_Ops_Edit__c
               = perControl.pse__Billing__c
               = perControl.pse__Invoicing__c
               = true;
        perControlList.add(perControl);
        
        insert perControlList;

        timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = project.Id;
        timecardHeader.pse__Resource__c = resource.Id;
        timecardHeader.pse__Start_Date__c = todayDate;
        timecardHeader.pse__End_Date__c = todayDate.addDays(6);
        timecardHeader.pse__Status__C = 'Approved';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Submitted__c = true;
        timecardHeader.pse__Project_Methodology__c = 'Fixed Price Hours';
        timecardHeader.Product_Line__c = 'ISS';
        timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 
        insert timecardHeader;
        
        timecard = new pse__Timecard__c();
        timecard.pse__Project__c = project.Id;
        timecard.pse__Resource__c = resource.Id;
        timecard.pse__Start_Date__c = todayDate.addMonths(-1);
        timecard.pse__End_Date__c = todayDate.addMonths(4);
        timecard.pse__Timecard_Header__c = timecardHeader.Id;
        timecard.Labor_Category_Account_Number__c = '123456';
        timecard.pse__Total_Hours__c = 2;
        insert timecard;
        
        miscAdjustment = new pse__Miscellaneous_Adjustment__c(Name='test');
        miscAdjustment.pse__Transaction_Category__c = 'Revenue';
        miscAdjustment.pse__Effective_Date__c = System.today();
        miscAdjustment.pse__Amount__c = 100;
        miscAdjustment.CurrencyIsoCode = 'USD';
        miscAdjustment.pse__Project__c = project.ID;
        miscAdjustment.Labor_Category_Account_Number__c = '999999';
        miscAdjustment.Product_Line__c='ISS';
        insert miscAdjustment;
        
        List<pse__Billing_Event_Item__c> listBillingEventItems = new List<pse__Billing_Event_Item__c>();
        
        Test.startTest();     
        pse__Billing_Event_Item__c billingEventItem = new pse__Billing_Event_Item__c();
        billingEventItem.pse__Object_Id__c = timecard.id;
        billingEventItem.pse__Category__c = 'Timecard';
        billingEventItem.pse__Project__c = project.Id;
        listBillingEventItems.add(billingEventItem);
        
        billingEventItem = new pse__Billing_Event_Item__c();
        billingEventItem.pse__Object_Id__c = miscAdjustment.id;
        billingEventItem.pse__Category__c = 'Miscellaneous Adjustment';
        listBillingEventItems.add(billingEventItem);
        
        insert listBillingEventItems;
        Test.stopTest();
        
        Set<ID> setBillingEventItemIds = new Set<ID>();
        setBillingEventItemIds.add(listBillingEventItems[0].id);
        setBillingEventItemIds.add(listBillingEventItems[1].id);
        
        Map<ID,pse__Billing_Event_Item__c> mapBillingEventItems = new Map<ID,pse__Billing_Event_Item__c>([SELECT Labor_Category_Account_Number__c,Extract_PO_Number__c FROM pse__Billing_Event_Item__c WHERE id IN :setBillingEventItemIds]);
        //VT 8/25:Commented System.assertEquals( timecard.Labor_Category_Account_Number__c, mapBillingEventItems.get(listBillingEventItems[0].id).Labor_Category_Account_Number__c);
        //System.assertEquals( miscAdjustment.Labor_Category_Account_Number__c,mapBillingEventItems.get(listBillingEventItems[1].id).Labor_Category_Account_Number__c);
        //System.assertEquals(project.PO_Number__c,mapBillingEventItems.get(listBillingEventItems[0].id).Extract_PO_Number__c);
        
    }
}