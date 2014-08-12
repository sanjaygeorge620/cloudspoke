@isTest
private class TestControllerClasses {
    
    static testMethod void testControllerClasses() {
    
    
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'stan34', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', 
         languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id,EmployeeNumber = '1234',
         timezonesidkey='America/Los_Angeles',legacy_company__c='Perceptive', username='standarduser'+math.random()+'@testorg1.com',LX_Region__c='NE');
         Insert adminUser;
            
        system.runas(adminUser)
        {
    
        
//        Id courseRecordId = 
        RecordType courseRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Course__c' limit 1];
        RecordType classRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Class__c' limit 1];
        
        Course__c currentCourse = new Course__c();
        if(courseRecord!=null)
            currentCourse.RecordTypeId = courseRecord.id;
        insert currentCourse ;
          
        Class__c classinstant = new Class__c();
        classinstant.class_status__c = 'Available';
        classinstant.Class_Capacity__c = 10;
        classinstant.Class_Date__c = Date.today();
        classinstant.Course__c = currentCourse.id ;
        if(classRecord!=null)
            classinstant.RecordTypeId = classRecord.id;
        
        insert classinstant;


        Account acc = new Account();
        acc.name = 'name';
        acc.BillingCountry = 'USA';
        acc.Physical_Country__c = 'USA';
        insert acc;
      
        Contact c = new Contact();
        c.lastName = 'Name';
        //c.isPartner = true;
        c.Contact_Role__c = 'User';
        c.Region__c = 'NA';
        c.email = 'test@usersemail.com';
        c.accountid = acc.id;
        c.Lx_Lexmark_Vertical__c = 'Manufacturing';
        insert c;
      
        //one suer is needed in database for this test.
        Profile prof = [Select id from Profile where Name='System Administrator' limit 1];
        //List<UserRole> portalRoleList = [Select PortalType, PortalRole, Name, Id, ContactAccessForAccountOwner,
                                                             //CaseAccessForAccountOwner From UserRole Where PortalType = 'CustomerPortal' Limit 1];
        //UserRole role = [Select id from UserRole where Name='System Administrator' limit 1];
        User nu = new User(username='test@yser.com', email = 'test'+math.random()+'@lexmark.com', LastName='TestUser', Alias='TUas');
        //User nu = [Select id,username,email,LastName,Alias from User where profileId =: prof.id];
        // nu.ContactId = c.Id;
        nu.profileId = prof.Id;
        nu.TimeZoneSidKey = 'America/Los_Angeles';
        nu.LocaleSidKey = 'en_US';
        nu.EmailEncodingKey = 'UTF-8';
        nu.LanguageLocaleKey = 'en_US';
        nu.IsActive = true;   
        nu.LX_region__c='NE';   
        nu.legacy_company__c='Perceptive';
            nu.EmployeeNumber = '1234';
        insert nu;
                
        //User u = [Select id, contactId from User where ContactId =: c.Id limit 1];    
        ELearning_Registration__c reg1 = new ELearning_Registration__c(Applicant__c = nu.Id, Registration_Status__c = 'Completed');
        reg1.Class__c = classinstant.id;
        insert reg1;
        
        Training_Attendee__c attendee = new Training_Attendee__c();
        attendee.Contact__c = nu.ContactId;
        attendee.Registration__c = reg1.Id;
        attendee.Class__c = classinstant.Id;
        insert attendee;
            
        ApexPages.StandardController sc = new ApexPages.StandardController(classinstant); 
        ControllerClasses extensionstdController = new ControllerClasses(sc);  
        String emails = extensionstdController.getEmails();
        //System.Assert(emails != '') ;
        
        }
    }
}