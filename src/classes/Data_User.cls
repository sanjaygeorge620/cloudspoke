public with sharing class Data_User {
    //create a class that can be called more than once to create 1 or multiple users
    Public static List<User> createUser(integer size, List<ID> profileIDList){
    
        // Select an existing user to use variables to create test user        
  /*      User systemUser = [select id, LastName, Email, Alias, TimeZoneSidKey,            
        LocaleSidKey, EmailEncodingKey, LanguageLocaleKey            
        from User where IsActive = true limit 1];
        system.debug('system User:' + systemUser);
   */     
        List<User> newUserList = new List<User>();
        string varAlias = string.valueof(system.currentTimeMillis());
        system.debug('varAlias: ' + varAlias);
        system.debug('Alias length: '+ varAlias.subString(3));
        integer aliaslength = varAlias.length();
        
        UserRole ur =[Select id from UserRole where name='Admin User'];
        integer u = 0;      
        User newUserRec;
        for (Integer i= 0;i<size;i++){
            system.debug('profileList[u]: ' + profileIDList[u]);
            system.debug('profileIDList: ' + profileIDList);
            newUserRec = new User (
                        Username = 'account.exe'+ i + varAlias+'@imagenow' + i + varAlias + '.com',        
                        LastName = 'executive',
                        FirstName = 'Account',       
                        Email = 'process.admin@perceptivesoftware.com',       
                        Alias = varAlias.subString(aliaslength-3,aliaslength)+ i,
                        CommunityNickname = varAlias.substring(aliaslength-4,aliaslength) + i + 'ToDuplication' + varAlias.substring(aliaslength-4,aliaslength) ,        
                        TimeZoneSidKey = 'America/Chicago',        
                        LocaleSidKey = 'en_US',    
                        EmailEncodingKey = 'ISO-8859-1',        
                        LanguageLocaleKey = 'en_US',
                        managerID = UserInfo.getUserID(),        
                        ProfileId = profileIdList[u],
                        UserRoleId = ur.Id,
                        LX_Region__c = 'NE',legacy_company__c = 'Lexmark', EmployeeNumber = '1234'
            );
            system.debug('CommunityNickname:' + NewUserRec.CommunityNickname ); 
            If (u < profileIDList.size()-1){
                u++;
                system.debug('u:' + u);

            }    
            newUserList.add(newUserRec);
        }
        User runuser= [select id ,isactive from user where id!=:UserInfo.getUserId() AND isactive=true AND EmployeeNumber!=NULL limit 1];
        System.runas(runuser){  
        insert newUserList;
        }
        return newUserList;
        
    }  
    static testMethod void testTestData() {
      Set<String> userProfile = new Set<String>();

      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
      //4.18.2013 from 55 to 57
      //profileIds.add('00e70000000yZmI'); 
        profileIds.add('00ei0000000WaeAAAS');
    //  for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           //userProfileMap.put(profile.Name,profile.Id);
    //       ProfileIds.add(profile.id);
    //    }
      List<User> userList = Data_User.createUser(1, profileIds);       
      System.assertEquals(userList.size(),1); 
  }
  
  Public static testMethod User testUserwithManager(){
    UserRole ur =[Select id from UserRole where name='Admin User'];
    list<Profile> tempprofileid = [select id, name from profile where name ='Standard User' limit 1];
    User newUserMgrRec = new User (
                        Username = 'account.exe1'+ '@imagenow' + '.com',        
                        LastName = 'executive1',
                        FirstName = 'Account1',       
                        Email = 'process.admi1n@perceptivesoftware.com',       
                        Alias = 'test1',
                        CommunityNickname = 'nickname1',        
                        TimeZoneSidKey = 'America/Chicago',        
                        LocaleSidKey = 'en_US',    
                        EmailEncodingKey = 'ISO-8859-1',        
                        LanguageLocaleKey = 'en_US',
                        managerID = UserInfo.getUserID(),        
                        UserRoleId = ur.Id,
                        ProfileId =tempprofileid[0].id,
                        Is_Manager__c=true,
                        LX_Region__c = 'NE',legacy_company__c = 'Lexmark', EmployeeNumber = '1234'
            );
            
            insert newUserMgrRec ;
            
            User newUserRecwithMgr = new User (
                        Username = 'account.exe'+ '@imagenow' + '.com',        
                        LastName = 'executive',
                        FirstName = 'Account', 
                        ProfileId =tempprofileid[0].id,      
                        Email = 'process.admin@perceptivesoftware.com',       
                        Alias = 'test',
                        CommunityNickname = 'nickname',        
                        TimeZoneSidKey = 'America/Chicago',        
                        LocaleSidKey = 'en_US',    
                        EmailEncodingKey = 'ISO-8859-1',        
                        LanguageLocaleKey = 'en_US',
                        managerID =newUserMgrRec.ID,        
                        UserRoleId = ur.Id,
                        LX_Ability_to_Create_Accounts__c='yes',
                        LX_Region__c = 'NE',legacy_company__c = 'Lexmark', EmployeeNumber = '1235'
            );
            
            insert newUserRecwithMgr;
            return newUserRecwithMgr;
  }
   static testMethod void testUserwidManager() {
   User tempusr = Data_User.testUserwithManager();     
   }
              
}