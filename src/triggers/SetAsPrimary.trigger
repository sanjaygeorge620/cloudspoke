trigger SetAsPrimary on Dealer__c(after insert, after update){
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    Set<Id> dealerIds = new Set<Id>();
    Set<Id> dealerOppIds= new Set<Id>();
    List<Dealer__c> dealerObj = new List<Dealer__c>();
    
    if(trigger.isUpdate || trigger.isInsert){
    
        // Populating the Dealer record Ids and the Opportunity Ids in Set.
        for(Dealer__c dObj: Trigger.new){
        
            if(dObj.Primary_Dealer__c == true){
            
                dealerIds.add(dObj.Id);
                dealerOppIds.add(dObj.Opportunity_Name__c);
            }
        }
        
        if(dealerIds != null && dealerIds.size()>0 && dealerOppIds != null && dealerOppIds.size()>0){        
            for(Dealer__c dto: [SELECT Id, Opportunity_Name__c, Primary_Dealer__c FROM Dealer__c WHERE Opportunity_Name__c IN :dealerOppIds AND Id NOT IN :dealerIds]){
                dto.Primary_Dealer__c = false;
                dealerObj.add(dto);
            }                
        }
        
        // Update Dealet Records.
        if(dealerObj != null && dealerObj.size()>0)
        update dealerObj;
    }
}