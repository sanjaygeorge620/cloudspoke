/* Class Name   : LX_Test_LX_CreateQuote_Offer
 * Description  : Test Class to test LX_CreateQuote_Offer and LX_Offer_Update_on_Quote_Update Trigger on Quote
 * Created By   : Abhishek Kumar
 * Created On   : 14-Jan-14

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Abhishek Kumar           14-Jan-14          Initial version
*/

@isTest(seeAllData=true)
private class LX_Test_LX_CreateQuote_Offer {

    static LX_Offer__c offRecord;
    static BigMachines__Quote__c quote;
    
    public static void createOffer()
    {
        offRecord = new LX_Offer__c();
        offRecord.Name = 'TestOffer' ;
        offRecord.Lx_Program__c = 'Deal';
        offRecord.RecordTypeId=LX_SetRecordIDs.priceProtectionOfferId;
        offRecord.daysClaimDueIn_quote__c = '54'; 
        offRecord.LX_Start_Date__c = Date.today(); 
        offRecord.LX_End_Date__c = Date.today()+ 5;
        
        insert offRecord ;
    
    }
    
    public static void createBMQuote()
    {
        quote = new BigMachines__Quote__c();
        quote.Offer__c = offRecord.id;
        
        insert  quote ;
    }
    
    public static void updateBMQuote()
    {
        quote.BigMachines__Status__c = 'Finalized';
        update quote;
    }
    
    static testmethod void offerEnrollment()
    {
        createOffer();
        createBMQuote();
        
        pageReference pgRef = Page.LX_CreateQuote_Offer;
        pgRef.getparameters().put('offerId',offRecord.Id);
        test.setCurrentPage(pgRef);
        
        LX_CreateQuote_Offer offerQuot = new LX_CreateQuote_Offer(new ApexPages.StandardController(offRecord));
        offerQuot.checkQuote();
    }
    
    static testmethod void offerUpdate()// test method to cover LX_Offer_Update_on_Quote_Update Tigger
    {
        createOffer();
        createBMQuote();
        updateBMQuote();
    }

}