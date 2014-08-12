/******************************************************************************
Name     : TrainingAttendeeBeforeInsert 
Purpose  : Defaults the class to be the class of the registration
Author   : Phi An
Date     : June 28, 2009

Modified By   : Aashish Mathur
Modified Date : July 10, 2009
Comments      : Set "Account Owner Email" with the
                TrainingAttendee.Registration.Account.Owner's email.
******************************************************************************/

trigger TrainingAttendeeBeforeInsert on Training_Attendee__c (before insert) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    
    // Set of Registration Ids
    Set<Id> regIds = new Set<Id>();
    
    for (Training_Attendee__c attendee: Trigger.new){
        if(attendee.Registration__c != null) {
            regIds.add(attendee.Registration__c);
            
            
        }
    }
    
      
    
    //Get Registration ID, Class ID Map
    Map<Id, ELearning_Registration__c> registrationClassMap = new Map<Id, ELearning_Registration__c>();
    List<ELearning_Registration__c> registrations = [select id, class__c, Account__c, Account__r.Name, Account__r.OwnerId, Account__r.Owner.Email from ELearning_Registration__c where id in: regIds];
    for(ELearning_Registration__c reg : registrations){
        registrationClassMap.put(reg.Id, reg);
    }
    
    for (Training_Attendee__c attendee: Trigger.new){
        if(attendee.Registration__c != null){
            ELearning_Registration__c reg = registrationClassMap.get(attendee.Registration__c);
            attendee.Class__c = reg.class__c;
            attendee.Account_Name__c = reg.Account__r.Name;
            
            // change for PR-02163
            if (reg.Account__c != null && reg.Account__r.OwnerId != null)
                attendee.Account_Owner_Email__c = reg.Account__r.Owner.Email;
            
            // end change for PR-02163
        }
    }
    
    
}