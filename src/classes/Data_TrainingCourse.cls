public with sharing class Data_TrainingCourse {
 	public static Course__c createTrainingCourse(Integer Tokens){       
//        Id courseRecordId = 
        RecordType courseRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Course__c' limit 1];
               
	  	  Course__c currentCourse = new Course__c();
	   	 if(courseRecord!=null){
	   	   currentCourse.RecordTypeId = courseRecord.id;
	   	 } 
	   	 currentCourse.Tokens__c = Tokens;
	  	  insert currentCourse ;      
	   	  return currentCourse;  
   	  }
     

      static testMethod void testTestData() {
         Course__c currentCourse = Data_TrainingCourse.createTrainingCourse(3);       
         System.assert(currentCourse.id != null);
      }   
}