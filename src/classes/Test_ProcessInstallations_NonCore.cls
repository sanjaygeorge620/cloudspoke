/**

 */
@isTest
private class Test_ProcessInstallations_NonCore 
{


    /*
        Test Case 1 : test the functionality of process method
    */
     
    static testMethod void testCreateInstallations() 
    {
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         List<ID> SwapAssetItems = new List<ID>();   
         Map<ID,List<License_Key__c>> SwapLicenseKeyMap = new Map<ID, List<License_Key__c>>();
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];       
         List<OpportunityLineItem> opplis = new List<OpportunityLineItem>();
         
         User sysAdmin = new User(alias = 'test21', email='test123@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Tes2ting', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test2231@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes', Legacy_Company__c='Lexmark');
         Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('License - External').getRecordTypeId();
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
         Test.startTest();
       
        List<Product2> products = new List<Product2>(); 
        products.add(createDataPr());
        
        Id priceBookId;
        for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE])
        {
            priceBookId = priceBook.id;
        }
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        PricebookEntry pE1 = new PricebookEntry(Product2Id = products.get(0).Id ,Isactive=true ,UnitPrice=100);
        
        if(priceBookId != null)
        {
           pE1.priceBook2Id = priceBookId ;
        
           priceBookEntries.add(pE1);
        
           insert priceBookEntries ;
     
           OpportunityLineItem opp_product1 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id,part_number__c = products.get(0).Part_number__c);
           opplis.add(opp_product1);          
           
       insert opplis;
         opp.SAP_Status__c = 'Override';
         update opp;  
        Test.stopTest();
        List<Server__c> srv = [Select ID,Server_Type__c from Server__c where Account__c =: acc.id];
        List<Asset_Item__c> aitem = [select id
                                    , Name
                                    , Quantity__c
                                    , Status__c
                                    , Product__c
                                    , Opportunity__c
                                    , Server__c
                                    , Asset__c
                                    from Asset_Item__c where Asset__r.AccountID =: acc.id];
        if(!srv.isEMpty())
        {
        opplis[0].server__c = srv[0].id;
        }        
        update opplis;
         List<License_Key__c>SwapLicenseKeyList = new  List<License_Key__c>();
        Map<OpportunityLineItem, List<Server__c>> temp = ProcessInstallations_getServers.processInstallations_getServers(opplis);
        Map<ID, Product2> ProductRecMap = new Map<ID, Product2>();    
        Map<Product2, OpportunityLineItem> ProductRecLineItem = new Map<Product2, OpportunityLineItem>();
        Map<ID, Product_Model__c> ProductModelRecordsMap = new Map<ID, Product_Model__c>();
        ProductRecMap.put(products.get(0).Id,products.get(0));
        ProductRecLineItem.put(products.get(0),opplis[0]);
        Product_Model__c pmo = [Select ID,name from Product_Model__c where ID =: products.get(0).Product_Model__c][0];
        ProductModelRecordsMap.put(products.get(0).Product_Model__c,pmo);
        Map<ID, List<Asset_Item__c>>  SwapAssetItemsMap = ProcessInstallations_GetSwapAssets.ProcessInstallations_GetSwapAssets(ProductRecMap,temp,ProductRecLineItem,ProductModelRecordsMap);
        List<Asset_Item__c> aitm = new List<Asset_Item__c>();
          if(SwapAssetItemsMap.size()>0)
          {
                                //loop through Asset map to compile list of assetIds to use 
                                List<ID> SwapAssetItemsMapKey = new List<ID>(SwapAssetItemsMap.keyset());
                                system.debug('SwapAssetItemsMapKey: ' + SwapAssetItemsMapKey);
                                for(ID IDRec : SwapAssetItemsMapKey )
                                {
                                aitm = SwapAssetItemsMap.get(IDRec);
                                    For(Asset_Item__c AssetItemRec: SwapAssetItemsMap.get(IDRec))
                                    { 
                                        SwapAssetItems.add(AssetItemRec.Asset__c);
                                    }
                                }  
                                system.debug('SwapAssetItems: ' + SwapAssetItems);  
                                if  (SwapAssetItems.size()>0)
                                {
                                    SwapLicenseKeyMap = ProcessInstallations_GetSwapLicenses.ProcessInstallations_GetSwapLicenses(SwapAssetItems);
                                    for(ID i : SwapLicenseKeyMap.keyset())
                                    {
                                    SwapLicenseKeyList = SwapLicenseKeyMap.get(i);                                    
                                    }
                                }   
         }
         List<Case> CasesToInsert = new List<Case>();
         boolean bol = true;
         List<Asset_Item__c> aitmlist = ProcessInstallations_InactivateAssetItem.ProcessInstallations_InactivateAssetItem(opplis[0],products.get(0),
         aitm,srv,SwapAssetItemsMap,products.get(0).Product_Model__c,pmo.name,'Yes',recordTypeId,CasesToInsert,bol);
         Map<OpportunityLineItem, List<Product2>> nonCoreProductsMap = new Map<OpportunityLineItem, List<Product2>>();
         nonCoreProductsMap.putall(ProcessInstallations_NonCoreProducts.ProcessInstallations_NonCoreProducts(opplis[0], nonCoreProductsMap,products.get(0)));
    }
    }
    }
 
    /* generate test data */
    
     /* Create Products */
    public Static List<Product2> createProducts(List<Product_Model__c> productModels)
    {
        return createProducts(productModels, false);
    }
   
    public Static List<Product2> createProducts(List<Product_Model__c> productModels, boolean tier_pricing){
        List<Product2> prodList = new List<Product2>();
        Product2 prdObj;
        Integer i = 0;
        for(;i< productModels.size(); i++){
             Product_Model__c pm = productModels.get(i);
             prdObj = new Product2(name='testproduct -'+i, family='Licenses',
                               Tier_Pricing__c = tier_pricing,BigMachines_Category__c ='Training',
                               Status__c = 'General Availability',Part_Number__c = 'PRO-'+i,Product_Model__c= pm.id,
                               Environment__c = 'Test');
                               
            prdObj.core_Product__c = false;
            prdObj.Replicate_Full_Environment__c = true;            
            prdObj.Test_Environments_Needed__c = 2;
            prdObj.Failover_Environments_Needed__c = 2;
            
            if(i == 0){
                prdObj.Exclude_from_Test_Clone__c = false;
                prdObj.Exclude_from_Failover_Clone__c = false;
                prdObj.Test_Environments_Allowed__c = 2;
                prdObj.Failover_Environments_Allowed__c = 2;
            }else  if(i == 1){
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
       acc.Address_Edit_States__c = 'Rajasthan';
       insert acc;
       return acc;
    }
*/    
    public static Opportunity createOpportunity(String accId){
      List<Contact> contacts = new List<Contact>(); 
      contacts.add(new Contact(LastName = 'Test',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',license_contact__c=true));
      contacts.add(new Contact(LastName = 'Test1',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc'));
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
      opp.Technology__c=true;
      opp.LX_Sales_Type__c='New Project';
      insert opp;
      return opp;
    }
    
    public static List<Product_Model__c> createProductModels(Integer size){
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
    
    public static Server__c  createMatchingServer(String serverName ,String sectroType, String accId, String agreementId){
         Server__c server = new Server__c(Name=serverName, agreement__c = agreementId,Server_Type__c = sectroType,Account__c = accId);
        insert server;
        return server;
    }
 public static product2 createDataPr()
    {
    List<Product_Model__c> pmlist = new List<Product_Model__c>();
    List<Product2> prlist = new List<Product2>();    
    Product_Model__c pm1 = new Product_Model__c(Name = 'Basic Software Maintenance Agreement',Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support',Status__c = 'Active');
    Product_Model__c pm2 = new Product_Model__c(Name = 'ImageNow Server123',Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support',Status__c = 'Active',Asset_Required__c = True);
    pmlist.add(pm1);
    pmlist.add(pm2);    
    insert pmlist;
    
    Product2 prdObj1 = new Product2(name='INOW', family='Licenses',Name_Abbrev__c = 'INOW',
                               BigMachines_Category__c ='Subscription',
                               Status__c = 'General Availability',Part_Number__c = 'PER-ABCD',Product_Model__c= pmlist[1].id,
                               Environment__c = 'Live',License_Required__c = True,core_Product__c = true,Test_Environments_Needed__c = 2,Failover_Environments_Needed__c = 1,
                               isActive = True);
                               
    Product2 prdObj2 = new Product2(name='SMSAINOW', family='SMSA',Name_Abbrev__c = 'SMSAINOW',
                               BigMachines_Category__c ='Subscription',
                               Status__c = 'General Availability',Part_Number__c = 'PER-EFGH',Product_Model__c= pmlist[0].id,
                               Failover_Licenses_Allowed__c = 0,isActive = True);                           
                               
                                                              
         prlist.add(prdObj1);
         prlist.add(prdObj2);
         
         insert prlist;
         prlist[0].SMSA_Product__c = prlist[1].id;
         prlist[0].Name_Abbrev__c = prlist[0].id;
         prlist[1].Parent_Product__c = prlist[0].id;  
         prlist[1].Name_Abbrev__c = prlist[1].id;           
         
         update prlist;  
         
         return prlist[0];    
    }
   
}