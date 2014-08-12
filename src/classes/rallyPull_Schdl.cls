global class rallyPull_Schdl implements Schedulable {
	 
	global void execute(SchedulableContext sc) {
		
		rallyPullBatch batch = new rallyPullBatch(); 
		Database.executeBatch(batch, 1);
	}
}