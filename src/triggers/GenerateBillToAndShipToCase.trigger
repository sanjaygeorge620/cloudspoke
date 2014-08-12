trigger GenerateBillToAndShipToCase on Account (after update) {

    list<Account> modfiedAccounts =  new list<Account>();
    for(Account account : Trigger.new){
        System.debug('-----'+Trigger.oldMap.get(account.Id).Name+'***'+Trigger.newMap.get(account.Id).Name );
        if( Trigger.oldMap.get(account.Id).Name != Trigger.newMap.get(account.Id).Name ){
            modfiedAccounts.add(account);
        }
    }
    list<RecordType> caseHelpdeskRecordTypes=[Select Id from RecordType where Name in ('HelpDesk') and SobjectType in ('Case') and isActive = true ];
    Map<Id,Contact> accoutingContactsMap = new Map<Id,Contact>([select Id, Accounting_Contact__c from Contact where AccountId in : modfiedAccounts and Accounting_Contact__c = true]);
    if((accoutingContactsMap.values().size() > 0) && (caseHelpdeskRecordTypes.size() > 0)){
        createCaseOnAccountingContact.createCase(accoutingContactsMap.keySet(), caseHelpdeskRecordTypes[0].Id);
    }
   else if(accoutingContactsMap.values().size() > 0){
    ID recordTypeId = [select Id, Name from RecordType where Name = 'Master Record' and SobjectType in ('Case') and isActive = true limit 1].Id;
    createCaseOnAccountingContact.createCase(accoutingContactsMap.keySet(), recordTypeId);
   }
    
}