trigger AccountSharing on Account(after insert, after update) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    
   //for each lead that comes in, if has a primary partner, put into list of ids that will be sent to the recordsharing class
    
    Set<ID> newAcctIdSet = new Set<ID>();
    Set<ID> AcctIdSet = new Set<ID>();
    
     //get listing of opportunities
     for (Account acctRec : Trigger.new){
        
      //  system.debug('oppRec.Primary_Partner__c' + oppRec.Primary_Partner__c);
        If(acctRec.Reseller_ID__c <> null && trigger.isInsert && FirstRun_Check.FirstRun_AccountSharing ||  
                    trigger.isUpdate && trigger.oldMap.get(acctRec.id).Reseller_ID__c != acctRec.Reseller_ID__c && acctRec.Reseller_ID__c <> null && trigger.isUpdate && FirstRun_Check.FirstRun_AccountSharing)
        
             {  
                system.debug('met Criteria');
                newAcctIdSet.add(acctRec.id);
                system.debug('newAcctIdSet :' + newAcctIdSet );  
                
                If(trigger.isUpdate){
                    AcctIdSet.add(trigger.oldMap.get(acctRec.id).Reseller_ID__c);
                    system.debug('acctIDSet:' + AcctIdSet);
                
                }
            }
     }
     
     if(newAcctIdSet .size()>0){
        if(acctIDSet.size()>0){
            recordSharing_Removal_Account.manualShare_Account_Removal(newAcctIdSet , AcctIDSet);
        }   
        recordSharing_Account.manualShare_Account_Read(newAcctIdSet );
     }
}