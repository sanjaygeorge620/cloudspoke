@isTest
private class TestUpdateTaskOnNewCaseEmail {
//create account
//create contact
//create case

//create task
//create email with activity ID of task
//update task with info from

@isTest
    static void TestUpdateTaskOnNewCaseEmail() {
    //add account record
        Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Type = 'Customer';
        acctRec.Party_Role__c = 'Reseller';
        acctRec.Party_Type__c = 'OEM';
        acctRec.Physical_Country__c = 'USA'; acctRec.BillingCountry = 'USA';
        insert acctRec;
        
    //add contact record
        Contact contactRec = new Contact();
        contactRec.LastName = 'TestingLastName1';
        contactRec.Region__c = 'NA';
        contactRec.Contact_Role__c = 'User';
        contactRec.Email = 'testing@acme.com';
        contactRec.AccountId = acctRec.id;
         insert contactRec;
         
       recordtype rt=[select id from Recordtype where   SobjectType='case' and Name='Product Support' and IsActive =true limit 1] ; 
         
    //create case
        Case caseRec = New Case();
        caseRec.Subject = 'Testing Subject'+system.now();
        caseRec.Description = 'Testing Description'+system.now();
        caseRec.Contactid=contactRec.id;
        caseRec.Accountid=acctRec.id;
        caseRec.recordtypeid=rt.id;
        insert caseRec;
        
   // Select an existing user to use variables to create test user
        User systemUser = [select id, LastName, Email, Alias, TimeZoneSidKey,
            LocaleSidKey, EmailEncodingKey, LanguageLocaleKey
            from User where IsActive = true limit 1];
        
    //create user
    User userRec = new User();
        userRec.Username = 'testing.sector@imagenow.com';
        userRec.LastName = 'Sector';
        userRec.FirstName = 'Testing';
        userRec.Email = 'testing.sector@lexmark.com';
        userRec.Alias = 'testSect';
        userRec.CommunityNickname = 'TestSector';
        userRec.TimeZoneSidKey = systemUser.TimeZoneSidKey;
        userRec.LocaleSidKey = systemUser.LocaleSidKey;
        userRec.EmailEncodingKey = systemUser.EmailEncodingKey;
        userRec.LanguageLocaleKey = systemUser.LanguageLocaleKey;
        userRec.LX_region__c='NE';
        userRec.ProfileId = [select id from Profile where Name = 'Development' limit 1].id;
        userRec.Legacy_Company__c = 'Lexmark';
        insert userRec;
        
    //new Task
    Task newTask = new Task();
        newTask.Subject = 'Other';
        newTask.whatID = caserec.ID;
        insert newTask;
        
    //new email - task is created first
    EmailMessage eMessage = New EmailMessage();
        eMessage.ToAddress = contactRec.email;
        eMessage.Subject = 'email Subject Test';
        eMessage.ccAddress = contactRec.email;
        eMessage.textBody = 'Text Body testing';
        eMessage.activityID = newTask.id;
        eMessage.parentID = caseRec.ID;
        eMessage.Incoming = TRUE;
        insert eMessage;
   
        /*system.assertEquals('email Subject Test',
        [select subject from EmailMessage where id = :eMessage.ID].subject);
        
        system.assertEquals('Other',
        [select subject from Task where id = :eMessage.activityID].subject);
        
        system.assertEquals('testing@acme.com',
        [Select ccAddress from EmailMessage where id = :eMessage.ID].ccAddress);
        
        system.assertEquals('Auto Processed',
        [Select Activity_Subject__c from Task where id = :newTask.ID].Activity_Subject__c);
         
         system.assert(eMessage.ccAddress != Null);*/
   
   
    //new Task
    Task newTask2 = new Task();
        newTask2.Subject = 'Other';
        newTask2.whatID = caserec.ID;
        newTask2.whoID = contactRec.ID;
        insert newTask2;
    
    //Email #2    
    EmailMessage eMessage2 = New EmailMessage();
        eMessage2.ToAddress = contactRec.email;
        eMessage2.Subject = 'email Subject Test';
        eMessage2.ccAddress = contactRec.email;
        eMessage2.textBody = null;
        eMessage2.htmlBody = 'Text Body testing';
        eMessage2.activityID = newTask2.id;
        eMessage2.parentID = caseRec.ID;
        eMessage2.Incoming = TRUE;
        insert eMessage2;
   
        /*system.assertEquals('email Subject Test',
        [select subject from EmailMessage where id = :eMessage2.ID].subject);
        
        system.assertEquals('Other',
        [select subject from Task where id = :eMessage2.activityID].subject);
        
        system.assertEquals('testing@acme.com',
        [Select ccAddress from EmailMessage where id = :eMessage2.ID].ccAddress);
        
        system.assertEquals('Auto Processed',
        [Select Activity_Subject__c from Task where id = :newTask2.ID].Activity_Subject__c);
         
         system.assert(eMessage2.ccAddress != Null);*/
             
    }

}