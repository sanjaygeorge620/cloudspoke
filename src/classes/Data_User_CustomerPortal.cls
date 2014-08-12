public with sharing class Data_User_CustomerPortal {
    //create a class that can be called more than once to create 1 or multiple users
    Public static List<User> createUser_CustomerPortal(integer size, List<ID> CreateUserFromContactIDList, String ProfileName){
    
     List<User> userRecList = new List<User>(); 
        List<Contact> createUserList = new List<Contact>([select    id 
                                                                    , accountid 
                                                                    //, account.IsCustomerPortal 
                                                                    , email 
                                                                    , LastName
                                                                    , FirstName
                                                                    from contact where id in :CreateUserFromContactIDList]); 
        Set<ID> AccountIdSet = new Set<ID>();
        string varAlias;
        integer aliaslength;
        
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = True;                //sets options so email is sent 
        List<Profile> ProfileId = [select id from Profile where Name = :ProfileName limit 1];
        system.debug('ProfileName == '+ProfileName);
        system.debug('ProfileId == '+ProfileId);
        Profile stdp = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         
          User stdu = new User(Alias = 'tam', Email='standarduser@lexmark.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = stdp.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='NootAnUserForRandom@testorg.com',LX_Region__C='NE',Legacy_Company__c = 'Acuo');
          insert stdu;
        // Added by sumedha on 5/13/2013 
        List<UserRole> portalRoleList = [Select PortalType, PortalRole, Name, Id, DeveloperName, ContactAccessForAccountOwner,
                                                             CaseAccessForAccountOwner From UserRole Where PortalType = 'CustomerPortal' Limit 1];
        system.debug('portalRoleList == '+portalRoleList);
        User newUserRec = new User();
        system.debug('createUserLIst.size(): '+ createUserList.size());
        system.debug('createUserLIst: '+ createUserList);
        if (CreateUserList.size() > 0) {
            for (Contact CreateUser: CreateUserList){
                
                //if (CreateUser.Account.isCustomerPortal== false){
                    //need to check if account is already a member
                  //  accountIDSet.add(CreateUser.Accountid);
               // }
            }
            for (Contact CreateUser: CreateUserList){
                
                varAlias = string.valueof(system.currentTimeMillis());
                system.debug('varAlias' + varAlias);
                aliaslength = varAlias.length();
                integer i = 1;
                newUserRec = new User (
                        Username = 'account.exe'+ i + varAlias+i+'a'+'@imagenow' + i + varAlias + '.com1',        
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
                        contactid = CreateUser.id,
                        Legacy_Company__c = 'Acuo',
                        LX_Region__c='NE'
                       // UserRoleId = portalRoleList[0].id //Added by sumedha on 5/13/2013
                );
                system.debug('NewUserAlias: ' + NewUserRec.Alias);
                system.debug('NewUserCommunity: ' + NewUserRec.CommunityNickname);
                NewUserRec.IsActive = True; 
                NewUserRec.setOptions(dlo);
                userrecList.add(newUserRec);
                 i = i + 1;       
            }
            system.debug('UserRecList: ' + UserRecList);
             try{
              System.RunAs(stdu){
                insert userRecList;
              }
              }catch(Exception ex){System.debug('*****Insert User with system run as: '+ex.getMessage());}
                         
        }   
        return userRecList;  
    }
    
    @isTest(SeeAllData=true)
    static void testTestData() {
      Account acc = Data_Account.createAccount3();
      system.debug('acc:' + acc);
      List<Contact> contacts = Data_Contact.createContacts_nonAccountingContact(acc.Id,1);
      List<ID>contactIDs = new List<ID>();
      for(Contact contactRec: contacts){
        contactIDs.add(contactRec.id);
      } 
      system.debug('testing');   
      List<User> userList = Data_User_CustomerPortal.createUser_CustomerPortal(1, contactIds, 'System Administrator');       
      System.assertEquals(userList.size(),1); 
  }            
}