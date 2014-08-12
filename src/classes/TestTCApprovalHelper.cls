/*************************************************************************
Name              : TestTCApprovalHelper
Author            : Appirio Offshore
Created Date      : March 30, 2010
Description       : For code coverage for the class "TCApprovalHelper"
**************************************************************************/
@isTest
public class TestTCApprovalHelper {
  
  public static testmethod void testUnit1(){
      try{
          CustomTimeCardApprovalController cntr = new CustomTimeCardApprovalController ();
          cntr.refreshPMList();
          Date dt=CustomTimeCardApprovalController.getWeekEndDate(System.Today());
          Date dtsrt= CustomTimeCardApprovalController.getWeekStartDate(system.Today());
          System.debug('*********UsedBefore****************'+Limits.getScriptStatements());
          System.debug('*********LimitsBefore****************'+Limits.getLimitScriptStatements());
          
          cntr.Run();
          System.debug('*********UsedAfter1****************'+Limits.getScriptStatements());
          System.debug('*********LimitsAfter1****************'+Limits.getLimitScriptStatements());
          cntr.Approve();
          System.debug('*********UsedAfter1****************'+Limits.getScriptStatements());
          System.debug('*********LimitsAfter1****************'+Limits.getLimitScriptStatements());
          cntr.Reject();
          System.debug('*********UsedAfter1****************'+Limits.getScriptStatements());
          System.debug('*********LimitsAfter1****************'+Limits.getLimitScriptStatements());
      }
      catch(exception e){
      
      }
  }
  
  private static testmethod void testCase1() {
    pse__Region__c region = new pse__Region__c();
    region.Name = 'testregion';
    region.CurrencyIsoCode = 'USD';
    pse__Region__c parentRegion = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1];
    region.pse__Parent_Region__c = parentRegion.Id;
    insert region;
    system.assert(region.Id != null);
    
    pse__Grp__c grp = new pse__Grp__c();
    grp.Name = 'TestGrp';
    grp.CurrencyIsoCode = 'USD';
    pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
    grp.pse__Parent_Group__c = parentGroup.Id;
    insert grp;
    system.assert(grp.Id != null);

    pse__Practice__c practice = new pse__Practice__c();
    practice.Name = 'TestPractice';
    practice.CurrencyIsoCode = 'USD';
    pse__Practice__c parentPractice = [Select id from pse__Practice__c where pse__Parent_Practice__c = null or Name like '%Corporate Practice%' limit 1];
    practice.pse__Parent_Practice__c = parentPractice.Id;
    insert practice;
    system.assert(practice.Id != null);
    
    Account testAccount = new Account(Name ='Test Account');
    testAccount.Physical_Country__c = 'Albania';
    testAccount.BillingCountry = 'Albania';
    insert testAccount;
    system.assert(testAccount.Id != null);
    
    Contact testContact = new Contact();
    testContact.LastName = 'Test it';
    testContact.AccountId = testAccount.Id;
    testContact.CurrencyIsoCode = 'USD';
    testContact.pse__Is_Resource_Active__c = true;
    testContact.pse__Is_Resource__c = true;
    testContact.pse__Default_Cost_Rate__c = 25.0;
    //testContact.pse__Salesforce_User__c = System.Userinfo.getUserId();
    testContact.pse__Region__c = region.Id;
    testContact.pse__Group__c = grp.id;
    testContact.pse__Practice__c = practice.id;
    testContact.phone='1234567890';
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
    project.pse__Practice__c = practice.Id;  
    project.pse__Billing_Type__c = 'Administrative';
    project.CurrencyIsoCode ='USD';
    insert project; 
    system.assert(project.Id != null);
    
    pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
    timecardHeader.pse__Project__c = project.Id;
    timecardHeader.pse__Resource__c = testContact.Id;
    timecardHeader.pse__Start_Date__c = CustomTimeCardApprovalController.getWeekStartDate(System.today());
    timecardHeader.pse__End_Date__c = CustomTimeCardApprovalController.getWeekEndDate(System.today());
    timecardHeader.pse__Status__c = 'Saved';
    timecardHeader.pse__Billed__c = false;
    timecardHeader.pse__Billable__c = false;
    timecardHeader.pse__Submitted__c = true;
    timecardHeader.pse__Project_Methodology__c = 'Administrative';
    timecardHeader.OwnerId = Userinfo.getUserId();
    timecardHeader.pse__Admin_Global_Edit__c = true ; 
    timecardHeader.pse__Project_Methodology__c = 'LXK_SE - Admin';
    insert timecardHeader;
    
    system.assert(timecardHeader.Id != null);
    
    List<pse__Timecard_Header__c> pseTCList = new List<pse__Timecard_Header__c>();
    pseTCList.add(timecardHeader);
    
    Test.startTest();
    
    TCApprovalHelper.updateTCs(pseTCList, 'Rejected');
    System.assertEquals(pseTCList[0].pse__Status__c, 'Rejected');
    
    TCApprovalHelper.updateTCs(pseTCList, 'Approved');
    System.assertEquals(pseTCList[0].pse__Status__c, 'Approved');
    
  
    try {
      TCApprovalHelper.sendMailToOwner(pseTCList);
    }
    catch(Exception ex) {
      System.debug('Exception : ' + ex);
    }
    
    Test.stopTest();
  }
}