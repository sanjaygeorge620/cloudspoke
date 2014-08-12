trigger ProjectRFPJunction on Project_RFP_Junction__c (after insert, after update) {

	handler_ProjectRFPJunction.populateAggregateFields(trigger.new);
}