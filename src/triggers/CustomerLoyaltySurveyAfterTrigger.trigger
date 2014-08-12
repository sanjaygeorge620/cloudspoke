/**
 * Author : Pruthvi Ayireddy
 * Date: 03/27/2014
 * Description : To handle after trigger activities i.e., update all the corresponding contacts whenever there is an update in the Customer Loyalty Survey Fields.
 */

trigger CustomerLoyaltySurveyAfterTrigger on Survey_MKT_Customer_Loyalty__c (after insert,after update) {
    
    // Bypass code
    if(LX_CommonUtilities.ByPassBusinessRule()) return;
    
    // This is executed when there is a change in the Likelihood to Recommend field of Customer Loyalty Survey
    
    CustomerLoyaltyTriggerHandler.updateLRinContacts(trigger.new,trigger.oldMap,trigger.isInsert);
    
    // This is executed when there is a change in the Reason for Recommendation or 
    // Suggestions for Improvement field of Customer Loyalty Survey
    
    CustomerLoyaltyTriggerHandler.updateRfRinContacts(trigger.new,trigger.oldMap,trigger.isInsert);
}