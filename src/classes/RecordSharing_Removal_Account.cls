public with sharing class RecordSharing_Removal_Account{


   Public static void manualShare_Account_Removal(Set<ID> oldacctListIDs, set<ID> AcctListIDs){
        system.debug('oldacctListIDs: ' + oldacctListIDs);
        system.debug('acctListIds: ' + acctListIds);
      //get all users related to old primary partner account specified on Lead
      List<User> PrimaryPartnerUsers = new List<User>([select accountid, id from User where accountId in :AcctListIDs]);

      //get all lead share records based on lead ids      
      List<AccountShare> acctShareList = new List<AccountShare>([select id, accountID, UserOrGroupID from AccountShare where accountID in :oldacctListIDs]);
      Map<ID, AccountShare> AcctShareMap = new Map<ID, AccountShare>();
      for(AccountShare acctShareRec : acctShareList){
          system.debug('acctShareRec.UserOrGroupID:' + acctShareRec.UserOrGroupID);
          system.debug('acctShareRec:' + acctShareRec);
          AcctShareMap.put(acctShareRec.UserOrGroupID, acctShareRec);
      }
    integer l = 0;
    system.debug('acctShareList:' + acctShareList);
    system.debug('PrimaryPartnerUsers:' + PrimaryPartnerUsers);
    for (User UserRec : PrimaryPartnerUsers){
        system.debug('acctShareMap:' + acctshareMap);
        system.debug('userRec.id:' + userRec.id);
        If(AcctShareMap.containsKey(userRec.id)){
            AccountShare acctShareRec = acctShareMap.get(userRec.id);

                
      // Insert the sharing record and capture the save result.   
      // The false parameter allows for partial processing if multiple records passed   
      // into the operation.  
                system.debug('acctShrRec: ' + acctShareRec);
                Database.deleteResult dr = Database.delete(acctShareRec,false);
                // Process the save results. 
                system.debug('saveResult:' + dr); 
                if(dr.isSuccess()){
                //   return true;                    // Indicates success 
                }
                else {   
                   Database.Error err = dr.getErrors()[0];              // Get first save result error.  
                   system.debug('Database error:' + err);
                   // Check if the error is related to trival access level.  
                   // Access levels equal or more permissive than the object's default   
                   // access level are not allowed.   
                   // These sharing records are not required and thus an insert exception is acceptable.   
                
                   if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                            err.getMessage().contains('AccessLevel')){ 
                   }
                 }
               }
            }
        
   }
}