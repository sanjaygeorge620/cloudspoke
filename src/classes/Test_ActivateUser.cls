@isTest
private class Test_ActivateUser {

    /*static testMethod void Test_ActivateUser() {
      Set<String> userProfile = new Set<String>();
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           //userProfileMap.put(profile.Name,profile.Id);
           ProfileIds.add(profile.id);
      }
      List<User> userList = Data_User.createUser(1, profileIds);  
      List<ID> UserIDList = new List<ID>();    
      ID UserID = userList[0].id;
      System.assertEquals(userList.size(),1);

      system.debug('userLIst: ' + userList);        
      List<User> UserrecList = new List<User>([Select isActive from User where id = :UserID]);
      
  /*    for (User userrec : userrecList){
        Userrec.isActive = False;
      }
      update userrecList;
  */    
     /* for(Integer i =0;i<userrecList.size();i++){     
        userIDList.add(userrecList[i].id);
      }  
     
      Test.startTest();
         activateuser.activateUser(userIDList);
      test.stopTest();
        
    }*/
}