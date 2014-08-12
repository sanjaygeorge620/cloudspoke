/* The purpose of this class is to test the caseHistoryCon and history classes.  
   The @IsTest annotation excludes this class from the system cache and as such 
   it is NOT counted against the org code size limit. */
   
@IsTest 

    private class CaseHistoryConTests {

    /* This is a basic test which simulates the primary positive
       case for the caseHistoryCon controller class as if it were
       invoked by a Visualforce page such as caseHistory or caseHistoryPrint. */
    public static testmethod void basicTest() {
    
        /* Instantiate an instance of this class so we can call it's setup method. */
        CaseHistoryConTests testclass = new CaseHistoryConTests();
               
        /* create a case with the relevant child objects */
        
        try
        {
            Case c = testclass.setupTestCase();
        
               
        /* Setup the controller with and test context per the helper method. */
        CaseHistoryCon controller = testclass.setupController(c);
          
        /* Switch to the runtime limit context. */      
        Test.startTest();
               
        /* Simulate the {!histories} expression in the Visualforce page caseHistory
           by directly calling the getHistories method.*/
        List<History> histories = controller.getHistories();   
        
        /* Switch back to the test context.*/
        Test.stopTest();
        
        /* Assert that the history size is the expected value, 5. */
        System.assertEquals(4,histories.size());
        }
        catch(exception e)
        {
            System.debug(e);
        }
        
    }
    
    /* This test calls the actions in the controller. */
    public static testmethod void actionsTest() {
        CaseHistoryConTests testclass = new CaseHistoryConTests();
               
        /* create a case with the relevant child objects */
        //Case c = testclass.setupTestCase();
        try
        {
            Case c = testclass.setupTestCase();
        
        
        /* Create a page for use in the test. */
        PageReference p = Page.caseHistory;
        
        /* Set the case ID in the context for use by the controller. */
        p.getParameters().put('cid',c.id);
        
        /* Set the page in the test context so the controller will have 
           access to the expected request parameter(s)*/
        Test.setCurrentPage(p);
        
        /* Construct our controller class. */
        CaseHistoryCon controller = new CaseHistoryCon();
        
        /* Assert defaults set by the constructor. */
        System.assert(controller.fullcomments);
        System.assert(!controller.hidePrivate);
        
        /* Call the togglecomments action. */
        controller.toggleComments();       
        
        /* Assert the expected state change. */
        System.assert(!controller.fullcomments);
        
        /* Call the togglePrivate action */
        controller.togglePrivate();
              
        /* Switch to the runtime limit context. */
        Test.startTest();
                
        /* Simulate the {!histories} expression in the Visualforce page caseHistory
           by directly calling the getHistories method.*/
        List<History> histories = controller.getHistories();   
        
        /* Switch back to the test context.*/
        Test.stopTest();
        
        /* The page should only be returning 2 histories in this case (i.e. excluding the private comment, event and task). */
        System.assertEquals(1,histories.size());
        
        /* Assert the expected state change. */
        System.assert(controller.hidePrivate);        
        
        /* Simulate navigation back to the case detail. */
        PageReference result = controller.backToCase();
        
        /* Assert the url for the page reference is as expected from the action. */
        System.assertEquals(result.getUrl(), new ApexPages.StandardController(c).view().getUrl());
        
        }
        catch(exception e)
        {
            System.debug(e);
        }  
    
    }
    
    /* This test simulates the formatting operations in the history class
       that are used by the caseHistoryPrint page. */
    public static testmethod void testHistoryFormatting() {
        
        /* Get the current time for later asserts and history constructor.*/
        Datetime dt = System.now();
        
        Account acc = DAta_account.createaccount3();
        /* Construct a history class to test the formatting */
        History h = new History(dt, false, 'actor','history type','from','to');
        
        History h1 = new History(dt,false,'actor','history type',acc.id,'to');
        History h2 = new History(dt,'actor','history type',acc.id,'to');
        
        /* Do the asserts */
        System.assertEquals(h.dtmonthyr,dt.format('MMMMM yyyy'));
        System.assertEquals(h.dttime,dt.format('h:mm a'));
        System.assertEquals(h.dtdayfmt, dt.format('d - EEEE'));
        System.assertEquals(h.dtmonth, dt.month());
        System.assertEquals(h.dtyear, dt.year());
        System.assertEquals(h.dtday, dt.day());
        
    }
    
    /* This setup will be shared across tests.  It creates a basic case,
       2 comments (1 public with long comment, 1 private with short comment), 
       1 closed task in the past, 1 event in the past, and one attachment. */
    private Case setupTestCase() {
    
        /* Get a caseStatus value that is not closed. */
        String status = [Select masterlabel from casestatus where isclosed = false limit 1].masterlabel;
        Case testCase = new Case(Status = status,RecordtypeID='012i0000000LkBB');
        Database.insert(testCase);
            
        /* Create CaseComments */
        List<CaseComment> casecomments = new List<CaseComment>();
        caseComments.add(new CaseComment(ParentId = testCase.id, CommentBody = 'Comment Body', ispublished = false));
        caseComments.add(new CaseComment(ParentId = testCase.id, ispublished = true,
                                         CommentBody = 'Comment Body that is very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long to cause the truncation to occur.'));
                                                                     
        Database.insert(casecomments);
        
        /* Create a closed Task (in the past).  Need to first query for a closed status value.*/
        String closedStatus = [select masterlabel from TaskStatus where isclosed = true][0].masterlabel;

        Task t = new Task(whatId = testCase.id, Status = closedStatus, ActivityDate = System.Today().addDays(-1));
        Database.insert(t);
        
        /* Create an Event in the past */
        Event e = new Event(whatId = testCase.id, DurationInMinutes = 60, ActivityDateTime = System.now().addDays(-1));
        Database.insert(e);
        
        /* Create an Attachment */
        Attachment a = new Attachment(ParentId = testCase.id, Name = 'Attachment', Body = Blob.valueOf('Attachment Body'));
        Database.insert(a);
        
        
        return testCase;
    }
    
    /* A setup method for the tests which constructs a caseHistoryCon class and sets
       the appropriate parameters in the context for tests. */
    private CaseHistoryCon setupController(Case c) {
        
        
        /* Construct the controller that will be returned by this setup method.*/
        CaseHistoryCon controller = new CaseHistoryCon();
    
        /* Create a page for use in the test. */        
        PageReference p = Page.caseHistory;
        
        /* Set the case ID in the context for use by the controller. */
        p.getParameters().put('cid',c.id);
        
        /* Set the case ID in the context for use by the controller. */
        Test.setCurrentPage(p);
        
        return controller;
    }
    
    
    static testmethod void m1(){
          RecordType rec = [Select id from Recordtype where name='Product Support' and sobjectType='Case'];
       Case testCase = new Case(Status = 'New',RecordtypeID=rec.Id);
        Database.insert(testCase);
            
        /* Create CaseComments */
        List<CaseComment> casecomments = new List<CaseComment>();
        caseComments.add(new CaseComment(ParentId = testCase.id, CommentBody = 'Comment Body', ispublished = false));
        caseComments.add(new CaseComment(ParentId = testCase.id, ispublished = true,
                                         CommentBody = 'Comment Body that is very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very, very long to cause the truncation to occur.'));
                                                                     
        Database.insert(casecomments);
        
      

        Task t = new Task(whatId = testCase.id, Status = 'Closed', ActivityDate = System.Today().addDays(-1));
        Database.insert(t);
        
        /* Create an Event in the past */
        Event e = new Event(whatId = testCase.id, DurationInMinutes = 60, ActivityDateTime = System.now().addDays(-1));
        Database.insert(e);
        
        /* Create an Attachment */
        Attachment a = new Attachment(ParentId = testCase.id, Name = 'Attachment', Body = Blob.valueOf('Attachment Body'));
        Database.insert(a);
        CaseHistoryCon controller = new CaseHistoryCon();
        ApexPages.CurrentPage().getParameters().put('cid',testcase.Id);
        controller.toggleComments();
        controller.togglePrivate();
        controller.backtocase();
        controller.getHistories();
        
    }
}