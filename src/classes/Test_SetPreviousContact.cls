/**

 */
@isTest
private class Test_SetPreviousContact {

    static testMethod void SetPreviousContact_Test() {
      
      Account acc = Data_Account.createAccount3();
      system.debug('acc:' + acc);
      List<Contact> contacts = Data_Contact.createContacts_nonAccountingContact(acc.Id,1);
      List<ID>contactIDs = new List<ID>();
      for(Contact contactRec: contacts){
        contactIDs.add(contactRec.id);
      } 
      system.debug('testing');   
      List<User> userList = Data_User_CustomerPortal.createUser_CustomerPortal(1, contactIds, 'System Administrator');       
      System.assertEquals(userList.size(),1); 
      
      
      
      for (User userRec : UserList){
            system.debug('user.contactID' + userRec.ContactID);
            system.debug('contact: ' + contact.id);
            System.assertEquals(userRec.contactID,contacts[0].id); 
      }

            
    }
}