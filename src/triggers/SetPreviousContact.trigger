/********************************************************************
*   when a customer Portal user is updated, we need to make sure that the contact ID that the user was associated is maintained even if the 
*       the contact is "deactivated" and unlinked from the user record
***************************************************************************/


trigger SetPreviousContact on User(before insert, before update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
   set<String> idset = new set<String>();
   list<User> PreviousContactListUpdated = new list<User>();         //list of all users that will be updated
   list<User> PreviousContactList = new list<User>();                //current list of all users that have the previous_contact__c field completed
   for(User U : Trigger.new)
   {
   idset.add(string.valueof(U.COntactID));
   }
   if(trigger.IsInsert)
   {
       PreviousContactList = [select id, Previous_contact__c from user where Previous_Contact__c in: idset and Previous_Contact__c != null and contactID != null limit 1000];
   }
   
   for(User u : Trigger.new) 
   {
        if (u.ContactID != null){
            if(!Test.isRunningTest()){
                system.debug('u.Previous_Contact__c: ' + u.Previous_Contact__c);
                
                if(u.Previous_Contact__c == null ||
                  ( u.ContactID != Trigger.Old[0].Previous_Contact__c && trigger.isUpdate) )
                  {                //only update previous contact field if null or doesn't match contact ID field
                    if(trigger.IsInsert)
                    {                                                                               //if on an insert, use current list of users to remove Previous contact linkage.
                        for(User UserRec : PreviousContactList)
                        {
                            system.debug('UserRec.Previous_Contact__c:' + UserRec.Previous_Contact__c);
                            system.debug('u.contactId: ' + u.contactId);
                            id contact_Id = u.contactId;
                            string sContact_Id = string.valueof(contact_Id);
                            If(UserRec.Previous_Contact__c ==  sContact_Id)
                            {
                                system.debug('inside if:');
                                UserRec.Previous_Contact__c = 'removed - ' + UserRec.Previous_Contact__c;                    //if this is maintained, then multiple updates to the same contact could occur.
                                PreviousContactListUpdated.add(UserRec);
                            }
                        }    
                    }
                    system.debug('testing');
                    u.Previous_Contact__c = u.ContactId;  
                } 
                
            }
        }
   }
   if (PreviousContactListUpdated.size() > 0)
   { 
       Update PreviousContactListUpdated;
   }    
}