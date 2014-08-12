/**
 * Author : Pruthvi Ayireddy
 * Date: 03/27/2014 
 * Description : To implement the logic for the trigger which updates all the corresponding contacts whenever there is an update in the 
 *          Customer Loyalty Survey Fields. 
 */
 
 public class CustomerLoyaltyTriggerHandler {
     
     // This method is used to update all the corresponding contacts whenever there is an update in the 'likelihood to remember' 
     // field of Customer Loyalty Survey Object.
     
     public static void updateLRinContacts(List<Survey_MKT_Customer_Loyalty__c> newList, Map<Id, Survey_MKT_Customer_Loyalty__c> oldMap, Boolean isInsert) {
         try{
         Set<Id> contIdSet = new Set<Id>();
         for(Survey_MKT_Customer_Loyalty__c cls: newList) {
             if(cls.Contact_Name__c != null) {
                 if(isInsert || cls.Likelihood_to_Recommend__c != oldMap.get(cls.Id).Likelihood_to_Recommend__c) {
                     contIdSet.add(cls.Contact_Name__c);
                 }
             }
         }
         if(!contIdSet.isEmpty()) {
             Map<Id, Contact> contMap = new Map<Id, Contact>([Select Id, Name, Likelihood_to_Recommend__c from Contact where 
                                                              Id IN: contIdSet]);
             for(Survey_MKT_Customer_Loyalty__c cls: newList) {
                 if(cls.Contact_Name__c != null) {
                     if(isInsert || cls.Likelihood_to_Recommend__c != oldMap.get(cls.Id).Likelihood_to_Recommend__c) {
                         contMap.get(cls.Contact_Name__c).Likelihood_to_Recommend__c = cls.Likelihood_to_Recommend__c;
                     }
                 }
             }
             update contMap.values();
         }
         }
         catch(Exception e){
            System.debug('Exception thrown in the method :: updateLRinContacts '+e.getMessage());
         }
     }
     
     // This method is used to update the 'Driving Comments' field in Contacts Object whenever there is an update in the 'Reason for Recommendation' or
     // 'Suggestions for Improvement' field of Customer Loyalty Survey Object.
     
    public static void updateRfRinContacts(List<Survey_MKT_Customer_Loyalty__c> newList, Map<Id, Survey_MKT_Customer_Loyalty__c> oldMap, Boolean isInsert){
            try{
            Set<Id> conIdSet = new Set<Id>(); 
            for(Survey_MKT_Customer_Loyalty__c cls: newList) {
            if(cls.Contact_Name__c != null) {
                 if(isInsert || cls.Reason_for_Recommendation__c != oldMap.get(cls.Id).Reason_for_Recommendation__c 
                    || cls.Suggestions_for_Improvement__c != oldMap.get(cls.Id).Suggestions_for_Improvement__c) {
                     conIdSet.add(cls.Contact_Name__c);
                 }
             }
             }
            if(!conIdSet.isEmpty()){
            Map<Id, Contact> conMap = new Map<Id, Contact>([Select Id, Name, Driving_Comments__c from Contact where
                                                            Id IN: conIdSet]);
            for(Survey_MKT_Customer_Loyalty__c cls: newList) {
             if(cls.Contact_Name__c != null) {
                    if(isInsert || cls.Reason_for_Recommendation__c != oldMap.get(cls.Id).Reason_for_Recommendation__c
                        || cls.Suggestions_for_Improvement__c != oldMap.get(cls.Id).Suggestions_for_Improvement__c)
                        {
                            if(isInsert || cls.Suggestions_for_Improvement__c != oldMap.get(cls.Id).Suggestions_for_Improvement__c)
                                {   
                                    conMap.get(cls.Contact_Name__c).Driving_Comments__c = cls.Suggestions_for_Improvement__c;
                                }
                            if(isInsert || cls.Reason_for_Recommendation__c != oldMap.get(cls.Id).Reason_for_Recommendation__c)
                                {   
                                    conMap.get(cls.Contact_Name__c).Driving_Comments__c = cls.Reason_for_Recommendation__c;
                                }
                        }
             }
             }
            update conMap.values();   
        }
        }
         catch(Exception e){
            System.debug('Exception thrown in the method :: updateRfRinContacts '+e.getMessage());
        }
    }
 }