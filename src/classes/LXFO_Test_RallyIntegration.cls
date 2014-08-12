/* Class Name   : LXFO_Test_RallyIntegration 
* Description   : Test Class for the trigger and Utility classes used for Rally Integration
* Created By   : Sanjay George
* Created Date : 03-23-2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay George          03-26-2013                1000                 Initial Version

*/


@isTest
private class LXFO_Test_RallyIntegration {

    public static Requirements__c Test_US;
   
    static testMethod  void Test_RallyCalloutMappingTrigger() {
        Rally_Integration_Callout_Settings__c TrgCntrlSettings = new Rally_Integration_Callout_Settings__c(Name='Rally',LastUpdate__c='', scheduleRunning__c=true, DeletionSync__c=true);
        insert TrgCntrlSettings;
        Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@lexmark.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles', username='standardusera@testorg.com',LX_region__c='NE',Legacy_Company__c = 'Acuo', EmployeeNumber = '123');
        insert u;
        
        Project__c prj = new Project__c(Name='Project Name');
        insert prj;
        Release__c rls = new Release__c(Name='Sample');
        insert rls;
        Sprint__c sprnt = new Sprint__c (Name='Sample Sprint');
        insert sprnt;
        
        Test_US = new Requirements__c( Project__c=prj.id, User_Story__c='Sample Data', Release__c=rls.id, Planned_Sprint_del__c= sprnt.id, Product_Owner__c=u.id );
        
        Test.startTest();
        LXFO_RallyCalloutMappingUtility TestInstance = new LXFO_RallyCalloutMappingUtility();
       
        
        LXFO_RallyCalloutMappingUtility.fetchUS_Rally();
        
        insert Test_US;
        Test_US.Object_ID__c='1234';
        update Test_US;
        
       
        
        Test.StopTest();
    }
     
    static testMethod  void Test_RallyCalloutMapping_delete() {
        Test.startTest();
        Rally_Integration_Callout_Settings__c TrgCntrlSettings = new Rally_Integration_Callout_Settings__c(Name='Rally',LastUpdate__c='', scheduleRunning__c=true, DeletionSync__c=true);
        insert TrgCntrlSettings;
        Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@lexmark.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles', username='standardusera@testorg.com',LX_region__c='NE',Legacy_Company__c = 'Acuo', EmployeeNumber = '1234');
        insert u;
        
        Project__c prj = new Project__c(Name='Project Name');
        insert prj;
        Release__c rls = new Release__c(Name='Sample');
        insert rls;
        Sprint__c sprnt = new Sprint__c (Name='Sample Sprint');
        insert sprnt;
        
        Test_US = new Requirements__c( Project__c=prj.id, User_Story__c='Sample Data', Release__c=rls.id, Planned_Sprint_del__c= sprnt.id, Product_Owner__c=u.id );
        insert Test_US;
        LXFO_RallyCalloutMappingUtility rc = new LXFO_RallyCalloutMappingUtility();
        system.debug('pppp'+Test_US);
        LXFO_RallyCalloutMappingUtility.US_ups = Test_US;
        //delete Test_US;
        LXFO_RallyCalloutUtility.deleteUS('12345');
        LXFO_RallyCalloutUtility.mailAdmin();
        LXFO_RallyCalloutUtility rs = new LXFO_RallyCalloutUtility();
        //String endpoint = 'https://SampleEndpoint.com';
        //LXFO_RallyCalloutUtility.connect_WebService(endpoint);
        Test.StopTest();
    }
    
    static testMethod  void Test_RallyCalloutMapping_Users() {
        Test.startTest();
        LXFO_RallyCalloutMappingUtility rc = new LXFO_RallyCalloutMappingUtility();
        LXFO_RallyCalloutMappingUtility.CreateUserMap_Rally();
        Test.StopTest();
    }
    
    
    
   
   
    static testmethod void testSchedule() {
        Test.startTest();
        // Schedule the test job 
        String jobId = System.schedule('TestRally Sync every 2 Hours','0 0 0 3 9 ? 2022',new LXFO_Schdl_RallyCallouts());
        // Get the information from the CronTrigger API object 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
            NextFireTime
            FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same 
        System.assertEquals('0 0 0 3 9 ? 2022', 
        ct.CronExpression);
        // Verify the job has not run 
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run 
        System.assertEquals('2022-09-03 00:00:00', 
        String.valueOf(ct.NextFireTime));
        Test.stopTest();

   }
}