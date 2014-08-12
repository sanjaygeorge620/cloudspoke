/**

 */
@isTest
private class Test_ProcessInstallations_Saperion 
{

   
     static testMethod void testCreateInstallationsCP() 
    {
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
            
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];       
         List<OpportunityLineItem> opplis = new List<OpportunityLineItem>();
         
         User sysAdmin = new User(alias = 'test21', email='test123@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Tes2ting', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test2231@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes', Legacy_Company__c='Lexmark');
         
         Database.Insert(sysAdmin);
         
         system.runas(sysAdmin)
         {
 
       Account acc = new Account();       
       acc.name='testAcc';
       acc.phone='123423';
       acc.Physical_Country__c = 'USA';
       acc.BillingCountry = 'USA';
       insert acc;
       
       

        Opportunity opp = createOpportunity(acc.id);
        List<Product_Model__c> productModels = createProductModels(2);
        List<Agreement__c> agreements = createAgreements(acc.id,opp.id,productModels );
        SERVER__C SERV = createServer(agreements[0].id,acc.id);
        
        
  
        List<Product2> products = createProducts(productModels); 
        
        update products;
        
        Upgrade_Table__c ut = new Upgrade_Table__c(name = products[0].part_number__c+'-'+'U01',Part_Number__c = products[0].part_number__c,Unit_of_Measure__c = 'U01',New_Unit_of_Measure__c = 'Z02',New_License__c = 'NO');
        insert ut;  
        
        Id priceBookId;
        for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
            priceBookId = priceBook.id;
        }
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        PricebookEntry pE1 = new PricebookEntry(Product2Id = products.get(0).Id ,Isactive=true ,UnitPrice=100);
        PricebookEntry pE2 = new PricebookEntry(Product2Id = products.get(1).Id ,Isactive=true ,UnitPrice=100);
        if(priceBookId != null){
           pE1.priceBook2Id = priceBookId ;
           pE2.priceBook2Id = priceBookId ;           
           priceBookEntries.add(pE1);
           priceBookEntries.add(pE2);           
           insert priceBookEntries ;
     
           OpportunityLineItem opp_product1 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id,part_number__c = products.get(0).Part_number__c);
           opplis.add(opp_product1);
           
           OpportunityLineItem opp_product2 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE2.Id,part_number__c = products.get(1).Part_number__c);
           opplis.add(opp_product2);
           
       insert opplis;
         }
         Test.startTest();
         opp.SAP_Status__c = 'Override';
         update opp;                
         Test.stopTest();
         
      }
            
    }
 
    
    /* generate test data */
    
     /* Create Products */
    public Static List<Product2> createProducts(List<Product_Model__c> productModels){
        return createProducts(productModels, false);
    }
   
    public Static List<Product2> createProducts(List<Product_Model__c> productModels, boolean tier_pricing)
    {
        List<Product2> prodList = new List<Product2>();
        Product2 prdObj;
        Integer i = 0;
        for(;i< productModels.size(); i++){
             Product_Model__c pm = productModels.get(i);
             prdObj = new Product2(name='testproduct -'+i, family='Licenses',
                               Tier_Pricing__c = tier_pricing,BigMachines_Category__c ='Training',
                               Status__c = 'General Availability',Part_Number__c = 'PRO-'+i,Product_Model__c= pm.id,
                               Environment__c = 'Test');
                               
 
            
            if(i == 0){
                prdObj.Exclude_from_Test_Clone__c = false;
                prdObj.Exclude_from_Failover_Clone__c = false;
                prdObj.Test_Environments_Allowed__c = 2;
                prdObj.Failover_Environments_Allowed__c = 2;
                prdObj.Replicate_Assets__c = True;
                prdObj.License_Required__c= True;
            }else  if(i == 1)
            {
                
                prdObj.core_Product__c = true;
                prdObj.Replicate_Full_Environment__c = true;            
                prdObj.Test_Environments_Needed__c = 2;
                prdObj.Failover_Environments_Needed__c = 2; 
                prdObj.Exclude_from_Test_Clone__c = true;
                prdObj.Exclude_from_Failover_Clone__c = true;
                prdObj.Test_Environments_Allowed__c = 2;
                prdObj.Failover_Environments_Allowed__c = 2;
                
            }else{
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
  
    public static List<Agreement__c> createAgreements(String accountId,string oppId, List<Product_Model__c> productModels)
    {
        List<Agreement__c> agreements = new List<Agreement__c>();
        Agreement__c agmnt;
        
        agmnt = new Agreement__c (Name =productModels.get(0).Name,account__c = accountId,Opportunity__c = oppId);
        agreements.add(agmnt);
        
        insert agreements;
        return agreements;
    }
    
  
    public static Opportunity createOpportunity(String accId){
      List<Contact> contacts = new List<Contact>(); 
       
      contacts.add(new Contact(LastName = 'Test',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', License_Contact__c = true,Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc'));
      contacts.add(new Contact(LastName = 'Test1',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com',License_Contact__c = true,Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc'));
      insert contacts;
        
      Opportunity opp =  new Opportunity();
      opp.AccountId = accId;
      opp.Name = 'Opportunity4TestMethod';
      opp.CloseDate = Date.today().addDays(10);
      opp.StageName = 'Negotiation';
      opp.Type = 'Renewal';
      opp.QAStatus__c = 'New';
      opp.Ship_To__c  = contacts.get(0).Id;
      opp.Bill_To__c  = contacts.get(0).Id;
      opp.MPS__c=true;
      opp.LX_Sales_Type__c='New Project';
      insert opp;
      return opp;
    }
    
    public static List<Product_Model__c> createProductModels(Integer size)
    {
        List<Product_Model__c> productModels = new List<Product_Model__c>();
        Product_Model__c pm;
        for(Integer i =0; i< size;i++)
        {
            pm = new Product_Model__c(Name = 'Test Model '+i,Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support');
            if(i==0)
            {
                pm.Model__c = 'TestM-'+i;
                pm.Asset_Required__c = true;
            }
            productModels.add(pm);
        }
        insert productModels;
        return productModels;        
    }
    
   public static Server__c createServer(String agreementId,string accountId)
   {
        Server__c server = new Server__c(Name='Test Server', agreement__c = agreementId,Server_Type__c = 'Live',Account__c = accountId);
        insert server;
        return server;
        
    }
    
    public static Server__c  createMatchingServer(String serverName ,String sectroType, String accId, String agreementId){
         Server__c server = new Server__c(Name=serverName, agreement__c = agreementId,Server_Type__c = sectroType,Account__c = accId);
        insert server;
        return server;
    }

}