trigger UpdateOppFields on Opportunity (before insert, before update) {
    
        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;   

    
   List<ID> OppAccountIds = new LIst<ID> ();
   Map<ID, Account> OppAccountMap = new Map<ID, Account> ();

     
   for(Opportunity o : Trigger.New){ 
       if((trigger.isBefore && trigger.isInsert && o.AccountID != null) || (trigger.isBefore && trigger.isUpdate && o.AccountID != null && trigger.oldMap.get(o.Id).AccountID != o.AccountID) ){   
            OppAccountIds.add(o.accountID);   
       }  
   }
   system.debug('oppAccountIds.size:' + oppAccountIds.size());
   if (oppAccountIds.size() > 0){
       system.debug('oppAccountIds:' + oppAccountIds);
       List<Account> OppAccounts = new List<Account>([select area_of_interest_s__c,Interested_Parties__c, Legacy_Company_Originator__c, RA__r.Email from Account where ID in :oppAccountIDs]);
       for (Account accRec : OppAccounts){
            OppAccountMap.put(accRec.id, AccRec);
       }
       
       for(Opportunity o : Trigger.New){ 
            system.debug('opportunityRec - UpdateOppFields: ' + o);
            if(o.Area_of_Interest_s__c == null){  
                o.Area_of_Interest_s__c = oppAccountMap.get(o.accountId).area_of_Interest_s__c;
            }
            If(o.Legacy_Company_Originator__c == null){
                o.Legacy_Company_Originator__c = oppAccountMap.get(o.accountId).Legacy_Company_Originator__c;
            }
            IF(o.Interested_Party__c == null && oppAccountMap.get(o.accountId).Interested_Parties__c != null)
            {
            o.Interested_Party__c = oppAccountMap.get(o.accountId).Interested_Parties__c;
            }
             
            // added for case 00030358 
            if (oppAccountMap.get(o.accountId).RA__r.Email != null) {          
                o.RA_Email__c = oppAccountMap.get(o.accountId).RA__r.Email;
            }
       }
      }
}