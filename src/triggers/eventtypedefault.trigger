trigger eventtypedefault on Event (before insert, before update) {
 Set<Id> accIds = new Set<Id>(); 
  Set<Id> oppIds = new Set<Id>(); 
  Set<Id> contactIds = new Set<Id>(); 

       for(Event e : trigger.new){ 
         String wId = e.WhatId; 
         if(wId!=null && (wId.startsWith('001'))&& !accIds.contains(e.WhatId)) {
               accIds.add(e.WhatId); 
         }else if(wId!=null && (wId.startsWith('006'))&& !oppIds.contains(e.WhatId)) {
             oppIds.add(e.WhatId); 
          } else if(wId!=null && (wId.startsWith('003'))&& !contactIds.contains(e.WhatId)) {
             contactIds.add(e.WhatId); 
          } 
   }
        List<Account> eventaccs = [Select Id, Party_Group__c from Account where Id in :accIds]; 
        List<Opportunity> eventopps = [Select Id, Opportunity.Account.Party_Group__c from Opportunity where Id in :oppIds]; 
        List<Contact> eventcontacts = [Select Id, Contact.Account.Party_Group__c from Contact where Id in :contactIds]; 

        Map<Id, Account> accMap = new Map<Id, Account>(); 
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        Map<Id, Contact> contactMap = new Map<Id, Contact>();

     for(Account a : eventaccs){ accMap.put(a.Id,a); } // Update custom task field with custom opp field 
     for(Opportunity o: eventopps){ oppMap .put(o.Id,o); }
     for(Contact c: eventcontacts){ contactMap .put(c.Id,c); }

     
     user u=[select id, name,Legacy_Company__c from user where id=:userinfo.getuserid()];
     string usercompany = u.Legacy_Company__c;

   for (Event e:trigger.new)
   {
     String wId = e.WhatId;
     if(wId!=null &&  (wId.startswith('001'))){
        Account thisacc = accMap.get(e.WhatId);
        if(thisacc != null)
          if(thisacc.Party_Group__c == 'Customer'   && usercompany == 'Lexmark' ) {
              e.Lx_Activity_Type__c = 'Enterprise Sales Activity'; 
            } else if(thisacc.Party_Group__c == 'Partner'  && usercompany == 'Lexmark'  ){
               e.Lx_Activity_Type__c = 'ISS Channel Activity';
              }
       }else
             if(wId!=null &&  (wId.startswith('006'))){
                Opportunity thisopp = oppMap.get(e.whatId);
                 if(thisopp  != null)
                  if(thisopp.Account.Party_Group__c == 'Customer' && usercompany == 'Lexmark' ) {
                    e.Lx_Activity_Type__c = 'Enterprise Sales Activity'; 
                  } else if(thisopp.Account.Party_Group__c == 'Partner' && usercompany == 'Lexmark'){
                      e.Lx_Activity_Type__c = 'ISS Channel Activity';
                    }
             }else
             if(wId!=null &&  (wId.startswith('003'))){
                Contact thiscontact = contactMap.get(e.whatId);
                 if(thiscontact != null)
                  if(thiscontact.Account.Party_Group__c == 'Customer' && usercompany == 'Lexmark' ) {
                    e.Lx_Activity_Type__c = 'Enterprise Sales Activity'; 
                  } else if(thiscontact.Account.Party_Group__c == 'Partner' && usercompany == 'Lexmark'){
                      e.Lx_Activity_Type__c = 'ISS Channel Activity';
                    }
             }
             
       } 
}