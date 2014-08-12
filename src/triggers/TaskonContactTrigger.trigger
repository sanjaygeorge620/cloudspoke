/**
 * Author : Pruthvi Ayireddy
 * Date: 04/01/2014
 * Description : To handle after trigger activities on ContactTaskTriggerHandler i.e., create a task on corresponding contact whenever there 
 *               is an insert or update operation on 'Requests Follow Up' field in Customer Loyalty Survey Object.
 *
 */

trigger TaskonContactTrigger on Survey_MKT_Customer_Loyalty__c (after insert, after update) {
    
    // Bypass code
    if(LX_CommonUtilities.ByPassBusinessRule()) return;
    
    // This is executed when there is a change in the 'Requests Follow Up' field in Customer Loyalty Survey Object.
    
    ContactTaskTriggerHandler.createTaskonContact(Trigger.new, Trigger.oldMap, Trigger.isInsert);
}