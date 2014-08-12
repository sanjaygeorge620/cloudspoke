@isTest(SeeallData = true)
Public class Test_cloudCharts 
{
  Public Static Testmethod void testcharts()
  {
    Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
    User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                  localesidkey='en_US', profileid = adminProfile.Id, 
                  timezonesidkey='America/Los_Angeles', username='standarduser@hecksss.com',LX_region__c='NE',Legacy_Company__c='Lexmark');
    Insert adminUser;
    
    
    Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
    //id Profileid = [Select id from Profile where name = 'Perceptive Customer Portal Admin'][0].id;
    Account acc = new Account();
    List<Contact> contacts = null;
    Contact cont = null;
    system.runas(adminUser)
    {
        acc = Data_Account.createAccount2();
        acc.Platform_Services__c = true;
        update acc;
        //Acc = [Select ID from Account where Platform_Services__c = True][0];
        contacts = Data_Contact.createContacts(acc.Id,1);
        System.debug('XXX'+contacts);
        cont = contacts[0];
    }
    
        // userrole obj = [Select PortalType, PortalRole, Name, Id, DeveloperName, ContactAccessForAccountOwner,
                                                             // CaseAccessForAccountOwner From UserRole Where PortalType = 'Partner' Limit 1];
    // user uacct= new User(alias = 'standt', email='SitescloudControllerTest@testRunAs.com', 
                    // emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                    // localesidkey='en_US', profileid = Profileid , contactid=cont.id,
                    // timezonesidkey='America/Los_Angeles', username='SitesControllerTest@testRunAs.com', userroleid = obj.Id);

    PageReference pageRef = Page.cloudcharts;

    boolean bo = true;
                    
    test.StartTest();                                
    System.runAs(adminUser)
    {
      Test.setCurrentPage(pageRef);
      string Server1 = 'Cine1 - Production';
      cloudWS controller = new cloudWS();
      controller.selected_server = Server1;

      PageReference pageRef2 = Page.cloudcharts_Chrome;
      pageRef2.getParameters().put('server',Server1);

      Test.setCurrentPage(pageRef2);
      List<SelectOption> sop = controller.getServers();
      controller.reloadIframe();

       
      cloudWS.getQT(); 
      cloudWS.getUT();
      cloudWS.getlstats(Server1);
    }
    test.StopTest();   
  }
}