/* Trigger Name : LX_Program_Offer_AI_AU_BI_BU_BD_AD 
 * Description : Delete the program offers and related enrollment offers.
 * Created By : Kapil
 * Created Date : 30-09-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer       Date           Modification ID      Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Kapil           30-09-2013     1000                 Initial Version 
 */

trigger LX_Program_Offer_AI_AU_BI_BU_BD_AD on LX_Program_Offer__c (after delete){
if(LX_CommonUtilities.ByPassBusinessRule()) return;
    set<id> offersToDelete = new set<id>();
    if(trigger.isDelete && trigger.isAfter){
        for(LX_Program_Offer__c prgOffer:trigger.old){
            offersToDelete.add(prgOffer.id);
        }
    }
    LX_ProgramOfferUtil prgOfferUtil = new LX_ProgramOfferUtil();
    prgOfferUtil.deleteProgramOffers(offersToDelete);    
    
}