/* Class Name : LX_TaskEventUtils
 * Description : This class will be used as util class for Task and Event objects when ever they are inserting
 from triggers
 * Created By : Srinivas Pinnamaneni(Deloitte)
 * Created Date : 5-2-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Srinivas Pinnamaneni 5-2-2013                        Initial Version
 * Madhurupa Ghose Roy  5-22-2013 
 * Kapil Reddy Sama     8-14-2013                       Migrated to QA
 */

public Class LX_TaskEventUtils{

/*Description: This method is written to update the contact job role field and set Last Activity Date for Task
*Param:setContactIds,lstTasks
*Returns:VOID
*/ 
    public void UpdateTaskJobRole(Set<Id> setContactIds, List<Task> lstTasks){
        //Get the list of contact records from the Contact object
        Map<Id,Contact> mapContact = new Map<Id,Contact>([select id,Job_Role__c,LX_Last_Activity_Date__c from contact where id in: setContactIds]);
     
        //Check the size of map 
        if(mapContact == null || mapContact.size() <= 0) return;
     
        //Declare contact object here
        Contact objContact = null;
       
        //Iterate the list of tasks record to update the contact job role field 
        for(Task obj : lstTasks){
            objContact  = mapContact.get(obj.WhoId);
            obj.LX_Contact_Job_Role__c = objContact.Job_Role__c;
            objContact.LX_Last_Activity_Date__c=Datetime.now();
        }
    
        try{
            if(objContact!=null){
                update objContact;
            }
        }
        catch (exception ex ){
            LX_CommonUtilities.createExceptionLog(ex);
        }
 
    }

/*Description: This method is written to update the contact job role field and set Last Activity Date for Event
*Param:setContactIds,lstEvents
*Returns:VOID
*/ 
  
    public void UpdateEventJobRole(Set<Id> setContactIds, List<Event> lstEvents){
        //Get the list of contact records from the Contact object
        Map<Id,Contact> mapContact = new Map<Id,Contact>([select id,Job_Role__c,LX_Last_Activity_Date__c from contact where id in: setContactIds]);
     
        //Chekc the size of map 
        if(mapContact == null || mapContact.size() <= 0) return;
     
        //Declare contact object here
        Contact objContact = null;
     
        //Iterate the list of tasks record to update the contact job role field 
        for(Event obj : lstEvents){
            objContact  = mapContact.get(obj.WhoId);
            obj.LX_Contact_Job_Role__c = objContact.Job_Role__c;
            objContact.LX_Last_Activity_Date__c=Datetime.now();
        }
        try{
            if(objContact!=null){
                update objContact;
            }
        }
        catch (exception ex ){
            LX_CommonUtilities.createExceptionLog(ex);
        }
    }
}