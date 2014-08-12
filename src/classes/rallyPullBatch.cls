global class rallyPullBatch implements Database.Batchable<integer>, Database.AllowsCallouts {
	
	// Start
	global Iterable<integer> start(Database.BatchableContext bc) {
		
		list<integer> i = new list<integer>();
		
		i.add(1);
		
		return i;
	}
	
	
	
	// Execute
	global void execute(Database.Batchablecontext BC, List<integer> scope) {
		
		
		rallyCalloutMappingUtility.syncUserStoriesFromRally();
	}
	
	
	// Finish 
	global void finish(Database.Batchablecontext BC) {
		/*
		//Query the AsyncApexJob object to retrieve the current job's information. 
 		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, ExtendedStatus, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
 						  FROM AsyncApexJob 
 						  WHERE Id = :BC.getJobId()];
		*/
	}
	
	
}