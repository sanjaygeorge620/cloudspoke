/*********************************************************************************
Name : OpportunityLineItemGrouping 
Created By : Bharti Mehta(Appirio Offshore)
Created Date : 21 Dec 2010
Usages : This trigger prepares set of Id of opportunities with Stage = 'Closed Won' 
         and later again when Quote_Status__c updated to 'Finalized' and calls a future 
         method OpportunityLineItemGrouping.UpdateLineItemGroupingInfo for that set

//MFitzgerald removed @future and changed trigger to accomodate sychronous processing
*********************************************************************************/

trigger OpportunityLineItemGrouping on Opportunity (before update) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return;  
 
    list<opportunity> opportunities = new list<Opportunity>();
    for(Opportunity opportunity : Trigger.New){
         System.debug('OpportunityLineItemGrouping: Opportunity: ' + Opportunity);
         if(opportunity.StageName == 'Closed Won' && opportunity.SAP_Sent__c != 'Yes'){
            opportunities.add(opportunity);
         }
    }

    System.debug('OpportunityLineItemGrouping: Opportunities to process: ' + opportunities.size() + ' RECORDS: '+ opportunities);
    if(opportunities.size() > 0){
        LX_OpportunityHelper.OpportunityLineItemGrouping = true;
        OpportunityLineItemGrouping.UpdateLineItemGroupingInfo(opportunities);
    }
}