/* The purpose of this class is to test the caseHistoryCon and history classes.  
   The @IsTest annotation excludes this class from the system cache and as such 
   it is NOT counted against the org code size limit. */
   
@IsTest private class Test_ProjectReference_Communications {

    /* This is a basic test which simulates the primary positive
       case for the caseHistoryCon controller class as if it were
       invoked by a Visualforce page such as caseHistory or caseHistoryPrint. */
       
      public static Id tId = null;
    public static testmethod void basicTest() {
     
        
        /* Instantiate an instance of this class so we can call it's setup method. */
        Test_ProjectReference_Communications testclass = new Test_ProjectReference_Communications();
               
        /* create a case with the relevant child objects */
        pse_Project_Reference__c p = testclass.setupTestProject();
                
        /* Setup the controller with and test context per the helper method. */
       ProjectReference_Communications controller = testclass.setupController(p);
          
        /* Switch to the runtime limit context. */      
        Test.startTest();
               
        /* Simulate the {!histories} expression in the Visualforce page caseHistory
           by directly calling the getHistories method.*/
        List<projHistory> projHistories = controller.getprojHistories();  
        system.debug('Histories'+ projHistories); 
        system.debug('HISTSIZE'+projhistories.size());
        
        /* Switch back to the test context.*/
        Test.stopTest();
        
        /* Assert that the history size is the expected value, N. */
        System.assertEquals(3,projhistories.size());
        
    }
    
    /* This test calls the actions in the controller. */
 //   public static testmethod void actionsTest() {
 //       Test_ProjectReference_Communications testclass = new Test_ProjectReference_Communications();
               
        /* create a case with the relevant child objects */
 //       pse_Project_Reference__c project = testclass.setupTestProject();
        
        /* Create a page for use in the test. */
 //       PageReference p = Page.ProjectReference_Communications;
        
        /* Set the case ID in the context for use by the controller. */
  //      p.getParameters().put('cid',project.id);
        
        /* Set the page in the test context so the controller will have 
           access to the expected request parameter(s)*/
 //       Test.setCurrentPage(p);
        
        /* Construct our controller class. */
 //       ProjectReference_Communications controller = new ProjectReference_Communications(new ApexPages.StandardController(project));
              
        /* Switch to the runtime limit context. */
 //       Test.startTest();
                
        /* Simulate the {!histories} expression in the Visualforce page caseHistory
           by directly calling the getHistories method.*/
  //      List<projHistory> projHistories = controller.getprojHistories();   
        
        /* Switch back to the test context.*/
  //      Test.stopTest();
        
        /* The page should only be returning 2 histories in this case (i.e. excluding the private comment, event and task). */
  //      System.assertEquals(1,projHistories.size());
        
        /* Assert the url for the page reference is as expected from the action. */
  //      System.assertEquals(result.getUrl(), new ApexPages.StandardController(project).view().getUrl());
    
 //   }
    
    /* This test simulates the formatting operations in the history class
       that are used by the caseHistoryPrint page. */
    public static testmethod void testHistoryFormatting() {
        
         Test_ProjectReference_Communications testclass = new Test_ProjectReference_Communications();
         pse_Project_Reference__c project = testclass.setupTestProject();
        /* Get the current time for later asserts and history constructor.*/
        Datetime dt = System.now();
        system.debug('task:' + tID);
        Task taskSelection = [select id, Subject, Activity_Subject__c, WhoId, Who.Name, WhatID, isClosed,ActivityDAte, ownerid, owner.Name, lastModifiedDate from Task  where id = :tId limit 1];
        system.debug('task Selection*********** '+taskSelection);
        /* Construct a history class to test the formatting */
        projHistory h = new projHistory(taskSelection.id, 
                                        taskSelection.Subject, 
                                        taskSelection.Activity_Subject__c, 
                                        taskSelection.WhoId,  
                                        taskSelection.Who.Name, 
                                        taskSelection.whatID, 
                                        taskSelection.isClosed, 
                                        taskSelection.ActivityDate, 
                                        taskSelection.ownerid, 
                                        taskSelection.owner.name, 
                                        taskSelection.lastModifiedDate); 
          system.debug('projHistory' + h);
                                         //(id i,             string s, string cs, ID n,             string nc,         ID rt, boolean t,date d,    ID a,        string an,   datetime lm )
  //      History h = new History(dt, false, 'actor','history type','from','to');
        
        /* Do the asserts */
  //      System.assertEquals(h.dtmonthyr,dt.format('MMMMM yyyy'));
  //      System.assertEquals(h.dttime,dt.format('h:mm a'));
  //      System.assertEquals(h.dtdayfmt, dt.format('d - EEEE'));
  //      System.assertEquals(h.dtmonth, dt.month());
  //      System.assertEquals(h.dtyear, dt.year());
  //      System.assertEquals(h.dtday, dt.day());
        
    }
    
    /* This setup will be shared across tests.  It creates a basic case,
       2 comments (1 public with long comment, 1 private with short comment), 
       1 closed task in the past, 1 event in the past, and one attachment. */
    private PSE_Project_Reference__c setupTestProject() {
    
        /* Get a caseStatus value that is not closed. */
           
        List<pse__Proj__c> Projects = Data_Project.createProject(1); 
        pse__Proj__c testProject = Projects[0];
        
        system.debug('testProject ID' + testProject.id);
              PSE_Project_Reference__c testProjectRef= new PSE_Project_Reference__c(id_External__c = testProject.id);
           insert testProjectRef; 
           
           Task t = new Task(whatId = testProject.id, Status = 'Completed', ActivityDate = System.Today().addDays(-1));
        insert t;
            
            
        system.debug('task*********** '+t);
        
        tId =t.id;

        Task TaskRec = [SELECT ID,
                             Subject, 
                             Activity_Subject__c,
                             whoId,
                             Who.Name,
                             whatID,
                             isClosed,
                               ActivityDate,
                               ownerid,
                               owner.name,
                               lastModifiedDate
                               FROM Task where id = :t.id];
                               
    system.debug('task2*********** '+TaskRec);
                              
     
        /* Create an Event in the past */
        Event e1 = new Event(whatId = testProject.id, DurationInMinutes = 60, ActivityDateTime = System.now().addDays(-1));
        Database.insert(e1);
        
        /* Create Event in the future */
        Event e2 = new Event(whatId = testProject.id, DurationInMinutes = 60, ActivityDateTime = System.now().addDays(+1));
        Database.insert(e2);
        
        return testProjectRef;
    }
    
    /* A setup method for the tests which constructs a caseHistoryCon class and sets
       the appropriate parameters in the context for tests. */
    private ProjectReference_Communications setupController(pse_Project_Reference__c project) {
    
        /* Construct the controller that will be returned by this setup method.*/
        ProjectReference_Communications controller = new ProjectReference_Communications(new ApexPages.StandardController(project));
    
        /* Create a page for use in the test. */        
        PageReference p = Page.ProjectReference_Communications;
        
        /* Set the case ID in the context for use by the controller. */
        p.getParameters().put('id',project.id);
        
        /* Set the case ID in the context for use by the controller. */
       Test.setCurrentPage(p);
        
        return controller;
    }
}