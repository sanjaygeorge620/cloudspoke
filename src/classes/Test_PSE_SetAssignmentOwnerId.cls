/**************************************************************
Class Name   : Test_PSE_SetAssignmentOwnerId
Created by   : Appirio
Created Date : December 18, 2009
Modified By : Appirio Offshore(Megha)
Modified Date : April 06,2010
Purpose      : Test Class for Trigger PSE_SetAssignmentOwnerId
***************************************************************/
@isTest
private class Test_PSE_SetAssignmentOwnerId {
    
    static  Date todayDate ;
    
    static testMethod void testTrigger() {
        todayDate = Date.today();
        
        Set<String> userProfile = new Set<String>();
        userProfile.add('System Administrator');
        //userProfile.add('PSE User');
       
        Map<String,ID> userProfileMap = new Map<String,ID>();
       
        List<ID> ProfileIds = new List<ID>();
         
        for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           //userProfileMap.put(profile.Name,profile.Id);
           ProfileIds.add(profile.id);
        }
        system.debug('profileIds: '+ ProfileIds);
        List<User> userList = Data_User.createUser(2, profileIds); 
        System.assertEquals(userList.size(),2); 
        System.runAs(userList[0])
        {
            //Insert Account
  
        
        
  
        system.debug('Check 2' + Limits.getQueries());
        /* create the project, set the PM and Owner to be the Manager resource */
        
        List<pse__Proj__c> Projects = Data_Project.createProject(1); 
        
        system.debug('Check 3' + Limits.getQueries());
        
         Test.startTest(); 
         
         //Account testAccount = Data_Account.createAccount();       
         //System.assert(testAccount.id != null);
           
         system.debug('Check 4' + Limits.getQueries()); 
        for(pse__Proj__c project : Projects){
           // project.pse__Project_Manager__c = Projects[0].Accounting_Contact__c;
        }
        update Projects;
       
        
        /* get a Manager and normal User resource */
        /*Contact xpm = [select id, Name, pse__Salesforce_User__r.Id from Contact where pse__Salesforce_User__r.profile.Name = 'PSE Manager' limit 1];
        Contact xresource = [select id, Name from Contact where pse__Salesforce_User__r.profile.Name = 'PSE User' limit 1];
        */
        //System.debug('DEBUG 1 PM Resource:'+ Projects[0].Accounting_Contact__r.Name);
        //System.debug('DEBUG 2 Resource: '+ Projects[0].Accounting_Contact__r.Name); 
        //System.debug('DEBUG 2.5 Resource.Salesforce__c: '+Projects[0].Accounting_Contact__r.pse__Salesforce_User__c); 

        
        /* give PM permissions to create an assignment for the Resource, Note, the Project needs to have same Region */
        
       Data_UserPermissionControl.createPermission(projects);
        
        
        /* build a schedule (don't think we need this, commented it out below) */       
        pse__Schedule__c schedule = new pse__Schedule__c();        
        schedule.pse__Start_Date__c = Date.today();
        schedule.pse__End_Date__c = Date.today().addDays(1);        
        insert schedule;
        
        /* create the Assignment using the normal user Resource */        
        pse__Assignment__c assignment = new pse__Assignment__c();
        assignment.pse__Project__c = projects[0].id;
        assignment.pse__Schedule__c = schedule.id;
        //assignment.pse__Resource__c = Projects[0].Accounting_Contact__c;   
        assignment.pse__Bill_Rate__c = 0;
        assignment.pse__Is_Billable__c = true;
        assignment.pse__Cost_Rate_Amount__c = 0;
        assignment.CurrencyIsoCode = 'USD';
        
       
  //      insert assignment;
        Test.stopTest();
        }
       
       
        
    }
}