@isTest
private class Test_CreatePriceBooks {

    static testMethod void testCreatePriceBook() {
      
        //create Product Development 
         
       List<Product2> products = createProduct(2); 
       
       List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
        //Create product Materails object 
        //List<Product_Material__c> productMaterials = createProductMaterials(products.get(0).id,3);
        
        List<Pricing__c> pricings = createPricings(products);
        
        products =  updateProducts(products);
        
        List<Product_Sales_Org__c> materialSalesOrgs = createMaterialSalesOrgs(products.get(0).id);
        //create price book Maker object
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Submitted');
        insert priceBookMaker;
        Test.startTest(); 
        CreatePriceBooks createPB;
        try{
           createPB = new CreatePriceBooks(priceBookMaker.id);
           createPB.process();
           for(Price_Book_Maker__c pbm : [select Id, Name , status__c from Price_Book_Maker__c where id = : priceBookMaker.id limit 1]){
              System.assertEquals(pbm.status__c,'Core - In Progress');
           }
        }catch(Exception ex){
            System.debug('---Exception--'+ex);
        } 
        //update price book Maker 
        priceBookMaker.status__c  = 'Core - Complete';
        update priceBookMaker;
        
        List<Core_Price_Book__c> corePriceBooks = createPriceBooks(priceBookMaker.id,3);
        createPB = new CreatePriceBooks(priceBookMaker.id);
        createPB.process();
        
        for(Price_Book_Maker__c pbm : [select Id, Name , status__c from Price_Book_Maker__c where id = : priceBookMaker.id limit 1]){
             System.assertEquals(pbm.status__c,'Core - Complete');
        }
        /* Test Ready to publish functionality */
        priceBookMaker.Status__c = 'Ready to Publish';
        update priceBookMaker;
        
        createPB = new CreatePriceBooks(priceBookMaker.id);
        createPB.process();
        for(Price_Book_Maker__c pbm : [select Id, Name , status__c from Price_Book_Maker__c where id = : priceBookMaker.id limit 1]){
             System.assertEquals(pbm.status__c,'Published - In Progress');
        } 
        /* Test published - Complete functionality */
        System.debug('==Test published without account Id--');
        priceBookMaker.Status__c = 'Published - Complete';
        update priceBookMaker;
        createPB = new CreatePriceBooks(priceBookMaker.id); 
        createPB.process();
        for(Price_Book_Maker__c pbm : [select Id, Name , status__c from Price_Book_Maker__c where id = : priceBookMaker.id limit 1]){
             System.assertEquals(pbm.status__c,'Complete');
        }
         /* Test published - Complete with account Id functionality */
         System.debug('==Test published with account Id--');
        priceBookMaker.Status__c = 'Published - Complete';
        update priceBookMaker;
        List<Account> priceBookAccounts = createPriceBookAccounts(priceBookDefs);
        createPB = new CreatePriceBooks(priceBookMaker.id,priceBookAccounts.get(0).id);
        createPB.process();
        for(Price_Book_Maker__c pbm : [select Id, Name , status__c from Price_Book_Maker__c where id = : priceBookMaker.id limit 1]){
             System.assertEquals(pbm.status__c,'Complete');
        }
        priceBookMaker.Status__c = 'Published - Complete 1';
        update priceBookMaker;
        createPB = new CreatePriceBooks(priceBookMaker.id);
        createPB.process();
        
        Test.stopTest();
 
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
  
  /* update product test data */
  public static List<Product2> updateProducts(List<Product2> products){
    for(Product2 pm : products){
        pm.Tier_Pricing__c = true;
    }
    update products;
    return products;
  }
  
  /* Create Product Sales Org test data */
  public static List<Product_Sales_Org__c> createMaterialSalesOrgs(Id productId){
    List<Sales_Organization__c> salesOrgs = createSalesOrgs(1);
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
        Sales_Organization__c so1 = new Sales_Organization__c(Name ='Test Sales org - '+i,Sales_Organization__c= '1'+i,LX_default__c = true);
        salesOrgs.add(so1);
    }
    insert salesOrgs;
    return salesOrgs;
  }
  
  /* Create core price book test data */
   public static List<Core_Price_Book__c> createPriceBooks(Id priceBookMakerId,Integer size){
      List<Core_Price_Book__c> corePriceBooks = new List<Core_Price_Book__c>();
      Core_Price_Book__c corePriceBook;
      for(Integer i =0;i<size;i++){
           corePriceBook = new Core_Price_Book__c(Price_Book_Maker_ID__c = priceBookMakerId);
           corePriceBooks.add(corePriceBook);
      }
      insert corePriceBooks;
      return corePriceBooks;
  }
  
  /* create Accounts with price book */
  public static List<Account> createPriceBookAccounts(List<Price_Book_Definition__c> priceBookDefs){
      List<Account> accounts = new List<Account>();
      
      Account account;
      for(Price_Book_Definition__c pbd : priceBookDefs){
           account = new Account(Name ='Test price Account',Physical_Country__c = 'USA',BillingCountry = 'USA');
           if(pbd.type__c == 'Product'){
               account.Price_Book_Product__c = pbd.id;
           }else if(pbd.Type__c == 'SMSA'){
               account.Price_Book_SMSA__c = pbd.id;
           }else if(pbd.type__c =='VSOE'){
               account.Price_Book_VSOE__c = pbd.id;
           }
           accounts.add(account);
      }
      insert accounts;
      return accounts;
  }
  
   public static List<Published_Price_Book__c> CreatePublishedPriceBooks(String pbmId){
    List<Published_Price_Book__c> publishedPbs = new List<Published_Price_Book__c>();
    Published_Price_Book__c ppb1 = new Published_Price_Book__c(Price_Book_Maker_ID__c =pbmId,Price_Book_Type__c='Product',Name='Test PPB - 1');
    publishedPbs.add(ppb1);
    
    Published_Price_Book__c ppb2 = new Published_Price_Book__c(Price_Book_Maker_ID__c =pbmId,Price_Book_Type__c='SMSA',Name='Test PPB - 2');
    publishedPbs.add(ppb2);
    
    Published_Price_Book__c ppb3 = new Published_Price_Book__c(Price_Book_Maker_ID__c =pbmId,Price_Book_Type__c='VSOE',Name='Test PPB - 3',isParent__c =true);
    publishedPbs.add(ppb3);
    
    insert publishedPbs;
    return publishedPbs;
  }
  
}