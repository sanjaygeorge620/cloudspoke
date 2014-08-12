/***************************************************************************************
Name              : TestCustomTimeCardApprovalController
Author            : Appirio Offshore
Created Date      : March 30, 2010
Description       : For code coverage for the class "CustomTimeCardApprovalController"
****************************************************************************************/
@isTest(seealldata = true)
public class TestCustomTimeCardApprovalController {
  
  
  private static testMethod void testCase2() {
    
    List<pse__Region__c> regions = [select Id from pse__Region__c where pse__Parent_Region__c = null];
    List<pse__Timecard_Header__c> timecards_headers = new List<pse__Timecard_Header__c>();
    pse__Region__c region = new pse__Region__c();
    region.Name = 'testregion';
    region.CurrencyIsoCode = 'USD';
    if(regions.size() > 0){
        region.pse__Parent_Region__c = regions[0].Id;
    }
    insert region;
    system.assert(region.Id != null);
    
    List<pse__Grp__c> groups = [select Id from pse__Grp__c where pse__Parent_Group__c = null];
    
    pse__Grp__c grp = new pse__Grp__c();
    grp.Name = 'TestGrp';
    grp.CurrencyIsoCode = 'USD';
    if(groups.size() > 0){
        grp.pse__Parent_Group__c = groups[0].Id;
    }
    insert grp;
    system.assert(grp.Id != null);

    List<pse__Practice__c> practices = [select Id from pse__Practice__c where pse__Parent_Practice__c = null];

    pse__Practice__c practice = new pse__Practice__c();
    practice.Name = 'TestPractice';
    practice.CurrencyIsoCode = 'USD';
    if(practices.size() > 0){
        practice.pse__Parent_Practice__c = practices[0].Id;
    }
    insert practice;
    
    system.assert(practice.Id != null);
    
    Account testAccount = new Account();
    testAccount.Name = 'testAccount';
    testAccount.Physical_Country__c = 'USA';
    testAccount.BillingCountry = 'USA';
    insert testAccount;
    system.assert(testAccount.Id != null);
    
    Contact testContact = new Contact();
    testContact.LastName = 'Test Contact';
    testContact.AccountId = testAccount.Id;
    testContact.CurrencyIsoCode = 'USD';
    testContact.pse__Is_Resource_Active__c = true;
    testContact.pse__Is_Resource__c = true;
    testContact.pse__Default_Cost_Rate__c = 25.0;
    //testContact.pse__Salesforce_User__c = System.Userinfo.getUserId();
    testContact.pse__Region__c = region.Id;
    testContact.pse__Group__c = grp.id;
    testContact.pse__Practice__c = practice.id;
    testcontact.Email = 'tet@test.com';
    testcontact.Phone = '35353535';
    insert testContact;
    system.assert(testContact.Id != null);
    
    pse__Permission_Control__c perControl = new pse__Permission_Control__c();
    perControl.pse__User__c = System.Userinfo.getUserId();
    perControl.pse__Resource__c = testContact.Id;
    perControl.pse__Start_Date__c = date.today();
    perControl.pse__End_Date__c = date.today().addDays(10);
    perControl.pse__Staffing__c
           = perControl.pse__Expense_Entry__c
           = perControl.pse__Expense_Ops_Edit__c
           = perControl.pse__Timecard_Entry__c
           = perControl.pse__Timecard_Ops_Edit__c
           = true;
    insert perControl;
    system.assert(perControl.Id != null);
    
    pse__Proj__c project = new pse__Proj__c(Name='test_project');
    project.pse__Is_Billable__c = false;
    project.pse__Is_Active__c = true;
    project.pse__Project_Status__c = 'Green';
    project.pse__Allow_Timecards_Without_Assignment__c = true; // note, set this to TRUE so we don't need to create an Assignment
    project.pse__Start_Date__c = Date.today().addMonths(-1);
    project.pse__End_Date__c = Date.today().addMonths(4);
    project.pse__Region__c = region.Id;     
    project.pse__Billing_Type__c = 'Administrative';
    project.pse__Practice__c = practice.Id;  
    project.CurrencyIsoCode ='USD';
    project.pse__Account__c = testAccount.id;
    project.Product_Line_s__c ='ISS';

    insert project; 
   // system.assert(project.Id != null);
      List<pse__Timecard_Header__c> psetimecards= new List<pse__Timecard_Header__c>();
      psetimecards = MassTCApprovalHelper.getAllTCForWeekend(System.today());
   // insert psetimecards;
      List<pse__Timecard_Header__c>  psetimeCardList = MassTCApprovalHelper.getTCFilterByPMStatus(psetimecards,userinfo.getUserId(),true,true,true,true);   
      insert psetimeCardList;
    User us1 =[Select id,email from user where email!='' and IsActive=true limit 1];
    
    pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
    timecardHeader.pse__Project__c = project.Id;
    timecardHeader.pse__Resource__c = testContact.Id;
    timecardHeader.pse__Start_Date__c = CustomTimeCardApprovalController.getWeekStartDate(System.today());
    timecardHeader.pse__End_Date__c = CustomTimeCardApprovalController.getWeekEndDate(System.today());
    timecardHeader.pse__Status__C = 'Submitted';
    timecardHeader.pse__Billed__c = false;
    timecardHeader.pse__Billable__c = false;
    timecardHeader.pse__Project_Methodology__c = 'LXK_SE - Admin';
    timecardHeader.pse__Submitted__c = true;
    timecardHeader.Product_Line__c = 'ISS';
    timecardHeader.ownerid = us1.id;
    timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 

     insert timecardHeader;
    system.assert(timecardHeader.Id != null);
    
    pse__Timecard_Header__c timecardHeader2 = new pse__Timecard_Header__c();
    timecardHeader2.pse__Project__c = project.Id;
    timecardHeader2.pse__Resource__c = testContact.Id;
    timecardHeader2.pse__Start_Date__c = CustomTimeCardApprovalController.getWeekStartDate(System.today());
    timecardHeader2.pse__End_Date__c = CustomTimeCardApprovalController.getWeekEndDate(System.today());
    timecardHeader2.pse__Status__C = 'Submitted';
    timecardHeader2.pse__Billed__c = false;
    timecardHeader2.pse__Billable__c = false;
    timecardHeader2.pse__Project_Methodology__c = 'LXK_SE - Admin';
    timecardHeader2.pse__Submitted__c = true;
    timecardHeader2.Product_Line__c = 'ISS';
    timecardHeader2.ownerid = us1.id;
    timecardHeader2.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 
    
    insert timecardHeader2;
    system.assert(timecardHeader.Id != null);
    
    Test.startTest();
    //public static methods
    Date endDate = CustomTimeCardApprovalController.getWeekEndDate(System.today());
    Date startDate = CustomTimeCardApprovalController.getWeekStartDate(System.today());
     CustomTimeCardApprovalController controller;
      try{
     controller = new CustomTimeCardApprovalController();
      }catch(exception ex){}
    
    CustomTimeCardApprovalController.TimeCard timecard = new CustomTimeCardApprovalController.TimeCard(); 
    List<CustomTimeCardApprovalController.TimeCard> lstTimeCards = new List<CustomTimeCardApprovalController.TimeCard>();
    
    timecard = new CustomTimeCardApprovalController.timeCard(true, 'saved', timecardHeader.Id, timecardHeader.Name,
                                                                testContact.Id, testContact.Name, 'test',
                                                                30.00, system.today(), Double.valueOf(40), 1200.00,'testa', 'test', 'USD', project.Name,
                                                                project.pse__Account__r.Name, string.valueOf(project.pse__Account__c), project.pse__Billing_Type__c);
    
    timecard = new CustomTimeCardApprovalController.TimeCard(true, 'Submitted', timecardHeader.Id, timecardHeader.Name,
                                                                testContact.Id, testContact.Name, 'test',
                                                                30, endDate, Double.valueOf(40), 1200, 'test','test', 'USD', project.Name,
                                                                project.pse__Account__r.Name, project.pse__Account__c, project.pse__Billing_Type__c);
    lstTimeCards.add(timecard);
    
    timecard = new CustomTimeCardApprovalController.TimeCard(true, 'Submitted', timecardHeader.Id, timecardHeader.Name,
                                                                testContact.Id, testContact.Name, 'test',
                                                                30, endDate, Double.valueOf(40), 1200, 'test','test', 'USD', project.Name,
                                                                project.pse__Account__r.Name, project.pse__Account__c, project.pse__Billing_Type__c);
    lstTimeCards.add(timecard);
    lstTimeCards.add(timecard);
    
    CustomTimeCardApprovalController.ProjectBase projBase;
    system.debug('*******Timecard1');
    //projBase = new CustomTimeCardApprovalController.ProjectBase('test manager', 'test project', lstTimeCards, testAccount.Name , testAccount.Id, 'Administrative');
    system.debug('*******Timecard2');
   
    //controller.projectBaseList.add(projBase);
    
    projBase = new CustomTimeCardApprovalController.ProjectBase('test manager', 'test project', lstTimeCards, System.today(), System.today().addDays(6), testAccount.Name , testAccount.Id, 'Administrative');
    controller.projectBaseList.add(projBase);
    CustomTimeCardApprovalController.ProjectBase projBase2 = new CustomTimeCardApprovalController.ProjectBase('abc','test manager', 'test project', lstTimeCards, System.today(), System.today().addDays(6), testAccount.Name , testAccount.Id, 'Administrative');
    CustomTimeCardApprovalController.ProjectBase projBase3 = new CustomTimeCardApprovalController.ProjectBase('test manager', 'test project', lstTimeCards, testAccount.Name , testAccount.Id, 'Administrative');
    controller.projectBaseList.add(projBase2);
    controller.projectBaseList.add(projBase3);
      
    Decimal totalAmt = projBase.totalAmount;
   // System.assertEquals(1500, totalAmt);
    
    double totalhours = projBase.totalhours;
  //  System.assertEquals(50, totalhours);
    
    string currencyISOCode = projBase.currencyISOCode;
   // System.assertEquals('USD', currencyISOCode);
    controller.run();
    controller.refreshPMList();
    controller.Approve();
//        controller.run();
      controller.Reject();
    
    timecards_headers.add(timecardHeader);
   
    TCApprovalHelper.updateTCsWithApproved(timecards_headers);
    timecards_headers.clear();
    timecards_headers.add(timecardHeader2);
    TCApprovalHelper.updateTCsWithRejected(timecards_headers);
            
    Test.stopTest();

  }
}