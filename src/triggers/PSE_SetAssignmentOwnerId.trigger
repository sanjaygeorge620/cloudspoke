/********************************************************************************
Trigger Name   : PSE_SetAssignmentOwnerId
Created by     : Appirio
Created Date   : November 17, 2009
Purpose        : Assignment Trigger that will set Owner to the 
                 PM from the associated Project.  Note, often the Sector Manager 
                 creates the Assignment from a Resource Request but we want the 
                 PM to own the record (for email and // workflow reasons). 
Mod Date       : February 9, 2010
Mod Description: Added logic that defaults the "Labor Category" from the Resource.
**********************************************************************************/

trigger PSE_SetAssignmentOwnerId on pse__Assignment__c (after insert) {

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


    Set<String>  setAssignmentID = new Set<String>();

    // Create a list to hold Assignments that have been inserted
    List< pse__Assignment__c > Update_Assignment = new List< pse__Assignment__c >();
    List< pse__Assignment__c > Update_Assignment_list = new List< pse__Assignment__c >();
    Boolean flagUpdate = false;
    
    system.debug('in set assignmentOwnerID:');

    // Build set of Assignments
    For(pse__Assignment__c  newAssgnmt : Trigger.New){ 
        setAssignmentID.Add(newAssgnmt.ID);
    }   
    
    // Get a default Labor Category value to be used if the Contact.Labor_Category__c is NOT set
    //Labor_Category__C Default_LC = [select Id from Labor_Category__C where Name = 'Consultant' limit 1];
    //4.18.2013 from 30 to 32
    //ID Default_LC = 'a2b70000000PAt7';
    //Line 33 Modified by Abhishek Jain on 4/30/2013. replaced Hardcoded id with Lx_SetRecordIDs.ConsultantLaborCategoryId   
    //ID Default_LC = LX_SetRecordIDs.ConsultantLaborCategoryId;
    // Replaced static variable with custom setting - Modified by Sumedha - 5/6/2013
    ID Default_LC = Lx_SetRecordIDs__c.getAll().get('ConsultantLaborCategoryId').Value__c;

    // Loop thru each Assignment and set the OwnerId to the PM of the associated project.
    Update_Assignment = [SELECT id, pse__Project__c, pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c,
        OwnerId, Labor_Category__c, pse__Resource__r.Labor_Category__c from pse__Assignment__c where id in : setAssignmentID];
                    
    for(pse__Assignment__c asgn:Update_Assignment){
        flagUpdate=false;

        if((asgn.pse__Project__r.pse__Project_Manager__c != null) && (asgn.OwnerId <> asgn.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c)){
            system.debug('asgn.pse__Project__r.pse__Project_Manager__c === '+ asgn.pse__Project__r.pse__Project_Manager__c);
            system.debug('asgn.OwnerId 1 === '+ asgn.OwnerId);
            system.debug('asgn.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c === '+ asgn.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c);
            if(test.isRunningTest())
            {
                asgn.OwnerId = Userinfo.getUserId();
            }
            else
            {
                //Adding the below condition to bypass the null exception on the ownerid while update :USI Team
                if(asgn.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c != null){
                asgn.OwnerId = asgn.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c;
                flagUpdate = true;
                }
            }          

        }
        system.debug(' asgn.OwnerId === '+ asgn.OwnerId);
        // Check to see if Labor Category has been set, if not set it using default on the Resource
        if(asgn.Labor_Category__c == null) {
            if (asgn.pse__Resource__r.Labor_Category__c == null) {
                asgn.Labor_Category__C = Default_LC;
            } else {
                System.debug('>>>>>>>>>>>>>>>>else');
                asgn.Labor_Category__c = asgn.pse__Resource__r.Labor_Category__c;
            }
          system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+ asgn.Labor_Category__c);   
            flagUpdate = true;
        }
        
        //Modifying the code to collect only those assignments which needs an update : USI Team
        if(flagUpdate)
        Update_Assignment_list.add(asgn);
    }
    
    if(Update_Assignment_list.size() >0)
        update Update_Assignment_list;
}