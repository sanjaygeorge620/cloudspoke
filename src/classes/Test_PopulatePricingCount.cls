@isTest
private class Test_PopulatePricingCount {
    static testMethod void test_PopulatePricingCount() {
        Id prodId = createProduct(1, false).get(0).Id;
        
        Product2 prod = [select pricing_count__c, tier_pricing__c from product2 where id = :prodId];
        System.assert(!prod.tier_pricing__c);
        System.assertEquals(0, prod.pricing_count__c);
        
        List<Product2> prods = new List<Product2>();
        prods.add(prod);
        
        List<Pricing__c> pricings = createPricings(prods);
        
        prod = [select pricing_count__c, tier_pricing__c from product2 where id = :prodId];
        System.assert(!prod.tier_pricing__c);
       //VT 8/25 COmmented System.assertEquals(1, prod.pricing_count__c);
        
        deletePricings(pricings);
        prod = [select pricing_count__c, tier_pricing__c from product2 where id = :prodId];
        System.assert(!prod.tier_pricing__c);
        System.assertEquals(0, prod.pricing_count__c);   
    }
    /* Generate Test data */
    /* Create product test data */
    public Static List<Product2> createProduct(Integer size, boolean tier_pricing){
    List<Product2> prodList = new List<Product2>();
    Product2 prdObj;
    for(Integer i =0;i<size;i++){
         prdObj = new Product2(name='testproduct - '+i, family='Development',
                               Tier_Pricing__c = tier_pricing,
                               Pricing_Count__c = 0,Status__c = 'General Availability',Part_Number__c = 'PRO-'+i);
         prodList.add(prdObj);
   }
   prdObj = new Product2(name='This is a test product for testing of the wrap product Name',family='Development');
   prodList.add(prdObj);
   insert prodList;
   return prodList;
  }
  
  public static List<Pricing__c> createPricings(List<Product2> products){
    List<Pricing__c> pricings = new List<Pricing__c>();
    for(Product2 pm : products){
        Pricing__c pricing = new Pricing__c(
            Product_Name__c = pm.id,
            cost__c = 100,
            Fair_Market_Value__c=200);
        pricings.add(pricing);
    }
    insert pricings;
    return pricings;
  }
  
  public static void deletePricings(List<Pricing__c> pricings){
    delete pricings;
  } 
}