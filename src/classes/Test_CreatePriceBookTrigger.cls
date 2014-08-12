/**
    Test Class for CreatePriceBook Trigger
 */
@isTest
private class Test_CreatePriceBookTrigger {

    static testMethod void testCreatePriceBook() {
        List<Product2> products = createProduct(2);
       
        List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
        //Create product Materails object 
        List<Pricing__c> pricings = createPricings(products);
         
        List<Product_Sales_Org__c> materialSalesOrgs = createMaterialSalesOrgs(products.get(0).id);
        
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Submitted');
        insert priceBookMaker;
        System.assert(priceBookMaker.id != null);
    }
    
    /* generate test data */
  
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
  
  /* Create Product Sales Org test data */
  public static List<Product_Sales_Org__c> createMaterialSalesOrgs(Id productId){
    List<Sales_Organization__c> salesOrgs = createSalesOrgs(3);
    List<Product_Sales_Org__c> materialSalesOrgs = new List<Product_Sales_Org__c>();
    for(Sales_Organization__c so : salesOrgs){
        Product_Sales_Org__c ms = new Product_Sales_Org__c(Product_Name__c = productId,
                                                             Sales_Organization__c = so.id);
        materialSalesOrgs.add(ms);
    }
    insert materialSalesOrgs;
    return materialSalesOrgs;
  } 
  /* Create Sales Organization test data */
  public static List<Sales_Organization__c> createSalesOrgs(Integer size){
    List<Sales_Organization__c> salesOrgs = new List<Sales_Organization__c>();
    for(Integer i =0;i<size;i++){
        Sales_Organization__c so1 = new Sales_Organization__c(Name ='Test Sales org - '+i,Sales_Organization__c= '1'+i,LX_Default__c=true);
        salesOrgs.add(so1);
    }
    insert salesOrgs;
    return salesOrgs;
  }
}