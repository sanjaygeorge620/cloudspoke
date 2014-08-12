/******************************************************************************
Name     : ClassRegistrationAfterUpdate
Purpose  : If Account field is changed, update Account Name and
           Account Owner Email of all related attendees.
           If Class field is changed, update Class on all related attendees.
Author   : Aashish Mathur
Date     : July 10, 2009
******************************************************************************/

trigger ClassRegistrationAfterUpdate on ELearning_Registration__c (after update) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    // Create set of ids of registrations whose Account field is changed
    Set<ID> registrationIdSet = new Set<ID>();
    for (ID registrationId : Trigger.newMap.keySet()) {
        if (Trigger.oldMap.get(registrationId).Account__c != Trigger.newMap.get(registrationId).Account__c ||
            Trigger.oldMap.get(registrationId).Class__c != Trigger.newMap.get(registrationId).Class__c
        )
            registrationIdSet.add(registrationId);
    }
    
    // If there is no such registration then return
    if (registrationIdSet.size() == 0)
        return;
    
    // Map of updated Registrations
    Map<ID, ELearning_Registration__c> updatedRegistrationMap = new Map<ID, ELearning_Registration__c>(
            [select id, Account__r.Name, Account__r.Owner.Email, Class__c from ELearning_Registration__c
            where id in :registrationIdSet]);
    
    // Main list of updated attendees
    List<Training_Attendee__c> updatedAttendeeList = new List<Training_Attendee__c>();
    
    // Process all related attendees
    ELearning_Registration__c updatedRegistration;
    for (List<Training_Attendee__c> attendeeList : [select id, Account_Name__c, Account_Owner_Email__c,
            Registration__c from Training_Attendee__c where Registration__c in :registrationIdSet]) {
        System.debug('Size of attendee: ' + attendeeList.size());
        
        // Update Account Name and Account Owner Email
        for (Training_Attendee__c attendee : attendeeList) {
            updatedRegistration = updatedRegistrationMap.get(attendee.Registration__c);
            
            if(Trigger.oldMap.get(attendee.Registration__c).Account__c != Trigger.newMap.get(attendee.Registration__c).Account__c){
                attendee.Account_Name__c = updatedRegistration.Account__r.Name;
                attendee.Account_Owner_Email__c = updatedRegistration.Account__r.Owner.Email;               
            }else if(Trigger.oldMap.get(attendee.Registration__c).Class__c != Trigger.newMap.get(attendee.Registration__c).Class__c){
                attendee.Class__c = updatedRegistration.Class__c;               
            }
        }
        
        // If main list of updated attendees may exceed governor limit
        // then update it and make a new list
        if (attendeeList.size() + updatedAttendeeList.size() > 1000) {
            update updatedAttendeeList;
            updatedAttendeeList = new List<Training_Attendee__c>();
        }
        
        // Add updated attendees to main list
        updatedAttendeeList.addAll(attendeeList);
    }
    System.debug('Size of updatedAttendeeList: ' + updatedAttendeeList.size());
    
    // Final updation
    update updatedAttendeeList;
}