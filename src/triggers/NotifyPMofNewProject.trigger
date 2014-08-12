trigger NotifyPMofNewProject on pse__Proj__c (after insert, after update) {
  if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
  List <pse__Proj__c> proje_list = new List<pse__Proj__c>();
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
  
    
    List<ID> newProjectList = new List<ID>();
    for (pse__Proj__c newProject : Trigger.new) {
        system.debug('newProject.pse__Project_Manager__c: ' + newProject.pse__Project_Manager__c);
        If(newProject.pse__Project_Manager__c != null ){
            if ( (trigger.isInsert) 
                        || (System.Trigger.oldmap.get(newProject.id).pse__Project_Manager__c != newProject.pse__Project_Manager__c &&
                            trigger.isUpdate ) ) {
    
                newProjectList.add(newProject.id);
            }
        }       
    }
    system.debug('newProjectList.size():'+newProjectList.size());
    if(FirstRun_Check.FirstRun_NotifyPMofNewProject_trigger){
        if(newProjectList.size() > 0){
            FirstRun_Check.FirstRun_NotifyPMofNewProject_trigger = False;
            SendEmailToPMWhenAssignedToProject.SendEmail(newProjectList);
        }
    }
// [SG:21/01/14]Gold Team US case for creation of WBS element based on opp for every new Project created

    if(Trigger.isAfter&&(Trigger.isInsert||Trigger.isupdate)){
        if(FirstRun_Check.FirstRun_LX_Project_BI_BU ){
            FirstRun_Check.FirstRun_LX_Project_BI_BU=false;
            FirstRun_Check.FirstRun_LX_WBSElementProject_BI_BU=false;
                if(Trigger.isinsert)
                LX_PseProjUtilityClass.createWBSProject(Trigger.new);
                
                if(Trigger.isupdate)
                {
                for(pse__Proj__c pse_proj : Trigger.new)
                {
                if(((pse_proj.recordtypeid == LX_SetRecordIDs.ProjectISSImplRecordTypeId) || (pse_proj.recordtypeid == LX_SetRecordIDs.ProjectProfServicesRecordTypeId)) && !((Trigger.oldmap.get(pse_proj.id).recordtypeid == LX_SetRecordIDs.ProjectISSImplRecordTypeId) || (Trigger.oldmap.get(pse_proj.id).recordtypeid == LX_SetRecordIDs.ProjectProfServicesRecordTypeId)))
                proje_list.add(pse_proj);
                }
                System.debug(proje_list);
                LX_PseProjUtilityClass.createWBSProject(proje_list);
                }
        }
    }
}