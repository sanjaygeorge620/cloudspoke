@isTest(SeeAllData=true)
public class testActivateUser{
    static List<User> testUserList;
    static List<Id> profileListID;
    static List<Id> userIDList;
    static List<Profile> profileList;
    
    public static testmethod void testActivateUser(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User userNew = new User();
        userNew.FirstName = 'testUser345';
        userNew.LastName = 'testUser345';
        userNew.ProfileId = profile.Id;
        userNew.Legacy_Company__c = 'Lexmark';
        userNew.Username = 'testUserName1290@test.com';
        userNew.Email = 'test123@lexmark.com';
        userNew.Alias = 'test';
        userNew.CommunityNickname = 'testComName';
        userNew.TimeZoneSidKey = 'America/Chicago';
        userNew.LocaleSidKey = 'en_US';
        userNew.EmailEncodingKey = 'ISO-8859-1';
        userNew.LanguageLocaleKey = 'en_US';
        userNew.EmployeeNumber = '1234';
        
        insert userNew;
        System.runAs(userNew){
          test.startTest();
              /*profileList = new List<Profile>();
              profileListID = new List<Id>();
              profileList = [Select id from profile limit 10];
              for(profile tempProfile : profileList){
                profileListID.add(tempProfile.Id);
              }
              testUserList = new List<User>();
              testUserList = Data_user.createUser(10,profileListID );
              */
              testUserList = new List<User>();
              testUserList.add(userNew);
              userIDList = new List<Id>();
              for(User tempUser : testUserList){
                  userIDList.add(tempUser.Id); 
              }
              ActivateUser.ActivateUser(userIDList);
          test.stopTest();    
        }
    }
}