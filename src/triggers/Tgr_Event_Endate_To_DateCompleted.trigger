/**
**Case:  00729095
** Objective : For all of the users with ISS roles ( including Channel and Sales users ; excluding Professional Services and Tech IS users ) 
**                           On Event records, the Date Completed will always be equal to the End Date value . ( always copy the value from End Date to Date completed ) .
**                           Irrespective of the “Completed” check box.
**            For rest of the users, Event functionalities will continue to work as it is working now. 
**
**
**/


trigger Tgr_Event_Endate_To_DateCompleted on Event (before insert, before update) {

 
    List<Id> assignedToIds_ISS_Only = new List<Id>();
    
    for(Event evt : Trigger.new){
        String OwnerRole = evt.Owner_Role_Name__c;
        if( OwnerRole != null && 
            OwnerRole.startsWith('ISS') &&
            ( ! OwnerRole.contains('Professional Services'))){
            evt.Date_Completed__c = evt.EndDateTime.date();
        }
    }
    
    
    
}