@isTest(seealldata = true)
private class testSitesOrderController{
    
    public static testmethod void tsiteordctrl() {
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
             
             
             User portalUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
             localesidkey='en_US', profileid = portalProfile.Id,contactId = con.Id, 
             timezonesidkey='America/Los_Angeles',username='stsdadndarduser@testorg1.com',
             LX_Region__C='NE',Legacy_Company__c='Lexmark');
             
             insert portalUser;         
             
             system.runas(portalUser){
                Order__c ord = new Order__c();
                ord.Name = 'test';
                ord.Account__c = acc.Id;
                insert ord;
                
                Order_Detail__c ordDetail= new Order_Detail__c();
                ordDetail.Order__c = ord.id;
                ordDetail.name='test';
                ordDetail.Quantity__c=25;
                insert ordDetail;
                
                ApexPages.currentPage().getParameters().put('id',ord.id);
                SitesOrderController sordctrl = new SitesOrderController();
                sordctrl.getOrderDetails();
                sordctrl.getOrders();
                sordctrl.getOpportunityLineItems();
            }
        }
    }
}