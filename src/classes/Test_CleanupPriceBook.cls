/**
 * Test class for CleanupPriceBook
 */
@isTest
private class Test_CleanupPriceBook {

    static testMethod void testDeletePriceBookMaker() {
        Price_Book_Maker__c priceBookMaker = new Price_Book_Maker__c(Name='test Price Book' ,Status__c = 'Submitted');
        insert priceBookMaker;
        loadCorePriceBooks(priceBookMaker.id);
        loadPublishedPriceBooks(priceBookMaker.id);
        Test.StartTest();
        CleanupPriceBook.deletePriceBookMaker(priceBookMaker.Id);
        Test.StopTest();
    }
    
    public static void loadCorePriceBooks(Id priceBookMakerId){
        List<Core_Price_Book__c> cores = new List<Core_Price_Book__c>();
        for(integer i =0; i< 100;i++){
            Core_Price_Book__c  cp = new Core_Price_Book__c(Product_Name__c = 'Test CPB -'+i, price_Book_Maker_ID__c = priceBookMakerId);
            cores.add(cp);
        }
        insert cores;
    }
    
    public static void loadPublishedPriceBooks(Id priceBookMakerId){
        List<Published_Price_Book__c> published = new List<Published_Price_Book__c>();
        for(integer i =0; i< 120;i++){
            Published_Price_Book__c  pub = new Published_Price_Book__c(Product_Name__c = 'Test CPB -'+i, price_Book_Maker_ID__c = priceBookMakerId);
            published.add(pub);
        }
        insert published;
    }
    
    
}