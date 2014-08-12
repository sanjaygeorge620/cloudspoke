trigger RallyUserStory on Rally_User_Story__c (after insert, after update) {

	if(LX_CommonUtilities.ByPassBusinessRule()) return;

	if(trigger.isInsert) {

		handler_RallyUserStory.createIPRUSMR(trigger.new);
		handler_RallyUserStory.syncRallyUpload(trigger.new, trigger.newMap, false);
		handler_RallyUserStory.setIPRStatus(trigger.new);
	}
	else if(trigger.isUpdate) {

		handler_RallyUserStory.syncRallyUpload(trigger.new, trigger.oldMap, true);
		handler_RallyUserStory.setIPRStatus(trigger.new);
	}
}