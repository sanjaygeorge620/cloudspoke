/******************************************************************
Trigger Name   : PSE_CascadeUpdatedOwnerId
Created by     : Appirio
Created Date   : November 11, 2009
Purpose        : When Owner of the Project is updated, set the 
                 OwnerId of any associated Milestones and Misc. Adjustments.
********************************************************************/
trigger PSE_CascadeUpdatedOwnerId on pse__Proj__c (after update) {

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


    //set of project ids
    Set<ID> projectIds = new Set<ID>(); 
    //list of pse__Miscellaneous_Adjustments__c
    List<pse__Miscellaneous_Adjustment__c> pseMiscAdjList = new List<pse__Miscellaneous_Adjustment__c>();
    //list of pse__Milestones__c
    List<pse__Milestone__c> pseMilestoneList = new List<pse__Milestone__c>();
    //preparing the set of project ids for which owner is changed   
    for(pse__Proj__c proj:Trigger.New){
        if(proj.OwnerId != Trigger.oldMap.get(proj.ID).OwnerId)
            projectIds.add(proj.ID);
    }
    
    //adding the values in the list which needs to be updated 
    if(projectIds!=null){
    for(pse__Proj__c proj:[select Id, Name, OwnerId, (Select Id, OwnerId, pse__Project__c From pse__Miscellaneous_Adjustments__r), (Select Id, OwnerId, pse__Project__c From pse__Milestones__r) From pse__Proj__c where Id IN:projectIds]){
        if(proj != null){
            if(proj.pse__Miscellaneous_Adjustments__r != null ){
                for(pse__Miscellaneous_Adjustment__c pseMiscAd : proj.pse__Miscellaneous_Adjustments__r){               
                    if(pseMiscAd.ownerId != Trigger.newMap.get(pseMiscAd.pse__Project__c).OwnerId){
                        pseMiscAd.ownerId = Trigger.newMap.get(pseMiscAd.pse__Project__c).OwnerId;
                        pseMiscAdjList.add(pseMiscAd);
                    }
                }                                   
            }
            if(proj.pse__Milestones__r != null ){                                               
                for(pse__Milestone__c pseMile : proj.pse__Milestones__r){
                    if(pseMile.ownerId != Trigger.newMap.get(pseMile.pse__Project__c).OwnerId){
                        pseMile.ownerId = Trigger.newMap.get(pseMile.pse__Project__c).OwnerId;
                        pseMilestoneList.add(pseMile);
                    }
                }   
            }           
        }   
    }
    }
        
    //updating the list of pse__Miscellaneous_Adjustments__c
    if(pseMiscAdjList != null && pseMiscAdjList.size()>0)
        update pseMiscAdjList;
    
    //updating the list of pse__Milestones__c
    if(pseMilestoneList != null && pseMilestoneList.size()>0)
        update pseMilestoneList;
}