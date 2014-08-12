@isTest
Public class testJobsTableController {
	static testMethod void testJobsTableController() {			

		//get a schedulable class
		String ApexClassName = '';
		List<ApexClass> classes = autoCompleteController.queryApexClasses('sch', '');
		ApexClassName = classes[0].Name;
		//create test data		
		//active job
		 Scheduled_Job__c job1 = new Scheduled_Job__c(name = 'Test1', 
                                                    active__c = true,
                                                    apex_class__c = ApexClassName,
                                                    run_units__c = 'Months',
                                                    nomultiselect_days__c = 'Sunday',
                                                    run_frequency__c = 5,
                                                    weekday_number__c = 'L',
                                                    start_time__c = '01');

		//not active job 
		 Scheduled_Job__c job2 = new Scheduled_Job__c(name = 'Test2', 
                                                    active__c = false,
                                                    apex_class__c = ApexClassName,
                                                    run_units__c = 'Months',
                                                    nomultiselect_days__c = 'Sunday',
                                                    run_frequency__c = 5,
                                                    weekday_number__c = 'L',
                                                    start_time__c = '01');

		insert job1;	
		insert job2;


		JobsTableController c = new JobsTableController();

		//assert that controller was created
		System.assert(c != null);

		//the 'Active' view is default, so we should only have one job in the list 
		System.assertEquals(1, c.wrapJobList.size());

		//change view to active jobs only
		c.view = 'All';
		c.getJobsList();

		//assert that there is now 2 jobs list
		System.assertEquals(2, c.wrapJobList.size());

		//change view to Not Active jobs only
		c.view = 'Not Active';
		c.getJobsList();

		//assert that there is now only one job in the wrapJobList
		System.assertEquals(1, c.wrapJobList.size());

		//pull in CronJobMap 
		Map<string, CronTrigger> cronMap = c.getCronTriggerMap();
		//assert that the cronMap is not empty
		System.assert(!cronMap.isEmpty());

		List<SelectOption> views = c.getViews();
		//assert that the view list is not empty
		System.assert(!views.isEmpty());

		c.view = 'All';
		List<JobsTableController.wrapJob> wrapJobs = c.getJobsList();

		for (JobsTableController.wrapJob w : wrapJobs){
			w.selected = true;
		}

		c.ActivateJobs();

		//change view to Active jobs only
		c.view = 'Active';
		c.getJobsList();

		//assert that there is now 2 jobs in the Active list
		System.assertEquals(2, c.wrapJobList.size());

		wrapJobs = c.getJobsList();

		for (JobsTableController.wrapJob w : wrapJobs){
			w.selected = true;
		}

		c.DeactivateJobs();

		//change view to Active jobs only
		c.view = 'Active';
		c.getJobsList();

		//assert that there is now 0 jobs in the Active list
		System.assertEquals(0, c.wrapJobList.size());

		List<Scheduled_Job__c> jobs = [SELECT id FROM Scheduled_Job__c WHERE Name = 'Test1'];

		c.SelectedJobId = jobs[0].id;

		c.DeleteJob();

		
 	}
 }