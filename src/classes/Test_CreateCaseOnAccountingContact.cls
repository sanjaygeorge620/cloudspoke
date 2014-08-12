@isTest
private class Test_CreateCaseOnAccountingContact {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        //create contact
      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);       
      System.assertEquals(contacts.size(),1); 
    }
}