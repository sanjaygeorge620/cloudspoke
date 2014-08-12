/**
**Author : Kapil
**Date : 1/27/2014
**Objective: To Create Offer Data.
** 
**
**/
@istest(seeAllData = true)
public class Data_Offer{
    public static List<LX_Offer__c> createOffers(Integer noOfRecords,string recordtypeId){
        List<LX_Offer__c> offersList = new List<LX_Offer__c> ();
        LX_Offer__c offer;
        Integer i;
        for(i=0 ; i < noOfRecords; i++){
            offer = new LX_Offer__c();            
            offer.Name = 'Offer' + i;
            offer.LX_Country__c = 'USA';
            offer.LX_Region__c = 'USA';
            offer.LX_Country__c = 'North America';
            offer.LX_Start_Date__c = system.today();
            offer.LX_End_Date__c = system.today()+200;
            offer.recordtypeId = recordtypeId;
            offersList.add(offer);
        }//end of for loop
        Insert offersList ;        
        return offersList ;        
    }
    
    static testMethod void testTestData() {
         List<LX_Offer__c> offerList = Data_Offer.createOffers(2,LX_SetRecordIDs.VIRRecordtypeID);           
    } 
}