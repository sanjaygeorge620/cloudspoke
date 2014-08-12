/* Trigger Name  : LX_updateEventJobRole
 * Description   : This trigger will be executed when Event is getting created from contact object and populates the contact
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
trigger LX_updateEventJobRole on Event(before insert) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    //Create a list object to store Event records
    List<Event> lstContactEvents = new List<Event>();
   
    //Declare a string variable to hold the Contact object ID
    String strContactObjectId = '003';
    
    //Declare a set to store contact Ids
    Set<Id> setContacts = new Set<Id>();
    
    //Iterate all the Events created here and check whethere the WHOID is related to contact object
    for(Event objEvent : trigger.New){
        //Check if Event who id is related to conatct record id
        if(objEvent.WhoId != null &&  String.valueOf(objEvent.WhoId).startswith(strContactObjectId)){
         
            //add contact ids to set
            setContacts.add(objEvent.WhoId);
         
            //add Events to list here
            lstContactEvents.add(objEvent);
        }
   }
   
   //Check the list size and call method to udpate job role
   if(lstContactEvents.size() <= 0) return;
   
   LX_TaskEventUtils objEventEventUtils = new LX_TaskEventUtils();
   objEventEventUtils.UpdateEventJobRole(setContacts,lstContactEvents); 
}