@isTest(seeAlldata=true)

public class Test_ProcessInstallations_CreateCase{
    
    static testmethod void m1(){
    
        Account acc = Data_Account.createAccount();
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1); 
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
     //   List<sObject> ls = Test.loadData(Opportunity.sObjectType, 'OpportunityTestData');
      //  List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList,1,acc,contacts); 
        List<Opportunity> test_opportunities = new List<Opportunity>{new Opportunity(name='test',stagename ='Qualifying',Contract_Indicator__c='123',closedate = date.today(),Software_solutions__c=true,accountid=acc.id)};
        insert test_opportunities;
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
          
        List<Product2> product = Data_Product.createProduct(pmList);  
        priceBook2 priceBook = [select ID from Pricebook2 where IsStandard = TRUE limit 1];
        
        Id priceBookId = priceBook.id;
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        PricebookEntry pE1 = new PricebookEntry(Product2Id = product.get(0).Id ,Isactive=true ,UnitPrice=100);
        pE1.priceBook2Id = priceBookId ;
        priceBookEntries.add(pE1);
        insert priceBookEntries ;
        
        Agreement__c agree = new Agreement__c(account__c = acc.id);
        insert agree;
        
        Server__c server = new Server__c(Name='Test Server', agreement__c = agree.Id,Server_Type__c ='Test',Account__c = acc.ID);
        insert server;
        
        System.debug('>>>>>>>>>>>>'+test_opportunities[0].id);
       OpportunityLineItem opp_product1 = new OpportunityLineItem(OpportunityId = test_opportunities[0].id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id );
       OpportunityLineItem opp_product2 = new OpportunityLineItem(OpportunityId = test_opportunities[0].id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
      //   OpportunityLineItem opp_product1 = new OpportunityLineItem(OpportunityId = ((Opportunity)ls[0]).id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id );
     //  OpportunityLineItem opp_product2 = new OpportunityLineItem(OpportunityId = ((Opportunity)ls[0]).id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
        
        List<OpportunityLineItem> opplis = new List<OpportunityLineItem>();
        opplis.add(opp_product1);
        opplis.add(opp_product2);
        insert opplis;
        
        Test.startTest();
        ProcessInstallations_CreateCase.ProcessInstallations_CreateCase(opplis[0],'test',new List<case>{new case()},server.id);
        Test.stopTest();
        
        
    
    }
    

}