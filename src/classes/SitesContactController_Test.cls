//Modified by Perceptive IS 07/17

@isTest(seealldata = true)
private class SitesContactController_Test 
{
//-------------------------------------------------------------------------------
// TEST SitesContactController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

//Public Static Contact co = [Select ID,AccountID from COntact where ID =: us.contactID][0];
//Public Static List<Contact> contacts = Data_Contact.createContacts(co.AccountID,1);
//Public Static Contact newcontact = contacts[0];

      static testMethod void testSitesContactController() 
     { 
         Profile portalProfile = [select id from profile where name = 'Perceptive Customer Portal Admin' limit 1];
         
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
         
         RecordType rtype =[Select id from RecordType where name='Location Customer'];   
         
         User sysAdmin = new User(alias = 'test21', email='test123@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Tes2ting', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test2231@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',Legacy_Company__c='Lexmark');
         
         Database.Insert(sysAdmin);
         
         system.runas(sysAdmin)
         {
        // Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
                  
         Account acc = new Account();
         acc.recordTypeId = rtype.id;
         acc.name='Test Account';
         acc.LX_Sales_Team_Assigned__c='Banking';
         acc.Industry_Subtype__c='Banking';
         acc.ownerId=sysAdmin.Id;
         acc.BillingCountry = 'USA';
         acc.Physical_Country__c = 'USA';
         
         insert acc;
         
         Contact con = new Contact(lastName='TestCon',Lx_Lexmark_Vertical__c='Banking',accountId = acc.Id,email='a@b.com');
         insert con; 
         
         Contact con2 = new Contact(lastName='TestCdfdfon', Lx_Lexmark_Vertical__c='Banking',accountId = acc.Id,email='a23324@b.com');
         insert con2;                

         
         User portalUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = portalProfile.Id,contactId = con.Id, 
         timezonesidkey='America/Los_Angeles',username='stsdadndarduser@testorg1.com',
         LX_Region__C='NE',Legacy_Company__c='Lexmark');
         
         insert portalUser;         
         
         system.runas(portalUser )
         {     
            Test.setCurrentPageReference(new PageReference('Page.contactdetails'));
            ApexPages.currentPage().getParameters().put('id', con2.id);
            SitesContactController  controller = new SitesContactController();         
              
            test.starttest();   
                    try
                    {
                    controller.c.firstname = 'new name';
                    Controller.updateContact();
                    }
                    catch(exception e)
                    {
                    System.debug(e);
                    }   
                    try
                    {
                    system.assertEquals(controller.c.firstname, 'new name');
                    controller.enableUser();
                    controller.u.username = 'badusernamefoobar.com';
                    System.assertEquals(controller.u.isactive,true);
                    Controller.updateContact();
                    
                    //try again with better username
                    controller.u.username = 'goodusername@foobar.com';
                    Controller.updateContact();
                    }
                    catch(exception e)
                    {
                    System.debug(e);
                    }   
                     try
                    {
                    controller.c.firstname = 'new name';
                    Controller.updateContact();
                    }
                    catch(exception e)
                    {
                    System.debug(e);
                    }                 
                    System.assertEquals(controller.resetPassword(),null);
                    controller.getShowUser();
  
            system.debug('TOTAL SOQL' +limits.getQueries());
            test.stoptest();    
         }/*end system.runas*/  
       }   
      
     }
}