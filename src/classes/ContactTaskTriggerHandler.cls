/*
 *
 * Author : Pruthvi Ayireddy
 * Date: 03/28/2014
 * Description : This class is used to handle the functionality of the trigger on Customer Loyalty Survey object which creates a task, when fired. 
 *  
 */ 

public class ContactTaskTriggerHandler{

    //This method creates a task when the 'Requests Follow Up' field in 'Customer Loyalty Survey' Object is checked.

    public static void createTaskonContact(List<Survey_MKT_Customer_Loyalty__c> newList,
                                           Map<Id, Survey_MKT_Customer_Loyalty__c> oldMap, boolean isInsert){
    
        try{
        List<Task> taskList = new List<Task>();
        Map<String,Environment_Variable__c> customSettingMap = Environment_Variable__c.getAll();
        for(Survey_MKT_Customer_Loyalty__c clsy : newList){
            // Check if the 'Requests Follow Up' field in 'Customer Loyalty Survey' Object is inserted or updated.
            if(clsy.Requests_Follow_Up__c  && (isInsert || clsy.Requests_Follow_Up__c != oldMap.get(clsy.Id).Requests_Follow_Up__c)){
                Task ct = new Task();
                ct.Subject = 'Note';            
                // Created task is always assigned to this person.'NetPromoter.TaskAssignedTo' from Environment variables Custom setting
                ct.OwnerId = customSettingMap.get('NetPromoter.TaskAssignedTo').Value__c;
                ct.WhoId = clsy.Contact_Name__c;
                ct.Description = 'Likelihood to Recommend : '+clsy.Likelihood_to_Recommend__c+'\n Reason For Recommendation : '
                    +clsy.Reason_for_Recommendation__c+'\n Suggestions for Improvement : '+clsy.Suggestions_for_Improvement__c+
                    '\n Additional Comments : '+clsy.Additional_Comments__c;
                taskList.add(ct);
                }
            }
            if(!taskList.isEmpty()){
                insert taskList; 
            }
            }
         catch(Exception e){
            System.debug('Exception thrown in the method :: createTaskonContact '+e.getMessage());
         }
    }
}