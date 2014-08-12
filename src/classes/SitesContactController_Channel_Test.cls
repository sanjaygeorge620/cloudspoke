@isTest
private class SitesContactController_Channel_Test {
//-------------------------------------------------------------------------------
// TEST SitesContactController - Completed
//-------------------------------------------------------------------------------

//ublic static user us = SitesTestSetup.testRunAs();

Public Static Contact co = null;
//Public Static List<Contact> contacts = Data_Contact.createContacts(co.AccountID,1);
//Public Static Contact newcontact = contacts[0];


      static testMethod void testSitesContactController_channel() { 
        
      test.StartTest();
       Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
       Account objAccount = Data_Account.createAccount3();
      // List<> lstCons = Data_Contact.QueryContacts();
      Contact con = new Contact(
                           LastName='Test Contact ssdasd',
                           firstName='TestFirst',
                           AccountId = objAccount.Id,
                           email='testadsasasaas'+'@lexmark.com',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           areas_of_need__c = 'Content',
                           phone='1234',
                           Lx_Lexmark_Vertical__c = 'Manufacturing'); 
        insert con;
        User adminUser = new User(alias = 's4t1', email='cstandarduser@lexmark.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = adminProfile.Id,
        timezonesidkey='America/Los_Angeles', username='standarduserZ009@testo3rg1.com',LX_Region__c='NE',Legacy_Company__c='Lexmark');
        Insert adminUser;
      //co = [Select ID,AccountID from COntact where ID =: adminUser.contactID][0];
      List<Contact> contacts = Data_Contact.createContacts(con.AccountID,1);
     Contact newcontact = contacts[0];
         
     //   Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
   
    
    
        System.runAs(adminUser) {
                SitesContactController_Channel  controller = new SitesContactController_Channel();
                
                 Profile p = [select id from profile where name = 'Perceptive Customer Portal Admin']; 
                
                  
                  //#1   new user - Valid username
                    Test.setCurrentPageReference(new PageReference('Page.contactdetails_Channel'));
                    ApexPages.currentPage().getParameters().put('id', con.id);
                    controller = new SitesContactController_Channel();
                    controller.testAccount = objAccount;
                    //try again with only contact
                    controller.c.firstname = 'new name';
                    Controller.updateContact();
                    
                    system.assertEquals(controller.c.firstname, 'new name');

                    controller.enableUser();
                    controller.u.username = 'badusernamefoobar.com';
                    System.assertEquals(controller.u.isactive,true);
                    Controller.updateContact();
                    
                    //try again with better username
                    controller.u.username = 'goodusername@foobar.com';
                    Controller.updateContact();
                    Id profId = SitesContactController_Channel.getPortalProfileID();
                    
                    System.assertEquals(controller.resetPassword(),null);
                    System.assertEquals(controller.getShowUser(),true);
                 system.debug('In Stop method');     
          }
        test.StopTest();
     }
}