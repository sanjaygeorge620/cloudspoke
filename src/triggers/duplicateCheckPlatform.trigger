/****************************************************************************
Author     :    Appirio Inc.
Create Date:    13 May
Reason     :    Add combination of Platform Name and version in a Unique field.
*****************************************************************************/
trigger duplicateCheckPlatform on Platform_Master__c (before insert,before Update)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
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

    for(Platform_Master__c d:trigger.New)
        d.Platform_and_Version_Combination__c = d.Platform__c+'='+d.Platform_Version__c;
}