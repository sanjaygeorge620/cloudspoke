@isTest
private class SitesLeadSubmitController_Test {
//-------------------------------------------------------------------------------
// TEST SitesCaseSubmitController - Completed
//-------------------------------------------------------------------------------
      static testMethod void testSitesLeadSubmitController() {  
      
      Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, Legacy_Company__c='Lexmark', 
         timezonesidkey='America/Los_Angeles', username='A12standarduser@testorg1.com',LX_Region__c='NE');
         Insert adminUser;
         
        system.runas(adminUser)
    {

        Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
        
                Account acc = Data_Account.createAccount();
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
            List<ID>contactIDs = new List<ID>();
            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);
            }    
            //List<User> userList = Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIds);  
            //system.debug('userList:' + userlist);
            //System.runAs(userList[0]) {
        
        
        
       
                                
                Test.setCurrentPageReference(new PageReference('Page.leadwebsubmit'));
                SitesLeadSubmitController  controller = new SitesLeadSubmitController();
                
                Group g1 = new Group(Name='group name', type='Queue');
                insert g1;
                QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');
                insert q1; 
                LX_SetRecordIDs.ChannelNewQueueId = q1.Id;
                controller.NewLead.LastName ='testSitesLeadSubmitController.LastName';
                controller.NewLead.Company ='testSitesLeadSubmitController.Company';
                //submit case and redirect if success
                try{
                controller.SubmitLead().getUrl();
                }
                catch(exception e)
                {
                System.debug(e);
                }
                controller.newLead = new Lead();
                controller.NewLead.LastName ='testSitesLeadSubmitController.LastName';
                controller.NewLead.Company ='testSitesLeadSubmitController.Company';
                controller.SubmitLead();
                
                               
        //}
     }
     }
}