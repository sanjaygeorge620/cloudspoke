/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
private class Test_InvoiceMaker_NoContract_Intl {

    static testMethod void myUnitTest() {
        test.startTest();
        //User objUSer  = [select id from user where profileid =: '00ee0000000Lsyy' and isactive = true limit 1];
        //system.runas(objUser)
        //{
        // TO DO: implement unit test
         //create a time period
        pse__Time_Period__c timePeriod = loadTimePeriod();
        
        Invoice_Maker__c im = new Invoice_Maker__c(Time_Period_End_Date__c = timePeriod.pse__End_Date__c.addDays(5) 
                                            ,Time_Period_Start_Date__c = timePeriod.pse__Start_Date__c.addDays(-5)
                                            , time_Billings__c=true
                                            , time_MiscAdjustments__c = true
                                            , status__c = 'Ready-For-Pickup' 
                                            , Time_Period__c = timePeriod.id
                                            , Record_Types__c = 'Professional Services');
        insert im;
        pse__Region__c parentRegion = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate%' limit 1];
        Set<Id> InvoiceMakerSet = new Set<Id>();
        InvoiceMakerSet.add(im.id);
        
        //Create Region
        pse__Region__c region = new pse__Region__c();
        region.pse__Parent_Region__c = parentRegion.Id;
        insert region;
    
        //Create Account
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.Physical_Country__c = 'USA';
        acc.BillingCountry = 'USA'; 

        insert acc;
        //Create Work Calendar
        pse__Work_Calendar__c workCalendar = new pse__Work_Calendar__c();
        insert workCalendar;
        //Create Contact record 
        Contact resource = new Contact();
        resource.LastName = 'LastName';
        resource.AccountId = acc.Id;
        resource.pse__Resource_Role__c = 'Consultant';
        resource.pse__Work_Calendar__c = workCalendar.Id;
        resource.pse__Is_Resource__c = resource.pse__Is_Resource_Active__c = true;
        resource.pse__Default_Cost_Rate__c = 0;
        resource.pse__Region__c = parentRegion.Id;
        resource.pse__Resource_Role__c = 'Consultant';
        resource.pse__Default_Cost_Rate__c = 25.0;
        resource.Phone = '12121212';
        resource.MobilePhone = '34567892';
        resource.Email = 'Test222@test.com';
        insert resource;
        //Create Project   
        pse__Proj__c project = new pse__Proj__c();
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
        project.pse__Start_Date__c = date.today().addMonths(-1);
        project.pse__End_Date__c = date.today().addMonths(4);
        project.pse__Region__c = region.Id;
        project.pse__Billing_Type__c = 'Adminstrative';
        project.PO_Number__c = '302021';
        project.OwnerId = UserInfo.getUserId();
        project.CurrencyIsoCode ='USD';
        project.Product_Line_s__c ='ISS';
        insert project;
        
        List<pse__Permission_Control__c> permissions = createPermissionControls(resource.id,project.id,region.id);  
        
        //Create PSE Time Card Header
        pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = project.Id;
        timecardHeader.pse__Resource__c = resource.Id;
        timecardHeader.pse__Start_Date__c = date.today();
        timecardHeader.pse__End_Date__c = date.today().addDays(6);
        timecardHeader.pse__Status__C = 'Approved';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Submitted__c = true;
        timecardHeader.pse__Project_Methodology__c = 'LXK_SE - Admin';
        timecardHeader.pse__Admin_Global_Edit__c = true;
        timecardHeader.Product_Line__c = 'ISS';
        timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 
        
        insert timecardHeader;
        
        
        //Create PSE Time Card
       pse__Timecard__c timecard = new pse__Timecard__c();
        timecard.pse__Project__c = project.Id;
        timecard.pse__Resource__c = resource.Id;
        timecard.pse__Start_Date__c = date.today().addMonths(-1);
        timecard.pse__End_Date__c = date.today().addMonths(4);
        timecard.pse__Timecard_Header__c = timecardHeader.Id;
        timecard.Labor_Category_Account_Number__c = '123456';
        timecard.pse__Total_Hours__c = 2;
        timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 
        insert timecard;
        
        
   
        
        //Create Billing Event
         pse__Billing_Event_Item__c billingEventItem = new pse__Billing_Event_Item__c();
        billingEventItem.pse__Object_Id__c = timecard.id;
        billingEventItem.pse__Category__c = 'Timecard';
        billingEventItem.pse__Project__c = project.Id;
        billingEventItem.pse__Quantity__c = 1;
        billingEventItem.pse__Timecard_Split__c = timecard.Id;
        insert billingEventItem;
        List<pse__Billing_Event_Item__c> lstData  = new list<pse__Billing_Event_Item__c>();
        lstData.add(billingEventItem);
        Map<String,List<pse__Billing_Event_Item__c>> mapData = new Map<String,List<pse__Billing_Event_Item__c>>();
        mapData.put('TEST',lstData);
        Map<String, Integer>  mapData1 = new Map<String, Integer>();
        mapData1.put('Test',1);
        InvoiceMaker_Intl_NoContract.excute(InvoiceMakerSet,'Professional Services');
        InvoiceMaker_Intl_NoContract.createAttachment(im,mapData,mapData1,'MiscAdjust');
        
        //Testing Methods Of InvoiceMaker_Intl
        System.debug('#$#$ Before Execute');
        InvoiceMaker_Intl.excute(InvoiceMakerSet,'Professional Services');
      //  System.debug('#$#$ After Execute');
         String contractNumber = InvoiceMaker_Intl.getContractNumber(project);
        InvoiceMaker_Intl.generateBEITimecardSplitLine(timecard, billingEventItem, contractNumber, Double.ValueOf(20), date.today(), date.today().addDays(2), 'MiscAdjust'  );
        InvoiceMaker_Intl.createAttachment(im,mapData,mapData1,'MiscAdjust');
        InvoiceMaker_Intl.generateCSVFormat(mapData,date.today(),date.today().addDays(2),'MiscAdjust');
       InvoiceMaker_Intl.generateProjectBasedCSV(lstData,date.today(),date.today().addDays(2),'MiscAdjust');
        
        
        //InvoiceMaker_Intl_NoContract.generateCSVFormat(lstData,date.today(),date.today() + 2,'MiscAdjust');
        InvoiceMaker_Intl_NoContract.generateProjectBasedCSV(lstData,date.today(),date.today().addDays(2),'MiscAdjust');
        InvoiceMaker_Intl_NoContract.buildChildBEIMap(mapData,billingEventItem);
        InvoiceMaker_Intl_NoContract.addMADJDesc(billingEventItem);
        InvoiceMaker_Intl_NoContract.getContractNumber(project);
        InvoiceMaker_Intl_NoContract.generateHeaderBEI(billingEventItem,'123456',3,date.today(),date.today().addDays(2),'MiscAdjust');
        InvoiceMaker_Intl_NoContract.generateInvoiceDescription(timecard,billingEventItem,date.today(),date.today().addDays(2),'MiscAdjust');
        
        InvoiceMaker_NoContract.excute(InvoiceMakerSet,'Professional Services');
        InvoiceMaker_NoContract.generateFilter(im);
        InvoiceMaker_NoContract.generateNamingFilter(im,'MiscAdjust');
        InvoiceMaker_NoContract.getBillingEIQuery();
        InvoiceMaker_NoContract.createAttachment(im,mapData,mapData1,'MiscAdjust');
        InvoiceMaker_NoContract.generateProjectBasedCSV(lstData,date.today(),date.today() + 2,'MiscAdjust');
        InvoiceMaker_NoContract.addMADJDesc(billingEventItem);
        InvoiceMaker_NoContract.getContractNumber(project);
        //generateBEITimecardSplitLine(pse__Timecard__c timecardSplit, pse__Billing_Event_Item__c bei, String contractNumber,Date StartDate,Date endDate)
        InvoiceMaker_NoContract.generateBEITimecardSplitLine(timecard,billingEventItem,'123456',date.today(),date.today().addDays(2),'MiscAdjust');
        InvoiceMaker_NoContract.generateHeaderBEI(billingEventItem,'123456',3,date.today(),date.today().addDays(2),'MiscAdjust');
        InvoiceMaker_NoContract.generateFileName(im,'MiscAdjust');
        InvoiceMaker_NoContract.generateInvoiceDescription(timecard,billingEventItem,date.today(),date.today().addDays(2),'MiscAdjust');
        InvoiceMaker_NoContract.buildChildBEIMap(mapData,billingEventItem);
        InvoiceMaker_NoContract.generateCSVFormat(mapData,date.today(),date.today() + 2,'MiscAdjust');
        
        InvoiceMaker_Intl.buildChildBEIMap(mapData,billingEventItem);
        //InvoiceMaker_Intl.createAttachment(im,mapData,mapData1,'MiscAdjust');
        InvoiceMaker_Intl.generateInvoiceDescription(timecard,billingEventItem,date.today(),date.today().addDays(2),'MiscAdjust');
          InvoiceMaker_Intl.generateHeaderBEI(billingEventItem,'123456',3,date.today(),date.today().addDays(2),'MiscAdjust');
          InvoiceMaker_Intl.addMADJDesc(billingEventItem);
          
          
          InvoiceMaker.excute(InvoiceMakerSet,'Professional Services');
          InvoiceMaker.generateFilter(im);
          InvoiceMaker.generateNamingFilter(im,'MiscAdjust');
          InvoiceMaker.createAttachment(im,mapData,mapData1,'MiscAdjust');
          InvoiceMaker.generateCSVFormat(mapData,date.today(),date.today() + 2,'MiscAdjust');
          InvoiceMaker.generateProjectBasedCSV(lstData,date.today(),date.today() + 2,'MiscAdjust');
          InvoiceMaker.getContractNumber(project);
          InvoiceMaker.generateBEITimecardSplitLine(timecard,billingEventItem,'123456',date.today(),date.today().addDays(2),'MiscAdjust');
          InvoiceMaker.addMADJDesc(billingEventItem);
          InvoiceMaker.generateHeaderBEI(billingEventItem,'123456',3,date.today(),date.today().addDays(2),'MiscAdjust');
          InvoiceMaker.generateFileName(im,'MiscAdjust');
          InvoiceMaker.generateInvoiceDescription(timecard,billingEventItem,date.today(),date.today().addDays(2),'MiscAdjust');
        
        test.stopTest();
        
        
    }
    // Create Permission controls
        
         public static List<pse__Permission_Control__c> createPermissionControls(Id resourceId, Id projectId, Id regionId){
        List<pse__Permission_Control__c> percontrols = new List<pse__Permission_Control__c>();
        //give permissions to resource
        pse__Permission_Control__c perControl1 = new pse__Permission_Control__c();
        perControl1.pse__User__c = UserInfo.getUserId();
        perControl1.pse__Resource__c = resourceId;
        perControl1.pse__Start_Date__c = Date.today();
        perControl1.pse__End_Date__c = Date.today().addDays(10);
        perControl1.pse__Cascading_Permission__c = true;
        perControl1.pse__Timecard_Entry__c = true;
        perControl1.pse__Timecard_Ops_Edit__c = true;
        perControl1.pse__Resource_Request_Entry__c = true;
        perControl1.pse__Billing__c = true;
        perControl1.pse__Expense_Entry__c = true;
        perControl1.pse__Expense_Ops_Edit__c = true;
        perControl1.pse__Invoicing__c = true;
        perControl1.pse__Skills_And_Certifications_Entry__c = true;
        perControl1.pse__Skills_And_Certifications_View__c = true;
        perControl1.pse__Staffing__c = true;
        perControl1.CurrencyIsoCode = 'USD';
        percontrols.add(perControl1);
        
        pse__Permission_Control__c perControl2 = new pse__Permission_Control__c();
        perControl2.pse__User__c = UserInfo.getUserId();
        perControl2.pse__Project__c = projectId;
        perControl2.pse__Start_Date__c = Date.today();
        perControl2.pse__End_Date__c = Date.today().addDays(10);
        perControl2.pse__Cascading_Permission__c = true;
        perControl2.pse__Timecard_Entry__c = true;
        perControl2.pse__Timecard_Ops_Edit__c = true;
        perControl2.pse__Resource_Request_Entry__c = true;
        perControl2.pse__Billing__c = true;
        perControl2.pse__Expense_Entry__c = true;
        perControl2.pse__Expense_Ops_Edit__c = true;
        perControl2.pse__Invoicing__c = true;
        perControl2.pse__Skills_And_Certifications_Entry__c = true;
        perControl2.pse__Skills_And_Certifications_View__c = true;
        perControl2.pse__Staffing__c = true;
        perControl2.CurrencyIsoCode = 'USD';
        percontrols.add(perControl2);
        
        pse__Permission_Control__c perControl3 = new pse__Permission_Control__c();
        perControl3.pse__User__c = UserInfo.getUserId();
        perControl3.pse__Region__c = regionId;
        perControl3.pse__Start_Date__c = Date.today();
        perControl3.pse__End_Date__c = Date.today().addDays(10);
        perControl3.pse__Cascading_Permission__c = true;
        perControl3.pse__Timecard_Entry__c = true;
        perControl3.pse__Timecard_Ops_Edit__c = true;
        perControl3.pse__Resource_Request_Entry__c = true;
        perControl3.pse__Billing__c = true;
        perControl3.pse__Expense_Entry__c = true;
        perControl3.pse__Expense_Ops_Edit__c = true;
        perControl3.pse__Invoicing__c = true;
        perControl3.pse__Skills_And_Certifications_Entry__c = true;
        perControl3.pse__Skills_And_Certifications_View__c = true;
        perControl3.pse__Staffing__c = true;
        perControl3.CurrencyIsoCode = 'USD';
        percontrols.add(perControl3);
        insert percontrols;
        return percontrols;
    }
    
    public static pse__Time_Period__c loadTimePeriod(){
        
        pse__Time_Period__c timePeriod;
        for(pse__Time_Period__c tp :[select Id, pse__Start_Date__c, pse__end_Date__c from pse__Time_Period__c limit 1]){
            timePeriod = tp;
        }
        if(timePeriod == null){
            timePeriod = new pse__Time_Period__c (pse__Start_Date__c = Date.newInstance(2010,5,1), pse__end_Date__c = Date.newInstance(2010,5,31), pse__Type__c = 'Monthly');
            insert timePeriod;
        }
        return timePeriod;
    }
}