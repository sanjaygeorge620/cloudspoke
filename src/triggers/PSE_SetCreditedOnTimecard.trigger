/***************************************************************************
Trigger Name   : PSE_SetCreditedOnTimecard
Created by     : Appirio offshore
Created Date   : May 18, 2010
Purpose        : This trigger will be used to set/unset the Time_Credited checkbox (pse__Time_Credited__c). 

*****************************************************************************/
trigger PSE_SetCreditedOnTimecard on pse__Timecard_Header__c (before insert, before update) {

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


    Set<String> assignmentIDSet = new Set<String>();
    Map<String,pse__Assignment__c> assignmentMap = new Map<String,pse__Assignment__c>();
    for(pse__Timecard_Header__c timecard : Trigger.new){
        if(Trigger.isInsert){            
            if(timecard.pse__Assignment__c != null && (!(timecard.pse__Billable__c)|| timecard.pse__Time_Credited__c)){
                assignmentIDSet.add(timecard.pse__Assignment__c);
            }            
        }else if(Trigger.isUpdate){
            if(Trigger.oldMap.containsKey(timecard.id) && Trigger.oldMap.get(timecard.id).pse__Billable__c != timecard.pse__Billable__c && timecard.pse__Assignment__c != null){
                assignmentIDSet.add(timecard.pse__Assignment__c);
            }
            if(timecard.pse__Assignment__c != null && timecard.pse__Time_Credited__c){
                assignmentIDSet.add(timecard.pse__Assignment__c);
            }
        }
    } 
    
    for(pse__Assignment__c assignment : [select Id,Name,pse__Is_Billable__c, pse__Time_Credited__c from pse__Assignment__c where id in : assignmentIdSet]){
        assignmentMap.put(assignment.ID,assignment);
    }
    
    
    for(pse__Timecard_Header__c timecard : Trigger.new){
    
        //Set time credited true for newly created, non-billable timecards with billable assignments.  
        //Need to double check what happens when dealing with a Time_Credited assignment.  Time_Credited should remain true on these
        if(Trigger.isInsert){
            //Time Credited Assignment, Time Credited timecard (create) - Time credited should be true does not matter what value other fields contains.
            if(assignmentMap.containsKey(timecard.pse__Assignment__c) && assignmentMap.get(timecard.pse__Assignment__c).pse__Time_Credited__c && timecard.pse__Time_Credited__c){                               
                   continue;  
            }
            else if(assignmentMap.containsKey(timecard.pse__Assignment__c) && assignmentMap.get(timecard.pse__Assignment__c).pse__Is_Billable__c){
                if(!(timecard.pse__Billable__c)){
                    timecard.pse__Time_Credited__c = true;  
                }
            }else{
                timecard.pse__Time_Credited__c = false;
            }
        }
        //Time Credited Assignment, Time Credited timecard (update any value) should not affect  Time_Credited field.
       
        if(Trigger.isUpdate && assignmentMap.containsKey(timecard.pse__Assignment__c) && assignmentMap.get(timecard.pse__Assignment__c).pse__Time_Credited__c && timecard.pse__Time_Credited__c){
             continue;             
        }
        //Set time credited true for timecards that have had their billable status updated              
        else if(Trigger.isUpdate && Trigger.oldMap.containsKey(timecard.id) && Trigger.oldMap.get(timecard.id).pse__Billable__c != timecard.pse__Billable__c && assignmentMap.containsKey(timecard.pse__Assignment__c) && assignmentMap.get(timecard.pse__Assignment__c).pse__Is_Billable__c){
            if(!timecard.pse__Billable__c){
                timecard.pse__Time_Credited__c = true;  
            }else{
                timecard.pse__Time_Credited__c = false; 
            }
        }
    }
}