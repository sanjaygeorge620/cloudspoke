/**
 * Test Class for SetProductRequester
 */
@isTest
private class Test_SetProductRequester {

    static testMethod void testProductRequester() {
        
         //create Product  
         List<Product2> products = createProducts(2);
         
         Test.StartTest();
         products = updateProducts(products,true);
         Set<Id> prductIds = new Set<Id>();
         for(Product2 product : products){
            prductIds.add(product.id);
         }
         for(Product2 prod : [select Id, Requester__c from Product2 where id in : prductIds]){
           // System.assertEquals(prod.Requester__c , System.UserInfo.getUserId());
         }
         products = updateProducts(products,false);
         for(Product2 prod : [select Id, Requester__c from Product2 where id in : prductIds]){
            System.assertEquals(prod.Requester__c , null);
         }
         Test.StopTest();
       
    }
    
    /* generate test data */
  
  /* Create Products */
  public Static List<Product2> createProducts(Integer size){
    return createProduct(size, false);
   }
   
   public Static List<Product2> createProduct(Integer size, boolean tier_pricing){
    List<Product2> prodList = new List<Product2>();
    Product2 prdObj;
    for(Integer i =0;i<size;i++){
         prdObj = new Product2(name='testproduct - '+i, family='Development',
                               Tier_Pricing__c = tier_pricing,BigMachines_Category__c ='Training',
                               Status__c = 'General Availability',Part_Number__c = 'PRO-'+i,set_Requester__c = false);
         prodList.add(prdObj);
   }
   insert prodList;
   return prodList;
  }
  
  public static List<Product2> updateProducts(List<Product2> products, Boolean isUpdateRequester){
           for(Product2 prod  : products){
                prod.Set_Requester__c = isUpdateRequester;
           }
           update products;
           return products;  
  }
  
}