public without sharing class RecordSharing 
{
Public static void manualShare_Lead_Read(Set<ID> LeadListIDs)
{
}
//Updated 0618 Praveen -- Removed the Sharing creation part since it is already handled in SQL and is causing DML exceptions in Salesforce
/*   
   Public static void manualShare_Lead_Read(Set<ID> LeadListIDs){
       
      //get all lead records based on list of leadIDs passed from trigger
      List<Lead> LeadRecList = new List<Lead>([select Id, Primary_Partner__c from Lead where id in :LeadListIDs]);
      Set<ID> PrimaryPartnerSet = new Set<ID>();
      
      //put only primary partner account id into set to be used for bulk search from user
      for (Lead LeadRec : LeadRecList){
        PrimaryPartnerSet.add(LeadRec.Primary_Partner__c);
      }
      //get all users related to primary partner account specified on Lead
      List<User> PrimaryPartnerUsers = new List<User>([select accountid, id from User where accountId in :PrimaryPartnerSet and
                                                      profile.name like '%Channel Portal%' and IsActive = True]);
      //for all users returned - put in map to be referenced by lead 
      Map<ID, List<User>> PrimaryPartnerMap = new Map<ID, List<User>>();
      For (User UserRec : PrimaryPartnerUsers){
            
        boolean AccountKeyfound;    
        if (PrimaryPartnerMap.size() > 0){                                                          //check to see if the Existing Map Contains anything
            AccountKeyfound = PrimaryPartnerMap.containsKey(UserRec.AccountID);             //does the existing map have the keyset of the new item         
        }else{
            AccountKeyfound = false;
        }
        system.debug('AccountKeyfound: ' + AccountKeyfound);                                    //does the map have a keyset matching the record
        List<User> tmpUserList = new List<User>();                  //create a tmpList to hold list returned from the map
            
        if (AccountKeyfound){       
            tmpUserList = PrimaryPartnerMap.get(UserRec.AccountID);                             //get list from Existing productsList
        }   
        
        tmpUserList.add(UserRec);
        PrimaryPartnerMap.put(UserRec.AccountID,tmpUserList);
      }
      

   integer l = 0;
    list<LeadShare> leadShareList = new list<LeadShare>();
    system.debug('leadRecList:' + leadRecList);
    For (Lead leadRec : leadRecList){

        List<User> UserList = new List<User> (PrimaryPartnerMap.get(leadRec.Primary_Partner__c));
        If(UserList.size() > 0) {
            For (l=0; l<UserList.size(); l++){
                LeadShare leadShrRec  = new leadShare();                         // Create new sharing object for Lead.  
                leadShrRec.leadId = leadRec.id;            // Set the ID of record being shared.
                leadShrRec.UserOrGroupId = userList[l].id;           // Set the ID of user or group being granted access. 
                leadShrRec.LeadAccessLevel = 'Read';              // Set the access level.
        
        
      // Insert the sharing record and capture the save result.   
      // The false parameter allows for partial processing if multiple records passed   
      // into the operation.  
                system.debug('leadShrRec: ' + leadShrRec);
                leadShareList.add(leadShrRec);

               }
            }
        }
        system.debug('leadShareList:' + leadShareList);
        insert leadShareList;
   }
    
*/    
}