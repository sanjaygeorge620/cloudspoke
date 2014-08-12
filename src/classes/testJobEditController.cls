@isTest
Public class testJobEditController {
	static testMethod void testJobEditController() {
		
		//get a schedulable class
		String ApexClassName = '';
		List<ApexClass> classes = autoCompleteController.queryApexClasses('sch', '');
		ApexClassName = classes[0].Name;

		//create Scheduled_Job__c record
		scheduled_Job__c job = new scheduled_Job__c();
		job.name = 'Test';
		job.active__c = true;
		job.apex_class__c = ApexClassName;
		job.run_units__c = 'Months';
		job.nomultiselect_days__c = 'Sunday';
		job.run_frequency__c = 5;
		job.weekday_number__c = 'L';
		job.start_time__c = '01';

		insert job;

		PageReference pageRef = Page.JobEdit;

	    Test.setCurrentPage(pageRef);

	    //create a new Scheduled_Job__c standard controller 
		ApexPages.StandardController sc = new ApexPages.StandardController(job);

		//pass the controller to the extension
		JobEditController e = new JobEditController(sc);	 	

		//assert that the controller extension was created
		System.assert(e != null);

		//assert that the controller did not have parameters that are passed on to the URL
		System.assertEquals(e.job.Name, null);

		System.assertEquals(e.newJob, true);

		//try to save the job without completed fields, should not save successfully
		String nextPage = '';

		//try to save the job with not fields populated.
		try{
			nextPage = e.saveJob().getUrl();
		} 
		catch(exception ex){}
		//assert that the job did not save successfully and was not sent on to the next page
		System.assertEquals('', nextPage);

		//cancel
		try{
			nextPage = e.cancel().getUrl();
		} 
		catch(exception ex){}
		//assert that on cancel, we are sent to the correct page. 
		System.assertEquals('/apex/JobsTable', nextPage);

		//complete fields
		e.job.name = 'Test2';
		e.job.active__c = true;
		e.job.apex_class__c = ApexClassName;
		e.job.run_units__c = 'Months';
		e.job.nomultiselect_days__c = 'Sunday';
		e.job.run_frequency__c = 5;
		e.job.weekday_number__c = 'L';
		e.job.start_time__c = '01';

		//save job again
		try{
			nextPage = e.saveJob().getUrl();
		} catch (exception ex2){}	
		//assert that save was successful
		System.assertEquals('/apex/JobsTable', nextPage);


		//pass the Id parameter to the URL
		ApexPages.currentPage().getParameters().put('id', job.id);

		//pass the controller to the extension
		JobEditController e2 = new JobEditController(sc);

		//assert that the extension was created succesfully
		System.assert(e2 != null);

		//assert that the controller is querying for the job successfully
		System.assertEquals(e2.job.Name, job.Name);

		System.assertEquals(e2.newJob, false);

		//get the hours options list
		List<selectOption> hours = e2.getHours();

		//assert that the hours were returned successfully 
		System.assertEquals(e2.getHours(), hours);

		//get the weekday number options list
		List<selectOption> weekdayNumber = e2.getWeekdayNumber();

		//assert that the weekday number list was returned successfully 
		System.assertEquals(e2.getWeekdayNumber(), weekdayNumber);

		//make changes to the job fields
		e2.job.name = 'Test3';
		e2.job.active__c = false;

		//save the changes to the job
		try{
			nextPage = e2.saveJob().getUrl();
		} catch (exception ex2){}	

		//assert that save was successful
		System.assertEquals('/apex/JobsTable', nextPage);
		

	}
}