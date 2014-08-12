trigger TrainingAttendee_CheckEnrollment on Training_Attendee__c (before insert, before update) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code

//if training attendee is being set to "enrolled", check the number of training tokens related 
    Set<ID> TrainingIdSet = new Set<ID>();
    integer tokenTotals = 0;
     //get listing of all Training Attendee Recs that have Enrolled status
     for (Training_Attendee__c  trainingRec : Trigger.new){
      //  system.debug('Old status: ' + Trigger.oldMap.get(trainingRec.id).Status__c);
     //   system.debug('new status: ' + trainingRec.Status__c);
        if (
                (trigger.isinsert && trainingRec.Tokens__c>0 
                        && (trainingRec.Status__c == 'Enrolled'|| trainingRec.Status__c == 'Attended')
                ) 
                ||
                (
                    trainingRec.Tokens__c > 0 && (trainingRec.Status__c == 'Enrolled' || trainingRec.Status__c == 'Attended') 
                            && Trigger.oldMap.get(trainingRec.id).Status__c != trainingRec.Status__c)
                ){
            TrainingIdSet.add(trainingRec.id);
            system.debug('TrainingIdSet:' + TrainingIdSet);
         }   
     }
    
    if (TrainingIdSet.size() > 0) { 
      //for all training attendees that have a status of "enrolled" - get all tokens 
        List<Token__c> trainingtokenList = new List<Token__c> ([select id, 
                                                                       Training_Attendee__r.id
                                                                     from Token__c 
                                                                      where Training_attendee__r.id in :TrainingIdSet]);
     
        system.debug('trainingtokenlist:' + trainingtokenlist);
        for (Training_Attendee__c updateTrainingRec : Trigger.new) {
        //for each trigger - loop through training token list to get count of Tokens
            if (trainingtokenlist.size() > 0) {
                for (Integer T = 0; T < trainingtokenList.size(); T++){
                    
                    system.debug('tokenTotals: ' + tokenTotals);
                    system.debug('updateTrainingRec.Id: ' + updateTrainingRec.Id);
                    system.debug('trainingtokenList[T].Training_Attendee__r.id' + trainingtokenList[T].Training_Attendee__r.id);
                    if (updateTrainingRec.Id == trainingtokenList[T].Training_Attendee__r.id){
                        tokenTotals = tokenTotals + 1;
                    }
                    system.debug('tokenTotals: ' + tokenTotals);
                    system.debug('updateTrainingRec.Tokens__c: ' + updateTrainingRec.Tokens__c);
                 }   
                 if (tokenTotals < updateTrainingRec.Tokens__c){
                     system.debug('This attendee does not have enough tokens');
                     updateTrainingRec.addError('Please assign tokens before enrolling this attendee.'); 
                 }
            }else{
            updateTrainingRec.addError('Please assign tokens before enrolling this attendee.'); 
            }
         } 
     }
   
          
}