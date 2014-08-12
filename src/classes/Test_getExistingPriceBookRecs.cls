@isTest(SeeAllData=true)
public class Test_getExistingPriceBookRecs{
    
    static Account testAcc;
    static Published_Price_Book__c testPubPriceBook;
    static Published_Price_Book__c testPubPriceBook1;
    public static testmethod void testExistingPriceBookRecs()
    {    
        testAcc = new Account();
        testAcc = Data_Account.createAccount();
        
        test.startTest();
        testPubPriceBook = new Published_Price_Book__c();
        testPubPriceBook.name = 'testPubPriceBook';
        testPubPriceBook.Part_Number__c = 'testPartNumber';
        testPubPriceBook.Sales_Organization__c = 'testSalesorg';
        testPubPriceBook.CurrencyIsoCode = 'USD';
        testPubPriceBook.Price_Book_Type__c = 'testPriceBookType';
        insert testPubPriceBook ;
        
        testPubPriceBook1 = new Published_Price_Book__c();
        testPubPriceBook1.Account__c = testAcc.Id;
        testPubPriceBook1.name = 'testPubPriceBook';
        testPubPriceBook1.Part_Number__c = 'testPartNumber';
        testPubPriceBook1.Sales_Organization__c = 'testSalesorg';
        testPubPriceBook1.CurrencyIsoCode = 'USD';
        testPubPriceBook1.Price_Book_Type__c = 'testPriceBookType';
        insert testPubPriceBook1 ;
        
        Set<String> partNumSet = new Set<String>();
        partNumSet.add('testPartNumber');
        Set<String> salesOrgSet = new Set<String>();
        salesOrgSet.add('testSalesorg');
        Set<String> currencyCodeSet = new Set<String>();
        currencyCodeSet.add('USD');
        Set<String> pricebooknameSet = new Set<String>();
        pricebooknameSet.add('testPubPriceBook');
        Set<String> pricebooktypeSet = new Set<String>();
        pricebooktypeSet.add('testPriceBookType');
        
        Map<String, Published_Price_Book__c> returnMap = new Map<String, Published_Price_Book__c>();
        returnMap = getExistingPriceBookRecs.getExistingPriceBookRecs(partNumSet ,salesOrgSet ,currencyCodeSet ,pricebooknameSet ,pricebooktypeSet );
        test.stopTest();
    }
}