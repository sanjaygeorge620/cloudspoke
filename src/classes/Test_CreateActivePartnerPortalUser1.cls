@isTest
private class Test_CreateActivePartnerPortalUser1 {

    

    static testMethod void Test_CreateActivePartnerPortalUser() {
    
    Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='lexmarkabc@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='standarduser@vip.com',LX_Region__C='NE',Legacy_Company__c = 'Acuo');
         Insert adminUser;
            
        system.runas(adminUser)
    {
      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,1); 
             
      list<ID> contactIDset = new List<ID>();
      for (Contact contactrec : Contacts){
        contactIDSet.add(contactRec.id);
      }
      
  
        Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIDSet);
  
      
    /*  system.assertEquals(True,
            [select Account.IsPartner from Contact where id = :contactIDSet].account.isPartner); */
     }      
    }

}