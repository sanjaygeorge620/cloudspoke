/******************************************************************************
Name     : TrainingAttendeeAfterDelete 
Purpose  : Set the count of the number of attendees on the Class object.
Author   : Phi An
Date     : June 28, 2009
******************************************************************************/
trigger TrainingAttendeeAfterDelete on Training_Attendee__c (after delete) {

 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    Set<Id> classIds = new Set<Id>();
    for (Training_Attendee__c attendee: Trigger.old){
        if(attendee.Class__c != null)
            classIds.add(attendee.Class__c);
    }
    
    
    
    Map<ID, Class__c> idToClassMap = new Map<ID, Class__c>([select id, Number_of_Attendees__c
             from Class__c where id in :classIds]);
   
   List<Class__c> toBeUpdatedClasses = new List<Class__c>();
   
   //Find the class, increment the number of 
    for (Training_Attendee__c attendee : Trigger.old){
        if (attendee.Class__c != null){
            Class__c aClass = idToClassMap.get(attendee.Class__c);
            if(aClass!=null && aClass.Number_of_Attendees__c > 0 && attendee.Status__c!='Cancelled'){
                aClass.Number_of_Attendees__c = aClass.Number_of_Attendees__c - 1;
                toBeUpdatedClasses.add(aClass);
            }
        }
    }
    
    
    //if(toBeUpdatedClasses!=null && toBeUpdatedClasses.size()>0){
    //    update toBeUpdatedClasses;  
    
    //}
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