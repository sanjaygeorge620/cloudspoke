@isTest
private class Test_Design_Controller {
  
  static testMethod void myUnitTest() {
        try{
        // Perform  data preparation.
        List<Project__c> projects = new List<Project__c>{};
        
        for(Integer i = 0; i < 10; i++){
            Project__c objProj = new Project__c(Name        = 'Test-Project'+ i
                                            );
            projects.add(objProj);
        }
        
        insert projects ;
        
        List<Sprint__c> sprints = new List<Sprint__c>{};
            
        for(Integer i = 0; i < 10; i++){
            Sprint__c objSprint = new Sprint__c(Name        = 'Test-Sprint'+ i,
                                                Status__c   = 'In Planning',
                                                Project__c  = projects[0].id
                                            );
            sprints.add(objSprint);
        }
        insert sprints;
        List<Requirements__c> requirements = new List<Requirements__c>{};
        Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@testorg.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='America/Los_Angeles', username='standardusera@testorg.com',LX_Region__c='NE');
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
                                                    Development_Stage__c    = 'Backlog' ,
                                                    Priority__c             = '0',
                                                    Planned_Sprint_del__c   = sprints[0].Id,
                                                    Allocated_Sprint__c     = sprints[0].Id
            );
            requirements.add(objRequirement);
        }
        insert requirements ;
        
        
        PageReference pageRef = Page.UserStoryDesign;
        Test.setCurrentPage(pageRef);
        
        Design_Controller controller = new Design_Controller();
        String testcurrentSprint  = controller.currentSprint;
        Boolean testgetIsSelectedDesignDetails = controller.getIsSelectedDesignDetails();
        controller.setIsSelectedDesignDetails(true);
        Boolean testgetIsSelectedDesignComponent = controller.getIsSelectedDesignComponent();
        controller.setIsSelectedDesignComponent(true);
        Boolean testgetIsSelectedDesignname =  controller.getIsSelectedDesignname();
        controller.setIsSelectedDesignname(true);
        test.startTest();
        Boolean testgetIsSelectedAcceptance =  controller.getIsSelectedAcceptance();
        controller.setIsSelectedAcceptance(true);
 
        List<SelectOption> testgetSprint   =  controller.getSprint();
        List<SelectOption> testgetStatus   =  controller.getStatus();
        string testSprName    = controller.SprName;
        list<string> testgetUserStory = controller.getUserStory();
        map<string,UserStory2Design__c> testgetUserStoryDesign = controller.getUserStoryDesign();
        map<string,Requirements__c> testgetUserStoryDesign2 = controller.getUserStoryDesign2();
        test.stopTest();
        Apexpages.currentPage().getParameters().put('SprintName' ,projects[0].id );
        try{
          pageReference prt1 =  controller.converTWord();
        }
          catch(System.QueryException e){
        }
        }
        catch(exception e){
        
        }
  }
  
  static testMethod void myUnitTest2() {
        try{
        // Perform  data preparation.
        List<Project__c> projects = new List<Project__c>{};
        
        for(Integer i = 0; i < 10; i++){
            Project__c objProj = new Project__c(Name        = 'Test-Project'+ i
                                            );
            projects.add(objProj);
        }
        
        insert projects ;
        
        List<Sprint__c> sprints = new List<Sprint__c>{};
            
        for(Integer i = 0; i < 10; i++){
            Sprint__c objSprint = new Sprint__c(Name        = 'Test-Sprint'+ i,
                                                Status__c   = 'In Planning',
                                                Project__c  = projects[0].id
                                            );
            sprints.add(objSprint);
        }
        insert sprints;
        List<Requirements__c> requirements = new List<Requirements__c>{};
        Profile p = [select id from profile where name='Standard User'];
         User u = new User(alias = 'standt', email='standarduser@testorg.com',
                            emailencodingkey='UTF-8', lastname='Testinga', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,LX_Region__c='NE',
                            timezonesidkey='America/Los_Angeles', username='standardusera@testorg.com');
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
                                                    Development_Stage__c    = 'Backlog' ,
                                                    Priority__c             = '0',
                                                    Planned_Sprint_del__c   = sprints[0].Id,
                                                    Allocated_Sprint__c     = sprints[0].Id
            );
            requirements.add(objRequirement);
        }
        insert requirements ;
        
         test.startTest();
        
        PageReference pageRef = Page.UserStoryDesign;
        Test.setCurrentPage(pageRef);
        
        Design_Controller controller = new Design_Controller();
        String testcurrentSprint  = controller.currentSprint;
        Apexpages.currentPage().getParameters().put('StName' , 'All');
        test.stopTest();
        list<string> testgetUserStory = controller.getUserStory();
        map<string,UserStory2Design__c> testgetUserStoryDesign = controller.getUserStoryDesign();
        map<string,Requirements__c> testgetUserStoryDesign2 = controller.getUserStoryDesign2();
        try{
          pageReference prt2 =  controller.redirectDesign();
          }
          catch(System.QueryException e){
          }
          }
         catch(exception e){
         
         } 
    }
}