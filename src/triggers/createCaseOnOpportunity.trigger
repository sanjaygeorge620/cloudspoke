//
// (c) 2010 Appirio , Inc.  pbondalapati@appirio.com
//
//   Create a case if opportunity stage is equal to validation and account record type is equal to prospect unlocked 
//
// 12/08/2010 created
//

trigger createCaseOnOpportunity on Opportunity (after insert, after update) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
    
    Set<Id> opportunityIdSet = new Set<Id>();
    
                
    if(Trigger.isInsert){
        for(Opportunity opportunity : Trigger.New){
            if(CreateCaseOnOpportunity.isCaseCreationRequired(opportunity.StageName, null)){
                 opportunityIdSet.add(opportunity.id);
            }
        }
    }
    if(Trigger.isUpdate){
        for(Opportunity opportunity : Trigger.New){
            System.debug('--New Stage--'+opportunity.stageName+'---Old Stage---'+Trigger.oldMap.get(opportunity.id).stageName);
            if(CreateCaseOnOpportunity.isCaseCreationRequired(opportunity.stageName,Trigger.oldMap.get(opportunity.id).stageName)){
                     opportunityIdSet.add(opportunity.id);
            }
        }
    }
    system.debug('opportunityIdSet.size(): ' + opportunityIdSet.size());
    if(opportunityIdSet.size() > 0 && FirstRun_check.FirstRun_afterInsertUpdate ){
        system.debug('about to call afterinsert update');
        CreateCaseOnOpportunity.afterInsertUpdate(opportunityIdSet ); 
        FirstRun_check.FirstRun_afterInsertUpdate = false;
    }
    
    
}