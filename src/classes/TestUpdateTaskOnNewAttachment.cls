@isTest
private class TestUpdateTaskOnNewAttachment {
//create account
//create contact
//create case

//create task
//create email with activity ID of task
//update task with info from

@isTest
    static void TestUpdateTaskOnNewAttachment() {
    //add account record
        Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Type = 'Customer';
        acctRec.Physical_Country__c = 'USA'; acctRec.BillingCountry = 'USA';
        insert acctRec;
        
   //get Acct to add value to account rec
        Account acct = [select id from Account where id = :acctRec.id limit 1];
        
    //add contact record
        Contact contactRec = new Contact();
        contactRec.LastName = 'TestingLastName';
        contactRec.Region__c = 'NA';
        contactRec.Contact_Role__c = 'User';
        contactRec.Email = 'testing@acme.com';
        contactRec.AccountId = acct.id;
         insert contactRec;
         
    //get contact to use on task
        Contact newContact = [Select id from Contact where id = :contactRec.id limit 1];
         
    //create case
    /*
        Case caseRec = New Case();
        caseRec.Impact__c = 'User';
        caseRec.Frequency__c = 'Hourly';
        caseRec.Subject = 'Testing Subject';
        caseRec.Description = 'Testing Description';
        caseRec.Reason = 'new problem';
        insert caseRec; */
    List<Case> cases = Data_Case.createCase(acct, contactRec, 'Product Support', 1); 
        Case CaseRec = cases[0];  
        
    //get case id
    //    case newCase = [Select id from Case where id = :caseRec.id limit 1];
        case newCase = cases[0];
        
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
        userRec.ProfileId = [select id from Profile where Name = 'Development' limit 1].id;
        userRec.LX_Region__c = 'NS';
        userRec.Legacy_Company__c = 'Lexmark';
        insert userRec;
        
    //get user id
        User NewUser = [Select id from User where id = :userRec.id limit 1];
        
    //new Task
    Task newTask = new Task();
        newTask.Subject = 'Other';
        newTask.whatID = caserec.ID;
        insert newTask;
        
        Task newTaskID = [Select id, description from Task where id = :newTask.id Limit 1];
         
    //new email - assuming task is created first
    EmailMessage eMessage = New EmailMessage();
        eMessage.ToAddress = contactRec.email;
        eMessage.Subject = 'email Subject Test';
        eMessage.ccAddress = contactRec.email;
        eMessage.textBody = 'Text Body testing';
        eMessage.htmlBody = '<br>Testing<br>';
        eMessage.activityID = newTaskID.id;
        eMessage.parentID = newcase.ID;
        eMessage.Incoming = TRUE;
        insert eMessage; 
        
        EmailMessage newMessage = [Select ID, activityID, TextBody, htmlBody, Subject, ToAddress, ccAddress, BccAddress from EmailMessage where id = :eMessage.ID limit 1];
        
        
    Attachment newAttach = new Attachment();
        newAttach.name = 'test attachment.doc';
        newAttach.parentID = newMessage.ID;
        newAttach.Body = Blob.valueOf ('Testing');            // EncodingUtil.base64Decode (body);;
        insert newAttach;
        
        Attachment attachRec = [Select ID, parentID, name from Attachment where id = :newAttach.ID limit 1];   
        
        /*system.assertequals('test attachment.doc',
        [select name from Attachment where id = :attachrec.ID].name); 
        
        system.assertEquals('email Subject Test',
        [select subject from EmailMessage where id = :newMessage.ID].subject);
        
        system.assertEquals('Other',
        [select subject from Task where id = :NewMessage.activityID].subject);
        
        system.assertEquals('testing@acme.com',
        [Select ccAddress from EmailMessage where id = :newMessage.ID].ccAddress);
        
                system.assertEquals('Auto Processed',
        [Select Activity_Subject__c from Task where id = :newTaskid.ID].Activity_Subject__c);
         
         system.assert(eMessage.ccAddress != Null);*/

             
    }

}