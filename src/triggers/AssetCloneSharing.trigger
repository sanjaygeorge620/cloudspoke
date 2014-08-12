trigger AssetCloneSharing on Asset_Clone__c (after insert, after update) {

    //for each lead that comes in, if has a primary partner, put into list of ids that will be sent to the recordsharing class
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    Set<ID> assetIdSet = new Set<ID>();
    Set<ID> AcctIdSet = new Set<ID>();
    
     //get listing of opportunities
     for (Asset_Clone__c  assetRec : Trigger.new){
        system.debug('assetRec.Account__c:' + assetRec.Account__c);
        system.debug('assetRec.Reseller_ID__c' + assetRec.Reseller_ID__c);
        If(assetRec.Reseller_ID__c <> null && trigger.isInsert ||
               trigger.isUpdate && trigger.oldMap.get(assetRec.id).Reseller_ID__c != assetRec.Reseller_ID__c 
               && assetRec.Reseller_ID__c <> null){
            system.debug('met Criteria');
            assetIdSet .add(assetRec.id);
            system.debug('assetIdSet :' + assetIdSet );  
            If(trigger.isUpdate){
                AcctIdSet.add(trigger.oldMap.get(assetRec.id).Reseller_ID__c);
                system.debug('acctIDSet:' + AcctIdSet);
            }
         }
     }
     
     if(assetIdSet .size()>0){
        if(acctIDSet.size()>0){
            recordSharing_Removal_Asset_Clone.manualShare_Asset_Clone_Removal(assetIdSet , AcctIDSet);
        }   
        recordSharing_Asset_Clone.manualShare_Asset_Clone_Read(assetIdSet );
     }
}