trigger HealthcareAccountSnapshot on Healthcare_Account_Snapshot__c (after insert, after update, before delete) {
	if(LX_CommonUtilities.ByPassBusinessRule()) return;
	
	if(trigger.isInsert) { 
		
		handler_HealthcareAccountSnapshot.prepareToCreateSharingRules(trigger.new);
	}
	
	if(trigger.isUpdate) {
		
		handler_HealthcareAccountSnapshot.checkforAccountTeamMemberChanges(trigger.new, trigger.newMap);
	}
	
	if(trigger.isDelete) { 
		
		handler_HealthcareAccountSnapshot.preventDeleteAccesss(trigger.old);
	}
}