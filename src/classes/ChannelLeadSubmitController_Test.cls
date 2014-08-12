@isTest(seeAllData=true)
public class ChannelLeadSubmitController_Test  {
    
    static testMethod void testChannelLeadSubmitController() {  
        Account acc = Data_Account.createAccount();
        acc.recordtypeid = LX_SetRecordIDs.AccountPartnerLockedRecordTypeId;
        update acc;
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
        
        Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
        Profile adminProfile = [select id from profile where name ='Perceptive Channel Portal Admin' limit 1]; 
        User adminUser = new User(alias = '1qa', email='cstandarduser@lexmark.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = adminProfile.Id, 
        timezonesidkey='America/Los_Angeles', username='Checking@lexmark.com',LX_region__c = 'NE',Legacy_Company__c='Lexmark',contactId = contacts[0].Id);
        Insert adminUser;
            


         
          List<ID>contactIDs = new List<ID>();
          for(Contact contactRec: contacts){
            contactIDs.add(contactRec.id);
          }
          Test.startTest();    
          List<User> userList =  Data_User_CustomerPortal.createUser_CustomerPortal(1, contactIds, 'System Administrator'); 
          system.debug('userList:' + userlist);
          System.runAs(adminUser) {
        
        
        
       
                                
                Test.setCurrentPageReference(new PageReference('Page.ChannelLeadWebSubmit'));
                ChannelLeadSubmitController  controller = new ChannelLeadSubmitController();
                controller.NewLead.Last_Name__c ='testSitesLeadSubmitController.LastName';
                controller.NewLead.Company__c ='testSitesLeadSubmitController.Company';
                //submit case and redirect if success
                //system.assertequals(controller.SubmitLead().getUrl(),'/apex/Channelleaddetails?id='+Controller.NewLead.id);                            
                controller.SubmitLead();
                ChannelLeadSubmitController  controller1 = new ChannelLeadSubmitController();
                controller1.SubmitLead();
                controller.getPartnerCampaign();
                
         Test.StopTest();                      
        }
     }

}