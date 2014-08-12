@isTest
public with sharing class Data_OpportunityLineItem {
    public static Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
    public static List<OpportunityLineItem> createOppLineItem(id oppid, id PriceBookEntryId, list<String> Category){ 
         List<OpportunityLineItem> LineItems = new List<OpportunityLineItem>();   
         for(Integer i =0;i<category.size();i++){        
            OpportunityLineItem oppLineItems = new OpportunityLineItem();
            oppLineItems.opportunityId       = oppid;
            oppLineItems.pricebookentryid    = PriceBookEntryId;
            oppLineItems.quantity            = 1;
            oppLineItems.unitprice           = 1;
         
            
            oppLineItems.Category__c             = Category[i];
            oppLineItems.Token_Type__c        = Category[i];
            LineItems.add(oppLineItems);  
         }
        system.debug('lineItems entered:' + lineItems);
        insert LineItems;       
        return LineItems;  
     }
     

      static testMethod void testTestData() {
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);  
        
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
        String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
        Test.startTest();    
        List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );       
        System.assert(oppLineItem[0].id != null);
        Test.stopTest();
      }   
}