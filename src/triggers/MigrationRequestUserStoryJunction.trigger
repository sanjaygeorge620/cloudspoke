trigger MigrationRequestUserStoryJunction on Migration_Request_User_Story_Junction__c (after insert) {

	if(LX_CommonUtilities.ByPassBusinessRule()) return;

	handler_MigrationRequestUserStory.updateIPRUSMR(trigger.new);
}