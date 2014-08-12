@isTest
private class SitesTrainingController_Test {
//-------------------------------------------------------------------------------
// TEST SitesTrainingController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

    
        static testMethod void testSitesTrainingController () {    
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id,Legacy_Company__c='Lexmark', 
         timezonesidkey='America/Los_Angeles', username='standarqawsedduser@tes322torg1.com',LX_Region__c = 'NE', EmployeeNumber = '1234');
         Insert adminUser;
    
           
          
          
            test.StartTest();
           
           System.runAs(adminUser) 
           {
               Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
               System.Debug('Check 1' +Limits.GetQueries());
                integer num;
                SitesTrainingController  controller;
                
               
                
                 System.Debug('Check 2' +Limits.GetQueries());
                 
                 course__c newCourse = new course__c (name='SitesControllerTest.course');
                 insert newCourse;
                 
                 ELearning_Registration__c newElearning = new ELearning_Registration__c ();
                 insert newElearning;
                 
                 
                 class__c  test_class = new class__c (Course__c = newCourse.id);
                 insert test_class;
                 
                //test course and class
                //course__c test_course = [select id from course__c where name='SitesControllerTest.course' limit 1];
                //class__c test_class = [select id from class__c where Course__r.name='SitesControllerTest.course' limit 1];
                Test.setCurrentPageReference(new PageReference('Page.coursedetails'));
                ApexPages.currentPage().getParameters().put('id', newCourse.id);
               
                
                controller = new SitesTrainingController();
                    controller.getCourseDetails();
                    controller.getClassesbyCourse();
                    controller.getCourseAttachments();
                    
                    System.debug('^^^^^^^^^^^^^^^^^^^^'+ Controller );
                
                System.debug('^^^^^^^^^^^'+ [select id From ELearning_Registration__c where Account__c=:Controller.SITE_ACCOUNT.id]);
                //List<ELearning_Registration__c> test_reg = [select id From ELearning_Registration__c where Account__c=:Controller.SITE_ACCOUNT.id];
                
                Test.setCurrentPageReference(new PageReference('Page.registrationdetails'));
                ApexPages.currentPage().getParameters().put('id', newElearning.id);
                controller = new SitesTrainingController();
                system.assertequals(controller.getRegistrationDetails().id,newElearning.id);
                
                num = [select count() From Training_Attendee__c t where t.Registration__r.id=:newElearning.id];
                system.assertequals(controller.getAttendees().size(),num);
                
                 
                controller.getMyRegistrations();
                
                Test.setCurrentPageReference(new PageReference('Page.training_location'));
                //controller.getTrainingLocation();
                
                system.assertequals(controller.getMyeLearningClasses().size(),checkClasses(Controller.PARAM_ELEARNING,Controller.SITE_CONTACT.ID));
                system.assertequals(controller.getMyClassRoomClasses().size(),checkClasses(Controller.PARAM_CLASSROOM,Controller.SITE_CONTACT.ID));
               // system.assertequals(controller.getMyLiveOnlineClasses().size(),checkClasses(Controller.PARAM_LIVEONLINE,Controller.SITE_CONTACT.ID));
                                
                Test.setCurrentPageReference(new PageReference('Page.classdetails'));
                ApexPages.currentPage().getParameters().put('id', test_class.id);
                controller = new SitesTrainingController();
                        system.assertequals(controller.getClassDetails().id,test_class.id);
                        
                Chapter__c test_chapter = new Chapter__c(Class__c = test_class.id, Chapter_Number__c = 11);
                insert test_chapter;
                
                //Chapter__c test_chapter = [select id from Chapter__c where Class__c =:test_class.id and Internal_Chapter__c=false limit 1];
                //Training_Attendee__c Attendee =[Select id from Training_Attendee__c where Contact__c=:controller.SITE_CONTACT.Id and Class__c =:test_class.id and Registration_Status__c ='Completed'];
                Test.setCurrentPageReference(new PageReference('classdetails_viewchapter'));
                ApexPages.currentPage().getParameters().put('id', test_chapter.id);
                controller = new SitesTrainingController();
                    system.debug('test_chapter.id: ' + test_chapter.id);
                   // system.assertequals(controller.getViewChapter().id,test_chapter.id);
                
                num = [select count() From Course__c c where c.course_status__c = 'Available' and Featured_Course_Order__c!=null and Course_Type__c=:Controller.PARAM_ELEARNING and Active__c=true and Customer_Training__c = true];
                system.assertequals(controller.getFeaturedCourseseLearning().size(),num);
                
                num = [select count() From Course__c c where c.course_status__c = 'Available' and Course_Type__c=:Controller.PARAM_ELEARNING and Active__c=true  and Customer_Training__c = true];
                system.assertequals(controller.getCourseseLearning().size(),num);
                
                num = [select count() From Course__c c where c.course_status__c = 'Available' and Course_Type__c=:Controller.PARAM_LIVEONLINE and Active__c=true and Customer_Training__c = true];
                system.assertequals(controller.getCourseseLiveOnline().size(),num);
                
                num = [select count() From Course__c c where c.course_status__c = 'Available' and Course_Type__c=:Controller.PARAM_CLASSROOM and Active__c=true and Customer_Training__c = true];
                system.assertequals(controller.getCourseseClassroom().size(),num);
                
                num = [select count() From Course__c c where c.course_status__c = 'Available' and Course_Type__c=:Controller.PARAM_ELEARNING and Release__c INCLUDES (:'Core Concept Training') and Active__c=true and Customer_Training__c = true];
                system.assertequals(controller.getCoursesCore().size(),num);
                
                num = [select count() From Course__c c where c.course_status__c = 'Available' and Course_Type__c=:Controller.PARAM_ELEARNING and Release__c INCLUDES (:'Release Training') and Active__c=true and Customer_Training__c = true];
                system.assertequals(controller.getCoursesRelease().size(),num);
                
                num = [select count() From Course__c c where c.course_status__c = 'Available' and Course_Type__c=:Controller.PARAM_ELEARNING and Release__c INCLUDES (:'Advanced Concept Training') and Active__c=true and Customer_Training__c = true];
                system.assertequals(controller.getCoursesAdvanced().size(),num);
                
                controller.getTrainingItems();
                
                //the rest of these methods are queries....
             //   num = [select count() from Training_Info_Item__c where Parent_Training_Info_Item__c ='' and Page_Section_Number__c =:Controller.PARAM_TRAINING_PROGRAMS];
             //    system.assertequals(controller.getTrainingPrograms().size(),num);
                controller.getTrainingPrograms();
                controller.getTrainingServices();
                controller.getOtherLinks(); 
                 
            /*   num = [select count() From Training_Info_Item__c t where t.Page_Section_Number__c =:Controller.PARAM_TOP_WIDGET and t.Order__c=0];
                 system.assertequals(controller.getTopWidget().size(),num); */
                controller.getVideoWidget();
                controller.getLeftWidget();
                controller.getMiddleWidget();
                controller.getRightWidget(); 
                
                  }
                test.StopTest();
                
         
           
           
        }
        private static integer checkClasses(string CourseType, id CONTACTID){
            Set<Id> myClasses = new Set<Id>();
               List<Training_Attendee__c> attendees = [Select Class__c 
                                                        from Training_Attendee__c 
                                                        where 
                                                            Contact__c=:CONTACTID and 
                                                            Registration_Status__c = 'Completed' and 
                                                            class_Type__c =:CourseType and
                                                            (Status__c = 'Enrolled' or Status__c = 'Attended')
                                                       ];
                for(Training_Attendee__c attendee : attendees){
                     myClasses.add(attendee.Class__c);   
                }
                
                List<Class__c> availableClasses = [select id, 
                                                          name, 
                                                          Course__r.Name, 
                                                          Class_Date__c, 
                                                          Open_Seats__c, 
                                                          Class_Type__c, 
                                                          Class_Capacity__c, 
                                                          Days_Until_Class__c, 
                                                          Training_Location__c, 
                                                          Training_Location__r.Name 
                                                    from Class__c 
                                                    where Id in : myClasses
                                                    order by Course__r.Name
                                                   ];
       
               return availableClasses.size();
        }
}