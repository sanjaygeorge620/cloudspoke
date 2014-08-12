/*******************************************************
Trigger Name : createTaskAndNotification 
Created Date : 19th June 2012
Related Story : US1347
Author : Appirio Offshore(Hemant)
Purpose : create a new Task, send notification to Sales Operations Queue
          when Submitted for Review field on the Opportunity is checked.
**********************************************************/

trigger createTaskAndNotification on Opportunity (after insert , after update) {
 
    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;   

    
    List<Opportunity> oppList = new List<Opportunity>();
    for(Opportunity opp : Trigger.new){
        if(isSubmittedForReview(opp)){
            oppList.add(opp);
        }
        
    }
    
    if(oppList.size() > 0){
        createTaskAndNotificationOnOpp.createTaskAndNotification(oppList);
    }
    
    /* Returns true if the Submitted for Review field on the Opportunity is checked */
    private boolean isSubmittedForReview(Opportunity opp){
        if(opp.Submitted_for_Review__c){
            if(Trigger.isInsert){
                return true;
            }
            if(Trigger.isUpdate && !Trigger.oldMap.get(opp.id).Submitted_for_Review__c){
                return true;
            }   
        }
        return false;
    }
}