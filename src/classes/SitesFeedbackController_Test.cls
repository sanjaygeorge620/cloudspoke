@isTest
private class SitesFeedbackController_Test {
//-------------------------------------------------------------------------------
// TEST SitesFeedbackController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

        static testMethod void testSitesFeedbackController() {
        
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='svtandvardvuvsevr@testorg1.com',LX_region__c='NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
         
        
        System.runAs(adminUser) {
        
        Test.Starttest();
           // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
                    SitesFeedbackController controller = new SitesFeedbackController();
                    integer num=1;
                    system.debug(Controller.SITE_FEEDBACK_OPTIONS.split(';'));
                    list<string> feedbacks = Controller.SITE_FEEDBACK_OPTIONS.split(';');
                     for(String f : feedbacks){
                        num+=1;
                    }
                    system.assertequals(controller.getFeedbackOptions().size(),num);
                    
                    //Attempt #1 with no passed values
                    controller.Feedback.Reference_Title__c ='';
                    controller.Feedback.Reference_Type__c ='';
                    controller.Feedback.Comment__c ='';
                    controller.submitFeedback();
                    
                    //Attempt #2 with passed values
                    controller.Feedback.Reference_Title__c ='testSitesFeedbackController.title';
                    controller.Feedback.Reference_Type__c ='testSitesFeedbackController.type';
                    controller.Feedback.Comment__c ='testSitesFeedbackController.comment';
                    controller.submitFeedback();
            
            Test.Stoptest();
            }
        }
}