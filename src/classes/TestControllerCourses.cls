/**************************************************************************
Name    : TestControllerCourses
Author  : Kirtesh Jain
Date    : 02 July, 2009
Usage   : used to Test ControllerCourses.cls 

****************************************************************************/
@isTest
private class TestControllerCourses {

    static testMethod void testControllerCourses() {

	  RecordType courseRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Course__c' limit 1];
	  RecordType classRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Class__c' limit 1];
      
      List<ELearning_Registration__c> listelearningRegistration = new List<ELearning_Registration__c>()  ; 
      for( integer i = 0 ; i < 3  ; i++ ){
        ELearning_Registration__c elearningRegistration = new ELearning_Registration__c();
        elearningRegistration.Applicant__c = UserInfo.getUserId();
        elearningRegistration.Registration_Status__c = 'Completed';
        listelearningRegistration.add(elearningRegistration);
      }
      insert listelearningRegistration ; 
      
      Course__c currentCourse = new Course__c();
      if(courseRecord!=null)
		currentCourse.RecordTypeId = courseRecord.id;
      
      insert currentCourse ;
      
      List<Class__c>  listClass = new List<Class__c>(); 
      for( integer i = 0 ; i < 3  ; i++ ){
       	  Class__c classinstant = new Class__c();
       	  classinstant.class_status__c = 'Available';
       	  classinstant.class_Date__c = Date.today();
       	  classinstant.Course__c = currentCourse.id ;
		  if(classRecord!=null)
			classinstant.RecordTypeId = classRecord.id;
       	  
       	  listClass.add(classinstant);
       }
       insert listClass ;
       
       ApexPages.StandardController sc = new ApexPages.StandardController(currentCourse); 
       ControllerCourses extensionstdController = new ControllerCourses(sc);  
       System.AssertEquals( extensionstdController.getAvailablePortalClasses().size() , 3 ) ;
       System.AssertEquals( extensionstdController.getShowRows() , true ) ;
       
       List<User> listUser = [Select ID from User where contactId != null and isActive = true limit 1] ;
       if(listUser.size() > 0 ) { 
         System.runAs(listUser[0]){
            List<ELearning_Registration__c> listelearningRegistration1 = new List<ELearning_Registration__c>()  ; 
            for( integer i = 0 ; i < 3  ; i++ ){
               ELearning_Registration__c elearningRegistration1 = new ELearning_Registration__c();
               elearningRegistration1.Applicant__c = UserInfo.getUserId();
               elearningRegistration1.Registration_Status__c = 'Completed';
               listelearningRegistration1.add(elearningRegistration1);
            }
            insert listelearningRegistration1 ; 
          }
       }
     
     }
}