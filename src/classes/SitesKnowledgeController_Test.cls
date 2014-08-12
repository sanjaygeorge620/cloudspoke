@isTest
private class SitesKnowledgeController_Test {
//-------------------------------------------------------------------------------
// TEST SitesKnowledgeController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

        static testMethod void testSitesKnowledgeController() {
         //  Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
         
         
         
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, Legacy_Company__c='Lexmark', 
         timezonesidkey='America/Los_Angeles', username='stadazdaer@testorg1.com',Lx_Region__c = 'NE', EmployeeNumber ='9231324654');
         Insert adminUser;
         
        system.runas(adminUser)
        {
       

         
         Test.StartTest();
           //System.runAs(us) {
               Test.setCurrentPageReference(new PageReference('Page.Knowledge'));
               ApexPages.currentPage().getParameters().put('s', 'search text');
               ApexPages.currentPage().getParameters().put('prod', 'Imagenow_Client');
               ApexPages.currentPage().getParameters().put('prodtitle', 'Imagenow Client');
               ApexPages.currentPage().getParameters().put('rel', 'X6_5');
               ApexPages.currentPage().getParameters().put('reltitle', '6.5');
               
               ApexPages.currentPage().getParameters().put('producthelp', 'true');
               ApexPages.currentPage().getParameters().put('supportarticle', 'true');
               ApexPages.currentPage().getParameters().put('technicaloverview', 'true');
               
               SitesKnowledgeController controller = new SitesKnowledgeController();
               
               //test 2
               Test.setCurrentPageReference(new PageReference('Page.Knowledge'));
               ApexPages.currentPage().getParameters().put('s', 'search text');
               ApexPages.currentPage().getParameters().put('rel', 'X6_5');
               ApexPages.currentPage().getParameters().put('reltitle', '6.5');
               
               ApexPages.currentPage().getParameters().put('producthelp', '');
               ApexPages.currentPage().getParameters().put('supportarticle', '');
               ApexPages.currentPage().getParameters().put('technicaloverview', '');
               
               ApexPages.currentPage().getParameters().put('filter', 'product');
               ApexPages.currentPage().getParameters().put('filtertitle', 'product');
               ApexPages.currentPage().getParameters().put('filtertype', 'product');
               
               
               controller.doSearch();
               controller.doFilter();
               controller.doUnFilter();
               
               controller = new SitesKnowledgeController();
               integer num = [Select count() From Perceptive_Site_Content__c where Public_Viewing__c = true and Type__c='Widget' and Perceptive_Site__r.Site_Name__c=:Controller.SITE_NAME and RecordType.Name='Widget' and Name='KnowledgeSpotlight' limit 1];
               system.assertequals(controller.getWidgetKnowledgeSpotlight().size(),num);

               //Make the static calls
               SitesKnowledgeController.getProductCategories();
               SitesKnowledgeController.getReleaseCategories();
               
           //}   
           Test.StopTest();
         }
        }
}