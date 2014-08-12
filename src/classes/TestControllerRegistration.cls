/**************************************************************************
Name    : TestControllerRegistration
Author  : Deepesh Makkar
Date    : 02 July, 2009
Usage   : used to Test ControllerRegistration.cls 

****************************************************************************/
@isTest
private class TestControllerRegistration {

    static testMethod void checkControllerRegistration() {
      setup();
      
      PageReference pageRef = Page.Registration;
      Test.setCurrentPage(pageRef);
      ApexPages.currentPage().getParameters().put('ClassID', '');
      ControllerRegistration controller = new ControllerRegistration();
      controller.getSelectedChapters();
      controller.getMyCompletedRegistrations();
      controller.getAvailableClasses();
      controller.getAllRegistrations();
      controller.getShowMyRegistrationRows();
      controller.viewChapter();
      controller.openChapter();
    }
    
    private static void setup() {
        Account acc = new Account();
        acc.name = 'name';
        acc.BillingCountry = 'USA';
        acc.Physical_Country__c='USA';
        insert acc;
      
        Contact c = new Contact();
        c.lastName = 'Name';
        c.Contact_Role__c = 'User';
        c.Region__c = 'NA';
        c.accountid = acc.id;
        c.phone='23453245';
        insert c;
      
      //one suer is needed in database for this test.
     // Profile prof = [Select id from Profile where Name like '%Portal%' limit 1];
      //UserRole role = [Select id from UserRole where Name='System Administrator' limit 1];
      Profile prof = [Select id from Profile where Name ='System Administrator' limit 1];
      User u = new User(username='test@yser123.com'+math.random(), email = 'test'+math.random()+'@lexmark.com', profileId = prof.Id, LastName='TestUser', Alias='TUspc');
      //u.ContactId = c.Id;
      u.TimeZoneSidKey = 'America/Chicago';
      u.LocaleSidKey = 'en_US';
      u.EmailEncodingKey = 'ISO-8859-1';
      u.LanguageLocaleKey = 'en_US';
      u.IsActive = true; 
      u.LX_Region__c='NE'; 
      u.legacy_company__c ='Perceptive';    
      insert u;
      
      //User newUser = [Select id from User where ContactId =: c.Id limit 1];
      
        List<ELearning_Registration__c> listELearnings = new List<ELearning_Registration__c>();
        ELearning_Registration__c reg1 = new ELearning_Registration__c(Applicant__c = u.Id, Registration_Status__c = 'Completed');
        ELearning_Registration__c reg2 = new ELearning_Registration__c(Applicant__c = u.Id, Registration_Status__c = 'Draft');
        listELearnings.add(reg1);
        listELearnings.add(reg2);
        insert listELearnings;
      
    }
    
   

    static testmethod void m1(){
           
            RecordType courseRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Course__c' limit 1];
            RecordType classRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Class__c' limit 1];
            
           
            
            Course__c currentCourse = new Course__c();
            currentCourse.RecordTypeId = courseRecord.id;
            insert currentCourse ;
            
            
            Class__c classinstant = new Class__c();
            classinstant.class_status__c = 'Available';
            classinstant.class_Date__c = Date.today();
            classinstant.Course__c = currentCourse.id ;
            classinstant.RecordTypeId = classRecord.id;
            insert classinstant;
             
            Class__c classinstant1 = new Class__c();
            classinstant1.class_status__c = 'Available';
            classinstant1.class_Date__c = Date.today();
            classinstant1.Course__c = currentCourse.id ;
            classinstant1.RecordTypeId = classRecord.id;
            insert classinstant1; 
            
            ELearning_Registration__c elearningRegistration = new ELearning_Registration__c();
            elearningRegistration.Applicant__c = UserInfo.getUserId();
            elearningRegistration.Registration_Status__c = 'Completed';
            elearningRegistration.class__c = classInstant.Id;             
            insert elearningRegistration; 
            
            
            
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
            
            ControllerRegistration cr = new ControllerRegistration ();
            ApexPages.CurrentPage().getParameters().put('ClassId',classinstant.Id);
            cr.getMyCompletedRegistrations();
            cr.getAvailableClasses();
            cr.getAllRegistrations();
            cr.getShowMyRegistrationRows();
            cr.viewChapter();
            cr.openChapter();
    }
    
     static testmethod void m2(){
           
            RecordType courseRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Course__c' limit 1];
            RecordType classRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Class__c' limit 1];
            
           
            
            Course__c currentCourse = new Course__c();
            currentCourse.RecordTypeId = courseRecord.id;
            insert currentCourse ;
            
            
            Class__c classinstant = new Class__c();
            classinstant.class_status__c = 'Available';
            classinstant.class_Date__c = Date.today();
            classinstant.Course__c = currentCourse.id ;
            classinstant.RecordTypeId = classRecord.id;
            insert classinstant;
             
            Class__c classinstant1 = new Class__c();
            classinstant1.class_status__c = 'Available';
            classinstant1.class_Date__c = Date.today();
            classinstant1.Course__c = currentCourse.id ;
            classinstant1.RecordTypeId = classRecord.id;
            insert classinstant1; 
            
            ELearning_Registration__c elearningRegistration = new ELearning_Registration__c();
            elearningRegistration.Applicant__c = UserInfo.getUserId();
        
            elearningRegistration.class__c = classInstant.Id;             
            insert elearningRegistration; 
            
            
            
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
            ApexPages.CurrentPage().getParameters().put('ClassId',classinstant.Id);
            ControllerRegistration cr = new ControllerRegistration ();
            cr.getMyCompletedRegistrations();
            cr.getAvailableClasses();
            cr.getAllRegistrations();
            cr.getShowMyRegistrationRows();
            cr.viewChapter();
            cr.openChapter();
    }


}