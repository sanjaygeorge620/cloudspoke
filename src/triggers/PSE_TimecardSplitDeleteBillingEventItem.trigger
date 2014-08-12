trigger PSE_TimecardSplitDeleteBillingEventItem on pse__Timecard__c (after update) {
    
    Set<ID> setTimecardSplitIds = new Set<ID>();
    List<pse__Billing_Event_Item__c> listBillingEventItems = new List<pse__Billing_Event_Item__c>();
    
    for(ID timecardSplitId : trigger.newMap.keySet()) {
        
        if(trigger.newMap.get(timecardSplitId).pse__Status__C == 'Rejected' && trigger.oldMap.get(timecardSplitId).pse__Status__C == 'Approved' && trigger.newMap.get(timecardSplitId).pse__Billed__c == false) {
            setTimecardSplitIds.add(timecardSplitId);
        }
    }
    
    for(pse__Timecard__c timecard : [Select pse__Billing_Event_Item__c
                                            From pse__Timecard__c 
                                            where Id 
                                            IN :setTimecardSplitIds]) {
        
        if(timecard.pse__Billing_Event_Item__c != null) {
            listBillingEventItems.add(new pse__Billing_Event_Item__c(id=timecard.pse__Billing_Event_Item__c));
        }
    }
    
    system.debug('******************************listBillingEventItems:'+listBillingEventItems);
    if(listBillingEventItems.size() > 0){
        delete listBillingEventItems;
    }
}