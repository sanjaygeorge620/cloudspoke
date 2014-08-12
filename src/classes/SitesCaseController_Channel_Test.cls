@isTest
private class SitesCaseController_Channel_Test {
//-------------------------------------------------------------------------------
// TEST SitesCaseController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

        static testMethod void testSitesCaseController() {
        
        
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='standardu43434343434ser@testorg1.com',LX_Region__C = 'NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
         
        system.runas(adminUser)
        { 
    
        
        
        test.StartTest();
         // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
          //System.runAs(us) {
                
                //CASES
                case newcase = SitesTestSetup.createSupportCase();
                Test.setCurrentPageReference(new PageReference('Page.casedetail'));
                ApexPages.currentPage().getParameters().put('id', newcase.id);
                SitesCaseController_Channel casecontroller = new SitesCaseController_Channel();    
            
            
                try{
                    casecontroller.getCase();
                   }catch(Exception e)
                   {
                   System.Debug(e);
                   }
                   // casecontroller.getCase();
                    
                    integer num;
                    casecontroller.SubmitCase();
                    
                    ApexPages.currentPage().getParameters().put('CaseType', 'On Hold');
                    casecontroller.getCasesExport();
                    
                    casecontroller.getCasesNeedsAttention();
                    casecontroller.getCasesOpen();
                    casecontroller.getCasesHold();
                    casecontroller.getCasesClosed();

             //TASKS - Portal user can't own activity
   /*          task newtask = new task();
                 newtask.subject='task subject 123132132';
                 newtask.whatid =NewCase.id;
                 newtask.IsVisibleInSelfService = true;
             //insert newtask;
                
            
                Test.setCurrentPageReference(new PageReference('Page.casedetails_tasks'));
                ApexPages.currentPage().getParameters().put('id', newtask.id);
                SitesCaseController_Channel taskcontroller = new SitesCaseController_Channel();*/
                
                //taskcontroller.getCaseActivity();
                //system.assertequals(taskcontroller.getActivityCase().id,NewCase.id);
             
         // }
          test.StopTest();      
         }
        }
}