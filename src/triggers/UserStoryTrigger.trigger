trigger UserStoryTrigger on Requirements__c (before update,after update){
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    if (trigger.isBefore && trigger.isUpdate) {
           Map<Id,String> mapStoryAC = new Map<Id,String>();
           
           for ( Requirements__c thisRequirement : trigger.new)
            {
               if(thisRequirement.Acceptance_Criteria__c!=trigger.oldMap.get(thisRequirement.id).Acceptance_Criteria__c)
                   mapStoryAC.put(thisRequirement.id , trigger.oldMap.get(thisRequirement.id).Acceptance_Criteria__c);  
            }
            UserStoryTriggerClass.createNewACHistoryRecord(mapStoryAC);
    }
    
    //autoburndown
    if(trigger.isAfter && trigger.isUpdate){
        Set<Id> affectedSprints = new Set<Id>();
        for(Requirements__c us:trigger.new){
            affectedSprints.add(us.Allocated_Sprint__c);
        }
        for(Id sprint:affectedSprints){
            automateBurnDown.updateSprintBurndown(sprint);
        }
    }
            
                    
}