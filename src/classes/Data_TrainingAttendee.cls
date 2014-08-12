public with sharing class Data_TrainingAttendee {
	public static Training_Attendee__c createTrainingAttendee(id classRecId, id registrationId){ 
 		Training_Attendee__c attendeeA   = new Training_Attendee__c();
        attendeeA.class__c = classRecId;
        attendeeA.Registration__c = registrationId;
        insert attendeeA;
        return attendeeA;  
     }
     

      static testMethod void testTestData() {
         Class__c newClass = Data_Class.createClass(); 
      	Account acc = Data_Account.createAccount();
         ELearning_Registration__c newRegistration = Data_ELearningRegistration.createElearning(newclass.id,acc.id ); 
         Training_Attendee__c newAttendee = Data_TrainingAttendee.createTrainingAttendee(newClass.id,newRegistration.id );       
         System.assert(newRegistration.id != null);
      }   
}