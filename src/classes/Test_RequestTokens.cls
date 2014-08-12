/**
    Test Class for RequestTokens
*/    
@isTest
private class  Test_RequestTokens {
    
    static testMethod void testExecute() {
        //add account record
        System.debug('--megha--');
    Account acctRec = new Account();
    acctRec.Name = 'testAccount';
    acctRec.Type = 'Internal';
    acctRec.Sector__c = 'Federal';
    acctRec.Party_Type__c = 'Press';
    acctRec.Party_Role__c = 'Commercial';
    acctRec.Physical_Country__c = 'USA'; acctRec.BillingCountry = 'USA';
    insert acctRec;
  
    //create masterContact
    Contact masterContactRec = new Contact();
    masterContactRec.LastName = 'TestingLastName';
    masterContactRec.FirstName = 'TestingFirstName';
    masterContactRec.Region__c = 'NA';
    masterContactRec.Contact_Role__c = 'User';
    masterContactRec.Email = 'testing@acme.com';
    masterContactRec.AccountId = acctRec.id;
    //masterContactRec.Lx_Lexmark_Vertical__c = 'Manufacturing';
    insert masterContactRec;
    
    ELearning_Registration__c elr = new ELearning_Registration__c();
    elr.Account__c = acctRec.id;
    insert elr;
    
    Training_Attendee__c ta = new Training_Attendee__c();
    ta.Registration__c = elr.id;
    ta.Name= 'test';
    ta.Contact__c = masterContactRec.id;
        insert ta;
        
        RequestTokens requestT = new RequestTokens(new ApexPages.Standardcontroller(ta));
        requestT.requstedTokens = '5';
        requestT.requestTokens();
    }
    
     static testMethod void testExecute_Unit2() {
        //add account record
        String ProfileName = 'System Administrator';
       List<Profile> PrfLisst = [select id from Profile where Name = :ProfileName limit 1];
       List<id> PrfList = new List<id>();
       for(Profile P: PrfLisst ){
          PrfList.add(P.id);
       }
       List<String> UrfList = new List<String>();
       List<User> UserList = Data_User.createUser(1,PrfList);
       List<User> UserList1 = Data_User.createUser(1,PrfList);
       for(User U: UserList ){
          UrfList.add(U.id);
       }
       for(User U: UserList1 ){
          UrfList.add(U.id);
       }
               Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Type = 'Internal';
        acctRec.Sector__c = 'Federal';
        acctRec.Party_Type__c = 'Press';
        acctRec.Party_Role__c = 'Commercial';
        acctRec.Physical_Country__c = 'USA'; acctRec.BillingCountry = 'USA';
        insert acctRec;
           //create masterContact
        Contact masterContactRec = new Contact();
        masterContactRec.LastName = 'TestingLastName';
        masterContactRec.FirstName = 'TestingFirstName';
        masterContactRec.Region__c = 'NA';
        masterContactRec.Contact_Role__c = 'User';
        masterContactRec.Email = UserList1[0].Email;
        masterContactRec.AccountId = acctRec.id;
        //masterContactRec.Lx_Lexmark_Vertical__c = 'Manufacturing';
        insert masterContactRec;
        List<ID> IdList = GetContactFromUserList.getContactFromUserList(UrfList );
    }
}