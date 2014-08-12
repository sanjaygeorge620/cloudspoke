trigger ProjectRFPJunctionChild on Project_RFP_Junction_Child__c (after insert, after update) {

	handler_ProjectRFPJunctionChild.populateAggregateFields(trigger.new);
}