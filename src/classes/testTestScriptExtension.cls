/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testTestScriptExtension {

    static testMethod void myUnitTest() {
    	
    	
    	//get user
    	 User tstuser = [select id from user where isActive=true LIMIT 1];
		
		//insert template record
		test_templates__c TT = new Test_templates__c(
			name = '1.2.23',
			test_manager__c = tstuser.id
		);
		insert TT;
		
		test_template_steps__c TTS = new test_template_steps__c(
		Test_Script__c = TT.id,
		Name = '1.2.23.1'
		);
		insert TTS;
    	//insert test record
    	Test__c TestHead = new Test__c(
    								assigned_to__c = tstuser.id,
    								Template__c = TT.id,
    								Test_Phase__c = 'Unit'
    								);
    	
    	//insert 
    	insert testHead;

		//Build Children
		test_steps__c testSt = new test_steps__c(
													Name='1.23.4.1',
													test__c = TestHead.id,
													Template_Step__c = TTS.id
													
		);
		
		//insert children
		insert testSt;
		

		
		
		PageReference pageRef = Page.runTestScript;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', testHead.id);
    	
    	//system.debug(ApexPages.currentPage().getUrl());
        
        
        ApexPages.Standardcontroller controller = New ApexPages.StandardController(testHead);
        runTestScriptExtension ext = new runTestScriptExtension(controller);
       // controller= new controller();

    	//List<Bug__c> tstBugs = ext.Bugs;
    	system.assertequals(ext.TestSp.size(), 1);

    	System.currentPageReference().getParameters().put('testId', testSt.id);
    	System.currentPageReference().getParameters().put('testName', testSt.name);
    	System.currentPageReference().getParameters().put('req', '');
    	ext.addBug();
    	ext.Bugs[0].Problem__c = 'bla bla';
    	ext.Bugs[0].Assigned_to__c = tstuser.id;
    	system.assertequals(ext.Bugs.size(),1);
    	system.assert(ext.isnewBugs, true);
    	
    	string shouldgoto = '/'+TestHead.id;
    	string goTo1 = ext.save().getUrl();
    	
    	system.assertequals(shouldgoto, goTo1);

    }
}