/******************************************************************************
Name     : TrainingAttendeeAfterInsert 
Purpose  : Set the count of the number of attendees on the Class object.
Author   : Phi An
Date     : June 28, 2009
******************************************************************************/
trigger TrainingAttendeeAfterInsert on Training_Attendee__c (after insert) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code

    //Map<ID, Class> idSet = new Set<ID>();
    Set<Id> classIds = new Set<Id>();
    
    //PR-02165//
    Map<Id, Training_Attendee__c> mapTrainingAttendeeforShare = new Map<Id, Training_Attendee__c>();
    Map<Id ,User> mapContactToUSer =  new Map<Id ,User>() ;
    //PR-02165//
    
    for (Training_Attendee__c attendee: Trigger.new){
        if(attendee.Class__c != null)
            classIds.add(attendee.Class__c);
        
        //PR-02165//
        if(  attendee.contact__c != null 
             && 
             attendee.status__c == 'Enrolled'){
            mapTrainingAttendeeforShare.put(attendee.contact__c , attendee );
        }
        //PR-02165//
    }
    
    //PR-02165//
    List<User> listUser = new List<User>([Select Id , ContactId from User 
                                          Where ContactId IN : mapTrainingAttendeeforShare.keyset()]);
    
    for( User u : listUser ){
       mapContactToUSer.put(u.ContactID , u );
    }
    
    
    List<ELearning_Registration__Share> listElearningRegistrationShare = new List<ELearning_Registration__Share>();
    
    for( Training_Attendee__c attendee :  mapTrainingAttendeeforShare.values()  ){
    
      if( mapContactToUser.get(attendee.contact__c) == null)
        continue ;
      ELearning_Registration__Share eRegistrationshare = new  ELearning_Registration__Share();
      eRegistrationshare.UserorGroupId =  mapContactToUser.get(attendee.contact__c).Id ; 
      eRegistrationshare.ParentId =   attendee.Registration__c ;
      eRegistrationshare.AccessLevel = 'Read';
      listElearningRegistrationShare.add(eRegistrationshare);
    }
    
    if( listElearningRegistrationShare != null && listElearningRegistrationShare.size()>0 ){
        try{
            insert listElearningRegistrationShare;
        }catch(Exception e){}  
    }
    
    //PR-02165//
    
    Map<ID, Class__c> idToClassMap = new Map<ID, Class__c>([select id, Number_of_Attendees__c
             from Class__c where id in :classIds]);
   
    List<Class__c> toBeUpdatedClasses = new List<Class__c>();
   
   //Find the class, increment the number of 
    for (Training_Attendee__c attendee : Trigger.new){
        if (attendee.Class__c != null){
            Class__c aClass = idToClassMap.get(attendee.Class__c);
            if(aClass!=null){
                
                if(aClass.Number_of_Attendees__c == null){
                    aClass.Number_of_Attendees__c = 1;
                }else{
                    aClass.Number_of_Attendees__c = aClass.Number_of_Attendees__c + 1;
                }
                toBeUpdatedClasses.add(aClass);
            }
        }
    }
    
    /**
    if(toBeUpdatedClasses!=null && toBeUpdatedClasses.size()>0){
        update toBeUpdatedClasses;  
    
    }*/
    
    
    if(toBeUpdatedClasses!=null && toBeUpdatedClasses.size()>0){
        //get rid of duplicates, counts should be the same since retrieve from same map multiple times to update 
        //number of attendees
        List<Class__c> classes = new List<Class__c>();
        Set<Id> uniqueClassIds = new Set<Id>();
        for(Class__c c : toBeUpdatedClasses){
            uniqueClassIds.add(c.Id);
        }
        for(Id i : uniqueClassIds){
            classes.add(idToClassMap.get(i));
        }
        update classes;  
    }
    
    
}