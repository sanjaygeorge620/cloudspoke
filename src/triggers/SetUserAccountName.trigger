/******************************************************************************

Name     : SetUserAccountName

Purpose  : set the account name based on the user contact record

Author   : jennifer dauernheim

Date     : March 15, 2010

******************************************************************************/

trigger SetUserAccountName on User_Registration__c(before insert, before Update){
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    Set<ID> idSet = new Set<ID>();
    for (User_Registration__c regRec : Trigger.new)
        idSet.add(regRec.Master_Contact__c);
    
    Map<ID, Contact> idToRegMap = new Map<ID, Contact>([select id, AccountID from Contact where id in :idSet]);
    
    for (User_Registration__c regRec : Trigger.new)
    //system.debug('******regRec.user_Account__c ' + regRec.User_Account__c);
    
        if (regRec.User_Account__c == null){
            system.debug('******regRec.user_Account__c ' + regRec.User_Account__c);
            system.debug('******regRec.user_Account__c ' + idToRegMap.get(regRec.Master_Contact__c).AccountID);
            regRec.User_Account__c = idToRegMap.get(regRec.Master_Contact__c).AccountID;
            system.debug('******regRec.user_Account__c  after' + regRec.User_Account__c);
        }

    }