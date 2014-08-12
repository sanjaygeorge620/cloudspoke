trigger UpdatePaymentTermsFromAccount on Opportunity (Before Insert) {
 
    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
 
 Set<Id> setAccountIds = new Set<Id>();

    for(Opportunity opportunity : trigger.New){
        if(opportunity.AccountId != null)
            setAccountIds.add(opportunity.AccountId);
    }
    
   Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id,Payment_Terms__c FROM Account WHERE Id in :setAccountIds and Payment_Terms__c != null]);
   for(Opportunity Opp : Trigger.new){
       if(accountMap.containsKey(opp.AccountId)){
        Opp.Payment_Terms__c = accountMap.get(opp.AccountId).Payment_Terms__c;
       }
    }

}