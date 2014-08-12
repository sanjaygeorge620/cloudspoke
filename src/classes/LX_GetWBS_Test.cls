@isTest(seeAllData = true)
private class LX_GetWBS_Test{

    static testMethod void myUnitTest() {
            List<pse__Region__c> regions = new List<pse__Region__c>();
            
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
            system.assert(project.Id != null);
            
            Recordtype rec = [Select id from RecordType where name='MPS' and sobjectType='pse__Timecard_Header__c'];
            
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
            timecardHeader.recordtypeId = rec.id;
            insert timecardHeader;
    
        Test.setCurrentPage(Page.LX_GetWBS);
         ApexPages.currentPage().getParameters().put('id', timecardHeader.id);
        LX_GetWBSController scInstance = new LX_GetWBSController();
        scInstance.Values = '--None--';
      // WBC_Contact_Junction__c conJunction = new WBC_Contact_Junction__c();
        scInstance.save();
    }
    
    static testMethod void myUnitTest2() {
            List<pse__Region__c> regions = new List<pse__Region__c>();
            
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
            system.assert(project.Id != null);
            
            Recordtype rec = [Select id from RecordType where name='MPS' and sobjectType='pse__Timecard_Header__c'];
            
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
            timecardHeader.recordtypeId = rec.id;
            insert timecardHeader;
            
            Account acc = Data_Account.createAccount(); 
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);   
            WBC_Contact_Junction__c conJunction = new WBC_Contact_Junction__c(contact__c = contacts[0].id);
            insert conJunction;
            
            Test.setCurrentPage(Page.LX_GetWBS);
            ApexPages.currentPage().getParameters().put('id', timecardHeader.id);
            LX_GetWBSController scInstance = new LX_GetWBSController();
            scInstance.Values = '--None--';            
            scInstance.save();
    }
    
    static testMethod void myUnitTest3() {
            List<pse__Region__c> regions = new List<pse__Region__c>();
            
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
            system.assert(project.Id != null);
            
            Recordtype rec = [Select id from RecordType where name='MPS' and sobjectType='pse__Timecard_Header__c'];
            
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
            timecardHeader.recordtypeId = rec.id;
            insert timecardHeader;
            
            Account acc = Data_Account.createAccount(); 
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);   
            WBC_Contact_Junction__c conJunction = new WBC_Contact_Junction__c(contact__c = contacts[0].id);
            insert conJunction;
            
            Test.setCurrentPage(Page.LX_GetWBS);
            ApexPages.currentPage().getParameters().put('id', timecardHeader.id);
            LX_GetWBSController scInstance = new LX_GetWBSController();
            scInstance.Values = '--None--';            
            ApexPages.currentPage().getParameters().put('id', null);
            scInstance.save();
    }    
    
    static testMethod void myUnitTest4() {
            List<pse__Region__c> regions = new List<pse__Region__c>();
            
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
            system.assert(project.Id != null);
            
            Recordtype rec = [Select id from RecordType where name='MPS' and sobjectType='pse__Timecard_Header__c'];
            
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
            timecardHeader.recordtypeId = rec.id;
            insert timecardHeader;
            
            Account acc = Data_Account.createAccount(); 
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);   
            WBC_Contact_Junction__c conJunction = new WBC_Contact_Junction__c(contact__c = contacts[0].id);
            insert conJunction;
            
            Test.setCurrentPage(Page.LX_GetWBS);            
            LX_GetWBSController scInstance = new LX_GetWBSController();
            scInstance.save();
    }   
}