@isTest
public with sharing class Data_User_PartnerPortal {
    //create a class that can be called more than once to create 1 or multiple users
    Public static List<User> createUser_PartnerPortal(integer size, List<ID> CreateUserFromContactIDList){
    
     List<User> userRecList = new List<User>(); 
        List<Contact> createUserList = new List<Contact>([select    id 
                                                                    , accountid 
                                                                   /* , account.IsPartner */
                                                                    , email 
                                                                    , LastName
                                                                    , FirstName
                                                                    from contact where id in :CreateUserFromContactIDList]); 
        Set<ID> AccountIdSet = new Set<ID>();
        string varAlias;
        integer aliaslength;
        user userWithRole = [select id from user where UserRoleID != null limit 1];
        list<Account> acc = new list<Account>();
        for(Contact c :createUserList){
            acc.add(new Account(id = c.AccountID, ownerID=userWithRole.id));
        
        }
        
        update acc;
        
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = True;                //sets options so email is sent 
        //List<Profile> ProfileId = [select id from Profile where Name = 'Perceptive Partner Portal Admin' limit 1]; comment by arun 
        List<Profile> ProfileId = [select id from Profile where Name = 'System Administrator' limit 1];
        User newUserRec;
        system.debug('createUserLIst.size(): '+ createUserList.size());
        system.debug('createUserLIst: '+ createUserList);
       
       /*  Account A = new Account(name='Account4TestMethod');       
     // A.Address_Edit_States__c = 'Rajasthan'; 
        A.Physical_State__c = 'Rajasthan';  
        A.Name = 'testAccount';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
       // A.Coverage_ID__c = gc.id;
        A.MDM_Sold_To_Number__c = '56A47657';
        A.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getInstance('AccountPartnerLockedRecordName')!=null?Lx_SetRecordIDs__c.getInstance('AccountPartnerLockedRecordName').Value__c:'').getRecordTypeId();

        A.Contact__c = createUserList[0].id ;
        A.IsPartner = true;
        insert A;  
       
        UserRole newUserRole = new UserRole(PortalType= 'Partner');
        insert newUserRole ;*/
       
       
        
          // Added by Gulzar on 5/14/2013 
        List<UserRole> portalRoleList = [Select PortalType, PortalRole, Name, Id, ContactAccessForAccountOwner,
                                                             CaseAccessForAccountOwner From UserRole Where PortalType = 'Partner' Limit 1];
        //UserRole newPortalRole = new UserRole(PortalType = 'Partner',PortalAccountId= acc .id);
        //Insert newPortalRole;
        
        if (CreateUserList.size() > 0) {
            for (Contact CreateUser: CreateUserList){
                
              /*  if (CreateUser.Account.IsPartner == false){
                    //need to check if account is already a member
                    accountIDSet.add(CreateUser.Accountid);
                }*/
            }
            for (Contact CreateUser: CreateUserList)
            {
                
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
                        CommunityNickname = createUser.FirstName + '.abcd.' + Createuser.LastName + varAlias.subString(aliaslength-2,aliaslength),     
                        TimeZoneSidKey = 'America/Los_Angeles',        
                        LocaleSidKey = 'en_US',    
                        EmailEncodingKey = 'UTF-8', 
                        Legacy_Company__c = 'Lexmark',        
                        LanguageLocaleKey = 'en_US',        
                        ProfileId = profileID[0].id,
                    EmployeeNumber = '1234',
                        LX_Region__c='NE'
                        //contactid = CreateUser.id,
                        //UserRoleId = portalRoleList[0].id //added by Gulzar
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
        return userRecList;  
    }
    
    
    Public static List<User> createUser_PartnerPortal1(integer size, List<ID> CreateUserFromContactIDList){
    
     List<User> userRecList = new List<User>(); 
        List<Contact> createUserList = new List<Contact>([select    id 
                                                                    , accountid 
                                                                   
                                                                    , email 
                                                                    , LastName
                                                                    , FirstName
                                                                    from contact where id in :CreateUserFromContactIDList]); 
        Set<ID> AccountIdSet = new Set<ID>();
        string varAlias;
        integer aliaslength;
        
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = True;                //sets options so email is sent 
        //List<Profile> ProfileId = [select id from Profile where Name = 'Perceptive Partner Portal Admin' limit 1]; comment by arun 
        List<Profile> ProfileId = [select id from Profile where Name =  'Perceptive Channel Portal Admin' limit 1];
        User newUserRec;
        system.debug('createUserLIst.size(): '+ createUserList.size());
        system.debug('createUserLIst: '+ createUserList);
        List<UserRole> portalRoleList = [Select PortalType, PortalRole, Name, Id, ContactAccessForAccountOwner,
                                                CaseAccessForAccountOwner From UserRole Where PortalType = 'Partner' Limit 1];
        
        
        if (CreateUserList.size() > 0) {
            for (Contact CreateUser: CreateUserList)
            {
                
                varAlias = string.valueof(system.currentTimeMillis());
                system.debug('varAlias' + varAlias);
                aliaslength = varAlias.length();
                integer i = 1;
                newUserRec = new User (
                        Username = 'account.exe'+ i + varAlias+i+'a'+'@imagenow' + i + varAlias + '.com1',        
                        LastName = CreateUser.LastName,
                        FirstName = CreateUser.FirstName,              
                        Email = 'user'+i+'@lexmark.com', //CreateUser.Email,      Hardcoded the email id to fix the domain to lexmark.com
                        Alias = CreateUser.FirstName.substring(0,1) + CreateUser.LastName.substring(0,2) + varAlias.subString(aliaslength-2,aliaslength),            
                        CommunityNickname = createUser.FirstName + '.' + Createuser.LastName + varAlias.subString(aliaslength-2,aliaslength),     
                        TimeZoneSidKey = 'America/Los_Angeles',        
                        LocaleSidKey = 'en_US',    
                        EmailEncodingKey = 'UTF-8', 
                        Legacy_Company__c = 'Lexmark',        
                        LanguageLocaleKey = 'en_US',        
                        ProfileId = profileID[0].id,EmployeeNumber='1234',
                        LX_Region__c='NE'  ,ContactId =  CreateUser.id                     
                );
                
                NewUserRec.IsActive = True; 
                NewUserRec.setOptions(dlo);
                userrecList.add(newUserRec);
                 i = i + 1;       
            }
            
            
            insert userRecList;
              
        }   
        return userRecList;  
    }
    
    static testMethod void testTestData() {
      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
      List<ID>contactIDs = new List<ID>();
      for(Contact contactRec: contacts){
        contactIDs.add(contactRec.id);
      }    
      List<User> userList = Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIds); 
            
      System.assertEquals(userList.size(),1); 
      userList = Data_User_PartnerPortal.createUser_PartnerPortal1(1, contactIds);
  }            
}