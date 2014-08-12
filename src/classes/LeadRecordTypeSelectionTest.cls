@istest
public with sharing Class LeadRecordTypeSelectionTest{

    static testmethod void testCreate() {
        
        // start the test execution context
        Test.startTest();
        
           PageReference Pg = page.LeadRecordTypeSelection;
           Test.setCurrentPage(Pg);

            LeadRecordTypeSelection c = new LeadRecordTypeSelection(new ApexPages.StandardController(new lead()));

            //Get List of Recordtypes
                system.assert(c.getleadTypes().size()>0,'No recordtypes available to test with');
           //Continue 
                   pagereference PgContinueCustom = c.btnContinueCustom();
                   pagereference PgContinueStandard = c.btnContinue();
          //Without RetURL
                   pagereference PgCancel = c.Cancel();
          //With RetURL    
                   Pg.getParameters().put('retURL', ('/apex/LeadRecordTypeSelection'));
                   Test.setCurrentPage(Pg);
                   PgCancel = c.Cancel();
                            
       // stop the test
        Test.stopTest(); 
    
    }
}