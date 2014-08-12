@IsTest
public class CheckPointBatchSchedulerTest{
    public static testmethod void testBatchJob(){
        //delete scheduled apex: type = 7 to prevent dupe jobs from being created
        for (CronTrigger cronTrigger : [SELECT Id, CronJobDetailId, CronJobDetail.Name FROM CronTrigger where CronJobDetail.JobType = '7']){
            System.abortJob(cronTrigger.Id);
        }
        
        //schedule job
        Test.StartTest();
            CheckPointBatchScheduler  m = new CheckPointBatchScheduler ();
            String sch = '0 0 23 * * ?';
            system.schedule('Checkpoint Server Update (Nightly @11pm)', sch, m);
        Test.StopTest();
    }
}