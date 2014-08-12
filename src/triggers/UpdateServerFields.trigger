/*
Created by Michael Fitzgerald 3.15.2011
Created to update the old server text__c fields with the new field information.
Could have completed this task with workflows but this was much simpler.

This was required when unhooking the product configurator from the Servers
to not interrupt reporting on environment data for Perceptive.
*/
trigger UpdateServerFields on Server__c (before update, before insert) {
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

     
   Set<Id> releases = new Set<Id>();
    
    //Grab all of the IDS

        
            Map<Id, ProductRelease__c> sMap = new Map<Id, ProductRelease__c>(firstRun_Check.FirstRun_UpdateServerFields);
            system.debug('smap-updateserverFields:' + sMap);
            system.debug('firstRun_Check.FirstRun_UpdateServerFields-updateserverFields:' + sMap);
            for (server__c s : Trigger.new) {
                //get all releases that are not in the map already.
          
                if(firstRun_Check.FirstRun_UpdateServerFields.containsKey(s.Release__c)){
                    system.debug('release already in map');
                }else{
                    releases.add(s.Release__c);
                }
            }  
            system.debug('releases'+ releases);
             //grab the release names for those releases not in map - then add to map.
             if (releases.size()>0){
                Map<Id, ProductRelease__c> sMapNew = new Map<Id, ProductRelease__c>([select name from ProductRelease__c where id in :releases]);
                system.debug('smapNew:' + sMapnew);
                firstRun_Check.FirstRun_UpdateServerFields.putall(sMapNew);
                sMap.putall(sMapNew);
             }
           //Loop through all records in the Trigger.new collection and update the server fields
           for(server__c s: Trigger.new){
              s.Platform_text__c = s.Platform__c;
              s.Platform_Version_text__c = s.Platform_Version__c;
              s.Database_text__c = s.Database__c;
              s.Database_Version_text__c = s.Database_Version__c;
              if (s.Release__c==null){ 
                  s.Release_text__c = '';
              } else {
                  s.Release_text__c = sMap.get(s.Release__c).name;
              }
                        
              //I hate to hard code but this is true every single time for Servers
              s.Brand_text__c = 'ImageNow';  
              s.Product_text__c = 'ImageNow Server';
           }
            
      
   
}