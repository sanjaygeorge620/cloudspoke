@isTest
Public class testScheduledJobTrigger {
    static testMethod void testScheduledJobTrigger() {

       //get a schedulable class
        String ApexClassName = '';
        List<ApexClass> classes = autoCompleteController.queryApexClasses('sch', '');
        ApexClassName = classes[0].Name;

        //create test data
        Scheduled_Job__c job1 = new Scheduled_Job__c(name = 'Test1', 
                                                    active__c = true,
                                                    apex_class__c = ApexClassName,
                                                    run_units__c = 'Months',
                                                    nomultiselect_days__c = 'Sunday',
                                                    run_frequency__c = 5,
                                                    weekday_number__c = 'L',
                                                    start_time__c = '01');
        insert job1;

        //query for the crontriggerid__c field to see if the trigger populated the field; 
        List<Scheduled_Job__c> jobs = [SELECT crontriggerid__c FROM Scheduled_Job__c WHERE name = 'test1'];

        System.assert(jobs[0].crontriggerid__c != null);

        //query to see if the cron trigger was created successfully.

        List<CronTrigger> cronTriggers = [SELECT CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test1'];

        //assert that a cron trigger was created and returned from the query
        System.assertEquals(1, cronTriggers.size());

        //attempt to make a duplicate job and insert it
        Scheduled_Job__c dupeJob = new Scheduled_Job__c(name = 'Test1', 
                                                    active__c = true,
                                                    apex_class__c = ApexClassName,
                                                    run_units__c = 'Months',
                                                    nomultiselect_days__c = 'Sunday',
                                                    run_frequency__c = 5,
                                                    weekday_number__c = 'L',
                                                    start_time__c = '01');
        try {
           insert dupeJob;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }

        //assert that the dupelicate job failed to insert
        List<Scheduled_Job__c> lookForDupes = [SELECT name FROM Scheduled_Job__c WHERE Name = 'Test1'];

        //assert that there is only one job with the name 'test1'
        System.assertEquals(1, lookForDupes.size());

        //attempt update job1 while it is still activated, it should not work
        job1.run_frequency__c = 10;

        try {
           update job1;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }

        //query for job1 to check if the update failed as it should have
        List<Scheduled_Job__c> checkForUpdate = [SELECT run_frequency__c FROM Scheduled_Job__c WHERE Name = 'Test1'];

        //assert that the update failed and the run frequency value remains unchanged
        System.assertEquals(5, checkForUpdate[0].run_frequency__c);

        //attempt to deactivate the job 
        job1.active__c = false;

        update job1;

        checkForUpdate = [SELECT active__c FROM Scheduled_Job__c WHERE Name = 'Test1'];
        //assert that update was successful
        system.assertEquals(false, checkForUpdate[0].active__c);

        //query for cronjob to see if it was aborted successfully 
        cronTriggers = [SELECT CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test1'];

        //assert that the cronTrigger was aborted
        system.assertEquals(0, cronTriggers.size());

        //reactivate the job
         //attempt to deactivate the job 
        job1.active__c = true;

        update job1;

        checkForUpdate = [SELECT active__c FROM Scheduled_Job__c WHERE Name = 'Test1'];
        //assert that update was successful
        system.assertEquals(true, checkForUpdate[0].active__c);

        //query for cronjob to see if it was created successfully 
        cronTriggers = [SELECT CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test1'];

        //assert that the cronTrigger was created
        system.assertEquals(1, cronTriggers.size());


        //update with out required fields, to see if we get an error as expected.
        job1.run_units__c = 'Hours';
        job1.active__c = false;

        try {
           update job1;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }
        

        checkForUpdate = [SELECT run_units__c FROM Scheduled_Job__c WHERE Name = 'Test1'];
        //assert that update was failed
        system.assertEquals('Months', checkForUpdate[0].run_units__c);

        //update with out required fields, to see if we get an error as expected.
        job1.run_units__c = 'Days';
        job1.active__c = false;

        try {
           update job1;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }

        checkForUpdate = [SELECT run_units__c FROM Scheduled_Job__c WHERE Name = 'Test1'];
        //assert that update was failed
        system.assertEquals('Months', checkForUpdate[0].run_units__c);

        //create a job where run units = days
        Scheduled_Job__c job2 = new Scheduled_Job__c(name = 'Test2', 
                                                    active__c = true,
                                                    apex_class__c = ApexClassName,
                                                    run_units__c = 'Days',
                                                    multiselect_days__c = 'Sunday;Monday',                                                 
                                                    start_time__c = '01');

        insert job2;


        checkForUpdate = [SELECT Name FROM Scheduled_Job__c WHERE Name = 'Test2'];

        System.assertEquals(1, checkForUpdate.size());

        //create a job where run units = hours
        Scheduled_Job__c job3 = new Scheduled_Job__c(name = 'Test3', 
                                                    active__c = true,
                                                    apex_class__c = ApexClassName,
                                                    run_units__c = 'Hours',
                                                    multiselect_days__c = 'Sunday',                                                 
                                                    run_frequency__c = 1);

        insert job3;

        checkForUpdate = [SELECT Name FROM Scheduled_Job__c WHERE Name = 'Test3'];

        System.assertEquals(1, checkForUpdate.size());


        //create new jobs with missing required fields
        Scheduled_Job__c job4 = new Scheduled_Job__c(name = 'Test4', 
                                                    active__c = true,
                                                    apex_class__c = ApexClassName,
                                                    run_units__c = 'Days',
                                                    multiselect_days__c = 'Sunday',                                                 
                                                    run_frequency__c = 1);

         try {
           insert job4;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }
        checkForUpdate = [SELECT Name FROM Scheduled_Job__c WHERE Name = 'Test4'];
        //no job should be returned, insert should fail
        System.assertEquals(0, checkForUpdate.size());


        //create new jobs with missing required fields
        job4 = new Scheduled_Job__c(name = 'Test5', 
                                    active__c = true,
                                    apex_class__c = ApexClassName,
                                    run_units__c = 'Hours',
                                    multiselect_days__c = 'Sunday', 
                                    start_time__c = '01'                                               
                                    );

         try {
           insert job4;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }
        checkForUpdate = [SELECT Name FROM Scheduled_Job__c WHERE Name = 'Test5'];
        //no job should be returned, insert should fail
        System.assertEquals(0, checkForUpdate.size());


        //create new jobs with missing required fields
        job4 = new Scheduled_Job__c(name = 'Test6', 
                                    active__c = true,
                                    apex_class__c = ApexClassName,
                                    run_units__c = 'Months',                                                    
                                    run_frequency__c = 5,
                                    weekday_number__c = 'L',
                                    start_time__c = '01');

         try {
           insert job4;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }

        checkForUpdate = [SELECT Name FROM Scheduled_Job__c WHERE Name = 'Test6'];
        //no job should be returned, insert should fail
        System.assertEquals(0, checkForUpdate.size());


        //create new jobs with an apex class that does not implement Schedulable
        job4 = new Scheduled_Job__c(name = 'Test7', 
                                    active__c = true,
                                    apex_class__c = 'AccountProfileController',                                                    
                                    run_units__c = 'Months',
                                    nomultiselect_days__c = 'Sunday',
                                    run_frequency__c = 5,
                                    weekday_number__c = 'L',
                                    start_time__c = '01');       

         try {
           insert job4;
        } catch (Exception e) { 
            System.debug('An error happened, as predicted!');
        }

        checkForUpdate = [SELECT crontriggerid__c FROM Scheduled_Job__c WHERE Name = 'Test7'];
        //insert should have failed
        System.assertEquals(0, checkForUpdate.size());


        //delete a job
        delete job1;

        //check to see if job was deleted
        checkForUpdate = [SELECT Name FROM Scheduled_Job__c WHERE Name = 'Test1'];
        //no job should be returned if job was deleted
        System.assertEquals(0, checkForUpdate.size());
    }
}