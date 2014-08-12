@isTest
private class SitesServerController_Test {
//-------------------------------------------------------------------------------
// TEST SitesServerController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

        static testMethod void testSitesServerController () {
        
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'ssfd', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id,Legacy_Company__c='Lexmark', 
         timezonesidkey='America/Los_Angeles', username='standasarduserVBN@testorg1.com',LX_Region__c = 'NE');
         Insert adminUser;
         
        
        
            System.runAs(adminUser) {
        
        test.StartTest();
           // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
               Account acc = Data_Account.createAccount();
                  Server__c s= new Server__c(Name = acc.Name,Status__c='Active',Server_Name__c='T2',Account__c=acc.Id);
                  insert s;
                                
                //server__c s = [select id, name from server__c limit 1];
                Test.setCurrentPageReference(new PageReference('Page.serverdetails')); 
                ApexPages.currentPage().getParameters().put('id',s.id );
                ApexPages.currentPage().getParameters().put('retURL','' );
                SitesServerController controller = new SitesServerController();
                    
                //system.assertequals(controller.Server.id,s.id);
                try
                {
                    controller.updateServer();
                }
                catch(Exception e)
                {
                    System.debug(e);
                }
                //system.assertequals(controller.updateServer().getUrl(),'/apex/serverdetails?id='+s.id);
                
                integer num =[select count() from ProductRelease__c where Brand__r.Name='ImageNow' and (status__c ='General Availability' or status__c ='Retirement Phase' or  status__c ='Limited Support Phase' or status__c ='End of Life')]; 
                system.assertequals(controller.getRelease().size(),num+1); /*adding 1 because I add a --none-- value to the SelectOption*/
            
            test.StopTest();           
          }
        }   
}