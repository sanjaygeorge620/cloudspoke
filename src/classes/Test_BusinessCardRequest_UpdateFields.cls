/**
 * 
 */
@isTest
private class Test_BusinessCardRequest_UpdateFields {

    static testMethod void TestBusinessCardRequest_UpdateFields() {

        //add account record
        Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Type = 'Customer';
        acctRec.Sector__c = 'Federal';
        acctRec.Physical_Country__c = 'USA'; acctRec.BillingCountry = 'USA';
        insert acctRec;
        
   //get Acct to add value to account rec
        Account acct = [select id from Account where id = :acctRec.id limit 1];
        
         //add userRec   
     User systemUser = [select id, LastName, Email, Alias, TimeZoneSidKey,
            LocaleSidKey, EmailEncodingKey, LanguageLocaleKey
            from User where IsActive = true limit 1];       
     
        User userRec1 = new User();
        userRec1.Username = 'unknown.Manager@perceptivesoftware.com';
        userRec1.LastName = 'Manager';
        userRec1.FirstName = 'Unknown';
        userRec1.Email = 'process.admin@perceptivesoftware.com';
        userRec1.Alias = 'uMan12';
        userRec1.CommunityNickname = 'uMan12';
        userRec1.TimeZoneSidKey = systemUser.TimeZoneSidKey;
        userRec1.LocaleSidKey = systemUser.LocaleSidKey;
        userRec1.EmailEncodingKey = systemUser.EmailEncodingKey;
        userRec1.LanguageLocaleKey = systemUser.LanguageLocaleKey;
        userRec1.LX_Region__c='NE';
        userRec1.Legacy_Company__c = 'Acuo';
        userRec1.ProfileId = [select id from Profile where Name = 'PSE Admin' limit 1].id;
        insert userRec1;
        
    //get user id
        User ManagerUser = [Select id from User where id = :userRec1.id limit 1];
        
            
        User userRec2 = new User();
        userRec2.Username = 'unknown.Consultant2@perceptivesoftware.com';
        userRec2.LastName = 'Consultant';
        userRec2.FirstName = 'Unknown';
        userRec2.Email = 'process.admin@perceptivesoftware.com';
        userRec2.Alias = 'uconsu';
        userRec2.Manager = ManagerUser;
        userRec2.CommunityNickname = 'uconsu';
        userRec2.TimeZoneSidKey = systemUser.TimeZoneSidKey;
        userRec2.LocaleSidKey = systemUser.LocaleSidKey;
        userRec2.EmailEncodingKey = systemUser.EmailEncodingKey;
        userRec2.LanguageLocaleKey = systemUser.LanguageLocaleKey;
        userRec2.ProfileId = [select id from Profile where Name = 'PSE Admin' limit 1].id;
        userRec2.LX_Region__c='NE';
        userRec2.Legacy_Company__c = 'Acuo';
        insert userRec2;
        
    //get user id
        User consultantUser = [Select id from User where id = :userRec2.id limit 1];
       
    //add contact record
        Contact contactRec = new Contact();
        contactRec.LastName = 'TestingLastName';
        contactRec.FirstName = 'TestingFirstName';
        contactRec.Region__c = 'NA';
        contactRec.Contact_Role__c = 'User';
        contactRec.Email = 'testing@acme.com';
        contactRec.pse__Salesforce_User__c = consultantUser.id;
        contactRec.AccountId = acct.id;
         insert contactRec;
         
    //get contact to use on task
     //   Contact newContact = [Select id from Contact where id = :contactRec.id limit 1];
        Contact newContact = [Select id, pse__Salesforce_User__c from Contact where pse__Salesforce_User__c != '' limit 1];
    
    // get recordtypeid - 
        RecordType RecordTypeID = [select Id from RecordType where name = 'Business Card Request' and sobjectType = 'Case' Limit 1];
         
    //create case
        Case caseRec = New Case();
        caseRec.Impact__c = 'User';
        caseRec.Subject = 'Testing Subject';
        caseRec.Description = 'Testing Description';
        caseRec.Reason = 'new problem';
        caseRec.Contact = newContact;
        caseRec.ContactId = newContact.Id;
        caseRec.Urgency__c = 'Low';
        caserec.RecordTypeId = RecordTypeID.id;
        insert caseRec;

        Case newCase = [Select id, Resource_Manager__c from Case where id = :caseRec.id limit 1];
     
     //get Recordtype id for Mobile request
        RecordType RTID = [select Id from RecordType where name = 'Mobile Request' and sobjectType = 'Case' Limit 1];
        
        Case c = new Case();
        c.RecordTypeId = RTID.Id;
        c.Status = 'New';
        c.Type = 'Request';
        c.ContactId = newContact.Id;
        insert c;
        

    }
}