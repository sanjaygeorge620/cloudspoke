@isTest(seeAlldata=true)
private class SitesPartnerAccountController_Test{


    static testmethod void m1(){
    
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
             localesidkey='en_US', profileid = adminProfile.Id, 
             timezonesidkey='America/Los_Angeles', username='stsdadndarduser@testorg1.com',
             LX_Region__C='NE',Legacy_Company__c = 'Acuo');
         Insert adminUser;
         
        system.runas(adminUser){     
       
            Account acc1 = Data_Account.createAccount3();
            
            Account acc2 = Data_Account.createAccount3();
            acc2.parentId = acc1.Id;
            acc2.type='Customer';
            acc2.BillingCountry = 'USA';
            acc2.Physical_Country__c = 'USA';
            update acc2;
            
            ApexPages.currentPage().getParameters().put('id',acc2.Id);
            ApexPages.currentPage().getParameters().put('accountId',acc1.Id);
            SitesPartnerAccountController spc = new SitesPartnerAccountController();
           
            System.debug('>>>>>>>>>'+spc.SITE_ACCOUNT);
            spc.SITE_ACCOUNT.Type='Partner';
            spc.SITE_ACCOUNT.Physical_Country__c='USA';
            spc.SITE_ACCOUNT.BillingCountry = 'USA';
            spc.SITE_ACCOUNT.ISS_Coverage_Model__c='Channel';
            insert spc.SITE_ACCOUNT;
            System.debug('>>>>>>>>>'+spc.SITE_ACCOUNT.Id);
            acc2.Reseller_Id__c = spc.Site_Account.Id;
           
            update acc2;
         
            
           
            
            Server__c sr1 = new Server__c();
            sr1.Name='Test Server';
            sr1.Account__c = acc1.Id;
            sr1.Server_Name__c = 'Test Server';
            sr1.Server_type__c='Test';
            insert sr1;
            
           
            Server__c sr2 = new Server__c();
            sr2.Name='Live Server';
            sr2.Account__c = acc1.Id;
            sr2.Server_Name__c = 'Live Server';
            sr2.Server_type__c='Live';
            insert sr2;
            
            Server__c sr3 = new Server__c();
            sr3.Name='FailOver Server';
            sr3.Account__c = acc1.Id;
            sr3.Server_Name__c = 'FailOver Server';
            sr3.Server_type__c='Failover';
            insert sr3;
            
            
            Asset_clone__c ac1 = new Asset_clone__c();
            
            ac1.Name='Test Asset Clone';
            ac1.Account__c = acc1.Id;
            ac1.Server__c = sr1.Id;
            insert ac1; 
            
            Asset_clone__c ac2 = new Asset_clone__c();
            
            ac2.Name='Test Asset Clone';
            ac2.Account__c = acc1.Id;       
            ac2.Server__c = sr2.Id;
            insert ac2; 
            
            Asset_clone__c ac3 = new Asset_clone__c();
            
            ac3.Name='Test Asset Clone';
            ac3.Account__c = acc1.Id;
            ac3.Server__c = sr3.Id;
            insert ac3; 
            
            spc.getAccountDetails();
            spc.getLiveProducts();
            spc.getTestProducts();
            spc.getFailoverProducts();
            spc.getAccount();
            spc.getPartnerAccount();
            try{
            spc.getLicenses();
            }
            catch(exception e){
            }
            spc.licensecase = new Case();
            
            spc.attachment = new Attachment();
            spc.submitLicenseRequest();
            spc.getLiveServers();
            spc.getFailoverServers();
            spc.getTestServers();
           
            spc.getActiveContacts();
            spc.getInactiveContacts();
            spc.getPortalContacts();
            spc.NewContact = new Contact();
            spc.NewContact.lastname='TestCon';
            spc.NewContact.Email='c@k.com';
            spc.createContact();
             spc.NewContact = new Contact();
            spc.NewContact.lastname='TestCon';
            spc.createContact();
            spc.getOrders();
            try{
            spc.getOrderDetails();
            }
            catch(Exception e){
            
            }
            spc.getOpportunityLineItems();
            
       }      
    
    }


}