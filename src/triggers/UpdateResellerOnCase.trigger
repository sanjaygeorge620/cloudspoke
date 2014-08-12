/******************************************************************************
Name     : UpdateResollerOnCase
Purpose  : Set the Reseller name based on the information retrieved from the account
Author   : Jennifer Dauernheim
Date     : July 10, 2009
******************************************************************************/

trigger UpdateResellerOnCase on Case (before insert, before update) {

    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 
    
    Set<ID> idSet = new Set<ID>();
    Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Id recordTypeId = rtMapByName.get('License - External').getRecordTypeId();
    for (Case caseRec : Trigger.new){
        system.debug('caseRec:' + caseRec);
        system.debug('caseRec.RecordType: ' + caseRec.RecordType);
        system.debug('caseRec.RecordTypeId: ' + caseRec.RecordType.id);
        system.debug('recordTypeId: ' + recordTypeId);
        If(caseRec.RecordTypeId != recordTypeID){
            idSet.add(CaseRec.Accountid);
        }
  //      system.debug('caseRec.accountid:' + CaseRec.Accountid);
    }
    if(idSet.size() > 0){
        Map<ID, Account> idToAccountMap = new Map<ID, Account>([select id,  Reseller_ID__r.Name from Account where id in :idSet 
            and Reseller_ID__c != Null and Reseller_ID__c != '']);
        
            
  //  system.debug('Size of Map' + idToAccountMap.size());
        
        for(Case caseRec : trigger.new){  
            Account accObject = idToAccountMap.get(caseRec.Account_ID__c); 
      //      system.debug('did I retrieve anything:' + accObject);
             if (accObject != Null){
                caseRec.Reseller_ID__c = accObject.Reseller_ID__r.Name;
            }
            else{
                caseRec.Reseller_ID__c = '';
            }
        }
    }       
}