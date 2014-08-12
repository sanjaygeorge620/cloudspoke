@isTest(seealldata = true)
private class SitesTraining_attachmentController_Test {
//-------------------------------------------------------------------------------
// TEST SitesTrainingController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

        static testMethod void testSitesTraining_attachmentController () {        
        
        
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='stqaqndaqrduser@tqestorg1.com',LX_region__c='NE',Legacy_Company__c='Lexmark',EmployeeNumber='1234567');
         Insert adminUser;
         
        system.runas(adminUser)
        {
           
          // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
          
                     
           
            test.StartTest();
           
           

               SitesTraining_attachmentController controller; 
               //List<Course__c > courseIdList = [select id from Course__c where Course__c.name='SitesControllerTest.course' limit 1];
               
               class__c test_class = new class__c();
               insert test_class ;
                
                //class__c test_class = [select id from class__c where Course__r.name='SitesControllerTest.course' limit 1];
                //Chapter__c test_chapter = [select id from Chapter__c where Class__c =:test_class.id and Internal_Chapter__c=false limit 1];
                Chapter__c test_chapter = new Chapter__c(Class__c = test_class.id, Chapter_Number__c = 12);
                insert test_chapter;
                Test.setCurrentPageReference(new PageReference('Page.classdetails_viewattachments'));
                ApexPages.currentPage().getParameters().put('id', test_class.id);
                ApexPages.currentPage().getParameters().put('chapter', test_chapter.id);               
                system.debug('CURRENT URL--' +ApexPages.currentPage().getURL());
                
                controller = new SitesTraining_attachmentController();
                controller.getClassDetails();
                controller.getCourseAttachments(); 
                try
                {               
                    controller.getViewChapter();                
                }
                catch(exception e)
                {
                    System.debug(e);
                }
        
        test.stoptest();
        
        }
    }
}