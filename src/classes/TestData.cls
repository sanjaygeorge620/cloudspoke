/**
* @author       Deepak Mazumdar
* @date         01.03.2013
* @description  Helper class which provides test data to all test classes 
*
* Modification Log    :
* -----------------------------------------------------------------------------------------------------------------------------
* Developer                 Date                   Description
* ---------------           -----------            ----------------------------------------------------------------------------
* Deepak Mazumdar           01.03.2013             Original Version
*/
@istest(seealldata=true)
public class TestData{
    
     /**
     * @author Deepak Mazumdar
     * @date 01.03.2013
     * @description Populate Epic / Theme
     * @return Epic / Theme (Functional_Area__c)
     */  
     public static Functional_Area__c getTestEpic(){
         Functional_Area__c oTestFunctionalArea = new Functional_Area__c();
         oTestFunctionalArea.Name               = 'CRM';
         oTestFunctionalArea.Overview__c        = 'Test Epic Overview';
         oTestFunctionalArea.TOC_Sort__c        = 1;
         return oTestFunctionalArea;         
     }
     
     /**
     * @author Deepak Mazumdar
     * @date 01.03.2013
     * @description Populate Epic / Theme
     * @return Project (Project__c)- This object can be used to record projects in multi-project programs
     */  
     public static Project__c getTestProject(){
         Project__c oTestProject         = new Project__c();
         oTestProject.Name               = 'Colingo';
         oTestProject.Start_Date__c      = date.valueof(datetime.now());
         oTestProject.End_Date__c        = date.valueof(datetime.now()) + 90;
         return oTestProject;         
     }
     
     /**
     * @author Deepak Mazumdar
     * @date 01.03.2013
     * @description Populate Release - object is used to record releases and record approvals for a release to be made. 
     *                                 User Stories and Defects can be assigned to a release and releases can be linked 
     *                                 to environments to understand what user stories or defects are in what environments 
     *                                 at any point in time.
     * @return Release (Release__c)
     */  
     public static Release__c getTestRelease(){
         Release__c oTestRelease            = new Release__c();
         oTestRelease.Name                   = 'Sprint 1';
         oTestRelease.Technology__c          = 'SFDC';
         oTestRelease.Impact__c              = 'Minor';
         oTestRelease.Approval__c            = 'Submitted';
         oTestRelease.Description__c         = 'Release for Sprint 1';
         oTestRelease.Planned_Start__c       = datetime.now() + 20;
         return oTestRelease;         
     }
     
     /**
     * @author Deepak Mazumdar
     * @date 01.03.2013
     * @description Populate User Story
     * @param themeId - Id of epic / theme
     * @param projectId - Id of the project
     * @return User Story (Requirement__c) populated with project, epic, acceptance criteria
     */  
     public static Requirements__c getTestUserStory(Id themeId, Id projectId, Id releaseId){
         Requirements__c oTestRequirement       = new Requirements__c();
         oTestRequirement.Functional_Area__c    = themeId;
         oTestRequirement.Project__c            = projectId;
         oTestRequirement.Release__c            = releaseId;
         oTestRequirement.Development_Stage__c  = 'Backlog';
         oTestRequirement.User_Story__c         = 'New Test User Story';
         oTestRequirement.Acceptance_Criteria__c= 'Test Acceptance Criteria';
         return oTestRequirement;         
     }
     
     /**
     * @author Deepak Mazumdar
     * @date 01.03.2013
     * @description Populate User Story
     * @param themeId - Id of epic / theme     
     * @return User Story (Requirement__c) populated with project, epic, acceptance criteria
     */  
     public static Sprint__c getTestSprint(Id projectId){
         Sprint__c oTestSprint             = new Sprint__c();
         oTestSprint.Name                  = 'Sprint 1';
         oTestSprint.Project__c            = projectId;
         oTestSprint.Status__c             = 'In Planning';
         oTestSprint.Objective__c          = 'Test objective of the sprint';
         oTestSprint.Start_Date__c         = date.valueof(datetime.now());
         oTestSprint.End_Date__c           = date.valueof(datetime.now()) + 14;
         oTestSprint.Tech1_Story_Points__c = 2;
         oTestSprint.Tech2_Story_Points__c = 2;
         oTestSprint.Tech3_Story_Points__c = 2;
         oTestSprint.Tech4_Story_Points__c = 2;
         return oTestSprint;         
     }
     
     /**
     * @author Deepak Mazumdar
     * @date 01.03.2013
     * @description Populate Design
     * @param themeId - Id of epic / theme
     * @param projectId - Id of the project
     * @return User Story (Requirement__c) populated with project, epic, acceptance criteria
     */  
     public static Design__c getTestDesign(Id projectId, Id epicThemeId, Id sprintId){
         Design__c oTestDesign             = new Design__c();
         oTestDesign.Name                  = 'Account Design';
         oTestDesign.Project__c            = projectId;
         oTestDesign.Sprint__c             = sprintId;
         oTestDesign.Functional_Area__c    = epicThemeId;                  
         oTestDesign.Design_Summary__c     = 'Test Design Summary';
         oTestDesign.Design_Details__c     = 'Test Design Detail';
         oTestDesign.System__c             = 'Salesforce';         
         return oTestDesign;         
     }
     
}