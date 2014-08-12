/******************************************************************
Trigger Name   : PSE_ProjectPMisOwner
Created by     : Appirio
Created Date   : January 21, 2010
Purpose        : PM should be Owner of Project Record.
********************************************************************/
trigger PSE_ProjectPMisOwner on pse__Proj__c (before update) {

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

    
    Set<ID> pmContactIds = new Set<ID>(); 
    
    // Check to see if the PM has changed, if so then we need to set the OwnerId to the PM's SFDC User ID.
    For(pse__Proj__c  Proj : Trigger.New){ 
        if(Proj.pse__Project_Manager__c <> null && Proj.pse__Project_Manager__c != Trigger.oldMap.get(Proj.ID).pse__Project_Manager__c){
           pmContactIds.add(Proj.pse__Project_Manager__c);
           //Proj.OwnerId = Proj.pse__Project_Manager__r.pse__Salesforce_User__c;
        }

    }

    if(pmContactIds.size() > 0){    

        // Build a map with the associated SFDC User Id's for each PM
        Map<Id, Contact> sfdc_user = new Map<Id, Contact>( [select pse__Salesforce_User__c from Contact where Id in :pmContactIds] );
    
        // now use Map to grab the SFDC User for each PM and set as the Owner
        for (pse__Proj__C Proj : Trigger.New) {
            // Throw warning if 'pse__salesforce_user__c' not set on the Contact record
            //system.debug('DEBUG: PSE_ProjectPMisOwner SFUser_id: ' + sfdc_user.get(Proj.pse__Project_Manager__c).pse__Salesforce_User__c);
            if (sfdc_user.get(Proj.pse__Project_Manager__c).pse__Salesforce_User__c == null) {
                //Proj.addError('The PM could not be assigned as the Owner of this Project.  Please ensure the Salesforce_User field on the Contact record is set for this PM.');
           
            } else {
               Proj.OwnerId = sfdc_user.get(Proj.pse__Project_Manager__c).pse__Salesforce_User__c;
            }
        }
    }

}