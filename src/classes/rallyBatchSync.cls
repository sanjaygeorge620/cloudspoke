global class rallyBatchSync implements Database.Batchable<sObject>, Database.AllowsCallouts { //Database.Stateful, Schedulable
	
	global final String query = 'SELECT Id, Developer_Name__c, LastModifiedDate, Rally_ID__c FROM Requirements__c WHERE Developer_Name__c = \'User Story\'';
	
	//Constructor
	public rallyBatchSync() {
		
	}
	
	// Start
	global Database.QueryLocator start(Database.BatchableContext bc) {
		
		return Database.getQueryLocator(query);
	}
	
	
	// Execute
	global void execute(Database.Batchablecontext BC, List<Requirements__c> scope) {
		
		for(Requirements__c us : scope) {
			
			
		}
	}
	
	// Finish
	global void finish(Database.Batchablecontext BC) { 
	
		//Query the AsyncApexJob object to retrieve the current job's information. 
 		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, ExtendedStatus, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
 						  FROM AsyncApexJob 
 						  WHERE Id = :BC.getJobId()];
	}
}