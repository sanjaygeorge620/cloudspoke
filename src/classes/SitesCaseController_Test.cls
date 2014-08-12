@isTest
private class SitesCaseController_Test {
//-------------------------------------------------------------------------------
// TEST SitesCaseController - Completed
//-------------------------------------------------------------------------------


//public static user us = SitesTestSetup.testRunAs();



        static testMethod void testSitesCaseController() {
        
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'vesss', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='sta'+math.random()+'nsdard12usagcer@testorg1.com',Lx_Region__c = 'NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
         
        system.runas(adminUser)
        { 
        
     // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
 
        test.starttest();
     
             // System.runAs(us) 
             // {
                
                //CASES
              
                case newcase = SitesTestSetup.createSupportCase();
                Test.setCurrentPageReference(new PageReference('Page.casedetail'));
                ApexPages.currentPage().getParameters().put('id', newcase.id);
                 SitesCaseController casecontroller1 = new SitesCaseController( new ApexPages.StandardController(newcase));
                SitesCaseController casecontroller = new SitesCaseController();    
                try{
                    casecontroller.getCase();
                   }catch(Exception e)
                   {
                   System.Debug(e);
                   }
                    
                    integer num;
                    num = [Select count() From CaseComment where IsPublished=true and parentid=:newcase.id];
                    system.assertequals(casecontroller.getCaseComments().size(),num);
                    
                    num = [Select count() From Attachment a where parentid=:newcase.id];
                    system.assertequals(casecontroller.getCaseAttachments().size(),num);
                    
                    num = [Select count() From CaseArticle c where c.CaseId=:newcase.id];
                    system.assertequals(casecontroller.getCaseArticles().size(),num); 
                    
                    num = [Select count() From Task where IsVisibleInSelfService=true and  whatid=:newcase.id];
                    system.assertequals(casecontroller.getCaseActivityHistory().size(),num); 
                    
                    //casecontroller.SubmitCase();
                    
                    casecontroller.CaseComment.CommentBody ='testSitesCaseController.comment';
                    casecontroller.SubmitComment();
                    
                    casecontroller.attachment.Body = Blob.valueOf('testSitesCaseController.Attachment');
                    casecontroller.uploadAttachment();
                    
                    ApexPages.currentPage().getParameters().put('CaseType', 'On Hold');
                    casecontroller.getCasesExport();
                    
                    casecontroller.getCasesNeedsAttention();
                    casecontroller.getCasesOpen();
                    casecontroller.getCasesHold();
                    casecontroller.getCasesClosed();
                    

             //TASKS - Portal user can't own activity
             task newtask = new task();
                 newtask.subject='task subject 123132132';
                 newtask.whatid =NewCase.id;
                 newtask.IsVisibleInSelfService = true;
             insert newtask;
                
            
                Test.setCurrentPageReference(new PageReference('Page.casedetails_tasks'));
                ApexPages.currentPage().getParameters().put('id', newtask.id);
                SitesCaseController taskcontroller = new SitesCaseController();
                
                taskcontroller.getCaseActivity();
                system.assertequals(taskcontroller.getActivityCase().id,NewCase.id);
                taskcontroller.SubmitCase();
                
               // }
                
                test.stoptest();
             
          }   
          
        }
}