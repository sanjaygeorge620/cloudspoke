@isTest
Public class testAutoCompleteController {
	static testMethod void testAutoCompleteController() {			

		List<ApexClass> classes = autoCompleteController.queryApexClasses('sch', 'customer');	

		classes = autoCompleteController.queryApexClasses('sch', '');	

		System.assert(!classes.isEmpty());	

 	}
 }