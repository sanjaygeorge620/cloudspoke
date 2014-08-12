trigger LeadFieldstoContactMap on Contact (before insert) {
     /*************************************
         *
         Description: Trigger to Map lead fields to Contact Standard fields when Lead is Converted
         *
         Date Created: 5/14/2012
         *
         Created By: Manoj Kolli
         *
     *****************************************/ 
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
    
    for(Contact c:Trigger.New){
        if(c.Lead_AA_Name_Map__c != Null){
            c.AssistantName = c.Lead_AA_Name_Map__c;
        }
        if(c.Lead_AA_Phone_Map__c != Null){
            c.AssistantPhone =  c.Lead_AA_Phone_Map__c;
        }
    }

}