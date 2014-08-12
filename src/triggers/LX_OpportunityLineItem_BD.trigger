/* Trigger Name : LX_OpportunityLineItem_BD
* Description :Trigger used to delete MQLI records when a product is deleted 
* Created By :  Veenu Trehan
* Created Date :12/16/2013 
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer          Date            Modification ID     Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*  Veenu Trehan     12/16/2013                          Initial Version

*/

trigger LX_OpportunityLineItem_BD on OpportunityLineItem (before delete) {

 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    // Trigger Switch
    Boolean LX_Switch = false; 
    static integer index = 0;    
    // Get current profile custom setting.
    LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
    // Get current Organization custom setting.
    LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
    // Get current User custom setting.
    LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
    
    // Allow the trigger to skip the User/Profile/Org based on the custom setting values
    if(LXUser != null)
        LX_Switch = LXUser.Bypass__c;
    else if(LXProfile != null)
        LX_Switch = LXProfile.Bypass__c;
    else if(LXOrg != null)
        LX_Switch = LXOrg.Bypass__c;
    if(LX_Switch)
        return;    
        
         set<string> OppLineOppIdSet=new set<string>();
        //to store the id's of the opp line items which got deleted to get the corresponding Mqli records
        for(OpportunityLineItem opl:trigger.old){
            OppLineOppIdSet.add(opl.id+'-'+opl.OpportunityId);
        }
        if(OppLineOppIdSet.size()>0){
            //call the helper class to delete corresponding mqli records
            LX_OpportunityLineItemHelper.MqliDelete(OppLineOppIdSet);
        }
   
}