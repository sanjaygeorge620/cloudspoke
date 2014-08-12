trigger UpdateScheduleEndDate on pse__Assignment__c(after update){

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


 List<pse__Schedule__c> schList = new List<pse__Schedule__c>();
 List<pse__Assignment__c> olda = Trigger.old;
 integer i = 0;
      
      For(pse__Assignment__c a:Trigger.New){
       
       if(a.pse__status__c!=null && 
          (a.pse__status__c=='Closed' || a.pse__status__c=='Void')&& 
          a.id==olda[i].id && 
          (olda[i].pse__status__c!='Closed'||olda[i].pse__status__c!='Void')){           
            pse__Schedule__c s = new pse__Schedule__c(id=a.pse__Schedule__c);
            if (a.pse__Start_Date__c <= System.today())
                {
                  s.pse__End_Date__c = System.today();
                 }
            else
                {
                  s.pse__Start_Date__c = System.today();
                  s.pse__End_Date__c = System.today(); 
                 }           
       schList.add(s);
       i++;
       }       
      }
      
 if(schList.size()>0)
 Update(schList);
}