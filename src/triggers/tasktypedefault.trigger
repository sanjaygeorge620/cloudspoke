trigger tasktypedefault on Task (before insert, before update) {
  Set<Id> accIds = new Set<Id>(); 
  Set<Id> oppIds = new Set<Id>(); 
  Set<Id> contactIds = new Set<Id>(); 

       for(Task t : trigger.new){ 
         String wId = t.WhatId; 
         if(wId!=null && wId.startsWith('001') && !accIds.contains(t.WhatId)) {
         accIds.add(t.WhatId); 
        } else if(wId!=null && wId.startsWith('006') && !oppIds.contains(t.WhatId)) {
             oppIds.add(t.WhatId); 
          }else if(wId!=null && wId.startsWith('003') && !contactIds.contains(t.WhatId)) {
             contactIds.add(t.WhatId); 
          }  
    } 
          Map<Id,Account> accMap = new Map<Id, Account>([Select Id, Party_Group__c from Account where Id in :accIds]); 
          Map<Id,Opportunity> oppMap = new Map<Id, Opportunity>([Select Id, Opportunity.Account.Party_Group__c from Opportunity where Id in :oppIds]); 
          Map<Id,Contact> contactMap = new Map<Id,Contact>([Select Id, Contact.Account.Party_Group__c from Contact where Id in :contactIds]); 
       // Map<Id, Account> accMap = new Map<Id, Account>(); 
       // Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
       // Map<Id, Contact> contactMap = new Map<Id, Contact>();
    // for(Account a : taskaccs){ accMap.put(a.Id,a); } // Update custom task field with custom opp field 
    // for(Opportunity o: taskopps){ oppMap .put(o.Id,o); }
    // for(Contact c: taskcontacts){ contactMap .put(c.Id,c); }

     user u=[select id, name,Legacy_Company__c from user where id=:userinfo.getuserid()];
     string usercompany = u.Legacy_Company__c;

 for (Task t:trigger.new)
 {
     String wId = t.WhatId;
     if(wId!=null && wId.startswith('001')){
         Account thisacc = accMap.get(t.WhatId);
         if(thisacc != null){
             if(thisacc.Party_Group__c == 'Customer' && usercompany == 'Lexmark' ) {
               t.Lx_Activity_Type__c = 'Enterprise Sales Activity'; 
             } else if(thisacc.Party_Group__c == 'Partner' && usercompany == 'Lexmark' ){
               t.Lx_Activity_Type__c = 'ISS Channel Activity';
             }
          }   
     }else if(wId!=null && wId.startswith('006')){
        Opportunity thisopp = oppMap.get(t.whatId);
        if(thisopp != null){
            if(thisopp.Account.Party_Group__c == 'Customer' && usercompany == 'Lexmark' ) {
                t.Lx_Activity_Type__c = 'Enterprise Sales Activity'; 
            } else if(thisopp.Account.Party_Group__c == 'Partner' && usercompany == 'Lexmark'){
              t.Lx_Activity_Type__c = 'ISS Channel Activity';
            }
         }   
     }else if(wId!=null &&  wId.startswith('003')){
        system.debug('Inside: '+wId); 
        Contact thiscontact = contactMap.get(t.whatId);
        system.debug('Inside Contact: '+thiscontact);
        if(thiscontact != null){
            if(thiscontact.Account.Party_Group__c == 'Customer' && usercompany == 'Lexmark' ) {
                t.Lx_Activity_Type__c = 'Enterprise Sales Activity'; 
            } else if(thiscontact.Account.Party_Group__c == 'Partner' && usercompany == 'Lexmark'){
                system.debug('Inside Partner: '+thiscontact.Account.Party_Group__c);
                  t.Lx_Activity_Type__c = 'ISS Channel Activity';
            }
         }
       } 
     } 
}