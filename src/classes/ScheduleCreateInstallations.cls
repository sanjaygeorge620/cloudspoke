/*********************************************************************************
Name : ScheduleCreateInstallations 
Created By : Bharti Mehta(Appirio Offshore)
Created Date : 29 Dec 2010
Usages : This schedules BatchCreateInstallations run
*********************************************************************************/
global class ScheduleCreateInstallations implements Schedulable{
	    
	global void execute(SchedulableContext SC) {
	   BatchCreateInstallations batchController = new BatchCreateInstallations(); 
       Database.executeBatch(batchController,1);
	}
}