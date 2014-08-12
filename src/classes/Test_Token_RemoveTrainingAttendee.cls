@isTest
private class Test_Token_RemoveTrainingAttendee {

    static testMethod void myUnitTest() {
    
        
        
        //create opportunity in system
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
            //stageList.add('Negotiation');
           // stageList.add('Negotiation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
        //update test opportunity so that QA Status = 'Complete'

                
       
       
        Class__c newClass = Data_Class.createClass(); 
        Test.StartTest();   
        ELearning_Registration__c newRegistration = Data_ELearningRegistration.createElearning(newclass.id,test_Opportunities[0].AccountID ); 
         
        Training_Attendee__c newAttendee = Data_TrainingAttendee.createTrainingAttendee(newClass.id,newRegistration.id ); 
        newAttendee.contact__c = test_Opportunities[0].Ship_To__c;
        update newAttendee;
                
       
        
        delete newAttendee;

              //Token_AssignTrainingAttendee.AttendeeStatus(1, contactID, attendeeID, accountID , name, registration);
              
              
              Test.StopTest();
              
              try{
              //
              //Rahul comment    //Token_RemoveTrainingAttendee.RemoveAttendee(attendeeID);
              }catch(Exception e){
                  system.debug('e.getMessage(): '+ e.getmessage());
                  System.Assert(e.getMessage().contains('Success: Tokens have been unassigned.'));
                  
              }
              

                        
        
        
                                         
                                             
    }
}