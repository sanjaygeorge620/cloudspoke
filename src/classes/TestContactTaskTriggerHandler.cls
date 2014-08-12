public class TestContactTaskTriggerHandler{

    //This method creates a task when the 'Requests Follow Up' field in 'Customer Loyalty Survey' Object is checked.

    public static void createTaskonContact(List<Survey_MKT_Customer_Loyalty__c> newList,
                                           Map<Id, Survey_MKT_Customer_Loyalty__c> oldMap, boolean isInsert){
    
        
        List<Task> taskList = new List<Task>();
        for(Survey_MKT_Customer_Loyalty__c clsy : newList){
            // Check if the 'Requests Follow Up' field in 'Customer Loyalty Survey' Object is inserted or updated.
            if(clsy.Requests_Follow_Up__c  && (isInsert || clsy.Requests_Follow_Up__c != oldMap.get(clsy.Id).Requests_Follow_Up__c)){
                // Creates a new task if there is any change in 'Requests Follow Up' field in 'Customer Loyalty Survey' Object.
                
                Task ct = new Task();
				Test_Custom_Setting__c ctn = Test_Custom_Setting__c.getValues('Dayakar Daram');
                ct.Subject = 'Note';            
                ct.OwnerId = ctn.ID__c; // Created task is always assigned to this person. 
                ct.WhoId = clsy.Contact_Name__c;
                ct.Description = 'Likelihood to Recommend : '+clsy.Likelihood_to_Recommend__c+'\n Reason For Recommendation : '
                    +clsy.Reason_for_Recommendation__c+'\n Suggestions_for_Improvement__c : '+clsy.Suggestions_for_Improvement__c+
                    '\n Additional Comments : '+clsy.Additional_Comments__c;
                taskList.add(ct);
                }
            }
            if(!taskList.isEmpty()){
                insert taskList; 
            }
    }
}