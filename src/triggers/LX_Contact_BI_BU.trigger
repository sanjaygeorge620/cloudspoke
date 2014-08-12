trigger LX_Contact_BI_BU on Contact (Before insert, Before Update) {
    
/*
 * Description  : Trigger to validate Lexmark vertical in Contact   
 * Created By   : Anita Koshi
 * Created On   : 05-May-13

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Anita Koshi           05-May-13          Initial version
 * 
*/

   if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
   if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
    if(trigger.isbefore && (trigger.isUpdate || trigger.isInsert) ){
        List<Contact> listContact = new List<Contact>();
        for(Contact crecord : trigger.new){
            listContact.add(crecord);
        }
        LX_ContactTriggerUtil oContact = new LX_ContactTriggerUtil();
        oContact.verticalCheck(listContact);
    }//if(trigger.isbefore && (trigger.isUpdate || trigger.isInsert) )
}