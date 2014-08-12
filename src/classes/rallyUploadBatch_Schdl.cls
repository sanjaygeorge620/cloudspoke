global with sharing class rallyUploadBatch_Schdl implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		
		rallyUploadBatch b = new rallyUploadBatch();
		
		database.executebatch(b);
	}
}