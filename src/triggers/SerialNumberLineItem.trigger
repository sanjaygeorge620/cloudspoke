trigger SerialNumberLineItem on Serial_Number_Line_Item__c (before insert, before update) {
	if(LX_CommonUtilities.ByPassBusinessRule()) return;

	if(trigger.isInsert) {

		handler_SerialNumberLineItem.setPartNameByPartNumber(trigger.new, trigger.newMap, trigger.isUpdate);
	}

	if(trigger.isUpdate) {

		handler_SerialNumberLineItem.setPartNameByPartNumber(trigger.new, trigger.oldMap, trigger.isUpdate);
	}
}