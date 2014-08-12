@isTest
private class SitesIdeasController_Test {
//-------------------------------------------------------------------------------
// TEST SitesIdeasController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

      static testMethod void testSitesIdeasController() { 
      
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='stand12222ser@testorg1.com',LX_region__c='NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
            
        system.runas(adminUser)
    {
      
      
      
      test.StartTest();  
      //  Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
        
            SitesIdeasController controller = new SitesIdeasController();
            
            integer num = [select count() from idea where id=:Controller.SITE_IDEAS_FEATURED limit 1];
            system.assertequals(controller.getFeaturedIdeas().size(),num);
            
            controller.howUserVoted = null;
            string test1 = controller.howUserVoted;
        
        test.StopTest();
        }
       }
       }