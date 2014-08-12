@isTest(seeAlldata=true)
private class Test_OrderDetailSharing {

    static testMethod void myUnitTest() {
    Map<String,ID> profiles = new Map<String,ID>();
    Map<String,ID> roles = new Map<String,ID>();
      List<Profile> ps = [select id, name from Profile where name = 'System Administrator' ];
      List<UserRole> ur = [Select id, name from UserRole];
      for(Profile p : ps){
         profiles.put(p.name, p.id);
      }
      for(UserRole r : ur){
         roles.put(r.name, r.id);
      }
     Profile prof = [select id, name from Profile where name = 'System Administrator'];
     //User admin = [SELECT Id FROM user WHERE profileid = :profiles.get('System Administrator') and isActive = true LIMIT 1];
     //Commented by Charan on 28-05-2013
     /*added by Charan on 28-05-2013*/               
        User Objuser = new User(alias = 'standt', email='standarduser@lexmark.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US',profileId = prof.Id,UserroleId=roles.get('CEO'),Legacy_Company__c = 'Lexmark',                         
                        timezonesidkey='America/Los_Angeles', username='testuser@lexmark.com',LX_Region__c = 'NE',EmployeeNumber = '1234');
        
        insert Objuser;
     /*added by Charan*/   
        
  //     Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
    System.runAs(Objuser){
            Test.startTest();
   
            Account acc = Data_Account.createAccount();
            Account accReseller = Data_Account.createPartnerAccount(); 
            //accReseller.RecordTypeID = '01270000000M922';
            accReseller.RecordTypeID = LX_SetRecordIDs.L4MDMCustomerAccountRecordId; 
            update accReseller ;
            
            
            acc.Reseller_ID__c = accReseller.id;
            update acc;
            
            List<Contact> contacts = Data_Contact.createContacts(accReseller.Id,1);
            
            list<ID>contactIDs = new list<ID>();

            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);

            }   

              
            createUser_PartnerPortal(1, contactIDs); 
            list<User> PartnerPortalList = new List<user>([select id from user where contactID in :contactIDs]);

                Order__c orderRec = new Order__c();
                orderRec.account__c = acc.id;
                orderRec.name = 'testing orderRec';
                insert orderRec;
                
                Order_Detail__c OrderDetailRec = new Order_Detail__c();
                orderDetailRec.Name = 'SMSA-CaptureNow Adrenaline';
                orderDetailRec.Order__c= orderRec.id;
              //orderDetailRec.Order_Reseller_Account__c=acc.id;
                insert OrderDetailRec;
                
                
           Set<ID> OrderIds = new Set<ID>();
           OrderIds.add(orderDetailRec.id);
           RecordSharing_Order_Detail.manualShare_Order_Detail_Read(OrderIds);   
           
           
           
           system.debug('Order_ShareRecords:' + [select id, userOrGroupID from Order_Detail__Share where parentID = :orderRec.id]);
           Id AccountRecordTypeId=LX_SetRecordIDs.L5LocationCustomerAccountRecordId;
            
           Account accReseller2 = Data_Account.createAccount(); 
            accReseller2.RecordTypeID = AccountRecordTypeId;
            update accReseller2 ;
            
             List<Contact> contacts2 = Data_Contact.createContacts(accReseller2.Id,1);
            
            list<ID>contactIDs2 = new list<ID>();

            for(Contact contactRec: contacts2){
                contactIDs2.add(contactRec.id);

            }   
            Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIDs2); 
            
            set<id> OrderListIds = new set<id>();
            orderListIds.add(orderDetailRec.id);
            set<id> acctListIds = new set<id>();
            acctListIds.add(AccReseller.id);
            
            system.debug('acctlistids:' + acctListIds);
            
            User userRec = [Select id from user where contactId = :contactIDs[0]];
            system.debug('userRec:' + userRec);
            List<Order_Detail__Share> OrderShareList = new List<Order_Detail__share>( [select userorGroupID from Order_Detail__Share where parentID = :orderDetailRec.id]);
            system.debug('OrderShareList :' + OrderShareList );
            
            Database.deleteResult dr = Database.delete(OrderShareList[0] ,false);
            system.debug('saveResult:' + dr);
//            system.assertEquals(True, dr.isSuccess());
            
            RecordSharing_Removal_Order_Detail.manualShare_Order_Detail_Removal(orderListIds, acctListIds);
  
            orderRec.account__c = accReseller2.ID;
            update orderRec;
            
          
            Test.stopTest();


            }  
                
                
                
    }
    
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
        
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = True;                //sets options so email is sent 
        List<Profile> ProfileId = [select id from Profile where Name = 'Perceptive Partner Portal Admin' limit 1];
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
                                                             CaseAccessForAccountOwner From UserRole where PortalType = 'Partner' Limit 1];
        //UserRole newPortalRole = new UserRole(PortalType = 'Partner',PortalAccountId= acc .id);
        //Insert newPortalRole;
        
        if (CreateUserList.size() > 0) {
            for (Contact CreateUser: CreateUserList){
                
              /*  if (CreateUser.Account.IsPartner == false){
                    //need to check if account is already a member
                    accountIDSet.add(CreateUser.Accountid);
                }*/
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
                        Legacy_Company__c = 'Lexmark',        
                        ProfileId = profileID[0].id, 
                        contactid = CreateUser.id,
                        LX_Region__c = 'NE',
                    EmployeeNumber = '1234'
                      //  UserRoleId = portalRoleList[0].id //added by Gulzar
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
}