/******************************************************************
Class Name   : TestPSE_CascadeUpdatedOwnerId
Created by   : Appirio
Created Date : March 30, 2010
Purpose      : Test the PSE_ProjectPMIsOwner trigger on the 
               pse__Proj__c update trigger
********************************************************************/
@isTest
private class Test_PSE_ProjectPMIsOwner {

    static ID userId ;
    static  Date todayDate ;

    static testMethod void Test_PSE_ProjectPMIsOwner() {

        //List<User> userList = [select id, Name from User where profile.Name = 'System Administrator' LIMIT 2];
        
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

        Set<String> userProfile = new Set<String>();
        userProfile.add('PSE Manager');
        userProfile.add('PSE User');
        userProfile.add('System Administrator');
       
        Map<String,ID> userProfileMap = new Map<String,ID>();
       
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
         userProfileMap.put(profile.Name,profile.Id);
        }
        
        /* get a PM */
        //Contact PM_Contact = [Select Id from Contact where pse__Resource_Role__c = 'Project Manager' and pse__Is_Resource_Active__c = True limit 1];

        /* Create a PM */
        User u = new User();
        u.Username = '123C@test.com';
        u.LastName = 'User Manager';
        u.Email = 'test@lexmark.com'; 
        u.Alias = 'tes12';
        u.CommunityNickname = 'tuser31';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.Legacy_Company__c='ISYS';
        if(userProfileMap.containsKey('PSE Manager')){
         u.ProfileId = userProfileMap.get('PSE Manager');
        }else{
         u.ProfileId = userProfileMap.get('System Administrator');
        }
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        u.Lx_Region__c = 'NE';
        insert u;
        system.assert(u.Id != null);
        
        Account testAccount = new Account();
        testAccount.Name = 'Test';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.Ownerid = u.id;
        testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry = 'USA';
        testAccount.TR_Status__c ='Off';
        insert testAccount;
        system.assert(testAccount.Id != null);
        
        Contact PM_Contact = new Contact();
        PM_Contact.LastName = 'Test';
        PM_Contact.AccountId = testAccount.Id;
        PM_Contact.CurrencyIsoCode = 'USD';
        PM_Contact.pse__Is_Resource_Active__c = true;
        PM_Contact.pse__Is_Resource__c = true;    
        PM_Contact.pse__Resource_Role__c ='Project Manager';
        PM_Contact.pse__Default_Cost_Rate__c = 25.0;
        PM_Contact.pse__Region__c = pse_region.Id;
        PM_Contact.pse__Salesforce_User__c = u.Id;  
        PM_Contact.email='test@gmail.com';
        PM_Contact.Lx_Lexmark_Vertical__c = 'Manufacturing' ;
        insert PM_Contact;
        system.assert(PM_Contact.Id != null);        

        /* build project with basics, note, proj doesn't need any specific settings, just needs to have the PM field be a valid SFDC User and it must be changed */
        pse__Proj__c project = new pse__Proj__c(Name='Trigger-Test');
        //project.pse__Is_Billable__c = true;
        project.pse__Is_Active__c = true;
        project.pse__Project_Status__c = 'Green';
        project.pse__Start_Date__c = todayDate.addMonths(-1);
        project.pse__End_Date__c = todayDate.addMonths(4);
        project.OwnerId = userId;
        project.pse__Account__c = testAccount.id;
        


        insert project;
        
        Test.startTest();
             
        /* Set the PM on the Project record and the trigger should change the OwnerId from the 'userId' to 'PM_Contact'  */     
        project.pse__Project_Manager__c = PM_Contact.Id;
        update project;
        
        Test.stopTest();        
        
       // for (pse__Proj__c proj : [Select OwnerId from pse__Proj__c Where Name = :project.Name])
         //VT 8/25 COmmented   System.assertEquals(proj.OwnerId, PM_Contact.pse__Salesforce_User__c);
                
 
    }        

}