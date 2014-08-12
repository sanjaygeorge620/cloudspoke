@isTest
public with sharing class Data_PriceBookEntry {
     public static PricebookEntry createPriceBookEntry(id pricebook2id, id product2Id){     
          /* Create a pricebook entry. */
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pricebook2id;
            pbe.Product2Id   = product2Id;
            pbe.IsActive     = true;
            pbe.UnitPrice    = 1;
            pbe.useStandardPrice = false;

        insert pbe;       
        return pbe;  
  } 

      static testMethod void testTestData() {
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);  
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
         PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);       
         System.assert(pbe.id != null);
      } 
}