trigger AccountTypeOpportunity on Account (before insert,before update, after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
 if(Trigger.isUpdate && Trigger.new[0].Type != Trigger.old[0].Type &&(Trigger.new[0].Type=='Partner-DCP'||Trigger.new[0].Type=='Partner-Referal'||Trigger.new[0].Type=='Partner-other'||Trigger.new[0].Type=='Partner-PSDN'||
 Trigger.new[0].Type=='Partner-SDK'||Trigger.new[0].Type=='Partner-Channel Level 1'||Trigger.new[0].Type=='Partner-Channel Level 2'||Trigger.new[0].Type=='Partner-Channel Level 3'||Trigger.new[0].Type=='Partner-Channel Porspect'||Trigger.new[0].Type=='Partner-Channel Level 1'
||Trigger.new[0].Type=='Partner-Porspect'||Trigger.new[0].Type=='Partner-OEM'||Trigger.new[0].Type=='Partner-System Integration'||Trigger.new[0].Type=='Pallas-Reseller'||Trigger.new[0].Type=='Pallas-OEM'))
 {
    System.debug('Opportunity...');
    list<Opportunity> AllOpp = new list<Opportunity>([select id,name from Opportunity where AccountId =:Trigger.new[0].Id or 
                                                                                 Primary_Partner__c  =:Trigger.new[0].Id]);
    if(!AllOpp.isEmpty())
    {
    System.debug('Do more logic here...'); 
        for(Opportunity oo :AllOpp)
        {
        System.debug('opp'); 
            oo.AccountTypeUpdate__c = Trigger.new[0].Type;
        }
        try
        {
        System.debug('update opp'); 
            update AllOpp;
        }catch(exception ex){

        }
    }
 }
 
 // Case 00030358
 Map<Id,Account> acctMap = new MAp<Id,Account>(); 
 if(Trigger.isUpdate && Trigger.isAfter) {
     for (Account accObj : Trigger.new) {
         if (accObj.RA__c != Trigger.oldMap.get(accObj.id).RA__c) {
             acctMap.put(accObj.id, accObj);
         }    
     }
     
     list<Opportunity> oppList = new list<Opportunity>([select id,name,RA_Email__c,AccountId from Opportunity where AccountId in :acctMap.keySet()]);
     if (oppList.size() > 0) {
         for (Opportunity opp : oppList) {
             if (acctMap.get(opp.AccountId).RA__r != null) {
                 opp.RA_Email__c = acctMap.get(opp.AccountId).RA__r.Email;
             }    
         }
     update oppList;    
    }    
 }
 
}