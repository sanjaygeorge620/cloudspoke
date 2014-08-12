global class CustomerLoyaltyAccountFields_Schdl implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		//String schedule = '0 0 22 1,15 * ?';
		CustomerLoyaltyAccountFieldsBatch batch = new CustomerLoyaltyAccountFieldsBatch();
		Database.executeBatch(batch);
	}
}