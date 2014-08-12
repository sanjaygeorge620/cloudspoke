@isTest
public class Test_UserStoryTriggerClass {

    /*
     * Method name  : Test_UserStoryTriggerClass 
     * @description Function tests the trigger actions on User Story.
     */
    public static testMethod void test_productActions() {
    
    Requirements__c testRequirement = new Requirements__c();
    Project__c testProject = new Project__c();
    testProject.Name       = 'TestProject';
    insert TestProject;
     Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@lexmark.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id, LX_Region__c = 'NE',
                            timezonesidkey='America/Los_Angeles',legacy_company__c='Perceptive', username='standardusera@testorg.com');
        insert u;
        
        
        Release__c rls = new Release__c(Name='Sample');
        insert rls;
        Sprint__c sprnt = new Sprint__c (Name='Sample Sprint');
        insert sprnt;
    testRequirement.Project__c = TestProject.id;
    testRequirement.Planned_Sprint_del__c   = sprnt.id;
                                                    
                                                    
    testRequirement.Release__c=rls.id;
    testRequirement.Product_Owner__c=u.id;
    testRequirement.Acceptance_Criteria__c = 'OldAcceptanceCriteria';
    insert testRequirement;
    
    //testRequirement.Acceptance_Criteria__c = 'NewAcceptanceCriteria';
    //update testRequirement;
    
    /*AC_History__c newlyCreatedACHistoryRecord = [Select Acceptance_Criteria__c  from AC_History__c 
                                                 where User_Story__c = :testRequirement.id
                                                 ORDER BY SystemModStamp DESC NULLS LAST
                                                 LIMIT 1];
    System.assertEquals('OldAcceptanceCriteria', newlyCreatedACHistoryRecord.Acceptance_Criteria__c);
*/
        }
        
        
     }