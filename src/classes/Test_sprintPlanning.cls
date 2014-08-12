/**
Apex Class Name     :   Test Sprint Planning
Version             :   1.0  
Created Date        :   18/02/2012
Function            :   This class contains unit tests for validating the behavior of Sprint Planning Apex classes
Modification Log    : 
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Deloitte UK                18/02/2012              Original Version 
******************************************************************************/
@isTest
private class Test_sprintPlanning {

    static testMethod void myUnitTest() {
        
        // Perform  data preparation.
        List<Sprint__c> sprints = new List<Sprint__c>{};
            
        for(Integer i = 0; i < 2; i++){
            Sprint__c objSprint = new Sprint__c(Name        = 'Test-Sprint'+ i,
                                                Status__c   = 'In Planning',
                                                Tech1_Story_Points__c   = 200.0,
                                                Tech2_Story_Points__c   = 200.0,
                                                Tech3_Story_Points__c   = 200.0,
                                                Tech4_Story_Points__c   = 200.0
                                            );
            sprints.add(objSprint);
        }
        insert sprints;
        List<Requirements__c> requirements = new List<Requirements__c>{};
        Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@lexmark.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles',legacy_company__c='Perceptive', username='standardusera@testorg.com',LX_Region__c = 'NE');
        insert u;
        
        Project__c prj = new Project__c(Name='Project Name');
        insert prj;
        Release__c rls = new Release__c(Name='Sample');
        insert rls;
        Sprint__c sprnt = new Sprint__c (Name='Sample Sprint');
        insert sprnt;
        
        //Test_US = new Requirements__c( Project__c=prj.id, User_Story__c='Sample Data', Release__c=rls.id, Planned_Sprint_del__c= sprnt.id, Product_Owner__c=u.id );
        
        for(Integer i = 0; i < 2; i++){
            Requirements__c objRequirement =new Requirements__c(
                                                    Project__c= Prj.id,
                                                    Release__c=rls.id,
                                                    Product_Owner__c=u.id,
                                                    User_Story__c           = 'Test-Description-User-Stroy',
                                                    Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
                                                    Story_Points_SAP__c     = '21',
                                                    SFDC_Story_Points__c    = '21',
                                                    StoryPointsMicrostrat__c=  21.0,
                                                    Story_points__c         =  '5',
                                                    Development_Stage__c    = 'Backlog' ,
                                                    Priority__c             = '0',
                                                    Planned_Sprint_del__c   = sprints[0].Id,
                                                    Allocated_Sprint__c     = null
            );
        
            requirements.add(objRequirement);
        }
        insert requirements;
        
        test.startTest();
        
        PageReference pageRef = Page.SprintPlanning;
        Test.setCurrentPage(pageRef);
        
        sprintPlanning controller = new sprintPlanning();
        List<SelectOption>      listSprints     = controller.getSprint();
        List<SelectOption>      listProjects     = controller.getProject();
        PageReference           pageRefNull     = controller.syncUserStory();
        System.assertEquals(null, pageRefNull); 
        controller.currentSprint                = sprints[0].Id; 
        List<Requirements__c> listAllocatedUS   = controller.getAllocatedUserStory();
        List<Requirements__c> listNonAllocatedUS= controller.getNotAllocatedUserStory();
        
        Sprint__c testspr     =  controller.spr ;
        list <Requirements__c> testreq = controller.req;
        list <Requirements__c> testnonreq = controller.notAllocatedUS ;
        Sprint__c testsprint      = controller.getSelectedSprint();
        integer test1             = controller.getsfdcPlanned();
        integer test2             = controller.getsapPlanned();
        integer test3             = controller.getflexPlanned();
        integer test4             = controller.getmicrostatPlanned();
        integer test5             = controller.getsfdcRemain();
        integer test6             = controller.getsapRemain();
        integer test7             = controller.getflexRemain();
        integer test8             = controller.getmicrostatRemain();
        
        Apexpages.currentPage().getParameters().put('SprintID' , 'AllocateUSies');
        Apexpages.currentPage().getParameters().put('UserStoryID' ,requirements[0].id);
        controller.updateUserStoriesSprint();
        
        
        controller.autoPlan();
        test.stopTest();
        
    }
    
    
    static testMethod void myUnitTest_ElseCases() {
        
        // Perform  data preparation.
        List<Sprint__c> sprints = new List<Sprint__c>{};
            
        for(Integer i = 0; i < 2; i++){
            Sprint__c objSprint = new Sprint__c(Name        = 'Test-Sprint'+ i,
                                                Status__c   = 'In Planning'
                                            );
            sprints.add(objSprint);
        }
        insert sprints;
        List<Requirements__c> requirements = new List<Requirements__c>{};
        Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@lexmark.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles',legacy_company__c='Perceptive', username='standardusera@testorg.com',LX_Region__c = 'NE');
        insert u;
        
        Project__c prj = new Project__c(Name='Project Name');
        insert prj;
        Release__c rls = new Release__c(Name='Sample');
        insert rls;
        Sprint__c sprnt = new Sprint__c (Name='Sample Sprint');
        insert sprnt;
        for(Integer i = 0; i < 2; i++){
            Requirements__c objRequirement =new Requirements__c(
                                                    Project__c= Prj.id,
                                                    Release__c=rls.id,
                                                    Product_Owner__c=u.id,
                                                    User_Story__c           = 'Test-Description-User-Stroy',
                                                    Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
                                                    Story_Points_SAP__c     = '21',
                                                    SFDC_Story_Points__c    = '21',
                                                    StoryPointsMicrostrat__c=  21.0,
                                                    Story_points__c         =  '5',
                                                    Development_Stage__c    = 'Backlog' ,
                                                    Priority__c             = '0',
                                                    Planned_Sprint_del__c   = sprnt.id,
                                                    Allocated_Sprint__c     = sprints[0].Id
            );
            requirements.add(objRequirement);
        }
        insert requirements;
        
        test.startTest();
        
        PageReference pageRef = Page.SprintPlanning;
        Test.setCurrentPage(pageRef);
        sprintPlanning controller = new sprintPlanning();
        List<SelectOption>    listSprints       = controller.getSprint();
        PageReference pageRefNull               = controller.syncUserStory();
        System.assertEquals(null, pageRefNull);
        controller.currentSprint                = sprints[0].Id; 
        List<Requirements__c> listAllocatedUS   = controller.getAllocatedUserStory();
        List<Requirements__c> listNonAllocatedUS= controller.getNotAllocatedUserStory();
        
        Sprint__c testsprint      = controller.getSelectedSprint();
        integer test1             = controller.getsfdcPlanned();
        integer test2             = controller.getsapPlanned();
        integer test3             = controller.getflexPlanned();
        integer test4             = controller.getmicrostatPlanned();
        integer test5             = controller.getsfdcRemain();
        integer test6             = controller.getsapRemain();
        integer test7             = controller.getflexRemain();
        integer test8             = controller.getmicrostatRemain();
        
        Apexpages.currentPage().getParameters().put('SprintID' , 'NonAllocateUSies');
        Apexpages.currentPage().getParameters().put('UserStoryID' ,requirements[0].id);
        controller.updateUserStoriesSprint();
        controller.autoPlan();
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest_NullCases() {
                
        List<Sprint__c> sprints = new List<Sprint__c>{};
            
        for(Integer i = 0; i < 200; i++){
            Sprint__c objSprint = new Sprint__c(Name        = 'Test-Sprint'+ i,
                                                Status__c   = 'In Planning'
                                            );
            sprints.add(objSprint);
        }
        insert sprints;
        List<Requirements__c> requirements = new List<Requirements__c>{};
        Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@lexmark.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles',legacy_company__c='Perceptive', username='standardusera@testorg.com',LX_Region__c = 'NE');
        insert u;
        
        Project__c prj = new Project__c(Name='Project Name');
        insert prj;
        Release__c rls = new Release__c(Name='Sample');
        insert rls;
        Sprint__c sprnt = new Sprint__c (Name='Sample Sprint');
        insert sprnt;
        for(Integer i = 0; i < 2; i++){
            Requirements__c objRequirement =new Requirements__c(
                                                    Project__c= Prj.id,
                                                    Release__c=rls.id,
                                                    Product_Owner__c=u.id,
                                                    User_Story__c           = 'Test-Description-User-Stroy',
                                                    Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
                                                    Story_Points_SAP__c     = '21',
                                                    SFDC_Story_Points__c    = '21',
                                                    StoryPointsMicrostrat__c=  21.0,
                                                    Story_points__c         =  '5',
                                                    Development_Stage__c    = 'Backlog' ,
                                                    Priority__c             = '0',
                                                    Planned_Sprint_del__c   = sprnt.id,
                                                    Allocated_Sprint__c     = sprints[1].Id
            );
            requirements.add(objRequirement);
        }
        insert requirements;        
        test.startTest();
        sprintPlanning controller = new sprintPlanning();
        List<SelectOption>    listSprints       = controller.getSprint();
        PageReference pageRefNull               = controller.syncUserStory();
        System.assertEquals(null, pageRefNull);
        controller.currentSprint                = null; 
        List<Requirements__c> listAllocatedUS   = controller.getAllocatedUserStory();
        List<Requirements__c> listNonAllocatedUS= controller.getNotAllocatedUserStory();
        
        
        Sprint__c testsprint      = controller.getSelectedSprint();
        integer test1             = controller.getsfdcPlanned();
        integer test2             = controller.getsapPlanned();
        integer test3             = controller.getflexPlanned();
        integer test4             = controller.getmicrostatPlanned();
        integer test5             = controller.getsfdcRemain();
        integer test6             = controller.getsapRemain();
        integer test7             = controller.getflexRemain();
        integer test8             = controller.getmicrostatRemain();
        
        test.stopTest();
        
    }
    
    
}