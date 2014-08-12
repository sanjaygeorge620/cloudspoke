/**
    Test Class for PriceBookBatchedProcessor
*/    
@isTest(seeAlldata = true)
private class Test_PriceBookBatchedProcessor {
    Test_PriceBookBatchedProcessor(){
    Price_Book_Batch__c batch = new Price_Book_Batch__c(number__c=100, name='Batch Number');
    upsert batch;
    }
     /* Test methos for operation CreateCorePriceBooks */
    static testMethod void testCreateCoreBooks() {
      
        List<Product2> products = createProduct(2); 
       products[0].Fair__c = 22;
       products[1].Fair__c = 22;
        List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
        //Create product Materails object 
        //List<Product_Material__c> productMaterials = createProductMaterials(products.get(0).id,3);
        
        List<Pricing__c> pricings = createPricings(products);
        
        products =  updateProducts(products);
        
        List<Product_Sales_Org__c> materialSalesOrgs = createMaterialSalesOrgs(products.get(0).id);
         List<Sales_Organization__c> salesOrgs = createSalesOrgs(3);
        Currency_Rate__c objCurrency = new Currency_Rate__c();
        objCurrency.Rate__c = 24;
        insert objCurrency;
                
        Sales_Org_Currency__c obj = new Sales_Org_Currency__c();
        obj.Currency_Name__c = objCurrency.Id;
        obj.Sales_Organization__c = salesOrgs[0].Id; 
        insert obj;
        
        Product2 p= new product2(name='testproduct',family='Development',Pricing_Count__c =1,BigMachines_Category__c ='Training',Part_Number__c = 'PRO-',Status__c = 'General Availability', isActive = true, Exclude_from_Pricebook__c = false , IS_Exclude_From_Price_Book__c = false);
        p.Tier_Pricing__c =false;
        insert p; 
        
        //create price book Maker object
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Complete');
        insert priceBookMaker;
        Test.startTest(); 
        // Test for operation CreateCorePriceBooks 
        PriceBookBatchedProcessor batch = new PriceBookBatchedProcessor(priceBookMaker.Id,true, 'CreateCorePriceBooks');
        //batch.insertCorePriceBooks(products, 0);
        batch.GetRoundedValue(5);
        batch.deriveQueryFromStatus();
        Id batchProcess = Database.executeBatch(batch,200);
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
   //prdObj = new Product2(name='This is a test product for testing of the wrap product Name',family='Development');
   //prodList.add(prdObj);
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
        pm.Cost__c = 100;
        pm.Fair__c = 150;
    }
    update products;
    return products;
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
        Sales_Organization__c so1 = new Sales_Organization__c(Name ='Test Sales org - '+i,Sales_Organization__c= '1'+i,LX_Country_Code__c='US');
        salesOrgs.add(so1);
    }
    // Added by sumedha on 10/22 to fix test errors. 
    salesOrgs[0].LX_Default__c = true;
    insert salesOrgs;
    return salesOrgs;
  }
  
  /* Create core price book test data */
   public static List<Core_Price_Book__c> createPriceBooks(Id priceBookMakerId,Integer size){
      List<Core_Price_Book__c> corePriceBooks = new List<Core_Price_Book__c>();
      Core_Price_Book__c corePriceBook;
      for(Integer i =0;i<size;i++){
           corePriceBook = new Core_Price_Book__c(Price_Book_Maker_ID__c = priceBookMakerId);
           corePriceBook.Header_Number__c = 1;
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
  
    
    
    
     /* Test  method for operation CreatePublishedPriceBooks */
     
    static testMethod void testCreatePublishedPriceBooksExecute() {
      
        List<Product2> products = createProduct(2); 
       
        List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
        //Create product Materails object 
        //List<Product_Material__c> productMaterials = createProductMaterials(products.get(0).id,3);
        
        List<Pricing__c> pricings = createPricings(products);
        
        products =  updateProducts(products);
        
        List<Product_Sales_Org__c> materialSalesOrgs = createMaterialSalesOrgs(products.get(0).id);
        //create price book Maker object
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Complete');
        insert priceBookMaker;
        Test.startTest(); 
        //Test for operation CreatePublishedPriceBooks 
        List<Core_Price_Book__c> corePriceBooks = createPriceBooks(priceBookMaker.id,3);
        PriceBookBatchedProcessor batch = new PriceBookBatchedProcessor(priceBookMaker.Id,true, 'CreatePublishedPriceBooks');
        batch.insertPublishedPriceBooks(corePriceBooks);
        batch.cleanupPublishedPriceBooks([select Status__c from Published_Price_Book__c where Price_Book_Maker_ID__c = :priceBookMaker.Id]);
        Test.stopTest();

    }
    
   static testMethod void testCreatePublishedPriceBooksWithAccountsExecute() {
      
        List<Product2> products = createProduct(2); 
       
        List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
        //Create product Materails object 
        //List<Product_Material__c> productMaterials = createProductMaterials(products.get(0).id,3);
        
        List<Pricing__c> pricings = createPricings(products);
        
        products =  updateProducts(products);
        
        List<Product_Sales_Org__c> materialSalesOrgs = createMaterialSalesOrgs(products.get(0).id);
        //create price book Maker object
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Complete');
        insert priceBookMaker;
        Test.startTest(); 
        // Test for operation CreatePublishedPriceBooks with accounts
        List<Core_Price_Book__c> corePriceBooks = createPriceBooks(priceBookMaker.id,3);
        List<Account> accounts = createPriceBookAccounts(priceBookDefs);
       PriceBookBatchedProcessor batch = new PriceBookBatchedProcessor(priceBookMaker.Id,true,'CreatePublishedPriceBooks',accounts);
        batch.deriveQueryFromStatus();
        batch.accounts = accounts;
      //  batch.insertPublishedPriceBooks(corePriceBooks);
      //  batch.GetRoundedValue(10);
      //  batch.GetRoundedValue(23);
      //  batch.GetRoundedValue(27);
        
       
     //   batch.insertCorePriceBooks(products,1);
        Test.stopTest();

    }
  static testMethod void testCleanupPublishedPriceBooksExecute() {
      
        List<Product2> products = createProduct(2); 
       
        List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
        //Create product Materails object 
        //List<Product_Material__c> productMaterials = createProductMaterials(products.get(0).id,3);
        
        List<Pricing__c> pricings = createPricings(products);
        
        products =  updateProducts(products);
        
        List<Product_Sales_Org__c> materialSalesOrgs = createMaterialSalesOrgs(products.get(0).id);
        //create price book Maker object
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Complete');
        insert priceBookMaker;
        List<Published_Price_Book__c> publishedBooks = createPublishedPriceBook(priceBookMaker.id);
        Test.startTest(); 
        // Test for operation CleanupPublishedPriceBooks
        PriceBookBatchedProcessor batch = new PriceBookBatchedProcessor(priceBookMaker.Id,true,'CleanupPublishedPriceBooks' );
        
        batch.deriveQueryFromStatus();
      //  batch.cleanupPublishedPriceBooks(publishedBooks);
        Test.stopTest();
        
    }
    
     /* Test  method for operation CleanupPublishedPriceBooks */
  static testMethod void testOtherMethods() {
         
        List<Product2> products = createProduct(2); 
       
        List<Price_Book_Definition__c> priceBookDefs = createPriceBookDefs();
        
        //Create product Materails object 
        //List<Product_Material__c> productMaterials = createProductMaterials(products.get(0).id,3);
        
        List<Pricing__c> pricings = createPricings(products);
        
        products =  updateProducts(products);
        
        List<Product_Sales_Org__c> materialSalesOrgs = createMaterialSalesOrgs(products.get(0).id);
        //create price book Maker object
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Complete');
        insert priceBookMaker;
        List<Published_Price_Book__c> publishedBooks = createPublishedPriceBook(priceBookMaker.id);
        Test.startTest(); 
        // Test for operation CleanupPublishedPriceBooks
       // PriceBookBatchedProcessor batch = new PriceBookBatchedProcessor(priceBookMaker.Id,true, 'CreateCorePriceBooks');
        
       /* batch.query = 'Select '+
                    '   Brand__c, '+
                    '   Cost__c, '+
                    '   Exclude_from_Quote_Process__c, '+
                    '   Family, '+
                    '   Id, '+
                    '   Name, '+
                    '   Parent_Product__c, '+
                    '   Parent_Product__r.Product_Model__c, ' +
                    '   Parent_Product__r.Cost__c, ' +  
                    '   SMSA_Product__r.Product_Model__c, ' +
                    '   SMSA_Product__r.Cost__c, ' +
                    '   SMSA_Product__c, ' +
                    '   Part_Number__c, '+
                    '   Product_Category__c, '+
                    '   Product_Model__r.Brand__c, '+
                    '   Product_Model__r.Family__c, '+
                    '   Product_Model__r.Line__c, '+
                    '   Product_Model__r.Model__c, '+
                    '   Product_Model__r.Series__c, '+
                    '   Product_Model__r.SMSA_Percent__c, '+
                    '   Tier_Pricing__c, '+
                    '   Uplift_Product__r.Name, '+ 
                    '   Uplift_Part_Number__c, '+
                    '   Token_Type__c '+
                    'From '+
                    '   Product2 '+
                    'Where '+
                    '   Status__c = \'General Availability\' '+
                    '   and isActive = true' +
                    '   and Exclude_from_Pricebook__c = false limit 200'; //+
        */
        
       // Database.executeBatch(batch,200);
        Test.stopTest();

    }
    
    /* generate test data */
  
   /* create published price book */
  public static List<Published_Price_Book__c> createPublishedPriceBook(String priceBookMakerId){
      List<Published_Price_Book__c> publishedPriceBooks = new List<Published_Price_Book__c>();
      
      Published_Price_Book__c publishedPriceBook;
      for(Integer i =0; i< 3;i++){
           publishedPriceBook = new Published_Price_Book__c(Name ='Test price Account');
           publishedPriceBook.Price_Book_Maker_ID__c = priceBookMakerId;
           publishedPriceBook.status__c = 'Active';
           publishedPriceBooks.add(publishedPriceBook);
      }
      insert publishedPriceBooks;
      return publishedPriceBooks;
  } 
  
   /*static testMethod void testInsertCorePriceBooks(){
        List<Product2> productList = createProduct(3);
        Integer startNumber = 1;
        Sales_Organization__c salesOrg = new Sales_Organization__c(CurrencyIsoCode='USD', Include_in_VSOE__c=true, Status__c='Active');
        upsert salesOrg;
        PriceBookBatchedProcessor book = new PriceBookBatchedProcessor();
        
   
   }*/
  
}