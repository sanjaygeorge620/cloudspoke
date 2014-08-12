public with sharing class RecordSharing_Order_Detail{
Public static void manualShare_Order_Detail_Read(Set<ID> orderListIDs)
{
}

/*   
   Public static void manualShare_Order_Detail_Read(Set<ID> orderListIDs){
       
      //get all lead records based on list of leadIDs passed from trigger
      List<Order_Detail__c> orderRecList = new List<Order_Detail__c>([select Id, Order_Reseller_Account__c from Order_Detail__c where id in :orderListIDs]);
      Set<ID> AccountIDSet = new Set<ID>();
       
       
      //put only account id into set to be used for bulk search from user
      for (Order_Detail__c orderRec : orderRecList){
        AccountIDSet.add(orderRec.Order_Reseller_Account__c );
      }
      //get all users related to primary partner account specified on Lead
    //  List<User> accountIDUsers = new List<User>([select accountid, id from User where accountId in :AccountIDSet and userType = 'PowerPartner' and isActive = True]);
              
       List<User> accountIDUsers = new List<User>();
       for(User u : [select accountid, id, profileID from User where accountId in :AccountIDSet 
                     and  profile.name like '%Channel Portal%' and IsActive = True])
       {       
       accountIDUsers.add(u);       
       }
       
      //for all users returned - put in map to be referenced by lead 
      Map<ID, List<User>> AcountIDMap = new Map<ID, List<User>>();
      For (User UserRec : accountIDUsers){
            
        boolean AccountKeyfound;    
        if (AcountIDMap.size() > 0){                                                            //check to see if the Existing Map Contains anything
            AccountKeyfound = AcountIDMap.containsKey(UserRec.AccountID);               //does the existing map have the keyset of the new item         
        }else{
            AccountKeyfound = false;
        }
        system.debug('AccountKeyfound: ' + AccountKeyfound);                                    //does the map have a keyset matching the record
        List<User> tmpUserList = new List<User>();                  //create a tmpList to hold list returned from the map
            
        if (AccountKeyfound){       
            tmpUserList = AcountIDMap.get(UserRec.AccountID);                               //get list from Existing productsList
        }   
        
        tmpUserList.add(UserRec);
        AcountIDMap.put(UserRec.AccountID,tmpUserList);
      }
      

    integer l = 0;
    For (Order_Detail__c orderRec : orderRecList){
        List<User> UserList = new List<User> (AcountIDMap.get(orderRec.Order_Reseller_Account__c ));
        If(UserList.size() > 0) {
            For (l=0; l<UserList.size(); l++){
                Order_Detail__Share orderShrRec  = new Order_Detail__Share();                       // Create new sharing object for Lead.  
                orderShrRec.parentId = orderRec.id;             // Set the ID of record being shared.
                orderShrRec.UserOrGroupId = userList[l].id;         // Set the ID of user or group being granted access. 
                orderShrRec.AccessLevel = 'Read';               // Set the access level.
        
        
      // Insert the sharing record and capture the save result.   
      // The false parameter allows for partial processing if multiple records passed   
      // into the operation.  
                system.debug('orderShrRec: ' + orderShrRec);
                Database.SaveResult sr = Database.insert(orderShrRec,false);
                // Process the save results. 
                system.debug('saveResult:' + sr); 
                if(sr.isSuccess()){
                //   return true;                    // Indicates success 
                }
                else {   
                   Database.Error err = sr.getErrors()[0];              // Get first save result error.  
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
*/
}