/**

 */
@isTest(seeAllData=true)
private class Test_ProcessInstallations_Asset {

    static testMethod void testCreateInstallationsAsset() {
        //Account acc = createAccount();
        Account acc = Data_Account.createAccount();
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1); 
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList,1,acc,contacts); 
        //List<Product_Model__c> productModels = createProductModels(4);
        //List<Agreement__c> agreements = createAgreements(acc.id,opp.id,productModels );
        
        //List<Product2> products = createProducts(productModels); 
         List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
          for (Product_Model__c pmRec : pmList){
            pmRec.Asset_Required__c = true;
          }
          update pmList;
          
          Test.StartTest();
          
        List<Product2> product = Data_Product.createProduct(pmList);  
        
        Id priceBookId;
        for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
            priceBookId = priceBook.id;
        }
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        PricebookEntry pE1 = new PricebookEntry(Product2Id = product.get(0).Id ,Isactive=true ,UnitPrice=100);
        //PricebookEntry pE2 = new PricebookEntry(Product2Id = product.get(1).Id ,Isactive=true ,UnitPrice=100);
        //PricebookEntry pE3 = new PricebookEntry(Product2Id = product.get(2).Id ,Isactive=true ,UnitPrice=100);
        OpportunityLineItem opp_product1;
        OpportunityLineItem opp_product2;
        if(priceBookId != null){
           pE1.priceBook2Id = priceBookId ;
           //pE2.priceBook2Id = priceBookId;
           //pE3.priceBook2Id = priceBookId;
           priceBookEntries.add(pE1);
           //priceBookEntries.add(pE2);
           //priceBookEntries.add(pE3);
           insert priceBookEntries ;
           List<OpportunityLineItem> opplis = new List<OpportunityLineItem>();
           opp_product1 = new OpportunityLineItem(OpportunityId = test_opportunities[0].id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id );
           opplis.add(opp_product1);
           opp_product2 = new OpportunityLineItem(OpportunityId = test_opportunities[0].id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
           opplis.add(opp_product2);
           insert opplis;
        }   
        
        product[0].Test_Environments_Allowed__c = 10;
        update product; 
        Agreement__c agree = new Agreement__c(account__c = acc.id);
        insert agree;
        
       Server__c server = new Server__c(Name='Test Server', agreement__c = agree.Id,Server_Type__c ='Test',Account__c = acc.ID);
        insert server;
        
         Server__c server2 = new Server__c(Name='Test Server1', agreement__c = agree.Id,Server_Type__c ='Failover',Account__c = acc.ID);
        insert server2;
        
         Asset ass = new Asset(Name = pmList[0].Name,Server__c = server.id,AccountID = acc.id);
        insert ass;
        
        //Product_Model__c pm = new Product_Model__c(Name = 'Test Model',Line__c = 'Solutions Software',Series__c //= 'Application Maint. & Dev',Family__c = 'Support');
        //insert pm;
        List<Server__c> lstServer = new List<Server__c>();
        lstServer.add(server);
        
        List<Server__c> lstServer2 = new List<Server__c>();
        lstServer.add(server2);
        
        
        ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(opp_product1,product[0],lstServer,pmList[0].Id,pmList[0].name,'Yes',true);
        ProcessInstallations_CreateAsset.ProcessInstallations_CreateAsset(opp_product1,product[0],lstServer2,pmList[0].Id,'teee','Yes',true);
        
       }

}