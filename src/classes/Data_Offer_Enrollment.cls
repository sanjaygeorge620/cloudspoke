/**
**Author : Kapil
**Date : 1/27/2014
**Objective: To Create Offer Enrollment Data.
** 
**
**/
@istest(seeAllData = true)
public class Data_Offer_Enrollment{
    public static List<LX_Offer_Enrollment__c> createOfferEnrollments(Account acc ,Integer noOfRecords){        
        List<LX_Offer_Enrollment__c> offerEnrollmentsList = new List<LX_Offer_Enrollment__c> ();
        LX_Offer_Enrollment__c offerEnrollment;
        List<LX_Offer__c> offerList = Data_Offer.createOffers(noOfRecords,LX_SetRecordIDs.VIRRecordtypeID); 
        Integer i;
        for(i=0 ; i < noOfRecords; i++){
            offerEnrollment = new LX_Offer_Enrollment__c (); 
            offerEnrollment.Account__c = acc.id;
            offerEnrollment.LX_Product_Line_Items__c ='Printers';
            offerEnrollment.LX_Timing_of_Discount__c ='Back-end';
            offerEnrollmentsList.add(offerEnrollment);
            offerEnrollment.Offer__c = offerList [i].id;
        }//end of for loop
        Insert offerEnrollmentsList;
        
        return offerEnrollmentsList;        
    }
    
     static testMethod void testTestData() {
         Account acc = data_account.createAccount10();
         
         List<LX_Offer_Enrollment__c> offerList = Data_Offer_Enrollment.createOfferEnrollments(acc,2);           
    } 
}