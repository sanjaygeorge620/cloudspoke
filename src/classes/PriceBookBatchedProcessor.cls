/*
 * Class to batch up various parts of the Price Book creation process.
 * Instantiated by CreatePriceBooks.cls, originating when a user creates or
 * changes the status of a Price Book Maker record.
 *
 * This class does three things:
 *  1) Creates Core Price Books from Products, Sales Organizations and CurrencyRates
 *  2) Creates Published Price Books from Core Price Books and Price Book Definitions
 *  3) Updates Published Price Books' status to Archived
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-10-07
 */
global class PriceBookBatchedProcessor implements Database.Batchable<sObject> { 
    public String query;
    public Id priceBookMakerId;
    public Id lastPriceBookMaker;
    public String operation;
    public List<Account> accounts;
    public Boolean updateStatus = true; 
     
    /*
     * Constructor for a PriceBookBatchedProcessor without Accounts
     */
    public PriceBookBatchedProcessor(Id id, Boolean up, String op) {
        priceBookMakerId = id;
        Price_Book_Maker__c pbm = [select previous_price_book_maker__c from price_book_maker__c where id = :id];
        lastPriceBookMaker = pbm.Previous_Price_Book_Maker__c;
        operation = op;
        updateStatus = up;
    }
     
    /*
     * Constructor for a PriceBookBatchedProcessor with Accounts
     */
    public PriceBookBatchedProcessor(Id id, Boolean up, String op, List<Account> a) {
        this(id, up, op);
        accounts = a;
    }
    
    /* 
     * In order to use this batched class for both Core and Published Price Book creation
     * we need to alternate the resultset query based on the context.
     */
    public String deriveQueryFromStatus() {
        // Create Core Price Books
        if (operation == 'CreateCorePriceBooks') {
            return  'Select '+
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
                    '   and Exclude_from_Pricebook__c = false'+
                    '   and IS_Exclude_From_Price_Book__c = false';           //Added For US1833 Praveen
               
        } 
        // Create Published Price Books
        else if (operation == 'CreatePublishedPriceBooks') {
            // If we have a previous price book maker from which we should grab core
            // price books, use that instead
            Id idToUse = lastPriceBookMaker == null ? priceBookMakerId : lastPriceBookMaker;
            return 'Select '+
                   '    Id, '+
                   '    Child_Number__c, '+
                   '    CurrencyIsoCode, '+
                   '    End_Date__c, '+
                   '    Exclude_from_Quote_Process__c, '+
                   '    Fair_Market_Value__c, '+
                   '    Family__c, '+
                   '    Header_Number__c, '+
                   '    IsParent__c, '+
                   '    Line__c, '+
                   '    List_Price__c, '+
                   '    Model__c, '+
                   '    Model_Brand__c, '+
                   '    Parent_Product__c, '+
                   '    Part_Number__c, '+
                   '    Price_Type__c, '+
                   '    Pricing_ID__c, '+
                   '    Product__c, '+
                   '    Product_Brand__c, '+
                   '    Product_Name__c, '+
                   '    Product_Family__c,' + 
                   '    Sales_Organization__c, '+
                   '    Series__c, '+
                   '    Start_Date__c, '+
                   '    Tier_Minimum__c, '+
                   '    Tier_Pricing__c, '+
                   '    Uplift_Part_Number__c, '+
                   '    Uplift_Product__c, '+
                   '    product__r.Product_Model__c, '  +                                                   //jd PRJ001715 - need to pull back product model
                   '   Token_Type__c '+
                   'From '+
                   '    Core_Price_Book__c '+
                   'Where '+
                   '    Price_Book_Maker_ID__c = \''+idToUse+'\'';
        }
        else if (operation == 'CleanupPublishedPriceBooks') {
            String queryAppend = '';
            if (accounts != null && accounts.size() == 1) {
                queryAppend = ' and Account__c = \''+accounts.get(0).Id+'\'';
            }
            return 'Select '+
                   '    Id '+
                   'From '+
                   '    Published_Price_Book__c '+
                   'Where '+
                   '    Price_Book_Maker_ID__c != \''+priceBookMakerId+'\' and '+
                   '    Status__c = \'Active\''+queryAppend;
        }
        else {
            System.debug('Unknown operation: '+operation);
            return '';
        }
    }
    
    /* 
     * Begin the batched processing.
     */
    global Database.QueryLocator start(Database.BatchableContext BC){
        query = deriveQueryFromStatus();
        System.debug(' === Derived query: '+query);
        
        // Only store number of batches for Core Price Book creation process
        if (operation == 'CreateCorePriceBooks') {
            // initiate the Batch counting
            Price_Book_Batch__c batch = [select number__c from price_book_batch__c where name = 'Batch Number'];
            if (batch == null) {
                batch = new Price_Book_Batch__c();
                batch.Name = 'Batch Number';
                batch.Number__c = 1;
                insert batch;
            }
            else {
                batch.Number__c = 1;
                update batch;
            }
        }
        
        return Database.getQueryLocator(query);
    }
    
    /*
     * The execute function, pass through to the context sensitive version.
     */
    global void execute(Database.BatchableContext BC, List<SObject> scope){
        if (operation == 'CreateCorePriceBooks' && scope instanceof List<Product2>) {
            // "Increment" batch counter
            Price_Book_Batch__c batch = [select number__c from price_book_batch__c where name = 'Batch Number'];
            if (batch == null) {
                batch = new Price_Book_Batch__c();
                batch.Name = 'Batch Number';
                batch.Number__c = 100000;
                insert batch;
            }
            else {
                batch.Number__c += 100000;
                update batch;
            }

            scope = (List<Product2>)scope;
            insertCorePriceBooks(scope, batch.Number__c);
        }
        else if (operation == 'CreatePublishedPriceBooks' && scope instanceof List<Core_Price_Book__c>) {
            scope = (List<Core_Price_Book__c>)scope;
            insertPublishedPriceBooks(scope);
        }
        else if (operation == 'CleanupPublishedPriceBooks' && scope instanceof List<Published_Price_Book__c>) {
            scope = (List<Published_Price_Book__c>)scope;
            cleanupPublishedPriceBooks(scope);
        }
    }
    
    /*
     * Cleanup the published price books.
     */
    public void cleanupPublishedPriceBooks(List<Published_Price_Book__c> scope) {
        for (Published_Price_Book__c ppb : scope) {
            ppb.Status__c = 'Archived';
        }
        update scope;
    }
    
    /*
     * Insert Core Price Books, based on:
     *  * Sales Organizations (either those specified in Product Sales Org, or all Sales
     *    Organizations).
     *  * Currency Rates (standard USD specified value and any values set in Sales Org
     *    Currencies).
     *  * Products, and if Tier Pricing is set on the Product
     *  * Pricing records related to Products
     */     
    public void insertCorePriceBooks(List<Product2> scope, Decimal startNumber) {
        System.debug('Found '+scope.size()+' Product Materials which will be used to create price books');
        List<Core_Price_Book__c> priceBooks = new List<Core_Price_Book__c>();
        List<Id> productIds = new List<Id>();
        List<ID> ProductModelIds = new List<ID>();
        map<String, Pricing__c> PricingRecMap = new map<String, Pricing__c>();                  //01-16 jd - pricing rec per product and tier(map<ProductID - TierMinimum> , Pricing__c Record)
        map<String, Tier_Pricing_Override__c> tpoRecMap = new map<String, Tier_Pricing_Override__c>();
        Map<String, Tier_Pricing_Override__c> tpoRecMapForSMSA = new map<String, Tier_Pricing_Override__c>();
        map<ID, List<Pricing__c>> PricingRecListMap = new map<ID, List<Pricing__c>>();  //1-16 jd - this will create a map that will contain the products and a list of all the pricing records related.
        Decimal headerNumber = startNumber;
        
        // Grab the entire list of Active Sales Orgs 
        List<Sales_Organization__c> allSalesOrgs = [
                Select
                    Name,
                    CurrencyIsoCode,
                    Sales_Organization__c
                From
                    Sales_Organization__c
                Where
                    Status__c = 'Active'];
                    
        // Generate the mapping from Sales Org to Currency
        Map<Id, List<Currency_Rate__c>> salesOrgCurrencies = new Map<Id, List<Currency_Rate__c>>();
        List<Tier_Pricing_Override__c> TPOverideList = new List<Tier_Pricing_Override__c>();
        // initialize
        for (Sales_Organization__c salesOrg : [
                Select
                    Id
                From
                    Sales_Organization__c]) {
            // default US currency rate
            salesOrgCurrencies.put(salesOrg.Id, new List<Currency_Rate__c>());
        }
        for (Sales_Org_Currency__c salesOrgCurrency : [
                Select
                    Currency_Name__c,
                    Currency_Name__r.Rate__c,
                    Currency_Name__r.Name,
                    Currency_Name__r.CurrencyIsoCode,
                    Sales_Organization__c
                From
                    Sales_Org_Currency__c
                Where
                    Sales_Organization__r.Status__c = 'Active']) {
            Currency_Rate__c currencyRate = new Currency_Rate__c(Id=salesOrgCurrency.Currency_Name__c);
            currencyRate.Name = salesOrgCurrency.Currency_Name__r.Name;
            currencyRate.Rate__c = salesOrgCurrency.Currency_Name__r.Rate__c;
            currencyRate.CurrencyIsoCode = salesOrgCurrency.Currency_Name__r.CurrencyIsoCode;
            salesOrgCurrencies.get(salesOrgCurrency.Sales_Organization__c).add(currencyRate);
        }
        
        // Get everything we need for the products in this set
        List<Product2> products = [
                Select
                    BigMachines_Category__c,
                    Brand__c,
                    Cost__c,
                    End_Date__c,
                    Exclude_from_Quote_Process__c,
                    Fair__c,
                    Family,
                    Id,
                    Name,
                    Parent_Product__c,
                    Parent_Product__r.Product_Model__c,
                    Parent_Product__r.Cost__c,  
                    SMSA_Product__r.Product_Model__c,
                    SMSA_Product__r.Cost__c,
                    SMSA_Product__c,
                    Part_Number__c,
                    Price_Type__c,
                    Product_Model__r.Brand__c,
                    Product_Model__r.Model__c,
                    Product_Model__r.Series__c,
                    Product_Model__r.Line__c,
                    Product_Model__r.Family__c,
                    Product_Model__r.SMSA_Percent__c,
                    Start_Date__c,
                    Tier_Pricing__c,
                    Uplift_Part_Number__c,
                    Uplift_Product__r.Name,
                    Token_Type__c,
                    (
                        Select
                            Cost__c,
                            End_Date__c,
                            Fair_Market_Value__c,
                            Start_Date__c,
                            Tier_Minimum__c,
                            product_Name__r.cost__c,
                            product_Name__r.parent_Product__c,                  //1-16 jd - need to capture parentproduct as lookup
                            product_Name__r.family,                             //1-16 jd - need to capture family field
                            parent_product__c,                                  //1-16 jd - need to pull in parentproduct field from record
                            Type__c
                        From
                            Pricing__r )
                From
                    Product2
                Where
                    Id in :scope];
  
        List<ID> ParentproductIds = new List<ID>();                         ////1-16 jd - create a list of ids so that can pull the pricing records for any matches
        For (Product2 product : products){                                  //1-16 jd - add product ids to list so that know what to retrieve.
            ParentproductIds.add(product.Id);
            if(product.Parent_product__c != null){                          //1-16
                ParentproductIds.add(product.Parent_Product__c);        //1-16 jd
            }
        } 
        
        
        system.debug('ParentProductsIDs: ' + ParentproductIds);             //1-16 jd
        List<Pricing__c> ParentProductList = new List<Pricing__c>([Select
                            Cost__c,
                            End_Date__c,
                            Fair_Market_Value__c,
                            Start_Date__c,
                            Tier_Minimum__c,
                            product_Name__r.cost__c,
                            product_Name__r.parent_Product__c,                  //1-16 jd - 
                            product_Name__r.family,                             //1-16 jd - need to capture family field
                            parent_product__c,                                  //1-16 jd - need to pull in parentproduct field from record
                            Type__c,
                            CurrencyIsoCode
                        From
                            Pricing__c  
                        where product_name__c  in :ParentProductIDs ]) ;     
            
        for (Product2 product : products) {
            productIds.add(product.Id);
            system.debug('Product.Parent_Product__c:' + Product.Parent_Product__c);
            if (product.Parent_Product__c != null){
                if (product.Parent_Product__r.Product_Model__c != null){
                    productModelIds.add(product.Parent_Product__r.Product_Model__c);
                }
                //Arun - Adding Parent Product
                productIds.add(product.Parent_Product__c);
            }
            if (product.Product_Model__c != null){
                ProductModelIds.add(product.Product_Model__c);
            }
        }
        Set<Id> pricIdSet = new Set<Id>();
        System.debug('-----------356-------------ParentProductList:'+ParentProductList);
          //1-16 jd - put the information retrived for the parent products pricing into the map
            for (Pricing__c pricingRec : ParentProductList){
                pricIdSet.add(pricingRec.Id);
                PricingRecMap.put(pricingRec.product_Name__c + '-' + pricingRec.Tier_Minimum__c, pricingRec);           //1-16 jd - this creates a map of product id & tier minimum
                system.debug('pricingRec.id - pricingRec.Tier_Minimum__c:' + pricingRec.product_Name__c + '-' + pricingRec.Tier_Minimum__c);    
                boolean productkeyfound;                                                    //1-16 jd/
                if (PricingRecMap.size() > 0){                                              //1-16 jd - check to see if the Existing pricing Contains anything
                    productkeyfound = PricingReclistMap.containsKey(pricingRec.product_Name__c);                //1-16 jd - does the existing pricing map have the keyset of the new pricing record             
                }else{                                                                      //1-16 jd
                    productkeyfound = false;                                                //1-16 jd
                }
                system.debug('productkeyfound: ' + productkeyfound);                        //1-16 jd - does the map have a keyset matching the pricingRecFound?
                List<Pricing__c> tmpPricingList = new List<Pricing__c>();                   //1-16 jd - create a tmpList to hold list returned
                
                if (productkeyfound){                                                       //1-16 jd
                    tmpPricingList = PricingReclistMap.get(pricingRec.product_Name__c);                         //1-16 jd - get list from Existing pricing
                }   
                system.debug('parent pricing rec:' + pricingRec);
                tmpPricingList.add(pricingRec);                                             //1-16 jd
                
                PricingReclistMap.put(pricingRec.product_Name__c,tmpPricingList);                               //1-16 jd
                system.debug('PricingReclistMap: ' + PricingReclistMap);                            //1-16 jd
            }
        System.debug('---------------------------380......pricIdSet:'+pricIdSet);
       TPOverideList = new List<Tier_Pricing_Override__c>([Select
                            Exception_Value__c,
                            IsActive__c,
                            currencyISOCode,
                            Price_Book_Currency_Override__c,
                            Price_Book_Currency_Override__r.CurrencyIsoCode,
                            PricingRecord__c,
                            PricingRecord__r.currencyisocode,
                            PricingRecord__r.Id,
                            PricingRecord__r.Product_Name__c,
                            Pricing_Record_Tier_Minimum__c,
                            Product_Name__c,                       
                            Price_Book_Currency_Override__r.Id,
                            Price_Book_Currency_Override__r.Sales_Organization__c,
                            Price_Book_Currency_Override__r.Type__c,
                            Price_Book_Currency_Override__r.Override_Price__c
                                                                                
                        From
                            Tier_Pricing_Override__c  
                        where IsActive__c = true and PricingRecord__c  in :pricIdSet]) ;
                        System.debug('-------------------394----------------------TPOverideList:'+TPOverideList );
        for(Tier_Pricing_Override__c tpo: TPOverideList) {          
            tpoRecMap.put(tpo.PricingRecord__r.Id + '-' +tpo.Price_Book_Currency_Override__r.CurrencyIsoCode, tpo);
            tpoRecMapForSMSA.put(tpo.PricingRecord__r.Id + '-' + tpo.PricingRecord__r.currencyisocode + '-' +tpo.Pricing_Record_Tier_Minimum__c, tpo);
            System.debug('--------------------------397------tpo:'+tpo);
        }
        
        System.debug('----------------------------tpoRecMap:'+tpoRecMap);
        system.debug('ProductModelIds:' + ProductModelIds);
        //get all product model information related to product models on the product records
        List<Product_Model__c> ProductModelList = new List<Product_Model__c>([Select  SMSA_Percent__c
                                                                                    , Name
                                                                                    , Id 
                                                                                    From Product_Model__c p
                                                                                    where id in :productModelIds and SMSA_Percent__c <> null ]);
          
        //build a map of product model information
        system.debug('ProductModelList:' + ProductModelList); 
        Map<ID, Product_Model__c> ProductModelMap = new Map<Id, Product_Model__c>();
        For (Product_Model__c productModelRec : ProductModelList){
            //if doesn't contain productModelId, then add
            If(!(productModelMap.containsKey(ProductModelRec.id))){
                ProductModelMap.put(ProductModelRec.id, ProductModelRec);
            }
        }
        system.debug('ProductModelMap:' + productModelMap);
        // Build a map of Material ID => Sales Orgs, initialize it 
        Map<Id, List<Sales_Organization__c>> orgMap = new Map<Id, List<Sales_Organization__c>>();
        for (Id id : productIds) {
            orgMap.put(id, new List<Sales_Organization__c>());
        }
        
        // Get the applicable Product Sales Orgs
        for (Product_Sales_Org__c salesOrg : [
                Select
                    Product_Name__r.Id,
                    Sales_Organization__r.Id,
                    Sales_Organization__r.CurrencyIsoCode,
                    Sales_Organization__r.Name,
                    Sales_Organization__r.Sales_Organization__c
                From
                    Product_Sales_Org__c
                Where
                    Product_Name__c in :productIds]) {
            Sales_Organization__c org = new Sales_Organization__c(id=salesOrg.Sales_Organization__r.Id);
            org.Name = salesOrg.Sales_Organization__r.Name;
            org.Sales_Organization__c = salesOrg.Sales_Organization__r.Sales_Organization__c;
            org.CurrencyIsoCode = salesOrg.Sales_Organization__r.CurrencyIsoCode; 
            orgMap.get(salesOrg.Product_Name__r.Id).add(org);
        }
        
        //5/20/2012 - get all applicable currency Override
        map<String, Price_Book_Currency_Override__c> OverrideMap = new map<String, Price_Book_Currency_Override__c>();  //jd 5/20/2012 PRJ002142
        list<id>CurrencyProductIds = new List<id>();                                                                    //jd 5/20/2012 PRJ002142
        CurrencyProductIds.addAll(productIds);                                                                          //jd 5/20/2012 PRJ002142
        CurrencyProductIds.addAll(ParentproductIds);                                                                    //jd 5/20/2012 PRJ002142
        Set<Id> overrideIdSet = new Set<Id>();
        for (Price_Book_Currency_Override__c overrideRec : [                                                            //jd 5/20/2012 PRJ002142
                    Select                                                                                              //jd 5/20/2012 PRJ002142
                        Override_Price__c                                                                               //jd 5/20/2012 PRJ002142
                        , Product__c 
                        , IsActive__c                                                                                   //jd 5/20/2012 PRJ002142
                        , Type__c                                                                                       //jd 5/20/2012 PRJ002142
                        , CurrencyIsoCode                                                                               //jd 5/20/2012 PRJ002142
                    from Price_Book_Currency_Override__c                                                                //jd 5/20/2012 PRJ002142
                    where                                                                                               //jd 5/20/2012 PRJ002142
                        Product__c in :productIds                                                                       //jd 5/20/2012 PRJ002142
                        and IsActive__c = true]){                                               //jd 5/20/2012 PRJ002142
       //populate map based on string(product-currency), pricebook currency override record                             //jd 5/20/2012 PRJ002142
            OverrideMap.put(overrideRec.Product__c + '-' + overrideRec.CurrencyIsoCode, overrideRec);                   //jd 5/20/2012 PRJ002142
            overrideIdSet.add(overrideRec.Id);
         }                                                                                                              //jd 5/20/2012 PRJ002142
        
        //-------------------------Arun Start
        if(!overrideIdSet.isEmpty()) {
            TPOverideList = new List<Tier_Pricing_Override__c>([Select
                                Exception_Value__c,
                                IsActive__c,
                                currencyISOCode,
                                Price_Book_Currency_Override__c,
                                Price_Book_Currency_Override__r.Id,
                                Price_Book_Currency_Override__r.CurrencyIsoCode,
                                Price_Book_Currency_Override__r.Sales_Organization__c,
                                Price_Book_Currency_Override__r.Type__c,
                                Price_Book_Currency_Override__r.Override_Price__c,
                                PricingRecord__c,
                                PricingRecord__r.currencyisocode,
                                PricingRecord__r.Id,
                                Pricing_Record_Tier_Minimum__c,
                                Product_Name__c                     
                            From
                                Tier_Pricing_Override__c  
                            where IsActive__c = true and Price_Book_Currency_Override__c in :overrideIdSet]) ;
                            System.debug('-------------------480----------------------TPOverideList:'+TPOverideList );
            for(Tier_Pricing_Override__c tpo: TPOverideList) {          
                tpoRecMap.put(tpo.PricingRecord__r.Id + '-' +tpo.Price_Book_Currency_Override__r.Id + '-' +tpo.Price_Book_Currency_Override__r.CurrencyIsoCode, tpo);
                System.debug('--------------------------484------tpo:'+tpo);
            }
        }
        //-------------------------Arun End
        // For the empty lists, put in the full Sales Org list 
        for (Id id : productIds) {
            if (orgMap.get(id).size() == 0) {
                orgMap.put(id, allSalesOrgs);
            }
        }

        for (Product2 product : products) {
            for (Sales_Organization__c org : orgMap.get(product.Id)) {              
                // create an additional price book for each Currency_Rate as well
                system.debug('product id:' + product.id);
                for (Currency_Rate__c currencyRate : salesOrgCurrencies.get(org.Id)) {
                    Integer childNumber = 1;
                    headerNumber++;
                     
                    // Create the product specific Core Price Books         
                    Core_Price_Book__c priceBook =              new Core_Price_Book__c();
                    priceBook.Category__c =                     product.BigMachines_Category__c;
                    priceBook.Child_Number__c =                 '';
                    priceBook.CurrencyIsoCode =                 currencyRate.CurrencyIsoCode;
                    priceBook.End_Date__c =                     product.End_Date__c;
                    priceBook.Exclude_from_Quote_Process__c =   product.Exclude_from_Quote_Process__c;
                    priceBook.Family__c =                       product.Product_Model__r.Family__c;
                    priceBook.Fair_Market_Value__c =            product.Fair__c == null ? 0 : product.Fair__c*currencyRate.Rate__c;
                    priceBook.Header_Number__c =                headerNumber;
                    priceBook.IsParent__c =                     true;
                    priceBook.Line__c =                         product.Product_Model__r.Line__c;
                    System.debug('----------491------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                    if(product.Part_Number__c == 'PER0468'){
                        priceBook.List_Price__c =               product.Cost__c;
                    }else{
                        system.debug('Product.Family:' + Product.Family);
                        if(product.Cost__c == null){                                                                                            //jd 5/20/2012 PRJ002142
                                priceBook.List_Price__c = 0;                                                                                        //jd 5/20/2012 PRJ002142
                            }else{                                                                                                                  //jd 5/20/2012 PRJ002142
                                if (OverrideMap.containsKey(product.id + '-' + currencyRate.CurrencyIsoCode) == true){                              //jd 5/20/2012 PRJ002142
                                    //priceBook.List_Price__c = OverrideMap.get(product.id + '-' + currencyRate.CurrencyIsoCode).Override_Price__c;   //jd 5/20/2012 PRJ002142
                                    priceBook.List_Price__c = (OverrideMap.get(product.id + '-' + currencyRate.CurrencyIsoCode).Override_Price__c);
                                    System.debug('----------502 a------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                }else  {                                                                                                             //jd 5/20/2012 PRJ002142
                                    priceBook.List_Price__c = product.Cost__c*currencyRate.Rate__c;
                                    priceBook.List_Price__c = GetRoundedValue(priceBook.List_Price__c);                                                 //jd 5/20/2012 PRJ002142
                                System.debug('----------505 a------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                }
                            } 
                        if(Product.Family != 'SMSA'){
                        // Arun - Commented and moved to up
                              /*  if(product.Cost__c == null){                                                                                            //jd 5/20/2012 PRJ002142
                                    priceBook.List_Price__c = 0;                                                                                        //jd 5/20/2012 PRJ002142
                                }else{                                                                                                                  //jd 5/20/2012 PRJ002142
                                    if (OverrideMap.containsKey(product.id + '-' + currencyRate.CurrencyIsoCode) == true){                              //jd 5/20/2012 PRJ002142
                                        priceBook.List_Price__c = OverrideMap.get(product.id + '-' + currencyRate.CurrencyIsoCode).Override_Price__c;   //jd 5/20/2012 PRJ002142
                                    System.debug('----------502 a------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                    }else  {                                                                                                             //jd 5/20/2012 PRJ002142
                                        priceBook.List_Price__c = product.Cost__c*currencyRate.Rate__c; 
                                        priceBook.List_Price__c = GetRoundedValue(priceBook.List_Price__c);                                                //jd 5/20/2012 PRJ002142
                                    System.debug('----------505 a------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                    }
                                }   */                                                                                                                    //jd 5/20/2012 PRJ002142
                     //       priceBook.List_Price__c =           product.Cost__c == null ? 0 : product.Cost__c*currencyRate.Rate__c;                   //jd 5/20/2012 PRJ002142 - remove old line
                        System.debug('----------506 a------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                        }else{
                        System.debug('----------506------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c); 
                            system.debug('product.Cost__c: ' + product.Cost__c);
                            if(product.Cost__c == null){
                                priceBook.List_Price__c = 0;
                            }else{
                                Decimal ProductModelSMSAPercent = 0;       //set variable to pull back SMSA percentage
                                system.debug('size of map');
                                system.debug('ProductModelMap.size:' + ProductModelMap.size());
                                If(ProductModelMap.size()>0){
                                    system.debug('Product.Parent_Product__c: '+ Product.Parent_Product__c); 
                                    If(Product.Parent_Product__c != null){     //check parentProductModel first
                                        //get parent product model SMSA percent
                                        system.debug('product.Parent_Product__r.Product_Model__c:' + product.Parent_Product__r.Product_Model__c);
                                        If(ProductModelMap.containsKey(product.Parent_Product__r.Product_Model__c)){
                                            ProductModelSMSAPercent = ProductModelMap.get(product.Parent_Product__r.Product_Model__c).SMSA_Percent__c;
                                            system.debug('parentproduct - productmodelsmsaPercent:' + ProductModelSMSAPercent);
                                        }
                                    }
                                    // if parent product model is blank, then use smsa product model
                                    system.debug('ProductModelSMSAPercent:'+ ProductModelSMSAPercent);
                                    if (ProductModelSMSAPercent == 0 || ProductModelSMSAPercent == null){
                                        system.debug('product.Product_Model__c:' + product.Product_Model__c);
                                        If(ProductModelMap.containsKey(product.Product_Model__c)){
                                            system.debug('inside product model');
                                            system.debug('ProductModelMap:'+productModelMap);
                                            ProductModelSMSAPercent = ProductModelMap.get(product.Product_Model__c).SMSA_Percent__c;
                                            system.debug('SMSAProduct - productmodelsmsaPercent:' + ProductModelSMSAPercent);
                                    
                                        }
                                    }
                                }
                                System.debug('----------536------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c); 
                                system.debug('right bfore listprice)');
                                system.debug('pricebook.List_Price__c:' + pricebook.List_Price__c);
                                List<Tier_Pricing_Override__c> newTpoList = new List<Tier_Pricing_Override__c>();
                                List<Price_Book_Currency_Override__c> newPBCOChildList = new List<Price_Book_Currency_Override__c>();
                                if (product.Parent_Product__c!=null){
                                    //priceBook.List_Price__c = product.Parent_Product__r.Cost__c*currencyRate.Rate__c;
                                    if (OverrideMap.containsKey(product.Parent_Product__c + '-' + currencyRate.CurrencyIsoCode) == true){                               //jd 5/20/2012 PRJ002142
                                        
                                        priceBook.List_Price__c = (OverrideMap.get(product.Parent_Product__c + '-' + currencyRate.CurrencyIsoCode).Override_Price__c);    //jd 5/20/2012 PRJ002142
                                        //priceBook.List_Price__c = (OverrideMap.get(product.Parent_Product__c + '-' + currencyRate.CurrencyIsoCode).Override_Price__c);
                                        System.debug('----------------------587------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                        List<Pricing__c> childPriceList = PricingReclistMap.get(product.Id);
                                        List<Pricing__c> parentPriceList = PricingReclistMap.get(product.Parent_Product__c);
                                        if(childPriceList != null && parentPriceList != null) {
                                            for(Pricing__c pricChild: childPriceList) {
                                                for(Pricing__c pricParent: parentPriceList) {
                                                    if(pricChild.currencyisocode == pricParent.currencyisocode && 
                                                        pricChild.Tier_Minimum__c == pricParent.Tier_Minimum__c) {
                                                        Tier_Pricing_Override__c tpoChild = tpoRecMapForSMSA.get(pricChild.Id + '-' + pricChild.currencyisocode + '-' +pricChild.Tier_Minimum__c);
                                                        Tier_Pricing_Override__c tpoParent = tpoRecMapForSMSA.get(pricParent.Id + '-' + pricParent.currencyisocode + '-' +pricParent.Tier_Minimum__c);
                                                        if(tpoChild == null && tpoParent != null) {
                                                        
                                                            Price_Book_Currency_Override__c newPBCOChild = new Price_Book_Currency_Override__c();
                                                            newPBCOChild.Include_In_Standard_Price_Books__c = true;
                                                            newPBCOChild.IsActive__c = true;
                                                            newPBCOChild.Override_Price__c= tpoParent.Price_Book_Currency_Override__r.Override_Price__c ;
                                                            newPBCOChild.Sales_Organization__c = tpoParent.Price_Book_Currency_Override__r.Sales_Organization__c ;
                                                            newPBCOChild.Type__c = tpoParent.Price_Book_Currency_Override__r.Type__c ;
                                                            newPBCOChild.Product__c = pricChild.Product_Name__c;
                                                            newPBCOChildList.add(newPBCOChild);
                                                            
                                                            Tier_Pricing_Override__c newTpoChild = new Tier_Pricing_Override__c();
                                                            newTpoChild.isActive__c= true;
                                                            newTpoChild.currencyISOCode = tpoParent.currencyISOCode ;
                                                            newTpoChild.PricingRecord__c= pricChild.Id;
                                                            newTpoChild.Exception_Value__c = tpoParent.Exception_Value__c;
                                                            //tpoChild.Exception_Value__c = tpoParent.Exception_Value__c;
                                                            newTpoList.add(newTpoChild);
                                                        }
                                                    }
                                                }    
                                            }
                                            if(!newPBCOChildList.isEmpty()) {
                                                insert newPBCOChildList;
                                                for(Integer ind=0;ind<newPBCOChildList.size(); ind++) {
                                                    newTpoList[ind].Price_Book_Currency_Override__c = newPBCOChildList[ind].Id;
                                                }
                                                if(!newTpoList.isEmpty()) {
                                                    insert newTpoList;
                                                }
                                            }
                                        }
                                    }else{                                                                                                              //jd 5/20/2012 PRJ002142
                                        //priceBook.List_Price__c = product.Cost__c*currencyRate.Rate__c;
                                        priceBook.List_Price__c = product.Parent_Product__r.Cost__c*currencyRate.Rate__c;
                                        priceBook.List_Price__c = GetRoundedValue(priceBook.List_Price__c);
                                        System.debug('------590----------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);             //jd 5/20/2012 PRJ002142
                                    }
                                    system.debug('priceBook.List_Price__c - after currency rate: ' + pricebook.List_Price__c);
                                    system.debug('ProductModelSMSAPercent - after listprice:' +ProductModelSMSAPercent);
                                    if(ProductModelSMSAPercent != null){
                                        If (ProductModelSMSAPercent != 0 ){
                                            pricebook.List_Price__c = (PriceBook.List_Price__c * (ProductModelSMSAPercent/100));
                                            System.debug('--------597--------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                        } 
                                    }
                                }else{
                                System.debug('----------554------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c); 
                                    //priceBook.List_Price__c = product.Cost__c*currencyRate.Rate__c;
                                    if (OverrideMap.containsKey(product.id + '-' + currencyRate.CurrencyIsoCode) == true){                              //jd 5/20/2012 PRJ002142
                                        priceBook.List_Price__c = (OverrideMap.get(product.id + '-' + currencyRate.CurrencyIsoCode).Override_Price__c)/0.2;   //jd 5/20/2012 PRJ002142
                                        System.debug('----------605------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                    }else {                                                                                                              //jd 5/20/2012 PRJ002142
                                        priceBook.List_Price__c = product.Cost__c*currencyRate.Rate__c; 
                                        priceBook.List_Price__c = GetRoundedValue(priceBook.List_Price__c);                                                //jd 5/20/2012 PRJ002142
                                        System.debug('-------608---------------------------priceBook.List_Price__c:'+priceBook.List_Price__c);
                                    }    
                                }
                            
                                system.debug('priceBook.List_Price__c - after percent: ' + pricebook.List_Price__c);
                            }
                        }
                    }  
                    System.debug('----------564------------------------------priceBook.List_Price__c:'+priceBook.List_Price__c); 
                    priceBook.Model__c =                        product.Product_Model__r.Model__c;
                    priceBook.Model_Brand__c =                  product.Product_Model__r.Brand__c;
                    priceBook.Parent_Product__c =               product.Parent_Product__c;
                    priceBook.Part_Number__c =                  product.Part_Number__c;
                    priceBook.Price_Book_Maker_ID__c =          priceBookMakerId;
                    priceBook.Price_Type__c =                   product.Price_Type__c;
                    priceBook.Product__c =                      product.Id;
                    priceBook.Product_Brand__c =                product.Brand__c;
                    priceBook.Product_Family__c =               product.Family;
                    priceBook.Product_Name__c =                 product.Name;
                    priceBook.Sales_Organization__c =           org.Sales_Organization__c;
                    priceBook.Series__c =                       product.Product_Model__r.Series__c;
                    priceBook.Start_Date__c =                   product.Start_Date__c;
                    priceBook.Tier_Minimum__c =                 1;
                    priceBook.Tier_Pricing__c =                 product.Tier_Pricing__c;
                    priceBook.Uplift_Part_Number__c =           product.Uplift_Part_Number__c;
                    priceBook.Uplift_Product__c =               product.Uplift_Product__r.Name;
                    pricebook.Token_Type__c =                   product.Token_Type__c;
                                        
                    priceBooks.add(priceBook);
                    system.debug('product pricing list:' + product.pricing__r);
                    for (Pricing__c pricing : product.Pricing__r) {
                        system.debug('inpricing loop - pricing rec: ' + pricing);
                        if (pricing.tier_Minimum__c >= 1){
                                priceBook =                                 new Core_Price_Book__c();
                                priceBook.Price_Book_Maker_ID__c =          priceBookMakerId;
                                priceBook.Category__c =                     product.BigMachines_Category__c;
                                priceBook.Child_Number__c =                 childNumber.format();
                                priceBook.CurrencyIsoCode =                 currencyRate.CurrencyIsoCode;
                                priceBook.End_Date__c =                     product.End_Date__c;      
                                priceBook.Exclude_from_Quote_Process__c =   product.Exclude_from_Quote_Process__c;          
                                priceBook.Fair_Market_Value__c =            pricing.Fair_Market_Value__c*currencyRate.Rate__c;
                                priceBook.Family__c =                       product.Product_Model__r.Family__c;
                                priceBook.Header_Number__c =                headerNumber;
                                priceBook.IsParent__c =                     false;
                                priceBook.Line__c =                         product.Product_Model__r.Line__c;
                               // priceBook.List_Price__c =                   pricing.Cost__c*currencyRate.Rate__c;
                                if(product.Part_Number__c == 'PER0468'){
                                     priceBook.List_Price__c =              pricing.Cost__c;
                                }else{
                                  system.debug('product.family:' + product.family);  
                                  if(Product.Family != 'SMSA'){
                                    priceBook.List_Price__c =  pricing.Cost__c == null ? 0 : pricing.Cost__c*currencyRate.Rate__c;
                                    priceBook.List_Price__c = GetRoundedValue(priceBook.List_Price__c);
                                    if (OverrideMap.containsKey(product.id + '-' + currencyRate.CurrencyIsoCode) == true){                              //jd 5/20/2012 PRJ002142
                                        Price_Book_Currency_Override__c pbco = OverrideMap.get(product.id + '-' + currencyRate.CurrencyIsoCode);
                                        Tier_Pricing_Override__c tpo = tpoRecMap.get(pricing.Id + '-' +pbco.Id + '-' +currencyRate.CurrencyIsoCode);
                                        if(tpo != null && tpo.Exception_Value__c != null && tpo.Exception_Value__c > 0) {                                            
                                            //priceBook.List_Price__c = tpo.Exception_Value__c;
                                            priceBook.List_Price__c = tpo.Exception_Value__c;
                                        }
                                    }
                                    //else                                                                                                               //jd 5/20/2012 PRJ002142
                                    //    priceBook.List_Price__c =           pricing.Cost__c == null ? 0 : pricing.Cost__c*currencyRate.Rate__c;
                                    
                                  System.debug('--------------------------------------616 priceBook.List_Price__c:'+priceBook.List_Price__c);
                                  }else{
                                    system.debug('pricing.Cost__c: ' + pricing.Cost__c);
                                    if(pricing.Cost__c == null){
                                        priceBook.List_Price__c = 0;
                                    }else{
                                        Decimal ProductModelSMSAPercent = 0;       //set variable to pull back SMSA percentage
                                        system.debug('Product.Parent_Product__c: '+ Product.Parent_Product__c); 
                                        If(ProductMOdelMap.size()>0){
                                            If(Product.Parent_Product__c != null){     //check parentProductModel first
                                                //get parent product model SMSA percent
                                                system.debug('product.Parent_Product__r.Product_Model__c:' + product.Parent_Product__r.Product_Model__c);
                                                If(ProductModelMap.containsKey(product.Parent_Product__r.Product_Model__c)){
                                                    ProductModelSMSAPercent = ProductModelMap.get(product.Parent_Product__r.Product_Model__c).SMSA_Percent__c;
                                                    system.debug('parentproduct - productmodelsmsaPercent:' + ProductModelSMSAPercent);
                                                }
                                            }
                                            // if parent product model is blank, then use smsa product model
                                            system.debug('ProductModelSMSAPercent:'+ ProductModelSMSAPercent);
                                            if (ProductModelSMSAPercent == 0|| ProductModelSMSAPercent == null){
                                                system.debug('product.Product_Model__c:' + product.Product_Model__c);
                                                If(ProductModelMap.containsKey(product.Product_Model__c)){
                                                    ProductModelSMSAPercent = ProductModelMap.get(product.Product_Model__c).SMSA_Percent__c;
                                                    system.debug('SMSAProduct - productmodelsmsaPercent:' + ProductModelSMSAPercent);
                                                }
                                            }
                                        }
                                        system.debug('Pricing.product_Name__c: '+ Pricing.product_Name__c);                                                             //1-16 jd
                                        If(Pricing.Product_Name__c != null){
                                            
                                            //priceBook.List_Price__c = pricing.Product_Name__r.Cost__c*currencyRate.Rate__c;                                           //1-16 jd - old code that calculates the SMSA price instead of the parent product price
                                            //get parent product's tier pricing record that matches tier minimum from the pricing record                                //1-16 jd 
                                            system.debug('PricingRecMap'+PricingRecMap);                                                                                //1-16 jd
                                            system.debug('pricing:' + pricing);                                                                                         //1-16 jd
                                            system.debug('parentPricingkey:' + pricing.product_Name__r.parent_Product__c + '-'+ pricing.Tier_Minimum__c);                   //1-16 jd
                                            if (PricingRecMap.containsKey(pricing.product_Name__r.parent_Product__c + '-'+ pricing.Tier_Minimum__c)){                       //1-16 jd                                                                       //1-16 jd - check to see if find a record that exactly matches the tier minimum
                                                Pricing__c parentpricingRec = PricingRecMap.get(pricing.product_Name__r.parent_Product__c + '-'+ pricing.Tier_Minimum__c);  //1-16 jd - get the pricing record that matches the SMSA parent product
                                                system.debug('parentpricingrec: ' + parentpricingrec);                                                                  //1-16 jd
                                                priceBook.List_Price__c = parentpricingRec.Cost__c;
                                                System.debug('-------------654-------------------------------------------tpoRecMap:'+tpoRecMap);
                                                System.debug('--------------------------------------------------------parentpricingRec:'+parentpricingRec);
                                                if(tpoRecMap.get(parentpricingRec.Id + '-' + parentpricingRec.CurrencyIsoCode) != null) {
                                                    Tier_Pricing_Override__c tpo = tpoRecMap.get(parentpricingRec.Id + '-' + parentpricingRec.CurrencyIsoCode);
                                                    if(tpo.Exception_Value__c != null && tpo.Exception_Value__c > 0) {
                                                        //priceBook.List_Price__c = tpo.Exception_Value__c;
                                                        priceBook.List_Price__c = (tpo.Exception_Value__c)/0.2;
                                                    }
                                                }                                                                  
                                            }else{                                                                                                                      //1-16 jd - if doesn't find a match then not exact record
                                                 //get all pricing records for parent product.                                                                          //1-16 jd
                                                 system.debug('PricingRecListMap'+PricingRecListMap);                                                                   //1-16 jd
                                                 system.debug('pricing.product_Name__r.parent_Product__c:' + pricing.product_Name__r.parent_Product__c);                //1-16 jd
                                                 List<Pricing__c> ParentPricingList = PricingRecListMap.get(pricing.product_Name__r.parent_Product__c);                 //1-16 jd                                   //1-16 jd
                                                 system.debug(parentpricinglist);                                                                                       //1-16 jd
                                                 Pricing__c TierPriceRec;                                                                                               //1-16 jd - create tier pricing hold record
                                                 if(ParentPricingList != null) {
                                                     for (Pricing__c priceRec : ParentPricingList){                                                                         //1-16 jd - filter through each pricing record to get closest without going over
                                                        system.debug('priceRec:' + priceRec);
        
                                                        if (TierPriceRec == null){                                                                                          //1-16 jd - if tierpricing hold record is blank, fill in starting value
                                                            system.debug('determine tierpricerec - priceRec.Tier_Minimum__c: ' + priceRec.Tier_Minimum__c);                 //1-16 jd
                                                            system.debug('determine tierpricerec - pricing.Tier_Minimum__c: ' + pricing.Tier_Minimum__c);                       //1-16 jd
                                                                if(priceRec.Tier_Minimum__c <= pricing.Tier_Minimum__c ){                                                       //1-16 jd
                                                                    TierPriceRec = priceRec;                                                                                    //1-16 jd   
                                                                }                                                                                                               //1-16 jd
                                                                                                                                                                                //1-16 jd
                                                        }else{
                                                            if(TierPriceRec.Tier_Minimum__c < priceRec.Tier_Minimum__c && priceRec.Tier_Minimum__c < pricing.Tier_Minimum__c){  //1-16 jd - get the product tier_minimum__c that is closest to the pricing tier miminum w/o going over
                                                                TierPriceRec = priceRec;                                                                                        //1-16 jd
                                                            }                                                                                                                   //1-16 jd
                                                        }                                                                                                                       //1-16 jd
                                                        system.debug('tierpricerec:' + tierpricerec);                                                                           //1-16 jd   
                                                        
                                                     } 
                                                 }                                                                                                                         //1-16 jd
                                                 if(tierpricerec != null){
                                                    priceBook.list_Price__c = tierpricerec.Cost__c;                                                                         //1-16 jd
                                                 System.debug('------------------------687:'+priceBook.list_Price__c);
                                                 }else{                                                                                                                     //1-16 jd
                                                    priceBook.list_Price__c = product.parent_product__r.cost__c;                                                        //1-16 jd
                                                 System.debug('------------------------690:'+priceBook.list_Price__c);
                                                 }                                                                                                                          //1-16 jd
                                            }                                                                                                                               //1-16 jd
                                            System.debug('------------------------693:'+priceBook.list_Price__c);
                                            priceBook.List_Price__c = priceBook.list_Price__c*currencyRate.Rate__c; 
                                            priceBook.List_Price__c = GetRoundedValue(priceBook.List_Price__c);                                                        //1-16 jd                                                                                                                   //1-16 jd
                                            System.debug('------------------------694:'+priceBook.list_Price__c);
                                            system.debug('priceBook.List_Price__c - after currency rate: ' + pricebook.List_Price__c);                                      //1-16 jd
                                            system.debug('ProductModelSMSAPercent - after listprice:' +ProductModelSMSAPercent);                                            //1-16 jd
                                                                                        //1-16 jd - no need to calculate
                                            if(ProductModelSMSAPercent != null){                                                                                            //1-16 jd
                                              If (ProductModelSMSAPercent != 0 ){                                                                                       //1-16 jd
                                                  pricebook.List_Price__c = (PriceBook.List_Price__c * (ProductModelSMSAPercent/100));                                  //1-16 jd
                                                }                                                                                                                       //1-16 jd
                                            }                                                                                                                               //1-16 jd
                                        }else{
                                            priceBook.List_Price__c = pricing.Cost__c*currencyRate.Rate__c;
                                            priceBook.List_Price__c = GetRoundedValue(priceBook.List_Price__c);
                                        System.debug('------------------------704:'+priceBook.list_Price__c);
                                        }
                                        system.debug('priceBook.List_Price__c - after percent: ' + pricebook.List_Price__c);
                                    }
                                  }
                                }
                                priceBook.Model__c =                        product.Product_Model__r.Model__c;
                                priceBook.Model_Brand__c =                  product.Product_Model__r.Brand__c;
                                priceBook.Parent_Product__c =               product.Parent_Product__c;
                                priceBook.Part_Number__c =                  product.Part_Number__c;
                                priceBook.Price_Type__c =                   pricing.Type__c;
                                priceBook.Pricing_ID__c =                   pricing.Id;                     
                                priceBook.Product__c =                      product.Id;
                                priceBook.Product_Brand__c =                product.Brand__c;
                                priceBook.Product_Family__c =               product.Family;
                                priceBook.Product_Name__c =                 product.Name;
                                priceBook.Sales_Organization__c =           org.Sales_Organization__c;
                                priceBook.Series__c =                       product.Product_Model__r.Series__c;
                                priceBook.Start_Date__c =                   product.Start_Date__c;
                                priceBook.Tier_Minimum__c =                 pricing.Tier_Minimum__c;
                                priceBook.Tier_Pricing__c =                 product.Tier_Pricing__c;
                                priceBook.Uplift_Part_Number__c =           product.Uplift_Part_Number__c;
                                priceBook.Uplift_Product__c =               product.Uplift_Product__r.Name;
                                pricebook.Token_Type__c =                   product.Token_Type__c;
        
                                childNumber++;
    
                            priceBooks.add(priceBook);
                        }
                    }
                }
            }
        }
        System.debug('---------------------------------------priceBooks:'+priceBooks);
        //insert priceBooks;
        Database.insert(priceBooks);
    }

    /*
     * Insert Published Price Books, based on:
     *  * Price Book Definitions, and
     *  * Previously created Core Price Books
     * We also need to scour all Accounts that have a custom Price Book Definition set, 
     * and create Published Price Books based for these Accounts, based on the specified
     * definition values.
     */
    public void insertPublishedPriceBooks(List<Core_Price_Book__c> scope) {
        List<Price_Book_Definition__c> priceBookDefinitions;
        Map<Id,Set<Account>> priceBookDefToAccountMap = new Map<Id,Set<Account>>();
        Map<String, Exception_Discount__c> priceBookDefExcDisc = new Map<String, Exception_Discount__c> ();         //12-22 jd PRJ001715: exception discounts record by uniquekey - price book def id + productModel or price book def id + product
        Map<String, Price_Book_Include__c> priceBookDefInclude= new Map<String, Price_Book_Include__c> ();          //12-22 jd PRJ001715: include record by uniquekey - price book def id + productModel or price book def id + product
        Map<String, Price_Book_Exclude__c> priceBookDefExclude = new Map<String, Price_Book_Exclude__c> ();         //12-22 jd PRJ001715: excludes record by uniquekey - price book def id + productModel or price book def id + product
        Map<String, List<String>> salesOrgToCurrencyMap = new Map<String, List<String>>();
        Map<String, List<Published_Price_Book__c>> existingPublishedRecs = new Map<String, List<Published_Price_Book__c>>();        //2-7 jd PRJ001716: new map to hold the existing published price book records
        Set<String> PartNumberSet = new Set<String>();                                                                              //2-7 jd PRJ001716: new set to hold partNumber keys
        Set<String> SalesOrgSet = new Set<String>();                                                                                //2-7 jd PRJ001716: new set to hold salesOrg keys
        Set<String> CurrencySet = new Set<String>();                                                                                //2-7 jd PRJ001716: new set to hold currency keys
        Set<String> TierMinimumSet = new Set<String>();                                                                             //2-7 jd PRJ001716: new set to hold tierMinimum keys
        Set<String> PriceBookNameSet = new Set<String>();                                                                           //2-7 jd PRJ001716: new set to hold PriceBookName keys
        Set<String> PriceBookTypeSet = new Set<String>();                                                                           //2-7 jd PRJ001716: new set to hold PriceBookType keys
  
        
        if (accounts == null) {
            /* Build Price Book Definition list */
            priceBookDefinitions = [
                    Select
                        Id,
                        Name,
                        Type__c,
                        Definition_Number__c,
                        Discount_Type__c,
                        Discount_Value__c
                    From
                        Price_Book_Definition__c
                    Where
                        Include_in_Standard_Price_Books__c = true];
        }
        else {
            /* Build Price Book Definition list */
            Set<Id> booksToGrab = new Set<Id>();
            Map<String, Account> salesOrgToAccountMap = new Map<String, Account>();
            
            for (Account a : accounts) {
                if (a.Price_Book_Product__c != null && a.Price_Book_Product__r.Name != 'Base') {
                    if (priceBookDefToAccountMap.get(a.Price_Book_Product__c) == null) {
                        priceBookDefToAccountMap.put(a.Price_Book_Product__c, new Set<Account>());
                    }
                    priceBookDefToAccountMap.get(a.Price_Book_Product__c).add(a);
                    booksToGrab.add(a.Price_Book_Product__c);
                }
                if (a.Price_Book_SMSA__c != null && a.Price_Book_SMSA__r.Name != 'Base') {
                    if (priceBookDefToAccountMap.get(a.Price_Book_SMSA__c) == null) {
                        priceBookDefToAccountMap.put(a.Price_Book_SMSA__c, new Set<Account>());
                    }
                    priceBookDefToAccountMap.get(a.Price_Book_SMSA__c).add(a);
                    booksToGrab.add(a.Price_Book_SMSA__c);
                }
                if (a.Price_Book_VSOE__c != null && a.Price_Book_VSOE__r.Name != 'Base') {
                    if (priceBookDefToAccountMap.get(a.Price_Book_VSOE__c) == null) {
                        priceBookDefToAccountMap.put(a.Price_Book_VSOE__c, new Set<Account>());
                    }
                    priceBookDefToAccountMap.get(a.Price_Book_VSOE__c).add(a);
                    booksToGrab.add(a.Price_Book_VSOE__c);
                }

            if (a.Sales_Organization__c != null) {
                    salesOrgToAccountMap.put(a.Coverage_ID__r.Sales_Organization__r.Sales_Organization__c, a);
                    //salesOrgToAccountMap.put(a.Sales_Organization__r.Sales_Organization__c, a);
                } 
            } 
           
            // Build master map of Sales org to a List of Currencies
            for (Sales_Org_Currency__c soc : [
                    Select
                        Sales_Organization__r.Sales_Organization__c,
                        Currency_Name__r.Name
                    From
                        Sales_Org_Currency__c]) {
                if (salesOrgToCurrencyMap.get(soc.Sales_Organization__r.Sales_Organization__c) == null) {
                    salesOrgToCurrencyMap.put(soc.Sales_Organization__r.Sales_Organization__c, new List<String>());
                }
                salesOrgToCurrencyMap.get(soc.Sales_Organization__r.Sales_Organization__c).add(soc.Currency_Name__r.Name);
            }
            
            priceBookDefinitions = [
                    Select
                        Id,
                        Name,
                        Type__c,
                        Definition_Number__c,
                        Discount_Type__c,
                        Discount_Value__c
                    From
                        Price_Book_Definition__c
                    Where
                        Id in :booksToGrab];
        }
        
        if (priceBookDefinitions.size()>0){                                                                     //jd PRJ001715: check to see if any values returned
                priceBookDefExclude = getPriceBookDefExclude.getPriceBookDefExclude(priceBookDefinitions);      //jd PRJ001715: get pricebook excludes per pricebook definition
                priceBookDefExcDisc = getPriceBookDefExcDisc.getPriceBookDefExcDisc(priceBookDefinitions);      //jd PRJ001715: get exception discounts per pricebook definition
                priceBookDefInclude = getPriceBookDefInclude.getPriceBookDefInclude(priceBookDefinitions);      //jd PRJ001715: get pricebook includes per pricebook definition
        } 
        
        List<Published_Price_Book__c> publishedPriceBooks = new List<Published_Price_Book__c>();
        for (Core_Price_Book__c priceBook : scope) {
            for (Price_Book_Definition__c priceBookDefinition : priceBookDefinitions) {
                // if the definition type is SMSA, ensure the price book is Support
                if (priceBookDefinition.Type__c == 'SMSA' && 
                        !(priceBook.Line__c == 'Solutions Software' &&
                          priceBook.Series__c == 'Application Maint. & Dev' &&
                          priceBook.Family__c == 'Support'))
                    continue;  
                    
                Boolean processRecord = false;
                String priceBookDefProductkey = priceBookDefinition.id+ '-' + priceBook.product__c;                                         //12-22 jd PRJ001715: create product key
                String priceBookDefModelkey = priceBookDefinition.id+ '-' + priceBook.product__r.Product_Model__c;                          //12-22 jd PRJ001715: create product model key
                string priceBookDefinitionID = priceBookDefinition.id;                                                                      //12-22 jd PRJ001715: create price book definition key
                
                system.debug('priceBookDefProductkey:' + priceBookDefProductkey);                                                           //12-22 jd PRJ001715: debug statement
                system.debug('priceBookDefModelkey:' + priceBookDefModelkey);                                                               //12-22 jd PRJ001715: debug statement
                system.debug('priceBookDefinitionID:' + priceBookDefinition.id);                                                            //12-22 jd PRJ001715: debug statement
                system.debug('pricebookdefInclude:'+ pricebookdefInclude);                                                                  //12-22 jd PRJ001715: debug statement
               //'********jd prj001715' 
               //check includes to see if any products based on product or product model
               //    if products - then    
               if(PriceBookdefInclude.containskey(priceBookDefinitionID)){                                                                              //jd prj001715
                if(priceBookDefInclude.containskey(priceBookDefProductkey) || priceBookDefInclude.containskey(priceBookDefModelkey)){           //jd prj001715
                    system.debug('found item in pricebookdefInclude');
                    if(!(priceBookDefExclude.containskey(priceBookDefProductkey)) &&!( priceBookDefExclude.containskey(priceBookDefModelkey))){ //jd prj001715
                        processRecord = true;                                                                                                   //jd prj001715
                    }                                                                                                                           //jd prj001715
                }                                                                                                                               //jd prj001715
               }else{                                                                                                                               //jd prj001715
                   if(!(priceBookDefExclude.containskey(priceBookDefProductkey)) &&!( priceBookDefExclude.containskey(priceBookDefModelkey))){      //jd prj001715
                        processRecord = true;                                                                                                       //jd prj001715
                   }    
               }                                                                                                                            //jd prj001715

               if(processRecord == true){              
                    Published_Price_Book__c publishedPriceBook = new Published_Price_Book__c();
                    publishedPriceBook.Price_Book_Maker_ID__c =         priceBookMakerId;
                    publishedPriceBook.Child_Number__c =                priceBook.Child_Number__c;
                    publishedPriceBook.CurrencyIsoCode =                priceBook.CurrencyIsoCode;
                    publishedPriceBook.End_Date__c =                    priceBook.End_Date__c;         
                    publishedPriceBook.Exclude_from_Quote_Process__c =  priceBook.Exclude_from_Quote_Process__c;     
                    publishedPriceBook.Fair_Market_Value__c =           priceBook.Fair_Market_Value__c;
                    publishedPriceBook.Family__c =                      priceBook.Family__c;
                    publishedPriceBook.Header_Number__c =               priceBook.Header_Number__c * 1000 + Integer.valueOf(priceBookDefinition.Definition_Number__c);
                    publishedPriceBook.IsParent__c =                    priceBook.IsParent__c;
                    publishedPriceBook.Line__c =                        priceBook.Line__c;
                    publishedPriceBook.List_Price__c =                  priceBook.List_Price__c;  //priceBook.List_Price__c;
                    
                    publishedPriceBook.Model__c =                       priceBook.Model__c;
                    publishedPriceBook.Model_Brand__c =                 priceBook.Model_Brand__c;
                    publishedPriceBook.Name =                           priceBookDefinition.Name;
                    publishedPriceBook.Parent_Product__c =              priceBook.Parent_Product__c;
                    publishedPriceBook.Part_Number__c =                 priceBook.Part_Number__c;
                    publishedPriceBook.Price_Book_Type__c =             priceBookDefinition.Type__c;
                    publishedPriceBook.Price_Type__c =                  priceBook.Price_Type__c;
                    publishedPriceBook.Pricing_ID__c =                  priceBook.Pricing_ID__c;                        
                    publishedPriceBook.Product__c =                     priceBook.Product__c;
                    publishedPriceBook.Product_Brand__c =               priceBook.Product_Brand__c;
                    publishedPriceBook.Product_Name__c =                priceBook.Product_Name__c;
                    publishedPriceBook.Product_Family__c =              priceBook.Product_Family__c;
                    publishedPriceBook.Sales_Organization__c =          priceBook.Sales_Organization__c;
                    publishedPriceBook.Series__c =                      priceBook.Series__c;
                    publishedPriceBook.Start_Date__c =                  priceBook.Start_Date__c;
                    publishedPriceBook.Status__c =                      'Active';
                    publishedPriceBook.Tier_Minimum__c =                priceBook.Tier_Minimum__c;
                    publishedPriceBook.Tier_Pricing__c =                priceBook.Tier_Pricing__c;
                    publishedPriceBook.Uplift_Part_Number__c =          priceBook.Uplift_Part_Number__c;
                    publishedPriceBook.Uplift_Product__c =              priceBook.Uplift_Product__c;
                    publishedPriceBook.Token_Type__c =                  priceBook.Token_Type__c;
                                                    
                    // only use Fair Market Value for VSOE
                    Double source = priceBookDefinition.Type__c == 'VSOE' ? priceBook.Fair_Market_Value__c : priceBook.List_Price__c;
                    source = source == null ? 0 : source;
                    
                    //jd prj001715 - figure out which discount to take based on exceptions//                                                //jd prj001715
                            //look for exception for price book definition based on product or part                                                 //jd prj001715
                    system.debug('priceBookDefExcDisc:' + priceBookDefExcDisc);
                    system.debug('priceBookDefinition.Discount_Type__c:' + priceBookDefinition.Discount_Type__c);
                    system.debug('priceBookDefinition.Discount_Value__c:'+priceBookDefinition.Discount_Value__c);
                    if(priceBookDefExcDisc.containskey(priceBookDefProductkey)) {                                                           //jd prj001715
                        system.debug('found product Key');
                        priceBookDefinition.Discount_Type__c = priceBookDefExcDisc.get(priceBookDefProductkey).Discount_type__c;            //jd prj001715
                        system.debug('priceBookDefinition.Discount_Type__c' + priceBookDefinition.Discount_Type__c);
                        priceBookDefinition.Discount_Value__c = priceBookDefExcDisc.get(priceBookDefProductkey).Discount_Value__c;          //jd prj001715
                        system.debug('priceBookDefinition.Discount_Value__c'+priceBookDefinition.Discount_Value__c);
                    }else{                                                                                                                  //jd prj001715
                        if(priceBookDefExcDisc.containskey(priceBookDefModelkey)){                                                          //jd prj001715
                            priceBookDefinition.Discount_Type__c = priceBookDefExcDisc.get(priceBookDefModelkey).Discount_type__c;          //jd prj001715
                           system.debug('priceBookDefinition.Discount_Type__c' + priceBookDefinition.Discount_Type__c);
                            priceBookDefinition.Discount_Value__c = priceBookDefExcDisc.get(priceBookDefModelkey).Discount_Value__c;        //jd prj001715
                            system.debug('priceBookDefinition.Discount_Value__c'+priceBookDefinition.Discount_Value__c);
                        }                                                                                                                   //jd prj001715
                    } 
                    
                    
                    
                    if (priceBookDefinition.Discount_Type__c == 'Amount' && priceBook.Part_Number__c != 'PER0468') {
                        system.debug('source: ' + source);                                                                                  //12-22 jd PRJ001715: debug statement
                        system.debug('priceBookDefinition.Discount_Value__c' + priceBookDefinition.Discount_Value__c);                      //12-22 jd PRJ001715: debug statement
                        publishedPriceBook.List_Price__c =  source - priceBookDefinition.Discount_Value__c;
                        system.debug('publishedPriceBook.List_Price__c' + publishedPriceBook.List_Price__c);                                //12-22 jd PRJ001715: debug statement
                    }
                    else if (priceBookDefinition.Discount_Type__c == 'Percent' && priceBook.Part_Number__c != 'PER0468') {
                        // e.g. if source is 1000 and discount value is 20, we want this to be 1000 - 1000 * 20/100 = 800
                        publishedPriceBook.List_Price__c =  source - source * priceBookDefinition.Discount_Value__c / 100;
                    }  
                    else {
                        System.debug('ERROR: I don\'t know what to do with Discount Type '+priceBookDefinition.Discount_Type__c);
                    }
                    system.debug('priceBook.List_Price__c - rounding: ' + priceBook.List_Price__c);
                    If((priceBook.Part_Number__c != 'PER0468' && priceBook.Product_Family__c != 'SMSA') && priceBook.List_Price__c > 100.00){
                        publishedPriceBook.List_Price__c = GetRoundedValue(publishedPriceBook.List_Price__c);
                    }
                    
                    //jd prj001715 - if the price is negative, set to zero.
                    if(publishedPriceBook.List_Price__c < 0){                                                                           //jd prj001715
                        publishedPriceBook.List_Price__c = 0;                                                                           //jd prj001715
                    }                                                                                                                   //jd prj001715
                    system.debug('publishedPriceBook.List_Price__c:'+publishedPriceBook.List_Price__c);
                    
                    if (accounts == null) {
                        // only create the base when we're not working on customer specific
                        publishedPriceBooks.add(publishedPriceBook);                
                    } 
                    // customer specific
                    else if (accounts != null && priceBookDefToAccountMap.get(priceBookDefinition.Id) != null) {
                        for (Account account : priceBookDefToAccountMap.get(priceBookDefinition.Id)) {
                            // Only create a customer specific price book if the sales org is the same as that on the account
                            // and the currency is in the list of sales_org_currencies for that sales org
                            Boolean createAccountPB = false;
                            if (account.Coverage_ID__r.Sales_Organization__c != null && account.Coverage_ID__r.Sales_Organization__r.Sales_Organization__c.equals(priceBook.Sales_Organization__c) && salesOrgToCurrencyMap.get(account.Coverage_ID__r.Sales_Organization__r.Sales_Organization__c) != null) {
                        
                                for (String s : salesOrgToCurrencyMap.get(account.Coverage_ID__r.Sales_Organization__r.Sales_Organization__c)) {

                                    if (s.equals(priceBook.CurrencyIsoCode)) {
                                        createAccountPB = true;
                                        break;
                                    }
                                }
                            } 
                            
                            if (createAccountPB) {
                                Published_Price_Book__c accountPriceBook = publishedPriceBook.clone();
                                accountPriceBook.Account__c = account.Id;
                                publishedPriceBooks.add(accountPriceBook);
                            }
                        }
                    }
                    //add parameters for search of existing records by using sets.                                                          PRJ001716 jd - new comment
                    PartNumberSet.add(publishedPriceBook.Part_Number__c);                                                                   //2-7 jd PRJ001716: add partNumber to set
                    SalesOrgSet.add(publishedPriceBook.Sales_Organization__c);                                                              //2-7 jd PRJ001716: add salesOrg to set
                    CurrencySet.add(publishedPriceBook.CurrencyIsoCode);                                                                    //2-7 jd PRJ001716: add currency to set
                    PriceBookNameSet.add(publishedPriceBook.Name);                                                                          //2-7 jd PRJ001716: add PriceBookName to set
                    PriceBookTypeSet.add(publishedPriceBook.Price_Book_Type__c);                                                            //2-7 jd PRJ001716: add PriceBookType to set   
               }
            }
        }
        insert publishedPriceBooks;                                                                                                 //  PRJ001716 - commented out, not inserting records until know which ones need to insert.
        
        //instead of inserting all the published pricebooks, only insert ones that do not exist already and update records that match       PRJ001716 jd - new comment
        //pricebook record is created and placed in new published price book recordslist.                                                   PRJ001716 jd - new comment
        //sets are created from each record for SOQL search to any existing records                                                         PRJ001716 jd - new comment
        //with SOQL results, the information is put in a map by key to be searched by publishedpricebook records list;                      PRJ001716 jd - new comment
        //list is iterated over and, if record found, then placed in update list                                                            PRJ001716 jd - new comment
        //if record is not found, then put in insert list.                                                                                  PRJ001716 jd - new comment
 //       map<String, Published_Price_Book__c> existingPriceBookRecs = new map<String, Published_Price_Book__c>();                          //PRJ001716 jd - map to hold existing pricebook records for comparison
        
 //       existingPriceBookRecs = getExistingPriceBookRecs.getExistingPriceBookRecs(partNumberSet, SalesOrgSet, CurrencySet, PriceBookNameSet, PricebookTypeSet);   //PRJ001716 jd - class to get existing pricebook records based on parameters passed
        
        //check for record in existing, if not in existing, then it needs to go into the insert.                                            //PRJ001716 jd - comment
 //       List<Published_Price_Book__c> updatePublishedPriceBooks = new List<Published_Price_Book__c>();                                        //PRJ001716 jd: create list for update records
 //       List<Published_Price_Book__c> insertPublishedPriceBooks = new LIst<Published_Price_Book__c>();                                        //PRJ001716 jd: create list for insert records
 //       system.debug('before publishedRec: ' + publishedPriceBooks);
 //       for (Published_Price_Book__c publishedRec : publishedPriceBooks)  {                                                               //PRJ001716 jd : for each record in the list, check to see if needs to go into the update or the insert list.
            
            //create key from publishedRec to compare to all records in existingPriceBookRecs map                                           //PRJ001716 jd: comment   
//          string publishedRecKey;                                                                                                         //PRJ001716 jd: string variable to hold compare string
//          publishedRecKey = publishedRec.Part_Number__c;                                                                                  //PRJ001716 jd: adding partnumber to string variable
//          publishedRecKey = publishedRecKey + ' - ' + publishedRec.Sales_Organization__c;                                                 //PRJ001716 jd: adding sales org to string variable
//          publishedRecKey = publishedRecKey + ' - '  + publishedRec.CurrencyIsoCode;                                                      //PRJ001716 jd: adding currencycode to string variable
//          publishedRecKey = publishedRecKey + ' - '  + string.valueof(publishedRec.tier_Minimum__c);                                      //PRJ001716 jd: adding tierminumum to string variable
//          publishedRecKey = publishedRecKey + ' - '  + publishedRec.Name;                                                                 //PRJ001716 jd: adding pricebook name to string variable
//          publishedRecKey = publishedRecKey + ' - '  + publishedRec.Price_Book_Type__c;                                                   //PRJ001716 jd: adding price book type to string variable
//          if(publishedRec.Account__c == null){                                                                                            //PRJ001716 jd: check if record has an account number
//              publishedRecKey = publishedRecKey + ' - no account';                                                                        //PRJ001716 jd: adding string holder to string variable
//          }else{                                                                                                                          //PRJ001716 jd: else statement
//              publishedRecKey = publishedRecKey + ' - '  + publishedRec.Account__c;                                                       //PRJ001716 jd: adding accountnumber to string variable
//          }
//          
//          //check to see if the key is in the map                                                                                         //PRJ001716 jd: comment
//          if (existingPriceBookRecs.containsKey(publishedRecKey)){                                                                        //PRJ001716 jd: check to see if map has record by key
//              Published_Price_Book__c tmpPriceRec = existingPriceBookRecs.get(publishedRecKey);                                           //PRJ001716 jd: get record to pull out id
//                  tmpPriceRec.Part_Number__c = publishedRec.Part_Number__c;
//                  tmpPriceRec.Sales_Organization__c = publishedRec.Sales_Organization__c;
//                  tmpPriceRec.CurrencyIsoCode = publishedRec.CurrencyIsoCode;
//                  tmpPriceRec.Tier_Minimum__c = publishedRec.Tier_Minimum__c;
//                  tmpPriceRec.Name = publishedRec.Name;
//                  tmpPriceRec.Price_Book_Type__c = publishedRec.Price_Book_Type__c;
//                  tmpPriceRec.List_Price__c = publishedRec.List_Price__c;
//                  tmpPriceRec.account__c = publishedRec.account__c;
//                  tmpPriceRec.Price_Book_Maker_ID__c = publishedRec.Price_Book_Maker_ID__c;
 //                   tmpPriceRec.Child_Number__c = publishedRec.Child_Number__c;
//                    tmpPriceRec.End_Date__c = publishedRec.End_Date__c;     
 //                   tmpPriceRec.Exclude_from_Quote_Process__c = publishedRec.Exclude_from_Quote_Process__c;  
  //                  tmpPriceRec.Fair_Market_Value__c = publishedRec.Fair_Market_Value__c;
//                    tmpPriceRec.Family__c = publishedRec.Family__c;
//                    tmpPriceRec.Header_Number__c = publishedRec.Header_Number__c;
//                    tmpPriceRec.IsParent__c = publishedRec.IsParent__c;
//                    tmpPriceRec.Line__c = publishedRec.Line__c;
//                    tmpPriceRec.Model__c = publishedRec.Model__c;
//                    tmpPriceRec.Model_Brand__c = publishedRec.Model_Brand__c;
//                    tmpPriceRec.Parent_Product__c = publishedRec.Parent_Product__c;
//                  tmpPriceRec.Price_Type__c = publishedRec.Price_Type__c;
//                    tmpPriceRec.Pricing_ID__c = publishedRec.Pricing_ID__c;                  
//                    tmpPriceRec.Product__c = publishedRec.Product__c;
//                      tmpPriceRec.Product_Brand__c = publishedRec.Product_Brand__c;
//                    tmpPriceRec.Product_Name__c = publishedRec.Product_Name__c;
//                    tmpPriceRec.Product_Family__c = publishedRec.Product_Family__c;
//                  tmpPriceRec.Series__c = publishedRec.Series__c;
//                    tmpPriceRec.Start_Date__c = publishedRec.Start_Date__c;
//                    tmpPriceRec.Status__c = publishedRec.Status__c;
//                  tmpPriceRec.Tier_Pricing__c = publishedRec.Tier_Pricing__c;
//                    tmpPriceRec.Uplift_Part_Number__c = publishedRec.Uplift_Part_Number__c;
//                    tmpPriceRec.Uplift_Product__c = publishedRec.Uplift_Product__c;
//                    tmpPriceRec.Token_Type__c = publishedRec.Token_Type__c;

//              updatePublishedPriceBooks.add(tmpPriceRec)  ;                                                                               //PRJ001716 jd: add tmprec to update list   
//          }else                                                                                                                           //PRJ001716 jd: else statement
//              insertPublishedPriceBooks.add(publishedRec);                                                                                //PRJ001716 jd: add rec to insert list
                    
            
//        }
 //       insert insertPublishedPriceBooks;                                                                                                 //PRJ001716 jd: insert all records that should be inserted
//      system.debug('insertPublishedpriceBooks: ' + insertPublishedPriceBooks.size());
//        update updatePublishedPriceBooks;                                                                                                 //PRJ001716 jd: update all records that should be udpated
//      system.debug('updatePublishedPriceBooks: ' + updatePublishedPriceBooks.size());
        
    }
    
    /*
     * Complete the Batched Apex job.
     */
    global void finish(Database.BatchableContext BC){ 
        if (updateStatus) {
            String newStatus = '';
            if (operation == 'CreateCorePriceBooks') {
                newStatus = 'Core - Complete';
            }
            else { //if (operation == 'CreatePublishedPriceBooks') {
                newStatus = 'Published - Complete';
            }
            Price_Book_Maker__c maker = new Price_Book_Maker__c(id=priceBookMakerId);
            maker.Status__c = newStatus;
            update maker;
        }
        System.debug('Finished batch');
    }
    
    public Integer GetRoundedValue(Decimal newCost){
        integer newCost_Rounded;
        integer calculatedCost = newCost.intvalue();        //gets the digits without the decimals
        system.debug('calculatedCost:' + calculatedCost);
        if (calculatedCost == 0){
            newCost_Rounded= calculatedCost;
        }else{
            String cost = String.valueOf(calculatedCost);               //turns the cost field into a string so that we can the length
            system.debug('cost:'+ cost);
            Integer costLength = cost.length();                 //get the length of the string to know how many digits need to look for
            system.debug('costLength:' + costLength);
            system.debug('what is this cost last digit: ' + cost.substring(costLength-1, costLength));
            string costEndingNumber = cost.substring(costLength-1, costLength);     //last digit of cost but in string format
            If(costEndingNumber == '0' || costEndingNumber == '5'){
                newCost_Rounded= calculatedCost;
            }else{
                system.debug('costEndingNumber:' + costEndingNumber);
                Integer costCompareNumber = (decimal.valueof(costEndingNumber)).intValue();     //last digit of cost but in integer format
                 
                integer fiveDif = 5-costCompareNumber;
                integer tenDif = 10-costCompareNumber;
                integer numberToAdd;
                system.debug('fiveDif - before negative check' + fiveDif);  
                if (fiveDif < 0){           //when subtracting - make sure fivedif is always a positive number
                    fiveDif = 0;
                }
                system.debug('fiveDif' + fiveDif);
                system.debug('tenDif' + tenDif);
                
                If(fiveDif < tenDif && fiveDif != 0){
                    newCost_Rounded = calculatedCost + fiveDif;
                }else{
                    newCost_Rounded = calculatedCost + tenDif;
                }
            }
        }
        system.debug('newCost_Rounded:' + newCost_Rounded);
        return newCost_Rounded;
    }
}