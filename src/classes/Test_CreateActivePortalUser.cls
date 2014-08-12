@isTest
private class Test_CreateActivePortalUser {

    static testMethod void test_CreateActivePortalUser() {
    
    Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
    User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                  localesidkey='en_US', profileid = adminProfile.Id, 
                  timezonesidkey='America/Los_Angeles',legacy_company__c='Perceptive', username='st1andardu555ser@txzestorg1.com',
                  LX_Region__c='NE');
                  
    Insert adminUser;
    
    system.runas(adminUser)
    {
      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,1); 
             
      set<ID> contactIDset = new set<ID>();
      for (Contact contactrec : Contacts){
        contactIDSet.add(contactRec.id);
      }
      
  
        //createActivePortaluser.CreateActivePortalUser(contactIDSet);
  
      
     /*system.assertEquals(True,
            [select Account.IsCustomerPortal from Contact where id = :contactIDSet].account.iscustomerPortal);*/
     }      
    }
}