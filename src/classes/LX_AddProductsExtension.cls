/*
Class Name : LX_AddProductsExtension
Description : Extension class for adding products from an Opportunity
Created By : Shubhashish Rai (shrai@deloitte.com)
Created Date : 17-Jun-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Shubhashish Rai  17-Jun-2014           1000               Initial Version
*************************************************************************/

public with sharing class LX_AddProductsExtension{
    public boolean isPaginationRequired{get;set;}
    public boolean onSbmtApprSavedProducts {get;set;}
    public Id oppId{get;set;}
    public Integer totalRecs = 50000;
    public Integer totalRecs_SavedProducts {get;set;}
    
    public static String oppCurrency{get;set;}
    public String quickBidType {get;set;}
    public List<ProductsWrapper> productWrapperList{get;set;}
    public List<ProductsWrapper> savedProductWrapperList{get;set;}
    
    public String ProductNameFilter{get;set;}
    public String PartNumberFilter{get;set;}
    public String DescriptionFilter{get;set;}
    public List<SelectOption> LineListFilter{set;}
    public List<SelectOption> SeriesListFilter{get;set;}
    public List<SelectOption> FamilyListFilter{get;set;}
    public List<SelectOption> ModelListFilter{get;set;}
    
    public String lineFilter;
    public String seriesFilter{get;set;}
    public String familyFilter{get;set;}
    public String modelFilter{get;set;}
    
    public String lineFilterPrevious {get;set;}
    
    public boolean isSeriesNotToBeDisplayed {get;set;}
    public boolean isFamilyNotToBeDisplayed{get;set;}
    public boolean isModelNotToBeDisplayed{get;set;}
    
    public Integer counterToDelete{get;set;}
    public Integer counterToSave{get;set;}
    
    public Integer counterPrevious{get;set;}
    public Integer counterVal {get;set;}
    public Decimal quantityPrevious{get;set;}
    public Decimal discountPrevious{get;set;}
    
    public boolean filterFormRender{get;set;}
    public boolean filterPageBlockRender{get;set;}
    public boolean mainFormRender{get;set;}
    public boolean mainPageBlockRender{get;set;}
    public boolean errorPageBlock{get;set;}
    public boolean PageBlockSavedProductsRender{get;set;}
    public boolean SavedProductsRenderForm {get;set;}
    
    public String strFilterPrevious{get;set;}
    
    public boolean isFilterApplied{get;set;}
    
    public boolean prev{get;set;}
    public boolean nxt{get;set;}
    
    public boolean prev_SavedProducts{get;set;}
    public boolean nxt_SavedProducts{get;set;}
    
    private boolean isLastPage = false;
    private integer OffsetSize = 0;
    private integer LimitSize = Integer.valueOf(Label.LX_Page_Limit_PRM_SearchResults);
    
    private boolean isLastPage_SavedProducts = false;
    private integer OffsetSize_SavedProducts = 0;
    private integer LimitSize_SavedProducts = 5;
    
    public integer Page_LimitSize {get;set;}
    
    public LX_AddProductsExtension(ApexPages.StandardController controller){
        oppId= ApexPages.currentPage().getParameters().get('oppId');
        Integer limitSizeQuery = (Limits.getLimitQueryRows() - Limits.getQueryRows());
        System.debug('@@@1' + limitSizeQuery);
        onSbmtApprSavedProducts = false;
        filterFormRender=true;
        filterPageBlockRender=true;
        mainFormRender=true;
        mainPageBlockRender=true;
        errorPageBlock=false;
        PageBlockSavedProductsRender = true;
        
        prev=true;
        nxt=false;
        prev_SavedProducts = true;
        nxt_SavedProducts = false;
        
        isFilterApplied = false;
        isSeriesNotToBeDisplayed = true;     
        isFamilyNotToBeDisplayed = true;
        isModelNotToBeDisplayed = true;
        
        savedProductWrapperList = new List<ProductsWrapper>();
        Integer countOppPricelistProds;
        
        opportunity opp = [select id,LX_In_Approval_Process_Quick_Bid__c from opportunity where id=: oppId];
        if(opp != null){
         if(opp.LX_In_Approval_Process_Quick_Bid__c)
            onSbmtApprSavedProducts = true;
        }
        
        string oppPricelistProductSavedCountQuery = 'Select count() from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in (\'' + oppId + '\')';
        List<Opportunity> oppList = new List<Opportunity>();
        try{
           totalRecs_SavedProducts = Database.countQuery( oppPricelistProductSavedCountQuery);
           oppList = [Select id, CurrencyIsoCode, LX_Quick_Bid_Type__c from Opportunity where id=: oppId];
           if(oppList.size()>0){
               oppCurrency = oppList[0].CurrencyIsoCode; 
               quickBidType = oppList[0].LX_Quick_Bid_Type__c ;
           }
           System.debug('@@@' + countOppPricelistProds + oppCurrency);
        }
        catch(Exception ex){
            System.debug('@@@' + oppPricelistProductSavedCountQuery);
        }
        if(!onSbmtApprSavedProducts){
            if(totalRecs_SavedProducts == 0)
                SavedProductsRenderForm= false;
            else if (totalRecs_SavedProducts <= LimitSize_SavedProducts ){
                SavedProductsRenderForm = true;
                nxt_SavedProducts = true;
                prev_SavedProducts = true;
                getSavedProducts();   
            }
            else{
                SavedProductsRenderForm = true;
                nxt_SavedProducts = false;
                prev_SavedProducts = true;
                getSavedDynamicProducts();
            }
        }
        else{
        filterFormRender = false;
        mainPageBlockRender = false;
          if(totalRecs_SavedProducts == 0){
                SavedProductsRenderForm= false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Problem with the Quick Bid. Unable to process your request')); 
            }
          else if(totalRecs_SavedProducts <= LimitSize_SavedProducts){
            SavedProductsRenderForm = false;
                nxt_SavedProducts = true;
                prev_SavedProducts = true;
                getSavedProducts();
            }
          else{
                SavedProductsRenderForm = false;
                nxt_SavedProducts = false;
                prev_SavedProducts = true;
                getSavedDynamicProducts();
            }
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_OnSubmitted_OppCustomer_Message));        
        }
        getDynamicProducts();
    }
    public List<SelectOption> getLineListFilter(){
       List<SelectOption> options = new List<SelectOption>();
       if(quickBidType == 'Standard'){
           options.add(new SelectOption('','--None--'));
           options.add(new SelectOption('Printers','Printers'));
           options.add(new SelectOption('Options','Options'));
           System.debug('@@@ in the getLineListFilter' + options.size());
       }
       else{
           options.add(new SelectOption('','--None--'));
           options.add(new SelectOption('Printers','Printers'));
           System.debug('@@@ in the getLineListFilter' + options.size());       
       }
       return options;
    }
  /*  public List<SelectOption> getSeriesListFilter(){
        List<SelectOption> options; 
        if(lineFilter!=null && lineFilter!='' && lineFilter=='Printers'){
            options = new List<SelectOption>();
            AggregateResult[] productModelList = [Select Series__c from Product2 where LX_Product_Line1__c = 'Printers' group by Series__c];
            for(AggregateResult prodModel : productModelList){
                String str = (String)prodModel.get('Series__c');
                options.add(new SelectOption(str,str));
            }
        }
        System.debug('@@@ in the getSeriesListFilter' + options.size());
        return options;
    }*/
    public String getlineFilter(){
        return lineFilter;
    }
    public void setlineFilter(String str){
        lineFilter=str;
        if(str!=null && str!='' && str=='Printers' && lineFilterPrevious != lineFilter){
            isSeriesNotToBeDisplayed = false;
            isFamilyNotToBeDisplayed = true;
            isModelNotToBeDisplayed = true;
        }
        else if(str!=null && str!='' && str=='Options' && lineFilterPrevious != lineFilter){
            isSeriesNotToBeDisplayed = true;
            isFamilyNotToBeDisplayed = true;
            isModelNotToBeDisplayed = false;
        }
        else if(str==null || str==''){
            isSeriesNotToBeDisplayed = true;
            isFamilyNotToBeDisplayed = true;
            isModelNotToBeDisplayed = true;     
        }
        lineFilterPrevious = lineFilter;
    }
    public void getDynamicProducts(){
        List<Product2> productList;
        String strFilterPage = ' ';
        String query='Select id, Name, Part_Number__c, Description from Product2 ';
        strFilterPage +=' order by Name';
        strFilterPage += ' LIMIT :LimitSize OFFSET :OffsetSize';
        
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');       
        List<LX_Opportunity_Pricelist_Product__c> oppPricelistProductSavedListTemp = new List<LX_Opportunity_Pricelist_Product__c>();
        string oppPricelistProductSavedListQuery = 'Select id, Name, CurrencyIsoCode, Parent_ID__c, LX_Opportunity__c, LX_Part_Number__c, LX_Product__c, LX_Product__r.Description, LX_Product__r.Name, LX_Quantity__c, LX_Discount__c, LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in (\'' + oppIdVar + '\') order by LX_Part_Number__c'; 
        List<Opportunity> currentOppList = new List<Opportunity>();
        try{
            oppPricelistProductSavedListTemp = Database.query(oppPricelistProductSavedListQuery);
            currentOppList = [Select id, CurrencyIsoCode  from Opportunity where id=: oppIdVar];
            oppCurrency = currentOppList[0].CurrencyIsoCode;
            //oppCurrency = oppPricelistProductSavedListTemp[0].CurrencyIsoCode;
            System.debug('@@@oppPricelistProductSavedListTemp ' + oppPricelistProductSavedListTemp );
        }
        catch(Exception ex){
            System.debug('@@@ ' + ex);
            LX_CommonUtilities.createExceptionLog(ex);
        }
 
       
        boolean FirstFilter1 = true;
        List<String> partNumberSavedList = new List<String>();
        String strFilter = ' ';
        
        if(quickBidType == 'Demo'){
            strFilter += ' WHERE LX_Product_Line1__c in (\'Printers\') and LX_Product_Catalog_Type__c in (\'Quick Bid\') '; 
        }
        else{
             strFilter += ' WHERE LX_Product_Line1__c in (\'Printers\', \'Options\') and LX_Product_Catalog_Type__c in (\'Quick Bid\') ';        
        }  
        Integer lstIterator1 = 0;
        String strPartNumber = '(';        
        if(oppPricelistProductSavedListTemp.size()>0){
            for(LX_Opportunity_Pricelist_Product__c oppPricelistProd : oppPricelistProductSavedListTemp ){
                lstIterator1++;
 
                if(lstIterator1<oppPricelistProductSavedListTemp .size()){
                    strPartNumber += '\'' + oppPricelistProd.LX_Part_Number__c + '\',';
                    partNumberSavedList.add(strPartNumber);
                }
                else{
                    strPartNumber += '\'' + oppPricelistProd.LX_Part_Number__c + '\'';
                    partNumberSavedList.add(strPartNumber);           
                }
            }
            strPartNumber += ')';
            strFilter += ' AND Part_Number__c NOT IN ' + strPartNumber ;
        } 
         

        productList = new List<Product2>();
        
        System.debug('@@@@query*' + query+strFilter+strFilterPage );
        try{
            productList = Database.query(query+strFilter+strFilterPage);
        }
        catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
        }
        productWrapperList = new List<ProductsWrapper>();
        Integer lstIterator = 0;
        for(Product2 productInstance: productList){
            ProductsWrapper productWrap = new ProductsWrapper();
            productWrap.ProductName = productInstance.Name;
            productWrap.PartNumber=productInstance.Part_Number__c;
            productWrap.Description=productInstance.Description;
            productWrap.counter = lstIterator;
            lstIterator++;
            productWrapperList.add(productWrap);
        }
        System.debug('@@@@' + productWrapperList + productWrapperList.size());
    }
    public void getDynamicProductsFilter(){
        
        List<Product2> productList;
        String strFilterPage = ' ';
        String strFilter = ' ';
        boolean FirstFilter = true;
        isFilterApplied = true;
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');
        List<LX_Opportunity_Pricelist_Product__c> oppPricelistProductSavedListTemp = new List<LX_Opportunity_Pricelist_Product__c>();
        string oppPricelistProductSavedListQuery = 'Select id, Name, CurrencyIsoCode, Parent_ID__c, LX_Opportunity__c, LX_Part_Number__c, LX_Product__c, LX_Product__r.Description, LX_Product__r.Name, LX_Quantity__c, LX_Discount__c, LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in (\'' + oppIdVar + '\') order by LX_Part_Number__c'; 
        List<Opportunity> currentOppList = new List<Opportunity>();
        try{
            oppPricelistProductSavedListTemp = Database.query(oppPricelistProductSavedListQuery);
            currentOppList = [Select id, CurrencyIsoCode  from Opportunity where id=: oppIdVar];
            oppCurrency = currentOppList[0].CurrencyIsoCode;
            System.debug('@@@oppPricelistProductSavedList');
        }
        catch(Exception ex){
            System.debug('@@@ ' + ex);
            LX_CommonUtilities.createExceptionLog(ex);
        }
        List<String> partNumberSavedList = new List<String>();
        Integer lstIterator = 0;
        String strPartNumber = '(';
        for(LX_Opportunity_Pricelist_Product__c oppPricelistProd : oppPricelistProductSavedListTemp ){
            lstIterator++; 
            if(lstIterator<oppPricelistProductSavedListTemp .size()){
                strPartNumber += '\'' + oppPricelistProd.LX_Part_Number__c + '\',';
                partNumberSavedList.add(strPartNumber);
            }
            else{
                strPartNumber += '\'' + oppPricelistProd.LX_Part_Number__c + '\'';
                partNumberSavedList.add(strPartNumber);           
            }
        }
        strPartNumber += ')';
        
        String query='Select id, Name, Part_Number__c, Description from Product2 ';
        if(quickBidType == 'Demo'){
            query += ' where LX_Product_Line1__c in (\'Printers\') and LX_Product_Catalog_Type__c in (\'Quick Bid\') ' ; 
        }
        else{
            query += ' where LX_Product_Line1__c in (\'Printers\', \'Options\') and LX_Product_Catalog_Type__c in (\'Quick Bid\') ' ; 
        }
        
        FirstFilter = false;
        
        if(ProductNameFilter != null && ProductNameFilter !='')
            {
                 strFilter += ' AND Name like\'%' + ProductNameFilter +'%\'';
            }
         
         if(PartNumberFilter!= null && PartNumberFilter!='')
            {
                    strFilter += ' AND Part_Number__c like \'%' + PartNumberFilter +'%\'';
            }
          if(DescriptionFilter != null && DescriptionFilter !='')
            {
                    strFilter += ' AND Description like \'%' + DescriptionFilter +'%\'';
            }
        if(oppPricelistProductSavedListTemp.size()>0){
            if(partNumberSavedList.size()>0){
                    strFilter += ' AND Part_Number__c NOT IN ' + strPartNumber ;
            }
        }
        if(lineFilter!= null && lineFilter!=''){
                    strFilter += ' AND LX_Product_Line1__c = \'' + lineFilter+'\'';
            }
        if(seriesFilter!= null && seriesFilter!='' && !(isSeriesNotToBeDisplayed)){
                    strFilter += ' AND Series__c = \'' + seriesFilter +'\'';
            }
         if(familyFilter!= null && familyFilter!='' && !(isFamilyNotToBeDisplayed)){
                    strFilter += ' AND LX_Product_Family__c = \'' + familyFilter+'\'';
            }
         if(modelFilter!= null && modelFilter!='' && !(isModelNotToBeDisplayed)){
                    strFilter += ' AND LX_Product_Model_Model__c =\'' + modelFilter+'\'';
            }
        /*String queryCount = 'Select count() from Product2';
        try{
            totalRecs = Database.countQuery(queryCount + strFilter);
        }
        catch(Exception e){
            totalRecs = 50000;
        }*/
        //System.debug('@@@@totalRecs' + totalRecs); 
          
        if(OffsetSize>0 && strFilterPrevious != strFilter){
            OffsetSize = 0;
        }
        
        system.debug('@@@ LimitSize ' + LimitSize );
        system.debug('@@@ OffsetSize' + OffsetSize);

        strFilterPage +=' order by Name';
        strFilterPage += ' LIMIT :LimitSize OFFSET :OffsetSize';
        
        System.debug('**@@@@query**' + query );
        System.debug('@@@@strFilter' + strFilter );
        strFilterPrevious = strFilter;
        System.debug('@@@@strFilterPage' + strFilterPage );
        
        productList = new List<Product2>();
        
        try{
            productList = Database.query(query+strFilter+strFilterPage);
        }
        catch(Exception ex){
            System.debug('@@@ queryError' + ex + query+strFilter+strFilterPage) ;
            LX_CommonUtilities.createExceptionLog(ex);
        }
        productWrapperList = new List<ProductsWrapper>();
        Integer lstIterator1 = 0;
        
        if(productList.size()>0){
            for(Product2 productInstance: productList){
                ProductsWrapper productWrap = new ProductsWrapper();
                productWrap.ProductName = productInstance.Name;
                productWrap.PartNumber=productInstance.Part_Number__c;
                productWrap.Description=productInstance.Description;
                productWrap.counter = lstIterator;
                lstIterator1++;
                productWrapperList.add(productWrap);
            }
            System.debug('@@@@' + productWrapperList + productWrapperList.size());
            
            Integer totalPageNumber ; 
            
            if(OffSetSize>0 && productList.size()<LimitSize){
                prev=false;
                nxt=true;
            }
            else if(OffSetSize>0 && productList.size()==LimitSize){
                prev = false;
                nxt = false;
            }
            else if(OffSetSize == 0 && productList.size()==LimitSize){
                prev=true;
                nxt = false; 
            }
            else if(OffsetSize == 0 && productList.size()<LimitSize){
                prev = true;
                nxt = true;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, '- Your search returned no results. Please search again.')); 
        }
    }
    public void getSavedProducts(){
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');
        savedProductWrapperList = new List<ProductsWrapper>();
        List<LX_Opportunity_Pricelist_Product__c> oppPricelistProductSavedList = new list<LX_Opportunity_Pricelist_Product__c>();
        string oppPricelistProductSavedListQuery = 'Select id, CurrencyIsoCode, Name, Parent_ID__c, LX_Opportunity__c, LX_Part_Number__c, LX_Product__c, LX_Product__r.Description, LX_Product__r.Name, LX_Quantity__c, LX_Discount__c, LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in (\'' + oppIdVar + '\') order by LX_Part_Number__c'; 
        List<Opportunity> currentOppList = new List<Opportunity>();
        try{
            oppPricelistProductSavedList = Database.query(oppPricelistProductSavedListQuery);
           // currentOppList = [Select id, CurrencyIsoCode  from Opportunity where id=: oppIdVar];
            oppCurrency = oppPricelistProductSavedList[0].CurrencyIsoCode;
            System.debug('@@@oppPricelistProductSavedList');
        }
        catch(Exception ex){
            System.debug('@@@ ' + ex);
            LX_CommonUtilities.createExceptionLog(ex);
        }
        Integer lstIterator = 0;
        
        if(oppPricelistProductSavedList.size()>0){
            for(LX_Opportunity_Pricelist_Product__c oppPricelistProd : oppPricelistProductSavedList ){
                ProductsWrapper prodWrapperSaved = new ProductsWrapper();
                prodWrapperSaved.ProductName = oppPricelistProd.LX_Product__r.Name;
                prodWrapperSaved.PartNumber = oppPricelistProd.LX_Part_Number__c;
                prodWrapperSaved.Description = oppPricelistProd.LX_Product__r.Description;
                prodWrapperSaved.oppPriceListProductInstance.LX_Quantity__c = oppPricelistProd.LX_Quantity__c;
                prodWrapperSaved.oppPriceListProductInstance.LX_Discount__c = oppPricelistProd.LX_Discount__c;
                prodWrapperSaved.selected = false;
                prodWrapperSaved.counter = lstIterator;
                lstIterator++;
                
                savedProductWrapperList.add(prodWrapperSaved);
            }  
        }
        getDynamicProducts();
   /*     if(isFilterApplied){
            getDynamicProductsFilter();
        }
        else{
            getDynamicProducts();
        }*/
    }
    public void getSavedDynamicProducts(){
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');
        savedProductWrapperList = new List<ProductsWrapper>();
        List<LX_Opportunity_Pricelist_Product__c> oppPricelistProductSavedList = new list<LX_Opportunity_Pricelist_Product__c>();
        string oppPricelistProductSavedListQuery = 'Select id, CurrencyIsoCode, Name, Parent_ID__c, LX_Opportunity__c, LX_Part_Number__c, LX_Product__c, LX_Product__r.Description, LX_Product__r.Name, LX_Quantity__c, LX_Discount__c, LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in (\'' + oppIdVar + '\')'; 

        oppPricelistProductSavedListQuery +=' order by LX_Part_Number__c';
        oppPricelistProductSavedListQuery +=' LIMIT :LimitSize_SavedProducts OFFSET :OffsetSize_SavedProducts';
        
        List<Opportunity> currentOppList = new List<Opportunity>();
        try{
            oppPricelistProductSavedList = Database.query(oppPricelistProductSavedListQuery);
            currentOppList = [Select id, CurrencyIsoCode  from Opportunity where id=: oppIdVar];
            oppCurrency = oppPricelistProductSavedList[0].CurrencyIsoCode;
            System.debug('@@@oppPricelistProductSavedList');
        }
        catch(Exception ex){
            System.debug('@@@ ' + ex);
            LX_CommonUtilities.createExceptionLog(ex);
        }
        
        Integer lstIterator = 0;
        if(oppPricelistProductSavedList.size()>0){
            for(LX_Opportunity_Pricelist_Product__c oppPricelistProd : oppPricelistProductSavedList ){
                
                ProductsWrapper prodWrapperSaved = new ProductsWrapper();
                prodWrapperSaved.ProductName = oppPricelistProd.LX_Product__r.Name;
                prodWrapperSaved.PartNumber = oppPricelistProd.LX_Part_Number__c;
                prodWrapperSaved.Description = oppPricelistProd.LX_Product__r.Description;
                prodWrapperSaved.oppPriceListProductInstance.LX_Quantity__c = oppPricelistProd.LX_Quantity__c;
                prodWrapperSaved.oppPriceListProductInstance.LX_Discount__c = oppPricelistProd.LX_Discount__c;
                prodWrapperSaved.selected = false;
                prodWrapperSaved.counter = lstIterator;
                lstIterator++;
                
                savedProductWrapperList.add(prodWrapperSaved);
            }  
        }
        getDynamicProducts();
       /* if(isFilterApplied){
            getDynamicProductsFilter();
        }
        else{
            getDynamicProducts();
        }*/
    }   
    public PageReference inlineSaveLogic(){
        System.debug('@@@ counterToSave' + counterToSave);
        System.debug('@@@ savedProductWrapperList ' + savedProductWrapperList );
        System.debug('@@@ savedProductWrapperList ' + savedProductWrapperList[counterToSave].oppPriceListProductInstance.LX_Quantity__c);
        System.debug('@@@ savedProductWrapperList ' + savedProductWrapperList[counterToSave].partNumber);
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');
        List<LX_Opportunity_Pricelist_Product__c> oppPricelistProdSaveList = new List<LX_Opportunity_Pricelist_Product__c>();
        
        if(counterToSave != counterPrevious){
            PageReference pRef = productChanged();
            return null;
        }
        
        try{
            oppPricelistProdSaveList = [Select id, Name, Parent_ID__c, LX_Opportunity__c, LX_Part_Number__c, LX_Product__c, LX_Product__r.Description, LX_Product__r.Name, LX_Quantity__c, LX_Discount__c, LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__r.id =: oppIdVar and LX_Part_Number__c =: savedProductWrapperList[counterToSave].partNumber];
            System.debug('@@@ oppPricelistProdSaveList ' +oppPricelistProdSaveList[0].id);
            if(oppPricelistProdSaveList.size()>0){
                oppPricelistProdSaveList[0].LX_Quantity__c = savedProductWrapperList[counterToSave].oppPriceListProductInstance.LX_Quantity__c;
                oppPricelistProdSaveList[0].LX_Discount__c = savedProductWrapperList[counterToSave].oppPriceListProductInstance.LX_Discount__c;
            }
            Database.update(oppPricelistProdSaveList[0]);
        }
        catch(Exception ex){
            System.debug('@@@ ' + ex);
            LX_CommonUtilities.createExceptionLog(ex); 
            return RecordsNotInserted();
        }
        
        Integer totalPageNumber_SavedProducts = getTotalPages_SavedProducts();
        //OffsetSize_SavedProducts = (totalPageNumber_SavedProducts  - 1)*LimitSize_SavedProducts;
        
        if (totalRecs_SavedProducts <= LimitSize_SavedProducts){
            SavedProductsRenderForm = true;
            nxt_SavedProducts = true;
            prev_SavedProducts = true;
            getSavedProducts(); 
        }
        else if(OffsetSize_SavedProducts == ((totalPageNumber_SavedProducts  - 1)*LimitSize_SavedProducts)) {
            SavedProductsRenderForm = true;
            prev_SavedProducts = false;
            nxt_SavedProducts = true;
            getSavedDynamicProducts();
        }
        else if(OffsetSize_SavedProducts == 0){
            SavedProductsRenderForm = true;
            prev_SavedProducts = true;
            nxt_SavedProducts = false;
            getSavedDynamicProducts();      
        }
        else{
            SavedProductsRenderForm = true;
            prev_SavedProducts = false;
            nxt_SavedProducts = false;
            getSavedDynamicProducts();          
        }
        
        counterPrevious = null;
        String strUrl = '/apex/LX_AddProducts?oppId='+oppIdVar;
        PageReference PageRef  = new PageReference (strUrl);
        ApexPages.currentPage().getParameters().put('oppId', oppIdVar);
        System.debug('@@@ ' + strUrl + PageRef);
        return null;
    } 
    public pagereference inlineDeleteLogic(){
        System.debug('@@@ counterToDelete' + counterToDelete);
        Id oppIdVar = ApexPages.currentPage().getParameters().get('oppId');

        List<LX_Opportunity_Pricelist_Product__c> oppPricelistProdSaveList = new List<LX_Opportunity_Pricelist_Product__c>();
        
        try{
            oppPricelistProdSaveList = [Select id, Name, Parent_ID__c, LX_Opportunity__c, LX_Part_Number__c, LX_Product__c, LX_Product__r.Description, LX_Product__r.Name, LX_Quantity__c, LX_Discount__c, LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__r.id =: oppIdVar and LX_Part_Number__c =: savedProductWrapperList[counterToDelete].partNumber];
            System.debug('@@@ oppPricelistProdSaveList ' +oppPricelistProdSaveList[0].id);
            if(oppPricelistProdSaveList.size()>0){
                Database.delete(oppPricelistProdSaveList);
                totalRecs_SavedProducts = totalRecs_SavedProducts - 1;
            }
        }
        catch(Exception ex){
            System.debug('@@@ ' + ex);
            LX_CommonUtilities.createExceptionLog(ex); 
            return RecordsNotInserted();
        }
       /* String querySavedProductsCount = 'Select count() from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c in (\'' + oppIdVar + '\')';
        totalRecs_SavedProducts = Database.countQuery(querySavedProductsCount);*/
        System.debug('@@@ totalRecs_SavedProducts ' + totalRecs_SavedProducts );
        
        Integer totalPageNumber_SavedProducts = getTotalPages_SavedProducts();
        if(totalRecs_SavedProducts == 0){
         //   SavedProductsRenderForm = false;
            System.debug('@@@ All Products Deleted' ); 
      /*      nxt_SavedProducts = true;
            prev_SavedProducts = true;*/
            savedProductWrapperList.clear();
            getSavedProducts();   
        }
        else if (totalRecs_SavedProducts <= LimitSize_SavedProducts){
      //      SavedProductsRenderForm = true;
            nxt_SavedProducts = true;
            prev_SavedProducts = true;
            getSavedProducts();   
        }
        else if(OffsetSize_SavedProducts == ((totalPageNumber_SavedProducts  - 1)*LimitSize_SavedProducts)) {
        //    SavedProductsRenderForm = true;
            prev_SavedProducts = false;
            nxt_SavedProducts = true;
            getSavedDynamicProducts();
        }
        else if(OffsetSize_SavedProducts == 0){
            SavedProductsRenderForm = true;
            prev_SavedProducts = true;
            nxt_SavedProducts = false;
            getSavedDynamicProducts();      
        }
        else{
            SavedProductsRenderForm = true;
            prev_SavedProducts = false;
            nxt_SavedProducts = false;
            getSavedDynamicProducts();          
        }
        PageReference PageRef  = new PageReference ('/apex/LX_AddProducts?oppId='+oppIdVar);
         ApexPages.currentPage().getParameters().put('oppId', oppIdVar);
           return null;
    }  
    public PageReference isRecordChanged(){
        System.debug('@@@ counterVal' + counterVal);
        System.debug('@@@ counterPrevious' + counterPrevious);
        if(counterPrevious == null){
            counterPrevious = counterVal;
            quantityPrevious = savedProductWrapperList[counterVal].oppPriceListProductInstance.LX_Quantity__c;
            discountPrevious = savedProductWrapperList[counterVal].oppPriceListProductInstance.LX_Discount__c;
            return null;
        }
        if(counterPrevious!=counterVal){
            System.debug('@@@ savedProductWrapperList[counterPrevious].oppPriceListProductInstance.LX_Quantity__c' + savedProductWrapperList[counterPrevious].oppPriceListProductInstance.LX_Quantity__c);
            System.debug('@@@ quantityPrevious' + quantityPrevious);      
            savedProductWrapperList[counterPrevious].oppPriceListProductInstance.LX_Quantity__c = quantityPrevious;
            savedProductWrapperList[counterPrevious].oppPriceListProductInstance.LX_Discount__c = discountPrevious;
            
            counterPrevious = null;
                        
            //Below code in this if condition to reRender the savedProductList to get the old values
             Integer totalPageNumber_SavedProducts = getTotalPages_SavedProducts();
            //OffsetSize_SavedProducts = (totalPageNumber_SavedProducts  - 1)*LimitSize_SavedProducts;
            
            if (totalRecs_SavedProducts <= LimitSize_SavedProducts){
                SavedProductsRenderForm = true;
                nxt_SavedProducts = true;
                prev_SavedProducts = true;
                getSavedProducts(); 
            }
            else if(OffsetSize_SavedProducts == ((totalPageNumber_SavedProducts  - 1)*LimitSize_SavedProducts)) {
                SavedProductsRenderForm = true;
                prev_SavedProducts = false;
                nxt_SavedProducts = true;
                getSavedDynamicProducts();
            }
            else if(OffsetSize_SavedProducts == 0){
                SavedProductsRenderForm = true;
                prev_SavedProducts = true;
                nxt_SavedProducts = false;
                getSavedDynamicProducts();      
            }
            else{
                SavedProductsRenderForm = true;
                prev_SavedProducts = false;
                nxt_SavedProducts = false;
                getSavedDynamicProducts();          
            }
           PageReference pRef = productChanged();
           return pRef; 
        }
        return null;
    }
    public PageReference productChanged(){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Selected_Product_Changed));
//        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, '- Please change one product at a time, you may continue editing this product. The previous record won't be saved.'));
        return null;
    } 
    public PageReference NoProductsFound(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_No_Products_Found));    
       return null;
    }
    public PageReference ProductDetailsNotEntered(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Product_Details_Not_Entered));    
       return null;
    }
    public PageReference NoRecordsSelected(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_No_Records_Selected));    
       return null;
    }
    public PageReference NoRecordsToBeDisplayed(){
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_No_Results_Returned));    
       return null;
    }
    public PageReference RecordsNotInserted(){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.LX_Records_Not_Inserted));
        return null;
    }
    public PageReference cancelLogic(){  
        PageReference PageRef  = new PageReference ('/'+oppId);     
        return PageRef ;
    } 
    public PageReference cancelLogicVF(){
        errorPageBlock = false;
       mainFormRender = true;
       mainPageBlockRender=true;
       filterFormRender=true;
       filterPageBlockRender=true;
        PageReference PageRef  = new PageReference ('/apex/LX_AddProducts?oppId='+oppId);  
        System.debug('@@@cancelLogicVF' + '/apex/LX_AddProducts?oppId=' + oppId);  
        ApexPages.currentPage().getParameters().put('oppId', oppId); 
        return PageRef ;
    }
    
    public PageReference saveLogic(){
        List<LX_Opportunity_Pricelist_Product__c> oppPricelistProdList = new List<LX_Opportunity_Pricelist_Product__c>();
       List<String> stringPartNumber = new List<String>();   
       boolean errorFlag=false;
       boolean noRecordsSelected = true;
       boolean isErrorInserting =false;
       Id OppIdVar = ApexPages.currentPage().getParameters().get('oppId');
       List<Opportunity> oppListInstance = [Select id, CurrencyIsoCode from Opportunity where id=: OppIdVar];
       
       for(ProductsWrapper productWrap: productWrapperList){
           if(productWrap.selected==true){
               noRecordsSelected = false;
               String str = productWrap.PartNumber;
               stringPartNumber.add(str);
               if(!(productWrap.oppPriceListProductInstance.LX_Quantity__c!=null && productWrap.oppPriceListProductInstance.LX_Discount__c!=null) || productWrap.oppPriceListProductInstance.LX_Quantity__c<=0 || productWrap.oppPriceListProductInstance.LX_Discount__c<0 ){
                  errorFlag = true;
                  PageReference pRef = ProductDetailsNotEntered();
                  return pRef;
               }
           }
       }
       if(noRecordsSelected){
            PageReference pRef = NoRecordsSelected();
            return pRef;
       }   
       List<Product2> lstProduct = [Select id, Part_Number__c from Product2 where Part_Number__c in: stringPartNumber];
       
       Map<String, Id> mapProductsWrapper= new Map<String, Id>();
       for(Product2 productInstance: lstProduct){
            mapProductsWrapper.put(productInstance.Part_Number__c, productInstance.Id);
       }
     
        if(errorFlag == false){
            for(ProductsWrapper productWrap: productWrapperList){
                if(productWrap.selected == true){
                    System.debug('@@@save' + productWrap);
                    LX_Opportunity_Pricelist_Product__c  oppPricelistProd = new LX_Opportunity_Pricelist_Product__c ();
                    oppPricelistProd.LX_Part_Number__c = productWrap.PartNumber;
                    oppPricelistProd.LX_Discount__c = productWrap.oppPriceListProductInstance.LX_Discount__c ;
                    oppPricelistProd.LX_Opportunity__c = oppId;
                    oppPricelistProd.LX_Quantity__c = productWrap.oppPriceListProductInstance.LX_Quantity__c ;
                    if(mapProductsWrapper.get(productWrap.PartNumber)!=null)
                        oppPricelistProd.LX_Product__c = mapProductsWrapper.get(productWrap.PartNumber);
                    oppPricelistProd.CurrencyIsoCode = oppListInstance[0].CurrencyIsoCode;
                    oppPricelistProdList.add(oppPricelistProd);
                }
            }
        }
        System.debug('@@@@ListOpp' + oppPricelistProdList + oppPricelistProdList.size());
        if(oppPricelistProdList.size()>0 && errorFlag == false){
            try{
                insert oppPricelistProdList;
                totalRecs_SavedProducts = totalRecs_SavedProducts + oppPricelistProdList.size();
            }
            catch(Exception ex){
                isErrorInserting = true;
                LX_CommonUtilities.createExceptionLog(ex);
            }
        }
        
        if(errorFlag == false){
            System.debug('@@ + inserted without errors');           
        
        Integer totalPageNumber_SavedProducts = getTotalPages_SavedProducts();
        //OffsetSize_SavedProducts = (totalPageNumber_SavedProducts  - 1)*LimitSize_SavedProducts;
        
        if (totalRecs_SavedProducts <= LimitSize_SavedProducts){
            SavedProductsRenderForm = true;
            nxt_SavedProducts = true;
            prev_SavedProducts = true;
            getSavedProducts();   
        }
        else if(OffsetSize_SavedProducts == ((totalPageNumber_SavedProducts  - 1)*LimitSize_SavedProducts)) {
            SavedProductsRenderForm = true;
            prev_SavedProducts = false;
            nxt_SavedProducts = true;
            getSavedDynamicProducts();
        }
        else if(OffsetSize_SavedProducts == 0){
            SavedProductsRenderForm = true;
            prev_SavedProducts = true;
            nxt_SavedProducts = false;
            getSavedDynamicProducts();      
        }
            PageReference PageRef  = new PageReference ('/apex/LX_AddProducts?oppId='+oppId);
            ApexPages.currentPage().getParameters().put('oppId', oppId);
            return null;
        }
        else if(noRecordsSelected == true){
            PageReference pRef = NoRecordsSelected();
            return pRef;
        }
        else if(isErrorInserting){
            PageReference pRef = RecordsNotInserted();  
            return pRef;
        }
        else{
            PageReference pRef = ProductDetailsNotEntered();
            return pRef;
        }
    }
    public void lineChanged(){
        //List<SelectOption> options; 
        SeriesListFilter = new List<SelectOption>();
        SeriesListFilter.add(new SelectOption('','--None--'));
        ModelListFilter = new List<SelectOption>();
        System.debug('@@@ lineFilter' + lineFilter);
        if(lineFilter!=null && lineFilter!='' && lineFilter=='Printers'){
            isSeriesNotToBeDisplayed = false;
            AggregateResult[] productModelList = [Select Series__c from Product_Model__c where Line__c= 'Printers' group by Series__c];
            for(AggregateResult prodModel : productModelList){
                String str = (String)prodModel.get('Series__c');
                SeriesListFilter.add(new SelectOption(str,str));
            }
        }
        if(lineFilter!=null && lineFilter!='' && lineFilter=='Options'){
            isModelNotToBeDisplayed = false;
            ModelListFilter.add(new SelectOption('','--None--'));            
            AggregateResult[] productModelList = [Select Model__c from Product_Model__c where Line__c= 'Options' group by Model__c LIMIT 999];
            for(AggregateResult prodModel : productModelList){
                String str = (String)prodModel.get('Model__c');
                ModelListFilter .add(new SelectOption(str,str));
            }            
            System.debug('@@@ lineChanged' + ModelListFilter.size());
        }
        if(lineFilter==null || lineFilter == ''){
            seriesFilter = null;
            familyFilter = null;
            modelFilter = null;   
        }
    }
    public void seriesChanged(){
         FamilyListFilter = new List<SelectOption>();
         FamilyListFilter.add(new SelectOption('','--None--'));
         System.debug('@@@ seriesFilter' + seriesFilter);
         if(seriesFilter!=null && seriesFilter!=''){
             isFamilyNotToBeDisplayed = false;
            AggregateResult[] productModelList = [Select Family__c from Product_Model__c where Series__c =: seriesFilter group by Family__c ];
            for(AggregateResult prodModel : productModelList){
                String str = (String)prodModel.get('Family__c');
                FamilyListFilter.add(new SelectOption(str,str));
            } 
         }
         if(seriesFilter==null || seriesFilter==''){
             isFamilyNotToBeDisplayed =true;
             isModelNotToBeDisplayed = true;
             modelFilter = null;
             familyFilter = null;
         }
        System.debug('@@@ seriesChanged' + FamilyListFilter.size());   
    }
    public void familyChanged(){
         ModelListFilter = new List<SelectOption>();
         ModelListFilter.add(new SelectOption('','--None--'));
         System.debug('@@@ familyFilter' + familyFilter);
         if(familyFilter!=null && familyFilter!=''){
             isModelNotToBeDisplayed = false;
            AggregateResult[] productModelList = [Select Model__c from Product_Model__c where Family__c=: familyFilter group by Model__c];
            for(AggregateResult prodModel : productModelList){
                String str = (String)prodModel.get('Model__c');
                ModelListFilter.add(new SelectOption(str,str));
            } 
         }
         if(familyFilter==null && familyFilter == ''){
             isModelNotToBeDisplayed = true;
             modelFilter = null;
         }
        System.debug('@@@ seriesChanged' + ModelListFilter.size());          
    }
    public void FirstPage()
    {   
        OffsetSize = 0;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        System.debug('@@@1' + OffSetSize);
        if(isFilterApplied){
           getDynamicProductsFilter();
        }
        else{
            getDynamicProducts();
        }
    }
    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        system.debug('OffsetSize == '+OffsetSize);
        if(isFilterApplied){
           getDynamicProductsFilter();
        }
        else{
            getDynamicProducts();
        }
    }
    
    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        if(isFilterApplied){
            getDynamicProductsFilter();
        }
        else{
            getDynamicProducts();
        }
    }
    public void LastPage()
    {
        Integer totalPageNumber = getTotalPages();
        OffsetSize = (totalPageNumber - 1)*LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        System.debug('@@@1' + OffSetSize);
        System.debug('@@@2' + totalrecs);
        System.debug('@@@3' + LimitSize);
        if(isFilterApplied){
           getDynamicProductsFilter();
        }
        else{
            getDynamicProducts();
        }
    } 
  
    public Integer getTotal_size()
    {
        return totalRecs;
    }
  
    
    public integer getTotalPages()
    {
        if(math.mod(totalRecs,LimitSize) > 0)
        {
          return totalRecs/LimitSize + 1;
        }
        else
        {
            return (totalRecs/LimitSize);
        }
    }
    
    public void FirstPage_SavedProducts()
    {  
        OffsetSize_SavedProducts = 0;
        prev_SavedProducts = ((OffsetSize_SavedProducts > 0) ? false : true);
        nxt_SavedProducts = ((OffsetSize_SavedProducts + LimitSize_SavedProducts < totalRecs_SavedProducts) ? false : true);
        System.debug('@@@1' + OffSetSize_SavedProducts);
        getSavedDynamicProducts();
    }
    public void previous_SavedProducts()
    {
        OffsetSize_SavedProducts = OffsetSize_SavedProducts - LimitSize_SavedProducts;
        prev_SavedProducts = ((OffsetSize_SavedProducts > 0) ? false : true);
        nxt_SavedProducts = ((OffsetSize_SavedProducts + LimitSize_SavedProducts < totalRecs_SavedProducts) ? false : true);
        system.debug('OffsetSize == '+OffsetSize_SavedProducts);
        getSavedDynamicProducts();
    }
    
    public void next_SavedProducts()
    {
        OffsetSize_SavedProducts = OffsetSize_SavedProducts + LimitSize_SavedProducts;
        prev_SavedProducts = ((OffsetSize_SavedProducts > 0) ? false : true);
        nxt_SavedProducts = ((OffsetSize_SavedProducts + LimitSize_SavedProducts < totalRecs_SavedProducts) ? false : true);
        getSavedDynamicProducts();
    }
    public void last_SavedProducts()
    {
        Integer totalPageNumber = getTotalPages_SavedProducts();
        OffsetSize_SavedProducts = (totalPageNumber - 1)*LimitSize_SavedProducts;
        prev_SavedProducts = ((OffsetSize_SavedProducts > 0) ? false : true);
        nxt_SavedProducts = ((OffsetSize_SavedProducts + LimitSize_SavedProducts < totalRecs_SavedProducts) ? false : true);
        System.debug('@@@1' + OffSetSize_SavedProducts);
        System.debug('@@@2' + totalrecs_SavedProducts);
        System.debug('@@@3' + LimitSize_SavedProducts);
        getSavedDynamicProducts();
    }
    
    public Integer getPageNumber_SavedProducts()
    {
        system.debug('OffsetSize = '+OffsetSize_SavedProducts);
        system.debug('LimitSize = '+LimitSize_SavedProducts);
        system.debug('totalRecs = '+totalRecs_SavedProducts);
        decimal doffSetSize = OffsetSize_SavedProducts;
        Decimal divDec = doffSetSize.divide(LimitSize_SavedProducts, 0, System.RoundingMode.UP);
        system.debug('divDec = '+divDec);
        return integer.valueOf(divDec + 1);
    }
    public Integer getTotal_size_SavedProducts()
    {
        return totalRecs_SavedProducts;
    }
  
    
    public integer getTotalPages_SavedProducts()
    {
        if(math.mod(totalRecs_SavedProducts,LimitSize_SavedProducts) > 0)
        {
          return totalRecs_SavedProducts/LimitSize_SavedProducts + 1;
        }
        else
        {
            return (totalRecs_SavedProducts/LimitSize_SavedProducts);
        }
    }

    public class ProductsWrapper{
        public String ProductName{get;set;}
        public String PartNumber{get;set;}
        public String Description{get;set;}
    /*    public Integer Quantity{get;set;}
        public Double Discount{get;set;}*/
        public LX_Opportunity_Pricelist_Product__c oppPriceListProductInstance{get;set;}
        public boolean selected{get;set;}
        public Integer counter{get;set;}
        public ProductsWrapper(){
            this.selected = false;
            oppPriceListProductInstance = new LX_Opportunity_Pricelist_Product__c() ;
        }
    }
}