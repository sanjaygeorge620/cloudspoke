trigger ClassRegistrationBeforeInsertUpdate on ELearning_Registration__c (before insert) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
   
    User loggedInUser = [select id, contactId from User where id =:UserInfo.getUserId()];
    Id accId = null;
    
    if(loggedInUser.ContactId != null){
        Contact contact = [select id, PortalAccountID__c from Contact where id =:loggedInUser.ContactId limit 1];
    
        if(contact != null){
            accId = contact.PortalAccountID__c; 
        }   
    }
    for(ELearning_Registration__c r:trigger.New){
        if(r.applicant__c == null)
            r.applicant__c = UserInfo.getUserId();
        if(accId!=null){
            r.Account__c = accId;
        }
      }
   
}