trigger SetAssignmentStatus on pse__Proj__c(after update) {
 
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

    
    List<pse__Assignment__c> assgnmtList = new List <pse__Assignment__c>();
    Set<id>  projectIds = new Set<id>();
    integer i;
    integer listSize;
    //added Logic by CV to stop recursion
    if(LX_AssignmentCls.isUpdated == true){
        LX_AssignmentCls.isUpdated = false;
        For(pse__Proj__c  p: Trigger.new){
         //get the project's Id when the phase is "Closed Inactive" or "Void"
         if(p.pse__Project_Phase__c=='Closed Inactive'||p.pse__Project_Phase__c=='Void')
         projectIds.add(p.id);
       }
        
        //for each project fetch the related assignments
        assgnmtList=[Select id, pse__Status__c From pse__Assignment__c where pse__Project__c=:projectIds and pse__status__c!='Closed' and  pse__Resource__r.pse__Is_Resource_Active__c = true];
        listSize = assgnmtList.size();
                
       //set the Assignment status to "Closed" if not set       
       For(i = 0;i<listSize;i++)
       {
        if(assgnmtList[i].pse__Status__c!='Closed'){
           assgnmtList[i].pse__Status__c='Closed'; 
           }             
       }     
       
      update assgnmtList; 
      }
}