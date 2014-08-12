trigger CreateCaseOnAccountingContact on Contact (after insert, after update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    Set<Id> contactIdSet = new Set<Id>();
    //Id RecordtypeID = [Select Id from RecordType where Name in ('HelpDesk') and SobjectType in ('Case') ].id;
    //ID recordTypeID = '01270000000Dvug';
    //04.16.2013 from 4 to 6
    //edited line 8 on 4/30/2013 by Abhishek Jain. Replaced Hardcoded id with LX_SetRecordIDs.CaseHelpDeskRecordTypeId   
    ID recordTypeID = LX_SetRecordIDs.CaseHelpDeskRecordTypeId;
    Boolean updateRequired;
    for (Contact contactRec : Trigger.new){         //get all contacts that need to process
            
            //********need to add check to make sure only process once.
         updateRequired = false;   
        if (FirstRun_Check.FirstRun_CreateCaseOnAccountingContact && contactRec.Accounting_Contact__c == true   /*)|| 
          (trigger.isupdate 
                && trigger.oldMap.get(contactRec.id).Accounting_Contact__c != true
                && contactRec.Accounting_Contact__c == true
                && FirstRun_Check.FirstRun_CreateCaseOnAccountingContact*/
            ){ 
            if (trigger.isInsert){
                updateRequired = true;
            }else{          
                if(CreateCaseOnAccountingContact.isAccountingContactUpdated(contactRec, Trigger.oldMap.get(contactRec.id))){
                    updateRequired = True;
                }
            }
            if (updateRequired == True){
                contactIdSet.add(contactRec.id);
                FirstRun_Check.FirstRun_CreateCaseOnAccountingContact = False;
            }  
        }
    }
    if(contactIdSet.size() > 0) {
        
        
        createCaseOnAccountingContact.createCase(contactIdset, RecordtypeID );
        
    }
}