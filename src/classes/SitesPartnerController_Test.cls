@isTest
private class SitesPartnerController_Test {
//-------------------------------------------------------------------------------
// TEST SitesController - COMPLETED
//-------------------------------------------------------------------------------
        public class TestSitesPartnerController extends SitesPartnerController {}
        
        static testMethod void testSitesController() {
            TestSitesPartnerController controller = new TestSitesPartnerController();    
            Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
            system.debug('getIsLoggedIn: '+controller.getIsLoggedIn());
            system.assertequals(controller.getIsLoggedIn(), true);
            
            system.debug('getUserAccount: '+controller.SITE_ACCOUNT);
            system.assertequals(controller.SITE_ACCOUNT.name, 'Invalid Account');
            
            system.debug('getUserContact: '+controller.SITE_CONTACT);
            system.assertequals(controller.SITE_CONTACT.FirstName, 'Invalid');
        
            system.debug('getRecordtypeID: '+controller.getRecordtypeID('case','Partner_Channel'));
            RecordType r_content =[Select id, developername From RecordType r where r.SobjectType='Perceptive_Site_Content__c' and r.DeveloperName ='inspire'];
            system.assertequals(controller.getRecordtypeID('Perceptive_Site_Content__c','inspire'), r_content.id);
            
            system.debug('sitesContent: '+controller.sitesContent('testSitesMethods',r_content.developername));
            //system.assertequals(controller.sitesContent('testSitesMethods',r_content.developername).size(), 1);
            
            system.debug('sitesContent: '+controller.sitesFeaturedContent('testSitesMethods','r_content.developername'));
            //system.assertequals(controller.sitesFeaturedContent('testSitesMethods',r_content.developername).size(), 1);
        
            RecordType r_widget =[Select id, developername From RecordType r where r.SobjectType='Perceptive_Site_Content__c' and r.DeveloperName ='widget'];    
            system.debug('getWidget: '+controller.getWidget('test_SiteContentSetup_widget'));
            //system.assertequals(controller.getWidget('test_SiteContentSetup_widget').size(), 1);
            
            system.debug('secureString(string sValue): '+controller.secureString('test_string'));
            system.assertequals(controller.secureString('test_string'), 'test_string');
        
            system.debug('relatedSite: '+controller.relatedSite);
            system.assertequals(controller.relatedSite, 'https://www.perceptivesoftware.com/');
            
            system.debug('SITE_NAME: '+controller.SITE_NAME);
            //system.assertequals(controller.SITE_NAME, siteSetup.Site_Name__c);
              
        
        }
}