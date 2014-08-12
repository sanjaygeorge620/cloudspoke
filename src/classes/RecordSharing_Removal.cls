public with sharing class RecordSharing_Removal {

   Public static void manualShare_Lead_Removal(Set<ID> LeadListIDs, set<ID> AcctListIDs){

      //get all users related to old primary partner account specified on Lead
      List<User> PrimaryPartnerUsers = new List<User>([select accountid, id from User where accountId in :AcctListIDs]);
      //get all lead share records based on lead ids      
      List<LeadShare> LeadShareList = new List<LeadShare>([select id, leadID, UserOrGroupID from LeadShare where LeadID in :LeadListIDs]);
      Map<ID, LeadShare> LeadShareMap = new Map<ID, LeadShare>();
      For (LeadShare LeadShareRec : LeadShareList){
          LeadShareMap.put(LeadShareRec.UserOrGroupID, LeadShareRec);
      }
    integer l = 0;
    for (User UserRec : PrimaryPartnerUsers){
         If(LeadShareMap.containsKey(userRec.id)){
            LeadShare LeadShareRec = LeadShareMap.get(userRec.id);
                
      // Insert the sharing record and capture the save result.   
      // The false parameter allows for partial processing if multiple records passed   
      // into the operation.  
                system.debug('leadShrRec: ' + LeadShareRec);
                Database.deleteResult dr = Database.delete(LeadShareRec,false);
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