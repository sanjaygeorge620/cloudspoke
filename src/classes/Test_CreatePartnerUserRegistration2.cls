/**
 * Name: Test_CreatePartnerUserRegistration2
 *
 * Description: to provide code coverage for CreatePartnerUserRegistration2 Class
 *
 * Created Date: 3/11/2012
 */
@isTest(seeAllData=true)
private class Test_CreatePartnerUserRegistration2 {



    static testMethod void Test_CreatePartnerUserRegistration() {
      
      Test.startTest();
      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
      
      //Account acc1 = Data_Account.createAccount();
      List<Contact> contacts1 = Data_Contact.createContacts(acc.Id,1);
             
      set<ID> contactIDset = new set<ID>();
      for (Contact contactrec : Contacts){
        contactIDSet.add(contactRec.id);
      }
      
      set<ID> contactID = new set<ID>();
      for (Contact contrec : Contacts1){
        contactID.add(contRec.id);
      }
      
      
        CreatePartnerUserRegistration2.CreatePartnerUserRegistration(contactIDSet);
        
        Contact c = contacts[0];
        Contact c1 = contacts1[0];
        c.email = c1.email;
        Update c;  
        
        CreatePartnerUserRegistration2.CreatePartnerUserRegistration(contactID);
      
      Test.stopTest(); 
           
    }

}