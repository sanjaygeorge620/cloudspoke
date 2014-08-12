public with sharing class ActivateUser {
@future
    public static void ActivateUser (List<ID> NewUserRecList){
        
        /********************************
        *   activate user
        *   1.  set IsActive = True
        *   2.  send email to user letting them know userName & password 
        *
        ********************************/
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
        
        List<User> UserRecList = new List<User>();
        for (Integer i =0;i<NewUserRecList.size();i++){
            User UserRec = new User(id = NewUserRecList[i] );
            UserRecList.add(userRec);
        }
                
        for (User UserRec : UserRecList){
            UserRec.IsActive = True;
            UserRec.SetOptions(dlo);
        }
        system.debug('NewUserRecList_activateUser: '+ UserRecList);
        update UserRecList;
        
        for (User UserRec : UserRecList){
            system.resetPassword(userRec.id, True);    
        }
    }
}