@isTest(seeAllData=true)
private class Test_TCApprovalHelper {

static testMethod void testTCApprovalHelper(){
    
    Test.startTest();
    
    Profile p = [SELECT Id FROM Profile WHERE Name='Tech DS']; 
    User u = new User(Alias = 'standt', Email='standarduser@lexmark.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='teststandarduser1248@lexmark.com', LX_Region__c= 'NE', LX_Ability_to_Create_Accounts__c = 'Yes', Legacy_Company__c='Lexmark');
    
    Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    User u1 = new User(Alias = 'stdt', Email='standarduser@lexmark.com', 
    EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p1.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='teststandarduserz1248@lexmark.com', LX_Region__c= 'NE', LX_Ability_to_Create_Accounts__c = 'Yes', Legacy_Company__c='Lexmark');

    //Testing as a standard user.
     List<pse__Proj__c> proj;
    System.runAs(u1){
       proj = new List<pse__Proj__c>();      
       proj = Data_Project.createProject(1);
    }
    System.runAs(u) {
     
       pse__Schedule__c sch = Data_Schedule.createSchedule();
      System.debug('Schedule is Created'+Sch);
   //   test.starttest();
      List<pse__Assignment__c> a = Data_Assignment.createAssignments(proj,sch,1);
      
      // insert a;  
       if(a!=null){
       List<pse__Timecard_Header__c> pseTCList = new List<pse__Timecard_Header__c>();
       pse__Timecard_Header__c pseTC = new pse__Timecard_Header__c();
       pseTC.ID_Legacy__c = 'abc';
       pseTC.pse__Project__c = proj[0].Id;
       pseTC.pse__Resource__c = a[0].pse__Resource__c;
       pseTC.pse__Start_Date__c = System.Today();
       pseTC.pse__End_Date__c = System.Today()+ 6;
       pseTC.pse__Assignment__c = a[0].Id;
       pseTC.pse__Bill_Rate__c = 0.0;
       pseTC.pse__Submitted__c = true;
       pseTCList.add(pseTC);
       TCApprovalHelper.updateTCs(pseTCList,'approved');
       //TCApprovalHelper.updateTCs(pseTCList,'rejected');
       //TCApprovalHelper.updateTCsWithRejected(pseTCList);
      }
       } 
        Test.stopTest();
    }
    
}