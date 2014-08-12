global class rallyUpload_Schdl implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		
		rallyUploadBatch batch = new rallyUploadBatch();
		Database.executeBatch(batch, 1);
	}
}