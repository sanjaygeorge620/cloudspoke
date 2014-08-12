/* Trigger Name  : LX_updateTaskJobRole
 * Description   : This trigger will be executed when task is getting created from contact object and populates the contact
 * Created By    : Srinivas Pinnamaneni(Deloitte)
 * Created Date  : 05-2-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Srinivas Pinnamaneni 05-2-2013                       Initial Version
 * Srinivas Pinnamaneni 07-22-2013                      Migrated to QA
 * Kapil Reddy Sama     08-14-2013
 */

//Job Role name in Activity Contact Job Role field.
trigger LX_updateTaskJobRole on Task (before insert) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    
    //Create a list object to store task records
    List<Task> lstContactTasks = new List<Task>();
   
    //Declare a string variable to hold the Contact object ID
    String strContactObjectId = '003';
    
    //Declare a set to store contact Ids
    Set<Id> setContacts = new Set<Id>();
    
    //Iterate all the tasks created here and check whethere the WHOID is related to contact object
    for(Task objTask : trigger.New){
        //Check if task who id is related to conatct record id
        if(objTask.WhoId != null &&  String.valueOf(objTask.WhoId).startswith(strContactObjectId)){
        
            //add contact ids to set
            setContacts.add(objTask.WhoId);
        
            //add Tasks to list here
            lstContactTasks.add(objTask);
        }
    }
   
    //Check the list size and call method to udpate job role
    if(lstContactTasks.size() <= 0) return;
   
    LX_TaskEventUtils objTaskEventUtils = new LX_TaskEventUtils();
    objTaskEventUtils.UpdateTaskJobRole(setContacts,lstContactTasks); 
}