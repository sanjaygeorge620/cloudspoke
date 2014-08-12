/**
 * This class contains unit tests for validating the behavior of PSE_SetCreditedOnTimecard trigger.
 * Note: List Used for dml operations for update also to resolve SOQL Limit Exception
 *
 */
@isTest
private class Test_PSE_SetCreditedOnTimecard {
    static  Date todayDate ;
    static  ID userId ;
    
    static testMethod void triggerPSE_SetCreditedOnTimecardTest() {
/*        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
        
  */        
        /* get a Manager and normal User resource */
        /*Contact xpm = [select id, Name, pse__Salesforce_User__r.Id from Contact where pse__Salesforce_User__r.profile.Name = 'PSE Manager' limit 1];
        Contact xresource = [select id, Name from Contact where pse__Salesforce_User__r.profile.Name = 'PSE User' limit 1];
        */
 /*       Set<String> userProfile = new Set<String>();
        userProfile.add('PSE Manager');
        userProfile.add('PSE User');
        userProfile.add('System Administrator');
       
        Map<String,ID> userProfileMap = new Map<String,ID>();
       
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
         userProfileMap.put(profile.Name,profile.Id);
        }
 */       
        /* create the project, set the PM and Owner to be the Manager resource */
        
/*        List<pse__Proj__c> Projects = Data_Project.createProject(1);       
        pse__Proj__c project = projects[0];
  //      pse__Proj__c project1 = Projects[1];
        System.assertEquals(Projects.size(),1); 
       
       List<User> users = new List<User>();
        //Insert User
        User u = new User();
        u.Username = '12354@test.com';
        u.LastName = 'User Manager';
        u.Email = 'megha.agarwal@metacube.com';
        u.Alias = 'tes12';
        u.CommunityNickname = 'tuser31';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        if(userProfileMap.containsKey('PSE Manager')){
         u.ProfileId = userProfileMap.get('PSE Manager');
        }else{
         u.ProfileId = userProfileMap.get('System Administrator');
        }
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        users.add(u);
       
         //Insert User
  //      User u1 = new User();
  //      u1.Username = '123456980@test.com';
  //      u1.LastName = 'User';
  //      u1.Email = 'megha.agarwal@metacube.com';
  //      u1.Alias = 'tes123';
  //      u1.CommunityNickname = 'tuser311';
  //      u1.TimeZoneSidKey = 'America/New_York';
  //      u1.LocaleSidKey = 'en_US';
  //      u1.EmailEncodingKey = 'ISO-8859-1';
  //      if(userProfileMap.containsKey('PSE User')){
  //          u1.ProfileId = userProfileMap.get('PSE User');
  //      }else{
  //          u1.ProfileId = userProfileMap.get('System Administrator');
  //      }
  //      u1.LanguageLocaleKey = 'en_US';
  //      u1.ManagerId = UserInfo.getUserId();
  //      users.add(u1);
        
        insert users;
       
        //Insert Account
        Account testAccount = new Account();
        testAccount.Name = 'Test';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.BillingCountry = 'WLF';
        insert testAccount;
        system.assert(testAccount.Id != null);
        
        List<Contact> contacts =new List<Contact>(); 
        //Insert Contact
        Contact xpm = new Contact();
        xpm.LastName = 'Test';
        xpm.AccountId = testAccount.Id;
        xpm.CurrencyIsoCode = 'USD';
        xpm.pse__Is_Resource_Active__c = true;
        xpm.pse__Is_Resource__c = true;    
        xpm.pse__Resource_Role__c ='Consultant';
        xpm.pse__Default_Cost_Rate__c = 25.0;
        xpm.pse__Region__c = project.pse__region__r.id;
        xpm.pse__Salesforce_User__c = u.Id;  
        xpm.Email = 'megha.agarwal@metacube.com';  
        contacts.add(xpm);
        //system.assert(xpm.Id != null); 
        
        //Insert Contact
 
 //       Contact xresource = new Contact();
 //       xresource.LastName = 'Test123';
 //       xresource.AccountId = testAccount.Id;
 //       xresource.CurrencyIsoCode = 'USD';
 //       xresource.pse__Is_Resource_Active__c = true;
 //       xresource.pse__Is_Resource__c = true;    
 //       xresource.pse__Resource_Role__c ='Consultant';
  //      xresource.pse__Default_Cost_Rate__c = 25.0;
 //       xresource.pse__Region__c = project.pse__region__r.id;
 //       xresource.pse__Salesforce_User__c = u1.Id;  
 //       xresource.Email = 'megha.agarwal@metacube.com';  
 //       contacts.add(xresource);
        insert contacts;
         

        
        system.debug('####1'+[select pse__Is_Billable__c from pse__proj__c where id=:project.id]);
        system.debug('projects[0].pse__region__r.id: ' + projects[0].pse__region__c);  
        List<pse__Permission_Control__c> permissionControls = new List<pse__Permission_Control__c>();
        //give permissions to region
        pse__Permission_Control__c perControl2 = new pse__Permission_Control__c();
        perControl2.pse__User__c = UserInfo.getUserId();
        perControl2.pse__region__c = projects[0].pse__region__c;				//
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
        permissionControls.Add(perControl2);
       
        //give permissions to project
        pse__Permission_Control__c perControl = new pse__Permission_Control__c();
        perControl.pse__User__c = UserInfo.getUserId();
        perControl.pse__Project__c = project.Id;				//
        perControl.pse__Start_Date__c = Date.today();
        perControl.pse__End_Date__c = Date.today().addDays(10);
        perControl.pse__Cascading_Permission__c = true;
        perControl.pse__Timecard_Entry__c = true;
        perControl.pse__Timecard_Ops_Edit__c = true;
        perControl.pse__Resource_Request_Entry__c = true;
        perControl.pse__Billing__c = true;
        perControl.pse__Expense_Entry__c = true;
        perControl.pse__Expense_Ops_Edit__c = true;
        perControl.pse__Invoicing__c = true;
        perControl.pse__Skills_And_Certifications_Entry__c = true;
        perControl.pse__Skills_And_Certifications_View__c = true;
        perControl.pse__Staffing__c = true;
        perControl.CurrencyIsoCode = 'USD';
        permissionControls.Add(perControl);
        
 //       pse__Permission_Control__c perControl3 = new pse__Permission_Control__c();
 //       perControl3.pse__User__c = UserInfo.getUserId();
 //       perControl3.pse__Project__c = project1.Id;				//
 //       perControl3.pse__Start_Date__c = Date.today();
 //       perControl3.pse__End_Date__c = Date.today().addDays(10);
 //       perControl3.pse__Cascading_Permission__c = true;
 //       perControl3.pse__Timecard_Entry__c = true;
 //      perControl3.pse__Timecard_Ops_Edit__c = true;
 //       perControl3.pse__Resource_Request_Entry__c = true;
 //       perControl3.pse__Billing__c = true;
 //       perControl3.pse__Expense_Entry__c = true;
 //       perControl3.pse__Expense_Ops_Edit__c = true;
 //       perControl3.pse__Invoicing__c = true;
 //       perControl3.pse__Skills_And_Certifications_Entry__c = true;
 //       perControl3.pse__Skills_And_Certifications_View__c = true;
 //       perControl3.pse__Staffing__c = true;
 //       perControl3.CurrencyIsoCode = 'USD';
 //       permissionControls.Add(perControl3);
         
        //give permissions to resource
        pse__Permission_Control__c perControl1 = new pse__Permission_Control__c();
        perControl1.pse__User__c = UserInfo.getUserId();
        perControl1.pse__Resource__c = xpm.id;//xresource.Id;
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
        permissionControls.Add(perControl1);
        system.debug('permissionControls: ' + permissionControls);
        insert permissionControls;
        
        for(pse__Permission_Control__c  pc : permissionControls){
            system.assert(pc.Id != null);
        }
  */      
        /* build a schedule  */       
/*        List<pse__Schedule__c> schedules = new List<pse__Schedule__c>();
        pse__Schedule__c schedule = new pse__Schedule__c();        
        schedule.pse__Start_Date__c = Date.today();
        schedule.pse__End_Date__c = Date.today().addDays(1);        
        schedules.Add(schedule);
 */       
        /* build a schedule */       
  /*      pse__Schedule__c schedule1 = new pse__Schedule__c();        
        schedule1.pse__Start_Date__c = Date.today();
        schedule1.pse__End_Date__c = Date.today().addDays(2);        
        schedules.Add(schedule1);
 */      
        /* build a schedule */       
 /*       pse__Schedule__c schedule2 = new pse__Schedule__c();        
        schedule2.pse__Start_Date__c = Date.today();
        schedule2.pse__End_Date__c = Date.today().addDays(2);        
        schedules.Add(schedule2);
       
        insert schedules;
      
        for(pse__Schedule__c sch : schedules){
            system.assert(sch.Id != null);
        }
 */       
 //       List<pse__Assignment__c > assignments = new List<pse__Assignment__c>();
        /* create the billable Assignment using the normal user Resource */                
 /*       pse__Assignment__c assignment = new pse__Assignment__c();
        assignment.pse__Project__c = project.id;
        assignment.pse__Schedule__c = schedule.id;
        assignment.pse__Resource__c = xpm.id;//xresource.id;   
        assignment.pse__Bill_Rate__c = 0;
        assignment.pse__Is_Billable__c = true;
        assignment.pse__Cost_Rate_Amount__c = 0;
        assignment.CurrencyIsoCode = 'USD';
        assignments.Add(assignment);
*/        
        /* create the non-billable Assignment using the normal user Resource */        
 //       pse__Assignment__c nonBillableAssignment = new pse__Assignment__c();
 //       nonBillableAssignment.pse__Project__c = project1.id;
 //       nonBillableAssignment.pse__Schedule__c = schedule1.id;
 //       nonBillableAssignment.pse__Resource__c = xpm.id;//xresource.id;   
 //       nonBillableAssignment.pse__Bill_Rate__c = 0;
 //       nonBillableAssignment.pse__Is_Billable__c = false;
 //       nonBillableAssignment.pse__Cost_Rate_Amount__c = 0;
 //       nonBillableAssignment.CurrencyIsoCode = 'USD';
 //       assignments.Add(nonBillableAssignment);
        
        /* create the Time credited Assignment using the normal user Resource */        
     /*   pse__Assignment__c timeCreditedAssignment = new pse__Assignment__c();
        timeCreditedAssignment.pse__Project__c = project.id;
        timeCreditedAssignment.pse__Schedule__c = schedule2.id;
        timeCreditedAssignment.pse__Resource__c = xpm.id;//xresource.id;   
        timeCreditedAssignment.pse__Bill_Rate__c = 0;
        timeCreditedAssignment.pse__Is_Billable__c = false;
        timeCreditedAssignment.pse__Cost_Rate_Amount__c = 0;
        timeCreditedAssignment.CurrencyIsoCode = 'USD';
        timeCreditedAssignment.pse__Time_Credited__c = true;
        assignments.Add(timeCreditedAssignment);
        */
 /*       insert assignments;
        
        for(pse__Assignment__c ass: assignments){
            system.assert(ass.Id != null);
        }
     //   timeCreditedAssignment.pse__Time_Credited__c = true;
     //   update timeCreditedAssignment;
        
        List<pse__Timecard_Header__c> timecards = new List<pse__Timecard_Header__c>();
*/        
        /* create timecard with Billable of 'true' */       
/*        pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = project.Id;
        timecardHeader.pse__Resource__c = xpm.id;//xresource.id;
        timecardHeader.pse__Assignment__c = assignment.Id;
        timecardHeader.pse__Start_Date__c = todayDate;
        timecardHeader.pse__End_Date__c = todayDate.addDays(6);
        timecardHeader.pse__Status__C = 'Saved';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = true;
        timecardHeader.pse__Project_Methodology__c = 'Fixed Price Hours';
        timecardHeader.pse__Submitted__c = false;
        //insert timecardHeader;
        timecards.Add(timecardHeader);
       
        /* create timecard with Billable of 'true' */       
 //       pse__Timecard_Header__c timecardHeader1 = new pse__Timecard_Header__c();
 //       timecardHeader1.pse__Project__c = project.Id;
 //       timecardHeader1.pse__Resource__c = xpm.id;//xresource.id;
 //       timecardHeader1.pse__Assignment__c = assignment.Id;
 //       timecardHeader1.pse__Start_Date__c = todayDate;
 //       timecardHeader1.pse__End_Date__c = todayDate.addDays(6);
 //       timecardHeader1.pse__Status__C = 'Saved';
 //       timecardHeader1.pse__Billed__c = false;
 //       timecardHeader1.pse__Billable__c = true;
 //       timecardHeader1.pse__Project_Methodology__c = 'Fixed Price Hours';
 //       timecardHeader1.pse__Submitted__c = false;
        //insert timecardHeader1;
 //       timecards.Add(timecardHeader1);
       
         /* create non-billable timecard */
        
  //      pse__Timecard_Header__c nontimecardHeader = new pse__Timecard_Header__c();
  //      nontimecardHeader.pse__Project__c = project1.Id;
  //      nontimecardHeader.pse__Resource__c = xpm.id; //xresource.id;
  //      nontimecardHeader.pse__Assignment__c = nonBillableAssignment.Id;
  //      nontimecardHeader.pse__Start_Date__c = todayDate;
  //      nontimecardHeader.pse__End_Date__c = todayDate.addDays(6);
  //      nontimecardHeader.pse__Status__C = 'Saved';
  //      nontimecardHeader.pse__Billed__c = false;
   //     nontimecardHeader.pse__Billable__c = false;
   //     nontimecardHeader.pse__Project_Methodology__c = 'INVST_CORP';
  //      nontimecardHeader.pse__Submitted__c = false;
 //       //insert nontimecardHeader;
 //       timecards.Add(nontimecardHeader);
       
        /* create TimeCredited timecard */
         
     /*   pse__Timecard_Header__c timeCreditedtimecardHeader = new pse__Timecard_Header__c();
        timeCreditedtimecardHeader.pse__Project__c = project.Id;
        timeCreditedtimecardHeader.pse__Resource__c = xpm.id;//xresource.id;
        timeCreditedtimecardHeader.pse__Assignment__c = timeCreditedAssignment.Id;
        timeCreditedtimecardHeader.pse__Start_Date__c = todayDate;
        timeCreditedtimecardHeader.pse__End_Date__c = todayDate.addDays(6);
        timeCreditedtimecardHeader.pse__Status__C = 'Saved';
        timeCreditedtimecardHeader.pse__Billed__c = false;
        timeCreditedtimecardHeader.pse__Billable__c = false;
        timeCreditedtimecardHeader.pse__Project_Methodology__c = 'INVST_CORP';
        timeCreditedtimecardHeader.pse__Submitted__c = false;
        timeCreditedtimecardHeader.pse__Time_Credited__c = true;
        timecards.Add(timeCreditedtimecardHeader);
        //insert timeCreditedtimecardHeader;
      */  

/*        Test.StartTest();
        insert timecards;
        
        System.debug('Timecard with billable true Neeraj' + [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = :timecardHeader.Id]);
        
         for(pse__Timecard_Header__c tc : timecards){
            system.assert(tc.Id != null);
        }
        
        
//        List<pse__Timecard_Header__c> TCHeaderList=[select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader.id or id = : timecardHeader1.id];
        List<pse__Timecard_Header__c> TCHeaderList=[select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader.id];
       
        /*
        pse__Timecard_Header__c addedTCHeader;
        pse__Timecard_Header__c addedTCHeader1;
        List<pse__Timecard_Header__c> TCHeaderList=[select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader.id or id = : timecardHeader1.id];
        pse__Timecard_Header__c addedTCHeader;
        pse__Timecard_Header__c addedTCHeader1;
        for(pse__Timecard_Header__c obj : TCHeaderList){
            if(obj.Id == timecardHeader.id)
                addedTCHeader = obj;
            if(obj.Id == timecardHeader1.id)
                addedTCHeader1 = obj;
        }
        System.assertEquals(addedTCHeader.pse__Time_Credited__c,false); 
        System.assertEquals(addedTCHeader1.pse__Time_Credited__c,true); 
        
        */
        
        
 /*       System.assert(false == [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader.id][0].pse__Time_Credited__c);
 //       System.assert(false == [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader1.id][0].pse__Time_Credited__c);
  //      System.assert(true == [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : nontimecardHeader.id][0].pse__Time_Credited__c);
        TCHeaderList.clear();
 */       
        
        /* update billable timecard to non-billable */
 /*       timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Project_Methodology__c = 'INVST_CORP';
        
        TCHeaderList.add(timecardHeader);
        system.debug('####'+[select pse__Is_Billable__c from pse__proj__c where id=:project.id]);
        System.debug('Neeraj::::::::Project'+project.pse__Is_Billable__c);
        System.debug('Neeraj::::::::assignment'+assignment.pse__Is_Billable__c);
        
         /* update non-billable to billable */
  //      timecardHeader1.pse__Billable__c = true;
  //      timecardHeader1.pse__Project_Methodology__c = 'Fixed Price Hours';
  //      //TCHeaderList.add(timecardHeader1);
  //      System.debug('########Neeraj TCHeaderList ####' + TCHeaderList);
        
        
        //Change a non-billable assignment to billable, update original timecard (that was non-billable) -> assert timecard is still time credited
  //      nonBillableAssignment.pse__Is_Billable__c = true;
  //      update nonBillableAssignment;
  //      nontimecardHeader.pse__Monday_Hours__c = 8;
        //update nontimecardHeader;
  //      TCHeaderList.add(nontimecardHeader);
        
 /*       update TCHeaderList;
        TCHeaderList.clear();
         
        System.assert(true == [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader.id][0].pse__Time_Credited__c);
 //       System.assert(false == [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader1.id][0].pse__Time_Credited__c);

        //Non-Billable Assignment, Non-Billable timecard (create). Change Assignment to Billable. Make some change to timecard-> assert Time Credited 
       
       /* TCHeaderList = [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timecardHeader.id or id = :timecardHeader1.id];
        
        System.assert(2==TCHeaderList.size());
        pse__Timecard_Header__c addedTCHeader2;
        for(pse__Timecard_Header__c obj : TCHeaderList){
            if(obj.id == timecardHeader.id)
                addedTCHeader1 = obj;
            if(obj.id == timecardHeader1.id)
                addedTCHeader2 = obj;
        } 
        
        System.assertEquals(true,addedTCHeader1.pse__Time_Credited__c);
        System.assertEquals(true,addedTCHeader2.pse__Time_Credited__c); 
        
         addedTCHeader2 = [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : nontimecardHeader.id];
        System.assertEquals(addedTCHeader2.pse__Time_Credited__c,true);
        */
        
        
        //Time Credited Assignment, Time Credited timecard (create) -> assert Time Credited = true 
 //       pse__Timecard_Header__c addedTCHeader3 = [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timeCreditedtimecardHeader.id];
 //       System.assertEquals(addedTCHeader3.pse__Time_Credited__c,true); 
               
        
        //Time Credited Assignment, Time Credited timecard (update any value) -> assert Time Credited = true
//        timeCreditedtimecardHeader.pse__Monday_Hours__c = 8;
     //   update timeCreditedtimecardHeader; 
 //       addedTCHeader3 = [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timeCreditedtimecardHeader.id];
 //       System.assertEquals(addedTCHeader3.pse__Time_Credited__c,true);
        
 //       timeCreditedtimecardHeader.pse__Billable__c = true;
//        timeCreditedtimecardHeader.pse__Project__c = project.Id;
//        timeCreditedtimecardHeader.pse__Project_Methodology__c = 'Fixed Price Hours';
        
        /*update timeCreditedtimecardHeader; 
        addedTCHeader3 = [select Id,Name,pse__Time_Credited__c from pse__Timecard_Header__c where id = : timeCreditedtimecardHeader.id];
        System.assertEquals(addedTCHeader3.pse__Time_Credited__c,false);
        */
        
/*        Test.StopTest(); 
*/
    }
    
}