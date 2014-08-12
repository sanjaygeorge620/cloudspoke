/******************************************************************************
Name     : UpdateCaseFields
Purpose  : set the ms fields on the case
Author   : jennifer dauernheim
Date     : July 10, 2009
******************************************************************************/
trigger UpdateCaseFields on Case (before insert, before Update){

    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 
    
   Set<ID> idSet = new Set<ID>();
    for (case caseRec : Trigger.new)
        idSet.add(caseRec.Account_ID__c);
    
    Map<ID, Account> idToCaseMap = new Map<ID, Account>([select id,
            remote_Administration__c, GSS_Monitored__c, FOCI__c, platform_services__c, subscription__c from Account where id in :idSet]); // Added GSS_Monitoring -- Arun S. for US2175
    
    for (case caseRec : Trigger.new)
        if (idToCaseMap.get(caseRec.Account_ID__c) != null){
            caseRec.remote_Administration__c = idToCaseMap.get(caseRec.Account_ID__c).Remote_Administration__c; // Added by Arun S. for US2175
            caseRec.GSS_Monitored__c = idToCaseMap.get(caseRec.Account_ID__c).GSS_Monitored__c;
            caseRec.FOCI__c = idToCaseMap.get(caseRec.Account_ID__c).FOCI__c;
            caseRec.Platform_Services__c = idToCaseMap.get(caseRec.Account_ID__c).platform_services__c;
            caseRec.Subscription__c = idToCaseMap.get(caseRec.Account_ID__c).subscription__c;
        }    

    }