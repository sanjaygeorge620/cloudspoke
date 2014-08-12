trigger LX_BI_BU on LX_Offer__c (Before Insert,Before Update,after insert,after update) {

    //Added ByPass Logic on 12/23/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;

    //Declare a set to store country values
    Set<String> setCountries = new Set<String>();
    //Get offer records whose status is Inactive/Active.
    Map<Id,String> offerStatusMap = new Map<id,string>();
    
    for(LX_Offer__c objOffer : Trigger.New)
    {
        setCountries.add(objOffer.salesRegion_quote__c);
        //Check the status and add record id to Set
        if(objOffer.LX_Offer_Status__c == 'Inactive' || objOffer.LX_Offer_Status__c == 'Active')
            offerStatusMap.put(objOffer.ID,objOffer.LX_Offer_Status__c);
    }
    
    //Assign sales Org value based on country selected in Offer record.
    // Sumedha - 2/5 : Added code to check if the currency on Offer is present in the list of 
    // available currencies from related sales org 
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        lx_Offer_Utils.AssignSalesOrg(trigger.new,setCountries);
        lx_Offer_Utils.validateCurrency(trigger.new);
        
    }
    
    //Check if any quote is associated to these offers.
    if(trigger.isBefore && trigger.isUpdate)
    {
        lx_Offer_Utils.offerQuoteAssociation(trigger.newMap,trigger.newMap.keySet(),trigger.oldMap);
    }
    
    if((trigger.isInsert || trigger.isUpdate) && trigger.isAfter){//Update enrollment status on update/insert of Offer 
        system.debug('offerStatusMap-->'+offerStatusMap);
        if(offerStatusMap != null && !offerStatusMap.isEmpty())
        {
            //Declare a map to store record id and status 
            LX_ProgramOfferUtil objProgramUtil = new LX_ProgramOfferUtil();
            objProgramUtil.updateOfferEnrollmentStatus(null,offerStatusMap);   //Update enrollment status             
        }
    }

}