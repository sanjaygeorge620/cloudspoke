trigger TestCustomerloyaltyTrigger on Survey_MKT_Customer_Loyalty__c (before insert, before update) {
TestTriggerHandler.updateCheckbox(trigger.new,trigger.oldMap,trigger.isInsert);
}