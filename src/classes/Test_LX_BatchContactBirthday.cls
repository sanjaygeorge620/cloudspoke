/* 
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 08/13/2013
 *
 * Author : Himanshu Dubey.
 * 
 * Description : Test class for LX_BatchContactBirthday.
*/
@isTest(seeAllData=true)
private class Test_LX_BatchContactBirthday {
  
private static testmethod void TestData(){
    Profile prof = [Select id from Profile where name='System Administrator'];
        
    List<User> lstUser = Data_User.createUser(1,new List<Id>{prof.Id});
    List<Contact> lstContact;
    System.runAs(lstuser[0]){
    
        Account acc = Data_Account.createAccount3();
        lstContact= Data_Contact.createContacts(acc.id,1); 
        lstContact[0].birthdate= System.today().addDays(10);  
        lstContact[0].LX_Last_Activity_Date__c = System.today();          
        system.debug('CONTACT******'+lstContact[0]);
        system.debug('CONTACT******email'+lstContact[0].Owner.Name);  
        system.debug('CONTACT******email'+lstContact[0].OwnerId); 
        system.debug('CONTACT******email'+lstContact[0].Owner.Email);       
        update lstContact[0];
    }    
     
    Test.startTest();
    try{
    LX_BatchContactBirthday testbatch = new LX_BatchContactBirthday();
    Database.BatchableContext BC;
    testbatch.execute(BC,lstContact);
    }catch(EmailException e){
               System.debug('@ EXCEPTION @ '+e.getMessage());
        } 
    Test.stopTest();  
    
} 
}