@isTest
public class TestClass_RemindComponentController{

    static testMethod void insertNewTask() {
       
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');

      System.runAs(u) {
         // The following code runs as user 'u' 
         System.debug('Current User: ' + UserInfo.getUserName());
         System.debug('Current Profile: ' + UserInfo.getProfileId()); 
      }

            
       /*Task taskToCreate = new Task();
      // User userToCreate = new User();
       
       //LIST<User> Owners = [SELECT ID from User where Name == 'Lakshmi Sheshadri'];
       // Do you recognize these fields
       taskToCreate.Subject = 'Email';
       taskToCreate.Owner = u.Name;
	   taskToCreate.Status = 'In Progress';
       taskToCreate.Priority = 'High';
             
       insert taskToCreate;*/
}
}