/**
 * Name: Test_EmployeeChangeValidation
 *
 * Description: to provide code coverage for EmployeeChangeValidation Class
 * Created By: Manoj Kolli
 * Created Date: 4/18/2012
 */
@isTest(seeAllData=true)
public class Test_EmployeeChangeValidation {

    Public static testMethod void Test_EmployeeChangeValidation() {
      
      Test.startTest();
            
      List<ID> ProfileIds = new List<ID>();
       for(Profile p : [select Id from Profile where Name ='System Administrator' limit 1]){
        ProfileIds.add(p.ID);
       }
      List<User> userList = Data_User.createUser(2, profileIds);       
      User u1 = userList[0];
      User u2 = userList[1];
      u2.Is_Manager__C = True;
      Update u2;
      Account acc = null;
      List<Contact> contacts = null;
       Contact con = null;
      
      System.RunAs(u1){      
     acc = Data_Account.createAccount();
      contacts = Data_Contact.createContacts(acc.Id,1);
       con = contacts[0];     
         PageReference pg1 = Page.EmployeeChange;
         pg1.getParameters().put('id',con.Id);
         EmployeeChangeValidation nc1 = new EmployeeChangeValidation();
         Test.setCurrentPage(pg1);
         nc1.Redirect();
         nc1.Error();
       }
     System.RunAs(u2){           
         PageReference pg2 = Page.EmployeeChange;
         pg2.getParameters().put('id',con.Id);
         EmployeeChangeValidation nc2 = new EmployeeChangeValidation();
         Test.setCurrentPage(pg2);
         nc2.Redirect();
         nc2.Error();
       }   
         Test.stopTest();
    }
}