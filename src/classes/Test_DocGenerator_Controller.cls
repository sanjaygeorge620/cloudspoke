/***********************************************************************************************************
Class Name          : Test_DocGenerator_Controller 
Version             : 1.0
Date Created        : 01.03.2013
Function            : Test class for DocGenerator_Controller apex class
                     
Modification Log    : 
-----------------------------------------------------------------------------------------------------------
* Developer                 Date                    Description
* ---------------           -----------             -------------------------------------------------------
* DM                        01.03.2013              Version 1.0
***********************************************************************************************************/
@isTest(SeeAllData=false)
private class Test_DocGenerator_Controller {
    
    public static Functional_Area__c oTestEpic;
    public static Project__c         oTestProject;
    public static Release__c         oTestRelease;
    public static Requirements__c    oTestUserStory;
    public static Sprint__c          oTestSprint;
    public static Design__c          oTestDesign;
                    
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
        
        // get Sprint 
        oTestSprint          = TestData.getTestSprint(oTestProject.Id);
        insert oTestSprint;
        
        // get Design 
        oTestDesign          = TestData.getTestDesign(oTestProject.Id, oTestEpic.Id, oTestSprint.Id);
        insert oTestDesign;
        
        UserStory2Design__c usdes=new UserStory2Design__c();
        usdes.Design__c=oTestDesign.id;
        insert usdes;
        
        Attachment Att= new Attachment();
        Att.Body=Blob.valueOf('Test');  
        Att.Name='Test';  
        Att.ContentType='contentType'; 
        Att.ParentID=oTestDesign.id;
        insert Att;
    }
    
    
    /*
        Test class method
    */
    static testMethod void myUnitTest() {
        setupTestData();    // create the needed test data
        
        test.startTest();
        
        //    set the reference of the page to DocGenerator page 
        PageReference pageRef = Page.DocGenerator;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('renderAs','pdf');
        ApexPages.currentPage().getParameters().put('functionalarea',oTestEpic.Id);
                
        DocGenerator_Controller oController    = new DocGenerator_Controller();
        
        //    Asset that functional area, project and user story has been created successfully
        system.assertEquals(oTestEpic.Name, 'CRM');
        system.assertEquals(oTestProject.Name, 'Colingo');
        system.assertEquals(oTestRelease.Name, 'Sprint 1');        
        system.assertEquals(oTestUserStory.User_Story__c, 'New Test User Story');
        oController.ConvertToWordFormat();
        
        
        test.stopTest();
    }
            
}