@isTest
private class SitesHomeController_Test {

//-------------------------------------------------------------------------------
// TEST SitesHomeController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

        static testMethod void testSitesHomeController() {
        
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='Test11andarduser@testorg1.com',LX_Region__c = 'NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
            
        system.runas(adminUser)
    
        {
        
        
        test.StartTest();
           // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
           // System.runAs(us) {
                    SitesHomeController controller = new SitesHomeController();
                    integer num ;
                    controller.doKBSearch();
                    controller.redirectLogin();
                    controller.RefFlexURL();
                    controller.getWidgetBusinessApplications();
                    controller.getWidgetEventResources();
                    controller.getWidgetEventResourcesPublic();
                    controller.getInspirePresentations();
                    controller.getInspireTracks();
                    controller.getRecentLicenses();
                    list<Perceptive_Site_Content__c> psc = controller.getWidgetMedia();
                    num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='Community-Internal' limit 1];
                    system.assertequals(controller.getWidgetCommunity().size(),num);
                    
                    num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='Training-Internal' limit 1];
                    system.assertequals(controller.getWidgetTraining().size(),num);
                    
                    num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='Support' limit 1];
                    system.assertequals(controller.getWidgetSupport().size(),num);
                    
                    num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='Downloads' limit 1];
                    system.assertequals(controller.getWidgetDownloads().size(),num);
                    
                    num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='KnowledgeSpotlight' limit 1];
                    system.assertequals(controller.getWidgetKnowledgeSpotlight().size(),num);
                    
                    num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='Amazon' limit 1];
                    system.assertequals(controller.getWidgetAmazon().size(),num);
                    
                    num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='Resources' limit 1];
                    system.assertequals(controller.getWidgetResources().size(),num);
                    
                    num = [select count() From License_Key__c l where l.Asset__r.Account.ID=:Controller.SITE_ACCOUNT.ID and l.CreatedDate = LAST_N_DAYS:30];
                    //system.assertequals(controller.getRecentLicenses().size(),num);
                    
                    num = [select count() From server__c s where s.Account__c=:controller.SITE_ACCOUNT.ID and (s.Date_Verified_by_Customer__c < LAST_N_DAYS:90 or s.Date_Verified_by_Customer__c=null)];                    
                    system.assertequals(controller.getOldServers().size(),num);
                    
                  //  num = [select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Inspire' and RecordType.Name='Inspire' and ];                
                  //  system.assertequals(controller.getInspirePresentations().size(),num);
                  //SitesController sc = new SitesController();
                 
                  /*Perceptive_Site__c obj = new Perceptive_Site__c();
                  obj.Language__c = 'English';
                  obj.Flexera_Key__c = 'Test Flexera Key';
                  obj.Flexera_IV__c =  'Test Flexera IV Key';
                  obj.Profiles__c = 'System Administrator Test';
                  obj.Home_Page__c = 'testpage';
                  obj.Login_Page__c = 'loginpage';
                  obj.Primary_Template__c = 'Primary Template';
                  obj.Secondary_Template__c = 'secondaruy Template';
                  obj.Site_Name__c = 'TestSiteName';
                  obj.URL__c = 'https://Test.com';
                  insert obj;*/
                  //controller.RefFlexURL();
            
         test.StopTest(); 
         }  
        }   
}