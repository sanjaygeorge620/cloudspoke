/******************************************************************
Class Name   : Test_PSE_TimecardDetermineApprover
Created by   : Appirio
Created Date : December 18, 2009
Purpose      : Test Class for Trigger PSE_TimecardDetermineApprover
********************************************************************/
@isTest
private class Test_PSE_TimecardDetermineApprover 
{

    static  Date todayDate ;
    static  ID userId ;
    
    static testMethod void testPSE_TimecardDetermineApprover() 
    {
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
         //Insert region 
        pse__Region__c pse_region = new pse__Region__c();
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
        insert pse_practice;
        system.assert(pse_practice.Id != null);
        
        //Insert Group
        pse__Grp__c  pse_group = new pse__Grp__c(name='test Group');
        pse_group.CurrencyIsoCode = 'USD';
        pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
        pse_Group.pse__Parent_Group__c = parentGroup.Id;
        insert pse_group;
        system.assert(pse_group.Id!=null);
          
        /* get a Manager and normal User resource */
        /*Contact xpm = [select id, Name, pse__Salesforce_User__r.Id from Contact where pse__Salesforce_User__r.profile.Name = 'PSE Manager' limit 1];
        Contact xresource = [select id, Name from Contact where pse__Salesforce_User__r.profile.Name = 'PSE User' limit 1];
        */
        Set<String> userProfile = new Set<String>();
        userProfile.add('PSE Manager');
        userProfile.add('PSE User');
        userProfile.add('System Administrator');
       
        Map<String,ID> userProfileMap = new Map<String,ID>();
       
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
         userProfileMap.put(profile.Name,profile.Id);
        }
       
        //Insert User
        User u = new User();
        u.Username = '123E@test.com';
        u.LastName = 'User Manager';
        u.Email = 'megha.agarwal@lexmark.com';
        u.Alias = 'tes12';
        u.CommunityNickname = 'tuser31';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.EmployeeNumber = '0000100';
        if(userProfileMap.containsKey('PSE Manager')){
         u.ProfileId = userProfileMap.get('PSE Manager');
        }else{
         u.ProfileId = userProfileMap.get('System Administrator');
        }
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        u.LX_Geo__c = 'North America';
        u.LX_Region__c = 'USA';
        u.LX_Country__c = 'USA';
        u.Legacy_Company__c='ISYS';
        insert u;
        system.assert(u.Id != null);
       
         //Insert User
        User u1 = new User();
        u1.Username = '1234gdhsj@test.com';
        u1.LastName = 'User';
        u1.Email = 'megha.agarwal@lexmark.com';
        u1.Alias = 'tes123';
        u1.CommunityNickname = 'tuser311';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.EmployeeNumber = '0000101';
        if(userProfileMap.containsKey('PSE User')){
            u1.ProfileId = userProfileMap.get('PSE User');
        }else{
            u1.ProfileId = userProfileMap.get('System Administrator');
        }
        u1.LanguageLocaleKey = 'en_US';
        u1.LX_Geo__c = 'North America';
        u1.LX_Region__c = 'USA';
        u1.LX_Country__c = 'USA';
        u1.Legacy_Company__c='ISYS';
        insert u1;
        system.assert(u1.Id != null);
       
        //Insert Account
        Account testAccount = new Account();
        testAccount.Name = 'Test';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry = 'USA';
        testAccount.TR_Status__c ='Off';
        insert testAccount;
        system.assert(testAccount.Id != null);
        
        //Insert Contact
        Contact xpm = new Contact();
        xpm.LastName = 'Test';
        xpm.AccountId = testAccount.Id;
        xpm.CurrencyIsoCode = 'USD';
        xpm.pse__Is_Resource_Active__c = true;
        xpm.pse__Is_Resource__c = true;    
        xpm.pse__Resource_Role__c ='Consultant';
        xpm.pse__Default_Cost_Rate__c = 25.0;
        xpm.pse__Region__c = pse_region.Id;
        xpm.pse__Salesforce_User__c = u.Id;  
        xpm.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        xpm.Email = 'megha.agarwal@metacube.com';  
        insert xpm;
        system.assert(xpm.Id != null); 
        
        //Insert Contact
        Contact xresource = new Contact();
        xresource.LastName = 'Test';
        xresource.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        xresource.AccountId = testAccount.Id;
        xresource.CurrencyIsoCode = 'USD';
        xresource.pse__Is_Resource_Active__c = true;
        xresource.pse__Is_Resource__c = true;    
        xresource.pse__Resource_Role__c ='Consultant';
        xresource.pse__Default_Cost_Rate__c = 25.0;
        xresource.pse__Region__c = pse_region.Id;
        xresource.pse__Salesforce_User__c = u1.Id;  
        xresource.Email = 'megha.agarwal@metacube.com';  
        insert xresource;
        system.assert(xresource.Id != null);
         
        /* create the project, set the PM and Owner to be the Manager resource */
        pse__Proj__c project = new pse__Proj__c(Name='test_project');
        project.pse__Is_Billable__c = false;
        project.pse__Project_Manager__c = u.id;
        project.pse__Is_Active__c = true;
        project.pse__Project_Status__c = 'Green';
        project.pse__Allow_Timecards_Without_Assignment__c = true; // note, set this to TRUE so we don't need to create an Assignment
        project.pse__Start_Date__c = todayDate.addMonths(-1);
        project.pse__End_Date__c = todayDate.addMonths(4);
        project.pse__Region__c = pse_region.Id;     
        project.pse__Practice__c = pse_practice.Id;  
        project.pse__Project_Phase__c = 'Design';
        project.CurrencyIsoCode ='USD';
        project.pse__Billing_Type__c = 'Administrative';
        project.pse__Project_Manager__c = xpm.id;
        project.pse__Account__c = testAccount.id;
        project.OwnerId = u.id;
        project.Product_Line_s__c ='ISS';
        insert project; 

        //give permissions to resource
        pse__Permission_Control__c perControl1 = new pse__Permission_Control__c();
        perControl1.pse__User__c = UserInfo.getUserId();
        perControl1.pse__Resource__c = xresource.Id;
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
        insert perControl1;
        system.assert(perControl1.Id != null);
        
        /* create timecard with status of 'saved' */       
        pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = project.Id;
        timecardHeader.pse__Resource__c = xresource.id;
        timecardHeader.pse__Start_Date__c = todayDate;
        timecardHeader.pse__End_Date__c = todayDate.addDays(6);
        timecardHeader.pse__Status__C = 'Saved';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Project_Methodology__c = 'LXK_SE - Admin';
        timecardHeader.pse__Submitted__c = false;
        timecardHeader.Product_Line__c = 'ISS';
        timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 

        insert timecardHeader;

        Test.startTest(); 
      
        /* flip status to 'Submitted' to fire the trigger */
        timecardHeader.pse__Status__C = 'Submitted';
        timecardHeader.pse__Submitted__c = true;

        update timecardHeader;
        
        Test.stopTest();
       
    }
    
       static testMethod void testPSE_TimecardDetermineApprover2() 
    {
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
         //Insert region 
        pse__Region__c pse_region = new pse__Region__c();
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
        insert pse_practice;
        system.assert(pse_practice.Id != null);
        
        //Insert Group
        pse__Grp__c  pse_group = new pse__Grp__c(name='test Group');
        pse_group.CurrencyIsoCode = 'USD';
        pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
        pse_Group.pse__Parent_Group__c = parentGroup.Id;
        insert pse_group;
        system.assert(pse_group.Id!=null);
          
        /* get a Manager and normal User resource */
        /*Contact xpm = [select id, Name, pse__Salesforce_User__r.Id from Contact where pse__Salesforce_User__r.profile.Name = 'PSE Manager' limit 1];
        Contact xresource = [select id, Name from Contact where pse__Salesforce_User__r.profile.Name = 'PSE User' limit 1];
        */
        Set<String> userProfile = new Set<String>();
        userProfile.add('PSE Manager');
        userProfile.add('PSE User');
        userProfile.add('System Administrator');
       
        Map<String,ID> userProfileMap = new Map<String,ID>();
       
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
         userProfileMap.put(profile.Name,profile.Id);
        }
       
        //Insert User
        User u = new User();
        u.Username = '123E@test.com';
        u.LastName = 'User Manager';
        u.Email = 'megha.agarwal@lexmark.com';
        u.Alias = 'tes12';
        u.CommunityNickname = 'tuser31';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.EmployeeNumber = '0000110';
        if(userProfileMap.containsKey('PSE Manager')){
         u.ProfileId = userProfileMap.get('PSE Manager');
        }else{
         u.ProfileId = userProfileMap.get('System Administrator');
        }
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        u.LX_Geo__c = 'North America';
        u.LX_Region__c = 'USA';
        u.LX_Country__c = 'USA';
        u.Legacy_Company__c='ISYS';
        insert u;
        system.assert(u.Id != null);
       
         //Insert User
        User u1 = new User();
        u1.Username = '1234gdhsj@test.com';
        u1.LastName = 'User';
        u1.Email = 'megha.agarwal@lexmark.com';
        u1.Alias = 'tes123';
        u1.CommunityNickname = 'tuser311';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.EmployeeNumber = '0000111';
        if(userProfileMap.containsKey('PSE User')){
            u1.ProfileId = userProfileMap.get('PSE User');
        }else{
            u1.ProfileId = userProfileMap.get('System Administrator');
        }
        u1.LanguageLocaleKey = 'en_US';
        u1.ManagerId = UserInfo.getUserId();
        u1.LX_Geo__c = 'North America';
        u1.LX_Region__c = 'USA';
        u1.LX_Country__c = 'USA';
        u1.Legacy_Company__c='ISYS';
        insert u1;
        system.assert(u1.Id != null);
       
        //Insert Account
        Account testAccount = new Account();
        testAccount.Name = 'Test';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry = 'USA';
        testAccount.TR_Status__c ='Off';
        insert testAccount;
        system.assert(testAccount.Id != null);
        
        //Insert Contact
        Contact xpm = new Contact();
        xpm.LastName = 'Test';
        xpm.AccountId = testAccount.Id;
        xpm.CurrencyIsoCode = 'USD';
        xpm.pse__Is_Resource_Active__c = true;
        xpm.pse__Is_Resource__c = true;    
        xpm.pse__Resource_Role__c ='Consultant';
        xpm.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        xpm.pse__Default_Cost_Rate__c = 25.0;
        xpm.pse__Region__c = pse_region.Id;
        xpm.pse__Salesforce_User__c = u.Id;  
        xpm.Email = 'megha.agarwal@metacube.com';  
        insert xpm;
        system.assert(xpm.Id != null); 
        
        //Insert Contact
        Contact xresource = new Contact();
        xresource.LastName = 'Test';
        xresource.AccountId = testAccount.Id;
        xresource.CurrencyIsoCode = 'USD';
        xresource.pse__Is_Resource_Active__c = true;
        xresource.pse__Is_Resource__c = true;    
        xresource.pse__Resource_Role__c ='Consultant';
        xresource.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        xresource.pse__Default_Cost_Rate__c = 25.0;
        xresource.pse__Region__c = pse_region.Id;
        xresource.pse__Salesforce_User__c = u1.Id;  
        xresource.Delegate_PSE_Approver__c = U.id;
        xresource.Email = 'megha.agarwal@metacube.com';  
        insert xresource;
        system.assert(xresource.Id != null);
         
        /* create the project, set the PM and Owner to be the Manager resource */
        pse__Proj__c project = new pse__Proj__c(Name='test_project');
        project.pse__Is_Billable__c = false;        
        project.pse__Is_Active__c = true;
        project.pse__Project_Status__c = 'Green';
        project.pse__Allow_Timecards_Without_Assignment__c = true; // note, set this to TRUE so we don't need to create an Assignment
        project.pse__Start_Date__c = todayDate.addMonths(-1);
        project.pse__End_Date__c = todayDate.addMonths(4);
        project.pse__Region__c = pse_region.Id;     
        project.pse__Practice__c = pse_practice.Id;  
        project.pse__Project_Phase__c = 'Design';
        project.CurrencyIsoCode ='USD';
        project.pse__Billing_Type__c = 'Administrative';        
        project.pse__Account__c = testAccount.id;
        project.Product_Line_s__c ='ISS';
        project.OwnerId = u.id;
        insert project; 

        //give permissions to resource
        pse__Permission_Control__c perControl1 = new pse__Permission_Control__c();
        perControl1.pse__User__c = UserInfo.getUserId();
        perControl1.pse__Resource__c = xresource.Id;
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
        insert perControl1;
        system.assert(perControl1.Id != null);
        
        /* create timecard with status of 'saved' */       
        pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = project.Id;
        timecardHeader.pse__Resource__c = xresource.id;
        timecardHeader.pse__Start_Date__c = todayDate;
        timecardHeader.pse__End_Date__c = todayDate.addDays(6);
        timecardHeader.pse__Status__C = 'Saved';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Project_Methodology__c = 'LXK_SE - Admin';
        timecardHeader.pse__Submitted__c = false;
        timecardHeader.Product_Line__c = 'ISS';
        timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 
        insert timecardHeader;

        Test.startTest(); 
      
        /* flip status to 'Submitted' to fire the trigger */
        timecardHeader.pse__Status__C = 'Submitted';
        timecardHeader.pse__Submitted__c = true;

        update timecardHeader;
        
        Test.stopTest();
       
    }
    
    static testMethod void testPSE_TimecardDetermineApprover3() 
    {
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
         //Insert region 
        pse__Region__c pse_region = new pse__Region__c();
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
        insert pse_practice;
        system.assert(pse_practice.Id != null);
        
        //Insert Group
        pse__Grp__c  pse_group = new pse__Grp__c(name='test Group');
        pse_group.CurrencyIsoCode = 'USD';
        pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
        pse_Group.pse__Parent_Group__c = parentGroup.Id;
        insert pse_group;
        system.assert(pse_group.Id!=null);
          
        /* get a Manager and normal User resource */
        /*Contact xpm = [select id, Name, pse__Salesforce_User__r.Id from Contact where pse__Salesforce_User__r.profile.Name = 'PSE Manager' limit 1];
        Contact xresource = [select id, Name from Contact where pse__Salesforce_User__r.profile.Name = 'PSE User' limit 1];
        */
        Set<String> userProfile = new Set<String>();
        userProfile.add('PSE Manager');
        userProfile.add('PSE User');
        userProfile.add('System Administrator');
       
        Map<String,ID> userProfileMap = new Map<String,ID>();
       
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
         userProfileMap.put(profile.Name,profile.Id);
        }
       
        //Insert User
        User u = new User();
        u.Username = '123E@test.com';
        u.LastName = 'User Manager';
        u.Email = 'megha.agarwal@lexmark.com';
        u.Alias = 'tes12';
        u.CommunityNickname = 'tuser31';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.EmployeeNumber = '0000120';
        if(userProfileMap.containsKey('PSE Manager')){
         u.ProfileId = userProfileMap.get('PSE Manager');
        }else{
         u.ProfileId = userProfileMap.get('System Administrator');
        }
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        u.LX_Geo__c = 'North America';
        u.LX_Region__c = 'USA';
        u.LX_Country__c = 'USA';
        u.Legacy_Company__c='ISYS';
        insert u;
        system.assert(u.Id != null);
       
         //Insert User
        User u1 = new User();
        u1.Username = '1234gdhsj@lexmark.com';
        u1.LastName = 'User';
        u1.Email = 'megha.agarwal@lexmark.com';
        u1.Alias = 'tes123';
        u1.CommunityNickname = 'tuser311';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.EmployeeNumber = '0000121';
        u1.managerid = u.id;
        if(userProfileMap.containsKey('PSE User')){
            u1.ProfileId = userProfileMap.get('PSE User');
        }else{
            u1.ProfileId = userProfileMap.get('System Administrator');
        }
        u1.LanguageLocaleKey = 'en_US';      
        u1.LX_Geo__c = 'North America';
        u1.LX_Region__c = 'USA';
        u1.LX_Country__c = 'USA';  
        u1.Legacy_Company__c='ISYS';
        insert u1;
        system.assert(u1.Id != null);
       
        //Insert Account
        Account testAccount = new Account();
        testAccount.Name = 'Test';
        testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry = 'USA';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.TR_Status__c ='Off';
        insert testAccount;
        system.assert(testAccount.Id != null);
        
        //Insert Contact
        Contact xpm = new Contact();
        xpm.LastName = 'Test';
        xpm.AccountId = testAccount.Id;
        xpm.CurrencyIsoCode = 'USD';
        xpm.pse__Is_Resource_Active__c = true;
        xpm.pse__Is_Resource__c = true;    
        xpm.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        xpm.pse__Resource_Role__c ='Consultant';
        xpm.pse__Default_Cost_Rate__c = 25.0;
        xpm.pse__Region__c = pse_region.Id;
        xpm.pse__Salesforce_User__c = u.Id;  
        xpm.Email = 'megha.agarwal@metacube.com';  
        insert xpm;
        system.assert(xpm.Id != null); 
        
        //Insert Contact
        Contact xresource = new Contact();
        xresource.LastName = 'Test';
        xresource.AccountId = testAccount.Id;
        xresource.CurrencyIsoCode = 'USD';
        xresource.pse__Is_Resource_Active__c = true;
        xresource.pse__Is_Resource__c = true;    
        xresource.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        xresource.pse__Resource_Role__c ='Consultant';
        xresource.pse__Default_Cost_Rate__c = 25.0;
        xresource.pse__Region__c = pse_region.Id;
        xresource.pse__Salesforce_User__c = u1.Id;  
      //  xresource.Delegate_PSE_Approver__c = U.id;
        xresource.Email = 'megha.agarwal@metacube.com';  
        insert xresource;
        system.assert(xresource.Id != null);
         
        /* create the project, set the PM and Owner to be the Manager resource */
        pse__Proj__c project = new pse__Proj__c(Name='test_project');
        project.pse__Is_Billable__c = false;        
        project.pse__Is_Active__c = true;
        project.pse__Project_Status__c = 'Green';
        project.pse__Allow_Timecards_Without_Assignment__c = true; // note, set this to TRUE so we don't need to create an Assignment
        project.pse__Start_Date__c = todayDate.addMonths(-1);
        project.pse__End_Date__c = todayDate.addMonths(4);
        project.pse__Region__c = pse_region.Id;     
        project.pse__Practice__c = pse_practice.Id;  
        project.pse__Project_Phase__c = 'Design';
        project.CurrencyIsoCode ='USD';
        project.pse__Billing_Type__c = 'Administrative';        
        project.pse__Account__c = testAccount.id;
        project.Product_Line_s__c ='ISS';
        project.OwnerId = u.id;
        insert project; 

        //give permissions to resource
        pse__Permission_Control__c perControl1 = new pse__Permission_Control__c();
        perControl1.pse__User__c = UserInfo.getUserId();
        perControl1.pse__Resource__c = xresource.Id;
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
        insert perControl1;
        system.assert(perControl1.Id != null);
        
        /* create timecard with status of 'saved' */       
        pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = project.Id;
        timecardHeader.pse__Resource__c = xresource.id;
        timecardHeader.pse__Start_Date__c = todayDate;
        timecardHeader.pse__End_Date__c = todayDate.addDays(6);
        timecardHeader.pse__Status__C = 'Submitted';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Project_Methodology__c = 'LXK_SE - Admin';
        timecardHeader.pse__Submitted__c = false; 
         timecardHeader.Product_Line__c = 'ISS';      
         timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 
        insert timecardHeader; 
        Test.startTest();
        /* flip status to 'Submitted' to fire the trigger */
        timecardHeader.pse__Status__C = 'Submitted';
        timecardHeader.pse__Submitted__c = true;
        
        update timecardHeader;        
        Test.stopTest();
       
    }
    
    // Added on 20 May 2014
    // Added by Pruthvi to test a condition when resource is the Project Manager.
    
    static testmethod void testPSE_TimecardDetermineApproverforPM(){
    
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
         //Insert region 
        pse__Region__c pse_region = new pse__Region__c();
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
        insert pse_practice;
        system.assert(pse_practice.Id != null);
        
        //Insert Group
        pse__Grp__c  pse_group = new pse__Grp__c(name='test Group');
        pse_group.CurrencyIsoCode = 'USD';
        pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
        pse_Group.pse__Parent_Group__c = parentGroup.Id;
        insert pse_group;
        system.assert(pse_group.Id!=null);
          
        /* get a Manager and normal User resource */
        /*Contact xpm = [select id, Name, pse__Salesforce_User__r.Id from Contact where pse__Salesforce_User__r.profile.Name = 'PSE Manager' limit 1];
        Contact xresource = [select id, Name from Contact where pse__Salesforce_User__r.profile.Name = 'PSE User' limit 1];
        */
        Set<String> userProfile = new Set<String>();
        userProfile.add('PSE Manager');
        userProfile.add('PSE User');
        userProfile.add('System Administrator');
       
        Map<String,ID> userProfileMap = new Map<String,ID>();
       
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
         userProfileMap.put(profile.Name,profile.Id);
        }
       
        //Insert User
        User u = new User();
        u.Username = '123E@test.com';
        u.LastName = 'User Manager';
        u.Email = 'megha.agarwal@lexmark.com';
        u.Alias = 'tes12';
        u.CommunityNickname = 'tuser31';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.EmployeeNumber = '0000120';
        if(userProfileMap.containsKey('PSE Manager')){
         u.ProfileId = userProfileMap.get('PSE Manager');
        }else{
         u.ProfileId = userProfileMap.get('System Administrator');
        }
        u.ProfileId = '00ei0000000WaeA';
        u.ManagerId = UserInfo.getUserId();
        u.LanguageLocaleKey = 'en_US';
        u.LX_Geo__c = 'North America';
        u.LX_Region__c = 'USA';
        u.LX_Country__c = 'USA';
        u.Legacy_Company__c='ISYS';
        insert u;
        system.assert(u.Id != null);
        
       
        //Insert Account
        Account testAccount = new Account();
        testAccount.Name = 'Test';
        testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry = 'USA';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.TR_Status__c ='Off';
        insert testAccount;
        system.assert(testAccount.Id != null);
        
        //Insert Contact
        Contact xpm = new Contact();
        xpm.LastName = 'Test';
        xpm.AccountId = testAccount.Id;
        xpm.CurrencyIsoCode = 'USD';
        xpm.pse__Is_Resource_Active__c = true;
        xpm.pse__Is_Resource__c = true;    
        xpm.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        xpm.pse__Resource_Role__c ='Consultant';
        xpm.pse__Default_Cost_Rate__c = 25.0;
        xpm.pse__Region__c = pse_region.Id;
        xpm.pse__Salesforce_User__c = u.Id;  
        xpm.Email = 'megha.agarwal@metacube.com';  
        insert xpm;
        system.assert(xpm.Id != null); 
        
         
        /* create the project, set the PM and Owner to be the Manager resource */
        pse__Proj__c project = new pse__Proj__c(Name='test_project');
        project.pse__Is_Billable__c = false;        
        project.pse__Is_Active__c = true;
        project.pse__Project_Status__c = 'Green';
        project.pse__Allow_Timecards_Without_Assignment__c = true; // note, set this to TRUE so we don't need to create an Assignment
        project.pse__Start_Date__c = todayDate.addMonths(-1);
        project.pse__End_Date__c = todayDate.addMonths(4);
        project.pse__Region__c = pse_region.Id;     
        project.pse__Practice__c = pse_practice.Id;  
        project.pse__Project_Phase__c = 'Design';
        project.CurrencyIsoCode ='USD';
        project.pse__Billing_Type__c = 'Administrative';        
        project.pse__Account__c = testAccount.id;
        project.pse__Project_Manager__c = xpm.id;
        project.Product_Line_s__c ='ISS';
        project.OwnerId = u.Id;
        insert project; 

        //give permissions to resource
        pse__Permission_Control__c perControl1 = new pse__Permission_Control__c();
        perControl1.pse__User__c = u.Id;
        perControl1.pse__Resource__c = xpm.Id;
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
        insert perControl1;
        system.assert(perControl1.Id != null);
        
        /* create timecard with status of 'saved' */       
        pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = project.Id;
        timecardHeader.pse__Resource__c = xpm.id;
        timecardHeader.pse__Start_Date__c = todayDate;
        timecardHeader.pse__End_Date__c = todayDate.addDays(6);
        timecardHeader.pse__Status__C = 'Saved';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Project_Methodology__c = 'PSW_INVST_PSAT';
        timecardHeader.pse__Submitted__c = false; 
        timecardHeader.Product_Line__c = 'ISS';      
        timecardHeader.recordTypeId = pse__Timecard_Header__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId(); 
        insert timecardHeader; 
        Test.startTest();
        /* flip status to 'Submitted' to fire the trigger */
        timecardHeader.pse__Status__C = 'Submitted';
        timecardHeader.pse__Submitted__c = true;
        
        update timecardHeader;        
        Test.stopTest();
       
    
    }
    
}