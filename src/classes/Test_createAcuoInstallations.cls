/**

 */
@isTest(Seealldata=True)

private class Test_createAcuoInstallations 
{
    /*
        Test Case 1 : test the functionality of process method
    */
     
     private static Account createAccount(){
        Account A = new Account(name='Account4TestMethod2');        
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.MDM_Sold_To_Number__c = '56A47657';
        A.Physical_Country__c = 'USA';
        A.BillingCity = 'NYC';
        A.LX_Country_Code__c = 'AI';
        A.BillingCountry  = 'USA';
        A.LX_Geo__c = 'EMEA';
        A.MPS_Qualification__c = 'MPS';
        A.LXK_Region__c = 'USA';
        A.TR_Status__c = 'On';
        A.ISS_Coverage_Method__c = 'Face to Face';
        A.ISS_Coverage_Model__c ='Enterprise';
        //VT 10/1 added to remove validation error
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Primary_Sector_Focus__c = 'Manufacturing';  
        A.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
        insert A;
        return A;
     }
     
    static testMethod void testCreateInstallations() 
    {
    
          
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                 
         User sysAdmin = new User(alias = 'test1', email='test1@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test1@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',Legacy_Company__c = 'Lexmark');
         Database.Insert(sysAdmin);
        
        system.runas(sysAdmin){
               
        Account A = createAccount();
        
        Opportunity opp = createOpportunity(A.id);
        List<Product_Model__c> productModels = createProductModels(3);
     // List<Agreement__c> agreements = createAgreements(acc.id,opp.id,productModels );
         
        List<Product2> products = createProducts(productModels); 
        
        
        Id priceBookId;
        for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
            priceBookId = priceBook.id;
        }
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        PricebookEntry pE1 = new PricebookEntry(Product2Id = products.get(0).Id ,Isactive=true ,UnitPrice=100);
        PricebookEntry pE2 = new PricebookEntry(Product2Id = products.get(1).Id ,Isactive=true ,UnitPrice=100);
        PricebookEntry pE3 = new PricebookEntry(Product2Id = products.get(2).Id ,Isactive=true ,UnitPrice=100);
        if(priceBookId != null)
        {
           pE1.priceBook2Id = priceBookId ;
           pE2.priceBook2Id = priceBookId;
           pE3.priceBook2Id = priceBookId;
           priceBookEntries.add(pE1);
           priceBookEntries.add(pE2);
           priceBookEntries.add(pE3);
           insert priceBookEntries ;
           List<OpportunityLineItem> opplis = new List<OpportunityLineItem>();
           OpportunityLineItem opp_product1 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id );
           opplis.add(opp_product1);
           OpportunityLineItem opp_product2 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
           opplis.add(opp_product2);
           insert opplis;
           
     
         }
         
         
          Server_Asset_Association__c aassetasso = new Server_Asset_Association__c();
          aassetasso.CurrencyIsoCode = 'PHP';
          insert aassetasso;
          
         Data_Center_Requirements_Sizing__c ds = new Data_Center_Requirements_Sizing__c(Opportunity__c = opp.id, Failover_Application_Server__c = 1, Live_Application_Server__c = 1);
         ds.Failover_Central_Services__c = 1;
         ds.Failover_Migration__c = 1;
         ds.Failover_Routers__c = 1;
         ds.Failover_Test__c = 1;
         ds.Failover_XDS__c = 1;
         ds.Live_Central_Services__c = 1;
         ds.Live_Migration__c = 1;
         ds.Live_Routers__c = 1;
         ds.Live_Test__c = 1;
         ds.Live_XDS__c = 1;
         insert ds;
         
         Test.startTest();

         opp.SAP_Status__c = 'SUBMITTED';
         update opp;
         
         createAcuoInstallations.Create(ds.id,opp.id);
         List<Environment__c> envList = new List<Environment__c>();
         envList = [Select ID, Agreement_Name__c, Environment_Type__c from Environment__c where Account__c =: A.id];
         if(!envList.isEmpty())
         {
         Test.setCurrentPageReference(new PageReference('Page.Acuo_assetmap'));
                ApexPages.currentPage().getParameters().put('Eid', envList[0].id);
                ApexPages.currentPage().getParameters().put('Aid', envList[0].Agreement_Name__c);
                ApexPages.currentPage().getParameters().put('Type', envList[0].Environment_Type__c);
                
                createAcuoInstallations acuocontroller = new createAcuoInstallations();  
                 acuocontroller.getserverOptions();
                 acuocontroller.getastitmOptions();
                 
            ds.Create_Assets__c = True;
         update ds;
         }   
         Test.stopTest();
         
         createAcuoInstallations cracuoinst = new createAcuoInstallations();
         cracuoinst.Cancel();
         cracuoinst.Back();  
         cracuoinst.Save();
         cracuoinst.Add();
         cracuoinst.Del();
         cracuoinst.mapping = new List<Server_Asset_Association__c>();
         cracuoinst.mapping.add(aassetasso);
         cracuoinst.edit();
    }
            
    }
 
 static testMethod void testCreateInstallations1() 
    {
    
          
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                 
         User sysAdmin = new User(alias = 'test1', email='test1@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test1@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',Legacy_Company__c = 'Lexmark');
         Database.Insert(sysAdmin);
        
        system.runas(sysAdmin){
               
        Account acc = createAccount();
        Opportunity opp = createOpportunity(acc.id);
        List<Product_Model__c> productModels = createProductModels(3);
     // List<Agreement__c> agreements = createAgreements(acc.id,opp.id,productModels );
         
        List<Product2> products = createProducts(productModels); 
        
        
        Id priceBookId;
        for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
            priceBookId = priceBook.id;
        }
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        PricebookEntry pE1 = new PricebookEntry(Product2Id = products.get(0).Id ,Isactive=true ,UnitPrice=100);
        PricebookEntry pE2 = new PricebookEntry(Product2Id = products.get(1).Id ,Isactive=true ,UnitPrice=100);
        PricebookEntry pE3 = new PricebookEntry(Product2Id = products.get(2).Id ,Isactive=true ,UnitPrice=100);
        if(priceBookId != null)
        {
           pE1.priceBook2Id = priceBookId ;
           pE2.priceBook2Id = priceBookId;
           pE3.priceBook2Id = priceBookId;
           priceBookEntries.add(pE1);
           priceBookEntries.add(pE2);
           priceBookEntries.add(pE3);
           insert priceBookEntries ;
           List<OpportunityLineItem> opplis = new List<OpportunityLineItem>();
           OpportunityLineItem opp_product1 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id );
           opplis.add(opp_product1);
           OpportunityLineItem opp_product2 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
           opplis.add(opp_product2);
           insert opplis;
           
     
         }
         
         
          Server_Asset_Association__c aassetasso = new Server_Asset_Association__c();
          aassetasso.CurrencyIsoCode = 'PHP';
          insert aassetasso;
          
          Asset ass =new Asset();
          ass.Name = 'data';
          ass.CurrencyIsoCode = 'USD';
          ass.AccountId = acc.id;
          insert ass;
          
          Asset_Item__c assitem = new Asset_Item__c();
          assitem.Name  = 'test';
          assitem.Asset__c = ass.id;
          insert assitem;
          
         Data_Center_Requirements_Sizing__c ds = new Data_Center_Requirements_Sizing__c(Opportunity__c = opp.id, Failover_Application_Server__c = 1, Live_Application_Server__c = 1);
         ds.Failover_Central_Services__c = 1;
         ds.Failover_Migration__c = 1;
         ds.Failover_Routers__c = 1;
         ds.Failover_Test__c = 1;
         ds.Failover_XDS__c = 1;
         ds.Live_Central_Services__c = 1;
         ds.Live_Migration__c = 1;
         ds.Live_Routers__c = 1;
         ds.Live_Test__c = 1;
         ds.Live_XDS__c = 1;
         insert ds;
         
         Test.startTest();

         opp.SAP_Status__c = 'SUBMITTED';
         update opp;
         
         createAcuoInstallations.Create(ds.id,opp.id);
         List<Environment__c> envList = new List<Environment__c>();
         envList = [Select ID, Agreement_Name__c, Environment_Type__c from Environment__c where Account__c =: acc.id];
         if(!envList.isEmpty())
         {
         Test.setCurrentPageReference(new PageReference('Page.Acuo_assetmap'));
                ApexPages.currentPage().getParameters().put('Eid', envList[0].id);
                ApexPages.currentPage().getParameters().put('Aid', envList[0].Agreement_Name__c);
                ApexPages.currentPage().getParameters().put('Type', 'Failover');
                
                createAcuoInstallations acuocontroller = new createAcuoInstallations();  
                 acuocontroller.getserverOptions();
                 acuocontroller.getastitmOptions();
                 
            ds.Create_Assets__c = True;
         update ds;
         }   
         Test.stopTest();
         
         createAcuoInstallations cracuoinst = new createAcuoInstallations();
         cracuoinst.Cancel();
         cracuoinst.Back();  
         cracuoinst.Save();
         cracuoinst.Add();
         cracuoinst.Del();
         cracuoinst.mapping = new List<Server_Asset_Association__c>();
         cracuoinst.mapping.add(aassetasso);
         cracuoinst.edit();
    }
            
    }
        /* generate test data */
    
     /* Create Products */
    public Static List<Product2> createProducts(List<Product_Model__c> productModels)
    {
        return createProducts(productModels, false);
    }
   
    public Static List<Product2> createProducts(List<Product_Model__c> productModels, boolean tier_pricing)
    {
        List<Product2> prodList = new List<Product2>();
        Product2 prdObj;
        Integer i = 0;
        for(;i< productModels.size(); i++)
        {
             Product_Model__c pm = productModels.get(i);
             prdObj = new Product2(name='testproduct -'+i, family='Licenses',
                               Tier_Pricing__c = tier_pricing,BigMachines_Category__c ='Training',
                               Status__c = 'General Availability',Part_Number__c = 'PRO-'+i,Product_Model__c= pm.id,
                               Environment__c = 'Test');
                               
            prdObj.core_Product__c = false;
            prdObj.Use_Sizing_Tool__c = true;            
            prdObj.Test_Environments_Needed__c = 0;
            prdObj.Failover_Environments_Needed__c = 0;
            
            if(i == 0)
            {
                prdObj.Exclude_from_Test_Clone__c = false;
                prdObj.Exclude_from_Failover_Clone__c = false;
                prdObj.Test_Environments_Allowed__c = 2;
                prdObj.Failover_Environments_Allowed__c = 2;
            }
            else  if(i == 1){
                prdObj.Exclude_from_Test_Clone__c = true;
                prdObj.Exclude_from_Failover_Clone__c = true;
                prdObj.Test_Environments_Allowed__c = 2;
                prdObj.Failover_Environments_Allowed__c = 2;
            }
            else{
                prdObj.Exclude_from_Test_Clone__c = false;
                prdObj.Exclude_from_Failover_Clone__c = false;
            }
            
            prodList.add(prdObj);
        }
        
        insert prodList;
        
        
        Integer maxIndex = productModels.size() - 1;
        List<Product_Sub_Item__c> productSubItemList = new List<Product_Sub_Item__c>();
         for(i = 0 ;i< productModels.size() - 2; i++){
            Product2 product = prodList.get(i);
            productSubItemList.add(new Product_Sub_Item__c(Parent_Product__c = product.Id , Product__c = prodList.get(maxIndex).id ));
        }
        insert productSubItemList;
        return prodList; 
  }
  
    public static List<Agreement__c> createAgreements(String accountId,string oppId, List<Product_Model__c> productModels){
        List<Agreement__c> agreements = new List<Agreement__c>();
        Agreement__c agmnt;
        
        agmnt = new Agreement__c (Name =productModels.get(0).Name,account__c = accountId,Opportunity__c = oppId);
        agreements.add(agmnt);
        
        insert agreements;
        return agreements;
    }
    
/*    public static Account createAccount(){
       Account acc = new Account(name='Account4TestMethod');
       acc.Address__States__c = 'Rajasthan';
       insert acc;
       return acc;
    }
*/    
    public static Opportunity createOpportunity(String accId)
    {
      List<Contact> contacts = new List<Contact>(); 
      contacts.add(new Contact(LastName = 'Test',License_Contact__c=true,Status__c='Active',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc',LX_Lexmark_vertical__c='Manufacturing', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc'));
      contacts.add(new Contact(LastName = 'Test1',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan',LX_Lexmark_vertical__c='Manufacturing', FirstName = 'abc'));
      insert contacts;
        
      Opportunity opp =  new Opportunity();
      opp.AccountId = accId;
      opp.Name = 'Opportunity4TestMethod';
      opp.CloseDate = Date.today().addDays(10);
      opp.StageName = 'Negotiation';
      opp.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
      opp.Type = 'MPS';
      opp.QAStatus__c = 'New';
      opp.Ship_To__c  = contacts.get(0).Id;
      opp.Bill_To__c  = contacts.get(0).Id;
      //opp.RecordTypeId = [select Id,name from RecordType where SObjectType='Opportunity' AND Name='MPS'][0].Id; 
      opp.RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId();
     opp.LX_Product_Type__c = 'Technology';
     opp.LX_Sales_Type__c = 'New Project';
     opp.LX_First_Time_to_Revenue__c = 'First Time to Revenue';
     opp.MPS__c = true;
      insert opp;
      return opp;
    }
    
    public static List<Product_Model__c> createProductModels(Integer size)
    {
        List<Product_Model__c> productModels = new List<Product_Model__c>();
        Product_Model__c pm;
        for(Integer i =0; i< size;i++){
            pm = new Product_Model__c(Name = 'Test Model '+i,Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support');
            if(i==0){
                pm.Model__c = 'TestM-'+i;
                pm.Asset_Required__c = true;
            }
            productModels.add(pm);
        }
        insert productModels;
        return productModels;
        
    }
    
   public static Server__c createServer(String agreementId,string accountId){
        Server__c server = new Server__c(Name='Test Server', agreement__c = agreementId,Server_Type__c = 'Live',Account__c = accountId);
        insert server;
        return server;
        
    }
     public static Server__c create_Server(String agreementId,string accountId){
        Server__c server = new Server__c(Name='Test Server', agreement__c = agreementId,Server_Type__c = 'Failover',Account__c = accountId);
        insert server;
        return server;
    }
    


}