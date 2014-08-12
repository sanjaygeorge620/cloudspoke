/**
* Test Class for SetPricingRequester
*/
@isTest
private class Test_SetPricingRequester {
    
    static testMethod void testSetPricingRequestor() {
         //create Product Development 
         
       List<Product2> products = createProduct(2);
       
       List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
       List<Pricing__c> pricings = createPricings(products);
       pricings.get(0).Set_Requester__c = true;
       update pricings;
       for(Pricing__c p : [select Id,Requester__c from pricing__c where id = :pricings.get(0).id limit 1]){
         //VT:8/25 COmmented   System.assertEquals(p.Requester__c,UserInfo.getUserId());
        }
    }
    
     /* Create Products */
  public Static List<Product2> createProduct(Integer size){
    return createProduct(size, false);
   }
   
   public Static List<Product2> createProduct(Integer size, boolean tier_pricing){
    List<Product2> prodList = new List<Product2>();
    Product2 prdObj;
    for(Integer i =0;i<size;i++){
         prdObj = new Product2(name='testproduct - '+i, family='Development',
                               Tier_Pricing__c = tier_pricing,BigMachines_Category__c ='Training',
                               Status__c = 'General Availability',Part_Number__c = 'PRO-'+i);
         prodList.add(prdObj);
   }
   prdObj = new Product2(name='This is a test product for testing of the wrap product Name',family='Development');
   prodList.add(prdObj);
   insert prodList;
   return prodList;
  }
  
  /* Create Price Book Definition test data */
  public static List<Price_Book_Definition__c> createPriceBookDefs(){
    List<Price_Book_Definition__c> priceBookDefs = new List<Price_Book_Definition__c>();
    Price_Book_Definition__c priceBookDef1 = new Price_Book_Definition__c(Name ='Test Price Book Def -1',
                                                                          Type__c = 'Product',
                                                                          Discount_Type__c = 'Amount',
                                                                          Discount_Value__c = 20);
                                                                         
    priceBookDefs.add(priceBookDef1);   
    Price_Book_Definition__c priceBookDef2 = new Price_Book_Definition__c(Name ='Test Price Book Def -2',
                                                                          Type__c = 'SMSA',
                                                                          Discount_Type__c = 'Percent',
                                                                          Discount_Value__c = 30);
    priceBookDefs.add(priceBookDef2);                                                                      
    Price_Book_Definition__c priceBookDef3 = new Price_Book_Definition__c(Name ='Test Price Book Def -3',
                                                                          Type__c = 'VSOE',
                                                                          Discount_Type__c = 'Percent',
                                                                          Discount_Value__c = 30);
    
    priceBookDefs.add(priceBookDef3);   
    insert priceBookDefs;
    return priceBookDefs;                                                        
  }
  
  /* Create Pricing test data */
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

}