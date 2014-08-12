/*********************************************************************
Class Name   : Test_PSE_BillingEventDetermineApprover
Created by   : Chetan Garg
Created Date : December 18, 2009
Purpose      : Test Class for Trigger PSE_BillingEventDetermineApprover
***********************************************************************/
@isTest
private class Test_PSE_BillingEventDetermineApprover {

   
    
    static testMethod void testTrigger() {
        
    ID userId ;
    Date todayDate ;
    pse__Proj__c project ;
    Contact resource ;
    
    Set<String> userProfile = new Set<String>();
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           ProfileIds.add(profile.id);
        }
      List<User> userList = Data_User.createUser(1, profileIds);       
    
    userId = UserInfo.getUserId();
    todayDate = Date.today();

 /* pse__Region__c parentRegion = new pse__Region__c();
    insert parentRegion;
*/
pse__Region__c parentRegion = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1];

    pse__Region__c region = new pse__Region__c();
    region.pse__Parent_Region__c = parentRegion.Id;
    insert region;

    pse__Work_Calendar__c workCalendar = new pse__Work_Calendar__c();
    insert workCalendar;

    
 
    List<pse__Proj__c> Projects = Data_Project.createProject(1);     
    for (pse__Proj__c ProjectRec : Projects){    
        ProjectRec.pse__Is_Billable__c = false;
        ProjectRec.pse__Closed_for_Time_Entry__c 
            = ProjectRec.pse__Closed_for_Expense_Entry__c  
            = false;
        ProjectRec.pse__Allow_Expenses_Without_Assignment__c
                = ProjectRec.pse__Allow_Timecards_Without_Assignment__c
                = ProjectRec.pse__Is_Active__c
                = true;
            
            ProjectRec.OwnerId = userId;
    }   
    update Projects;
    
    Test.startTest();
    pse__Billing_Event__c billingEvent = new pse__Billing_Event__c();
    billingEvent.pse__Date__c = Date.today();
    billingEvent.CurrencyIsoCode ='USD';
    billingEvent.pse__Project__c = Projects[0].id; //project.id; 
    insert billingEvent;
    Test.stopTest();
    }
}