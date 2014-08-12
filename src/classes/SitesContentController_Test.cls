@isTest
private class SitesContentController_Test {
//-------------------------------------------------------------------------------
// TEST SitesContentController - Completed 
//-------------------------------------------------------------------------------

 //public static user us = SitesTestSetup.testRunAs();
        static testMethod void testSitesContentController() {
        
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='standarduser0012Z@testorg1.com',LX_Region__c='NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
        
        System.runAs(adminUser) {
        
        test.StartTest();
            //Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            SitesContentController controller = new SitesContentController();
            integer num;
            
                num = [select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Partner Showcase' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Showcase'];          
                system.assertequals(controller.getPARTNER_SHOWCASE().size(),num);
                
                num = [select count() From Perceptive_Site_Content__c where Featured__c = true and Public_Viewing__c = true and Type__c='Partner Showcase' and Perceptive_Site__r.Site_Name__c=:controller.SITE_NAME and RecordType.Name='ShowCase' limit 1];
                system.assertequals(controller.getPARTNER_FEATURED_SHOWCASE().size(),num);
                
                num = [select count() From Perceptive_Site_Content__c where Featured__c = true and Public_Viewing__c = true and Type__c='Solution Showcase' and Perceptive_Site__r.Site_Name__c=:controller.SITE_NAME and RecordType.Name='ShowCase' limit 1]; 
                system.assertequals(controller.getSOLUTION_FEATURED_SHOWCASE().size(),num);
            
        test.StopTest();
        }
    }
}