/* Class Name   : LX_Test_lx_Offer_Utils
 * Description  : Test Class to test lx_Offer_Utils
 * Created By   : Abhishek Kumar
 * Created On   : 14-Jan-14

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Abhishek Kumar           14-Jan-14          Initial version
*/

@isTest(seeAllData=true)
private class LX_Test_lx_Offer_Utils {
    
    static List<LX_Offer__c> offlst;
    static List<Sales_Organization__c> sOrglst;
    static set<String> cntrySet;
    static Map<Id,LX_Offer__c> offIdMap1;
    static Map<Id,LX_Offer__c> offIdMap2;
    static set<Id> ofIdset;
    
    public static void createOfferLst(){
    
        offlst = new List<LX_Offer__c>();
        
        for(integer i=1;i<=3;i++)
        {
            LX_Offer__c offRecord = new LX_Offer__c();
            offRecord.Name = 'TestOffer'+ i ;
            offRecord.Lx_Program__c = 'Deal';
            offRecord.RecordTypeId=LX_SetRecordIDs.priceProtectionOfferId;
            offRecord.salesRegion_quote__c = '1234';
            offRecord.daysClaimDueIn_quote__c = '54'; 
            offRecord.LX_Start_Date__c = Date.today(); 
            offRecord.LX_End_Date__c = Date.today()+ 5;
        
            offlst.add(offRecord); 
        }
        
        insert offlst;
    
    }
    
    public static void createSalesOrg()
    {
        sOrglst = new List<Sales_Organization__c>();
        
        sOrglst.add(new Sales_Organization__c(Name='Germany',LX_Default__c=true,Sales_Organization__c='1234'));
        sOrglst.add(new Sales_Organization__c(Name='India',LX_Default__c=true,Sales_Organization__c='7890'));
        sOrglst.add(new Sales_Organization__c(Name='USA',LX_Default__c=true,Sales_Organization__c='4567'));
        
        insert sOrglst;
    }
    
    public static void createCountry()
    {
        cntrySet = new set<String>();
        cntrySet.add('Germany');
        cntrySet.add('India');
        cntrySet.add('USA');
    }
    
    public static void createBMQuote()
    {
        BigMachines__Quote__c quote = new BigMachines__Quote__c();
        quote.Offer__c = offlst[0].id;
        
        insert  quote ;
    }
    public static void createOfferMap()
    {
        offIdMap1 = new Map<Id,LX_Offer__c>();
        offIdMap2 = new Map<Id,LX_Offer__c>();
        ofIdset = new set<Id>();
        for(LX_Offer__c off:offlst)
        {
            offIdMap1.put(off.Id,off);   
            offIdMap2.put(off.Id,off);
            ofIdset.add(off.Id);   
        }
    }
    
    static testmethod void offerUtil()
    {
        test.startTest();
        createCountry();
        createOfferLst();
        createSalesOrg();
        createBMQuote();
        createOfferMap();
        
         lx_Offer_Utils.AssignSalesOrg(offlst,cntrySet); 
         
         lx_Offer_Utils.offerQuoteAssociation(offIdMap1,ofIdset,offIdMap2);
         test.stopTest();
    }
    
}