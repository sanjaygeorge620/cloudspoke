/**
 * Test Class for PriceBookCleanup
 */
@isTest
private class Test_PriceBookCleanup {

    static testMethod void testDeleteCorePriceBook() {
       Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Submitted');
        insert priceBookMaker;
        loadCorePriceBooks(priceBookMaker.id);
        Test.StartTest();
        PriceBookCleanup corePBBatchedProcess = new PriceBookCleanup(priceBookMaker.id, 'DeleteCorePriceBooks');
        Database.executeBatch(corePBBatchedProcess, 10);
        Test.StopTest();
    }
    
    
     static testMethod void testDeletePPBProcess() {
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Submitted');
        insert priceBookMaker;
        loadPublishedPriceBooks(priceBookMaker.id);
        Test.StartTest();
        PriceBookCleanup publishedPBBatchedProcess = new PriceBookCleanup(priceBookMaker.Id,'DeletePublishedPriceBooks');
        Database.executeBatch(publishedPBBatchedProcess,10);
        Test.StopTest();
    }
    public static void loadCorePriceBooks(Id priceBookMakerId){
        List<Core_Price_Book__c> cores = new List<Core_Price_Book__c>();
        for(integer i =0; i< 10;i++){
            Core_Price_Book__c  cp = new Core_Price_Book__c(Product_Name__c = 'Test CPB -'+i, price_Book_Maker_ID__c = priceBookMakerId);
            cores.add(cp);
        }
        insert cores;
    }
    
    public static void loadPublishedPriceBooks(Id priceBookMakerId){
        List<Published_Price_Book__c> published = new List<Published_Price_Book__c>();
        for(integer i =0; i< 10;i++){
            Published_Price_Book__c  pub = new Published_Price_Book__c(Product_Name__c = 'Test CPB -'+i, price_Book_Maker_ID__c = priceBookMakerId);
            published.add(pub);
        }
        insert published;
    }
}