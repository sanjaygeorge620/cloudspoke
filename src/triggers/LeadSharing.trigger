trigger LeadSharing on Lead (after insert, after update) {

   if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code

    //for each lead that comes in, if has a primary partner, put into list of ids that will be sent to the recordsharing class
    
    Set<ID> LeadIdSet = new Set<ID>();
    Set<ID> AcctIdSet = new Set<ID>();
    
     //get listing of opportunities
     for (Lead  LeadRec : Trigger.new){
        
        system.debug('LeadRec.Primary_Partner__c' + LeadRec.Primary_Partner__c);
        If(LeadRec.Primary_Partner__c <> null && trigger.isInsert ||
               trigger.isUpdate && trigger.oldMap.get(LeadRec.id).Primary_Partner__c != LeadRec.Primary_Partner__c && LeadRec.Primary_Partner__c <> null
               )
            system.debug('met Criteria');
            LeadIdSet.add(leadRec.id);
            system.debug('LeadIdSet:' + LeadIdSet);  
            If(trigger.isUpdate){
                AcctIdSet.add(trigger.oldMap.get(LeadRec.id).Primary_Partner__c);
                system.debug('acctIDSet:' + AcctIdSet);
            }
     }
     
     if(leadIDSet.size()>0){
        if(acctIDSet.size()>0){
            recordSharing_Removal.manualShare_Lead_Removal(LeadIdSet, AcctIDSet);
        }   
        recordSharing.manualShare_Lead_Read(LeadIdSet);
     }
    

}