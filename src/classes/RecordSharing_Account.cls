public with sharing class RecordSharing_Account{
// 06-18 Praveen
 
 Public static void manualShare_Account_Read(Set<ID> acctListIDs)
 {
 }
 /*  Public static void manualShare_Account_Read(Set<ID> acctListIDs){
       
      //get all lead records based on list of leadIDs passed from trigger
      List<Account> acctRecList = new List<Account>([select Id, Reseller_ID__c from Account where id in :acctListIDs]);
      Set<ID> PrimaryPartnerSet = new Set<ID>();
       
      //put only primary partner account id into set to be used for bulk search from user
      for (Account acctRec : acctRecList)
      {
        PrimaryPartnerSet.add(acctRec.Reseller_ID__c);
      }
      //get all users related to primary partner account specified on Lead
      //List<User> PrimaryPartnerUsers = new List<User>([select accountid, id from User where accountId in :PrimaryPartnerSet and userType = 'PowerCustomerSuccess' and IsActive = True]);
       List<User> PrimaryPartnerUsers = new List<User>();
       
       for(User u : [select accountid, id, profileID from User where accountId in :PrimaryPartnerSet
                     and profile.name like '%Channel Portal%' and IsActive = True])
       {           
       PrimaryPartnerUsers.add(u);        
       }
       
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
    list<AccountShare> acctShareList = new list<AccountShare>();
    system.debug('acctRecList:' + acctRecList);
    For (Account acctRec : acctRecList){

        List<User> UserList = new List<User> (PrimaryPartnerMap.get(acctRec.Reseller_ID__c));
        If(UserList.size() > 0) {
            For (l=0; l<UserList.size(); l++){
                AccountShare acctShrRec  = new AccountShare();                         // Create new sharing object for Lead.  
                acctShrRec.AccountID = acctRec.id;            // Set the ID of record being shared.
                acctShrRec.UserOrGroupId = userList[l].id;           // Set the ID of user or group being granted access. 
                acctShrRec.AccountAccessLevel = 'Read';              // Set the access level.
                acctShrRec.OpportunityAccessLevel = 'Read';
                acctShrRec.ContactAccessLevel = 'None';
                acctShrRec.CaseAccessLevel = 'None';
        
        
      // Insert the sharing record and capture the save result.   
      // The false parameter allows for partial processing if multiple records passed   
      // into the operation.  
                system.debug('acctShrRec: ' + acctShrRec);
                acctShareList.add(acctShrRec);

               }
            }
        }
        system.debug('acctShareList:' + acctShareList);
        insert acctShareList;
   }
*/
}