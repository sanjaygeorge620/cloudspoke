@isTest(seealldata=true)
private class SitesCaseSubmitController_Test {
//-------------------------------------------------------------------------------
// TEST SitesCaseSubmitController - Completed
//-------------------------------------------------------------------------------


//public static user us = SitesTestSetup.testRunAs();

      static testMethod void testSitesCaseSubmitController() {
      Profile case_adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User case_adminUser = new User(alias = 'test', email='testuser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = case_adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='abc123.abc@testorg11.com',LX_region__c='NE',Legacy_Company__c='Lexmark');
         Insert case_adminUser;
         
      Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='New_Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles',manager = case_adminUser,  username='standardus1xz3a2er@testorg1.com',LX_region__c='NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
         
        system.runas(adminUser)
    {   
      
      
       // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
       
        Test.StartTest();
      
       
                
                //system.assertEquals(controller.getContactDetail().id, Controller.SITE_CONTACT.id);    
                
                Test.setCurrentPageReference(new PageReference('Page.casewebsubmit'));
                
                Account acc = new Account(Name = 'test123',Physical_Country__c='India',BillingCountry='India');
                insert acc;
                ApexPages.currentPage().getParameters().put('acctid',acc.Id);
                SitesCaseSubmitController  controller = new SitesCaseSubmitController();
                
                //server__c server = [select id from server__c where Account__r.Id=:Controller.SITE_ACCOUNT.id limit 1];
                server__c server = new server__c(Account__c = acc.id);
                server.Machine_Name__C = 'test';
                server.Server_Type__C = 'Failover';
                insert server;
                
                Brand__c br = new Brand__c(name='Perceptive');
                insert br;
                
                Product_Model__c pm = new Product_Model__c(Name = 'Test Model',Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support');
                pm.Model__c = 'TestM';
                pm.Asset_Required__c = true;
                pm.Brand__c = br.id;
                insert pm;
                
                Product2 product = new Product2();       
                product.Name = 'testAccount';
                product.Part_Type__c='Licensed Software';
                product.Tier_Pricing__c = false;
                product.BigMachines_Category__c ='Training';
                product.Status__c = 'General Availability';
                product.Part_Number__c = 'PRO-';
                product.Product_Model__c= pm.id;
                product.Environment__c = 'Test';
                product.brand__c = br.Id;
                product.core_Product__c = true;
                product.Replicate_Full_Environment__c = true;
                product.Exclude_from_Test_Clone__c = true; 
                product.Exclude_from_Failover_Clone__c = true;
                product.Test_Environments_Needed__c = 2;
                product.Failover_Environments_Needed__c = 2;
                insert product;
               
                Account test_acc = Data_Account.createAccount3();
                Contact con = new Contact();
                RecordType con_rec= [Select id from Recordtype where name='Resource Contact' and SobjectType='Contact'];
                con.LastName= 'test';
                con.AccountId= acc.id;
                con.recordTypeId = con_rec.id;
                insert con;
                 
                Case test_case = new case();
                RecordType case_rec = [Select id from Recordtype where name='Dataload' and SobjectType='Case'];
                test_case.ContactId= con.id;
                test_case.Status = 'New';
                test_case.Impact__c = 'User';
                test_case.Urgency__c = 'Low';
                test_case.Origin = 'Cases';
                test_case.Type = 'Problem';
               test_case.ChannelSubmitted__c = true;
                test_Case.recordTypeId = case_rec.id;
                insert test_case;

                controller.getServers();
                
                controller.NewCase.description ='testSitesCaseSubmitController.support';
                controller.NewCase.Server__c = server.id;
                system.assertequals(controller.getServer().id,Server.id);
                
                controller.getProducts();
               //controller.attachment.name = 'testSitesCaseSubmitController.Attachment.support';
                controller.attachment.name='test'; 
                controller.NewCase.ChannelSubmitted__c = true;    
                controller.routecase();
                controller.SubmitCase();

                controller.attachment.name='test'; 
                controller.NewCase.ChannelSubmitted__c = true;    
                controller.routecase();
             //   controller.NewCase.SelectedAccount = 'test';
                
                controller.SubmitFeedback();
                controller.attachment.name='test'; 
                controller.SubmitDevCase();

                controller.getCustomers();
                controller.attachment.name = 'testSitesCaseSubmitController.Attachment.support';
                controller.attachment.Body = Blob.valueOf('testSitesCaseSubmitController.Attachment.support');
                
                //submit case and redirect if success
                //system.assertequals(controller.SubmitCase().getUrl(),'/apex/casedetails?id='+Controller.NewCase.id);
                
                //submit feedback and redirect if success
                //system.assertequals(controller.SubmitFeedback().getUrl(),'/apex/cases');
                
                controller = new SitesCaseSubmitController();
                controller.attachment.name = 'testSitesCaseSubmitController.Attachment.dev';
                controller.attachment.Body = Blob.valueOf('testSitesCaseSubmitController.Attachment.dev');
                controller.DevCase.description ='testSitesCaseSubmitController.dev';
                controller.SubmitDevCase();
               
                test.StopTest();

                //submit feedback and redirect if success
               // system.assertequals(controller.SubmitDevCase().getUrl(),'/apex/casedetails?id='+Controller.DevCase.id);
               controller.selectedProduct=pm.Id;
               controller.getbrand();
               
               
     }
     
     }
}