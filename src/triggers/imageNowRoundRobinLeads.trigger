/* 
 * Simple round robbin lead assignment, 
 * trigger assumes the following custom fields on the User object 
 * User.
 *  Receiving_Leads__c   -- are they open for new leads at this time 
 *  Open_Leads_Owned__c  -- how many leads do they have right now 
 *  
 * if no matching new owner is found the default for the org is the new owner
 */ 
 
 trigger imageNowRoundRobinLeads on Lead (before insert, after insert, after update, after delete) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
 
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
 if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
 
    }