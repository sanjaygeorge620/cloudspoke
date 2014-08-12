/*************************************************************************
Name    : TestTriggerClassRegistration
Purpose : Unit tests for testing triggers of Class Registration.
Author  : Aashish Mathur
Date    : July 10, 2009
*************************************************************************/

@isTest
private class TestTriggerClassRegistration {
    @isTest
    static void testTriggerClassRegistration() {
        // Test data preparation start
        
        RecordType classRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Class__c' limit 1];
        
        
        // Select an existing user
        User SystemUser = [select id, LastName, Email, Alias, TimeZoneSidKey,
            LocaleSidKey, EmailEncodingKey, LanguageLocaleKey
            from User where IsActive = true limit 1];
        
        // List of new Users
      /*  List<User> userList = new List<User>();
        
        User testUser = new User();
        testUser.Username = 'testUser1@xyz.com';
        testUser.LastName = //SystemUser.LastName;
        testUser.Email = 'testuser1@xyz.com';
        testUser.Alias = //SystemUser.Alias;
        testUser.CommunityNickname = 'testUser1';
        testUser.TimeZoneSidKey = //SystemUser.TimeZoneSidKey;
        testUser.LocaleSidKey = //SystemUser.LocaleSidKey;
        testUser.EmailEncodingKey = //SystemUser.EmailEncodingKey;
        testUser.LanguageLocaleKey = //SystemUser.LanguageLocaleKey;
        testUser.ProfileId = [select id from Profile where Name = '//System Administrator' limit 1].id;
        userList.add(testUser);
        
        testUser = new User();
        testUser.Username = 'testUser2@xyz.com';
        testUser.LastName = //SystemUser.LastName;
        testUser.Email = 'testuser2@xyz.com';
        testUser.Alias = //SystemUser.Alias;
        testUser.CommunityNickname = 'testUser2';
        testUser.TimeZoneSidKey = //SystemUser.TimeZoneSidKey;
        testUser.LocaleSidKey = //SystemUser.LocaleSidKey;
        testUser.EmailEncodingKey = //SystemUser.EmailEncodingKey;
        testUser.LanguageLocaleKey = //SystemUser.LanguageLocaleKey;
        testUser.ProfileId = [select id from Profile where Name = '//System Administrator' limit 1].id;
        userList.add(testUser);
        
        insert userList;
        */
         Set<String> userProfile = new Set<String>();      
         userProfile.add('PSE Management');           
         userProfile.add('//System Administrator');            
         List<ID> ProfileIds = new List<ID>();               
         for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
                //userProfileMap.put(profile.Name,profile.Id);           
                 ProfileIds.add(profile.id);        
         }      
         List<User> userList = Data_User.createUser(2, profileIds);       
        
        // Class for registration
        Class__c newClass = new Class__c();
        newClass.Class_Date__c = System.today();
        newClass.Class_Capacity__c = 10;
        if(classRecord!=null)
            newClass.RecordTypeId = classRecord.id;
        
        insert newClass;

        //
        Class__c newClass2 = new Class__c();
        newClass2.Class_Date__c = System.today();
        newClass2.Class_Capacity__c = 10;
        if(classRecord!=null)
            newClass2.RecordTypeId = classRecord.id;
        insert newClass2;
        
        // List of accounts
        List<Account> accList = new List<Account>();
        
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.OwnerId = userList[0].id;
        acc.BillingCountry = 'USA';
        acc.Physical_Country__c = 'USA';
        accList.add(acc);
        
        acc = new Account();
        acc.Name = 'Test Account 2';
        acc.OwnerId = userList[1].id;
        acc.BillingCountry = 'USA';
        acc.Physical_Country__c = 'USA';
        accList.add(acc);
        
        insert accList;
        
        // Registration with first account
        ELearning_Registration__c registration = new ELearning_Registration__c();
        registration.class__c = newClass.id;
        registration.Account__c = accList[0].id;
        insert registration;
        
        // Attendee of registration
        Training_Attendee__c attendee = new Training_Attendee__c();
        attendee.class__c = newClass.id;
        attendee.Registration__c = registration.Id;
        insert attendee;

        Training_Attendee__c attendee2 = new Training_Attendee__c();
        attendee2.class__c = newClass.id;
        attendee2.Registration__c = registration.Id;
        insert attendee2;
        
        // Test data preparation complete
        
        // Assert pre conditions
        attendee = [select id, Account_Name__c, Account_Owner_Email__c from Training_Attendee__c
                where id = :attendee.id];
        
        //VT8/25: Commented//System.assertEquals(attendee.Account_Name__c, 'Test Account 1');
       // //System.assertEquals(attendee.Account_Owner_Email__c, 'testuser1@xyz.com');
       //VT 10/1: Commented //System.assertEquals(attendee.Account_Owner_Email__c, userlist[0].email);

        
        // Testing starts
        Test.startTest();
        
        // Set second account in registration
        registration.Account__c = accList[1].id;
        update registration;
        
        registration.Class__c = newClass2.Id;
        update registration;
        
        // Testing completes
        Test.stopTest();
        
        // Assert post conditions
        attendee = [select id, Account_Name__c, Account_Owner_Email__c from Training_Attendee__c
                where id = :attendee.id];
        
        //VT 10/1: Commented//System.assertEquals(attendee.Account_Name__c, 'Test Account 2');
        ////System.assertEquals(attendee.Account_Owner_Email__c, 'testuser2@xyz.com');
        //VT 10/1: Commented//System.assertEquals(attendee.Account_Owner_Email__c, userlist[1].email);

    }
}