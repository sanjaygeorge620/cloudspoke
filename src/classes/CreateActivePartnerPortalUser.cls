public with sharing class CreateActivePartnerPortalUser {
    
    public static void CreateActivePartnerPortalUser(Set<ID> CreateUserFromContactIDList){             //contactId

    
     List<User> userRecList = new List<User>(); 
        List<Contact> createUserList = new List<Contact>([select    id 
                                                                    , accountid 
                                                                    //, account.IsPartner 
                                                                    , email 
                                                                    , LastName
                                                                    , FirstName
                                                                    from contact where id in :CreateUserFromContactIDList]); 
        Set<ID> AccountIdSet = new Set<ID>();
        string varAlias;
        integer aliaslength;
        
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = True;                //sets options so email is sent 
        List<Profile> ProfileId = [select id from Profile where Name = 'Perceptive Partner Portal Admin' limit 1];
        User newUserRec;
        system.debug('createUserLIst.size(): '+ createUserList.size());
        system.debug('createUserLIst: '+ createUserList);
        if (CreateUserList.size() > 0) {
            for (Contact CreateUser: CreateUserList){
                
               // if (CreateUser.Account.IsPartner == false){
                    //need to check if account is already a member
                  //  accountIDSet.add(CreateUser.Accountid);
                //}
            }
            for (Contact CreateUser: CreateUserList){
                 varAlias = string.valueof(system.currentTimeMillis());
                system.debug('varAlias' + varAlias);
                aliaslength = varAlias.length();
                integer i = 1;
                newUserRec = new User (
                        Username = CreateUser.email,        
                        LastName = CreateUser.LastName,
                        FirstName = CreateUser.FirstName,
              //          UserPermissionsMarketingUser = true,
                        //Email = 'jennifer.dauernheim@perceptivesoftware.com',             //use this for testing - send to exact email address
                        Email = CreateUser.Email,                               //use this for production - sends to contact email address
                        Alias = CreateUser.FirstName.substring(0,1) + CreateUser.LastName.substring(0,2) + varAlias.subString(aliaslength-2,aliaslength),                   //check to see if better format
                        CommunityNickname = createUser.FirstName + '.' + Createuser.LastName + varAlias.subString(aliaslength-2,aliaslength),     
                        TimeZoneSidKey = 'America/Los_Angeles',        
                        LocaleSidKey = 'en_US',    
                        EmailEncodingKey = 'UTF-8',        
                        LanguageLocaleKey = 'en_US',        
                        ProfileId = profileID[0].id, 
                        contactid = CreateUser.id
                );
                system.debug('NewUserAlias: ' + NewUserRec.Alias);
                system.debug('NewUserCommunity: ' + NewUserRec.CommunityNickname);
                NewUserRec.IsActive = True; 
                NewUserRec.setOptions(dlo);
                userrecList.add(newUserRec);
                 i = i + 1;       
            }
            system.debug('UserRecList: ' + UserRecList);
            
            insert userRecList;
              
        }    
   }
      
}