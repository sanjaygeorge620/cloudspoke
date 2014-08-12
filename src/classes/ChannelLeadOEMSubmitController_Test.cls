/**
 * Name: ChannelLeadOEMSubmitController_Test
 *
 * Description: to provide code coverage for ChannelLeadOEMSubmitController  Class
 * Created By: Manoj Kolli
 * Created Date: 5/21/2012
 */
@isTest(seeAllData=true)
public class ChannelLeadOEMSubmitController_Test  {
    
            static testMethod void testChannelLeadOEMSubmitController() {  
            
            Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
        User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
        emailencodingkey='UTF-8', lastname='Testing'+string.valueof(system.currentTimeMillis()), languagelocalekey='en_US', 
        localesidkey='en_US', profileid = adminProfile.Id, 
        timezonesidkey='America/Los_Angeles', username='standarfgdfgugfser@lexmark.com',LX_region__c='NE', Legacy_Company__c = 'Lexmark');
        Insert adminUser;
        


        Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
          Account acc = Data_Account.createAccount();
         //User u =[Select Id,Name,Email, userType from User where Name = 'Jennifer Dauernheim' and userType = 'Standard' limit 1];
         //acc.recordtypeid = [select id from RecordType where sobjecttype = 'Account' and developerName = 'Partner_Unlocked'].id;
          acc.Type = 'Partner-OEM';
         //acc.OwnerId = u.Id;
          update acc;
          
          List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
          system.debug('****ContactID' + contacts[0]);
          system.debug('****ContactID' + contacts[0].AccountID);          
          List<ID>contactIDs = new List<ID>();
          for(Contact contactRec: contacts){
            contactIDs.add(contactRec.id);
          }    
          List<User> userList =  Data_User_CustomerPortal.createUser_CustomerPortal(1, contactIds, 'System Administrator'); 
          system.debug('userList:' + userlist);
          system.debug('****ContactID' + userlist[0].contactID);
          system.debug('****ContactID' + userlist[0].accountID);
          System.runAs(adminUser ) {
        
        
        
       
                                
                Test.setCurrentPageReference(new PageReference('Page.ChannelOpportunitysubmit'));
                ChannelLeadOEMSubmitController  controller = new ChannelLeadOEMSubmitController();
                //controller.NewLead.Opportunity_Name__c ='testOEMOppName';
                //controller.NewLead.Stage__c ='Qualification';
                //controller.NewLead.Close_Date__c =Date.Today();
                //controller.NewLead.Opportunity_Owner__c = u.Id;
                
                //controller.NewLead.Company ='testSitesLeadSubmitController.Company';
                //submit case and redirect if success
                //system.assertequals(controller.SubmitLead().getUrl(),'/apex/ChannelOpportunitydetails?id='+Controller.NewLead.id);
                controller.SubmitLead();
          
                               
        }
     }

}