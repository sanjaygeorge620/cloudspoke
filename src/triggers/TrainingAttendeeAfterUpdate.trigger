trigger TrainingAttendeeAfterUpdate on Training_Attendee__c (after update) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    Set<Id> classIds = new Set<Id>();
    
    //PR-02165//
    Map<Id, Training_Attendee__c> mapTrainingAttendeeforShare = new Map<Id, Training_Attendee__c>();
    Map<Id, Training_Attendee__c>  mapTrainingAttendeeforCancelled = new Map<Id, Training_Attendee__c>();
    
    Map<Id ,User> mapContactToUSer =  new Map<Id ,User>() ;
    Set<Id> IdsRegistration = new  Set<Id>();
    Set<Id> IdsUser = new Set<Id>() ;
    //PR-02165//
    
    for (Training_Attendee__c attendee: Trigger.new){
        if(attendee.Class__c != null)
            classIds.add(attendee.Class__c);
    }
    
    //change for PR-02163
    for (Training_Attendee__c attendee: Trigger.old){
        if(attendee.Class__c != null)
            classIds.add(attendee.Class__c);
    }
    
    
   Map<ID, Class__c> idToClassMap = new Map<ID, Class__c>([select id, Number_of_Attendees__c
             from Class__c where id in :classIds]);
   
   List<Class__c> toBeUpdatedClasses = new List<Class__c>();
   
   //Find the class, increment the number of 
    for(integer i=0;i<Trigger.size;i++){
        Training_Attendee__c oldAttendee = Trigger.Old[i];
        Training_Attendee__c newAttendee = Trigger.New[i];
    
        if (newAttendee.Class__c != null && 
            newAttendee.Status__c != oldAttendee.Status__c && 
            newAttendee.Status__c == 'Cancelled' &&
            newAttendee.Class__c == oldAttendee.Class__c){ //No change in Class
            
            Class__c aClass = idToClassMap.get(newAttendee.Class__c);
            if(aClass!=null){
                
                
                
                if(aClass.Number_of_Attendees__c != null && aClass.Number_of_Attendees__c > 0){
                    aClass.Number_of_Attendees__c = aClass.Number_of_Attendees__c - 1;
                }
                toBeUpdatedClasses.add(aClass);
            }
        }else if(   newAttendee.Class__c != null && 
                    newAttendee.Status__c != oldAttendee.Status__c && 
                    oldAttendee.Status__c == 'Cancelled' &&
                    newAttendee.Class__c == oldAttendee.Class__c){  //No change in Class
                
            Class__c aClass = idToClassMap.get(newAttendee.Class__c);
            if(aClass!=null){
                
                
                
                if(aClass.Number_of_Attendees__c != null){
                    aClass.Number_of_Attendees__c = aClass.Number_of_Attendees__c + 1;
                }
                toBeUpdatedClasses.add(aClass);
        }
                
        }
        
        //change for PR-02163
        if(newAttendee.Status__c != 'Cancelled' && newAttendee.Class__c != oldAttendee.Class__c) {
          Class__c newClass = idToClassMap.get(newAttendee.Class__c);
          Class__c oldClass = idToClassMap.get(oldAttendee.Class__c);
          if(newClass != null && newClass.Number_of_Attendees__c != null) {
            newClass.Number_of_Attendees__c = newClass.Number_of_Attendees__c + 1;
            toBeUpdatedClasses.add(newClass);
          }
          else {
            newClass.Number_of_Attendees__c = 1;
            toBeUpdatedClasses.add(newClass);
          }
          if(oldClass != null && oldClass.Number_of_Attendees__c != null && oldClass.Number_of_Attendees__c > 0) {  
            oldClass.Number_of_Attendees__c = oldClass.Number_of_Attendees__c - 1;
            toBeUpdatedClasses.add(oldClass);
          }
        }
    
       
       //PR-02165//
        if(     ( newAttendee.contact__c != null )
              &&( newAttendee.status__c == 'Enrolled'|| newAttendee.status__c == 'Attended' 
                  ||newAttendee.status__c == 'Seat Requested' )){
            
            mapTrainingAttendeeforShare.put( newAttendee.contact__c , newAttendee ); 
           if(  newAttendee.contact__c != oldAttendee.contact__c ){
             if( oldAttendee.contact__c != null ){
                mapTrainingAttendeeforCancelled.put(oldAttendee.contact__c, OldAttendee );
                IdsRegistration.add(oldAttendee.Registration__c) ;
              }
           }
        }
        
        if( ( oldAttendee.contact__c != null) &&  
            (oldAttendee.status__c != newAttendee.status__c) && 
            newAttendee.status__c == 'Cancelled'){
          
          mapTrainingAttendeeforCancelled.put( oldAttendee.contact__c , oldAttendee);
          IdsRegistration.add(oldAttendee.Registration__c) ;
          
        }
        
       //PR-02165//
        
    
    }
    
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
    
    
    //PR-02165//
    List<User> listUser = new List<User>([Select Id , ContactId from User 
                                          Where ContactId IN : mapTrainingAttendeeforShare.keyset() OR 
                                          ContactId IN : mapTrainingAttendeeforCancelled.keyset() ]);
    
    for( User u : listUser ){
       mapContactToUSer.put(u.ContactID , u );
    }
    
    
    for(  Training_Attendee__c trainingAttendee : mapTrainingAttendeeforCancelled.values()){
       if( mapContactToUSer.get(trainingAttendee.Contact__c) != null ){
         User u = mapContactToUSer.get(trainingAttendee.Contact__c);
         IdsUser.add(u.Id);
       }
    }
    
    
    if( IdsUser.size() > 0  ){
        
      List<ELearning_Registration__Share> listElearningRegistrationDelete = new List<ELearning_Registration__Share>();
      Map<Id , ELearning_Registration__Share> mapElearningRegistrationRetrieveforDelete = new Map<Id , ELearning_Registration__Share>();
      
      
      mapElearningRegistrationRetrieveforDelete =  new Map<Id , ELearning_Registration__Share>([Select Id ,PArentId , UserOrGroupID from ELearning_Registration__Share Where 
                                                                                                ParentId IN :IdsRegistration
                                                                                                AND UserOrGroupId IN : IdsUser]);
    
       /*
      for(  ELearning_Registration__Share eRegistrationshare : mapElearningRegistrationRetrieveforDelete.values()  ){
         
         if( mapTrainingAttendeeforCancelled.get(   )){
          
    
          }
      }
      */
      
      for( Training_Attendee__c trainingAttendee :    mapTrainingAttendeeforCancelled.values()){
          
        for(  ELearning_Registration__Share eRegistrationshare : mapElearningRegistrationRetrieveforDelete.values() ){
         
          if(  ( mapContactToUSer.get(trainingAttendee.contact__c).Id == eRegistrationshare.UserOrGroupId  ) 
                && 
               ( trainingAttendee.Registration__c == eRegistrationshare.ParentId )
             ){
          
              listElearningRegistrationDelete.add(eRegistrationshare);
          }
        }
      }
      
      if( listElearningRegistrationDelete.size() > 0 )
       Database.delete(listElearningRegistrationDelete);
      
    }
    
    List<ELearning_Registration__Share> listElearningRegistrationShare = new List<ELearning_Registration__Share>();
    for( Training_Attendee__c attendee :  mapTrainingAttendeeforShare.values()  ){
      if(mapContactToUser.get(attendee.contact__c) == null)
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
    
    
   
}