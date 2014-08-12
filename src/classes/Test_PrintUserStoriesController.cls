/***********************************************************************************************************
Class Name          : Test_PrintUserStoriesController 
Version             : 1.0
Date Created        : 01-MAR-2013
Function            : Test Class for PrintUserStoriesController apex class
                     
Modification Log    : 
-----------------------------------------------------------------------------------------------------------
* Developer                 Date                    Description
* ---------------           -----------             -------------------------------------------------------
* DM                        01-MAR-2013             Version 1.0
***********************************************************************************************************/

@isTest(SeeAllData=false)
private class Test_PrintUserStoriesController {

public static Functional_Area__c oTestEpic;
    public static Project__c         oTestProject;
    public static Release__c         oTestRelease;
    public static Requirements__c    oTestUserStory;
            
    /**
     * @author Deepak Mazumdar
     * @date 01.03.2013
     * @description Setup the test data which is required for test class coverage
     * @return null
    */   
    static testMethod void setupTestData() 
    {       
        // get Epic / Theme (Functional_Area__c)
        oTestEpic            = TestData.getTestEpic();                
        insert oTestEpic;
        
        // get Project (Project__c)
        oTestProject         = TestData.getTestProject();                
        insert oTestProject;
        
        // get Releases
        oTestRelease         = TestData.getTestRelease();                
        insert oTestRelease;
        
        // get User Story
        oTestUserStory       = TestData.getTestUserStory(oTestEpic.Id, oTestProject.Id, oTestRelease.Id);
        insert oTestUserStory;
    }
    
    static testMethod void myUnitTest() {
        setupTestData();
        
        test.startTest();
        
        //    set the reference of the page to PrintUserStories visualforce page
        PageReference pageRef = Page.PrintUserStories;
        Test.setCurrentPage(pageRef);
        
        PrintUserStoriesController oController    = new PrintUserStoriesController();
        oController.SprintId                      = oTestUserStory.Id;
        
        oController.getUserStories(oTestUserStory.Id);
        test.stopTest();        
    }        
}