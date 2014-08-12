@isTest
private class SitesCaseSubmitController_Channel_Test {
//-------------------------------------------------------------------------------
// TEST SitesCaseSubmitController - Completed
//-------------------------------------------------------------------------------
      static testMethod void testSitesCaseSubmitController_Channel() {
      
      Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'st321009', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='stsq2andarduser@testorg1.com',
         LX_Region__c='NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
         
         system.runas(adminUser){  
        Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
        
        Account acc = Data_Account.createAccount();
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
            List<ID>contactIDs = new List<ID>();
            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);
                contactRec.AccountId = acc.ID;
            }   
            update Contacts ;
             
            //List<User> userList = Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIds);  
            
           /* for(Contact contactRec: contacts){
                
                contactRec.AccountId = acc.ID;
                contactRec.ownerID = userList[0].id;
            } */  
            update Contacts ;
            //system.debug('userList:' + userlist);
            //System.runAs(userList[0]) {
                
                
                SitesCaseSubmitController_Channel  controller  = new SitesCaseSubmitController_Channel();
                
                controller.newCase.description ='testSitesCaseSubmitController.dev';

                //submit feedback and redirect if success
                pagereference pr = controller.SubmitCase();
                
                               
        //}
      }
     }
}