public with sharing class testJobSchedulerController {
    public List<CronTrigger> jobs{get;set;}
    
    public testJobSchedulerController() {
        jobs = [SELECT Id, State, PreviousFireTime, NextFireTime, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType, OwnerId
   				 FROM CronTrigger ORDER BY CreatedDate DESC];
    }
}