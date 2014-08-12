@isTest
private class SitesTrainingRegistrationController_Test {
//-------------------------------------------------------------------------------
// TEST SitesTrainingRegistrationController - Completed
//-------------------------------------------------------------------------------

//public static user us = SitesTestSetup.testRunAs();

        static testMethod void testSitesTrainingRegistrationController() {
        
            Account acc = Data_Account.createAccount();
            acc.recordtypeid = LX_SetRecordIDs.AccountPartnerLockedRecordTypeId;
            update acc;
            
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
            
            Profile adminProfile = [select id from profile where name = 'Perceptive Channel Portal Admin' limit 1]; 
            User adminUser = new User(alias = 'stz', email='cstandarduser@lexmark.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = adminProfile.Id, Legacy_Company__c='Lexmark', 
            timezonesidkey='America/Los_Angeles', username='sqqqtandarduser@testorg1.com',LX_Region__c='NE',contactid = contacts[0].id);
            Insert adminUser;
            
            system.runas(adminUser){ 
            
                test.StartTest();
                
                Course__c newCourse= new Course__c(name='SitesControllerTest.course');
                insert newCourse;
                
                class__c test_class = new class__c(Course__c=newCourse.id);
                insert test_class;
                
                Legal_Term__c l = new Legal_Term__c ();
                l.Public__c =true;
                l.Type__c = 'Training Registration';
                insert l;
                
                Test.setCurrentPageReference(new PageReference('Page.registration_class'));
                ApexPages.currentPage().getParameters().put('id', test_class.id);
                SitesTrainingRegistrationController  controller = new SitesTrainingRegistrationController();
                system.assertEquals(controller.getClass().id, test_class.id);           
                
                controller.addATTENDEE();
                controller.submitEnrollment();
                controller.step1();
                controller.step2();
                system.assertequals(ApexPages.currentPage().getParameters().get('id'),test_class.id);
                test.StopTest();
            }
    }
            
            static testMethod void testSitesTrainingRegistrationController1() {
            
            Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
            User adminUser = new User(alias = 'stz', email='cstandarduser@lexmark.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = adminProfile.Id, Legacy_Company__c='Lexmark', 
            timezonesidkey='America/Los_Angeles', username='sqqqtandarduser@testorg1.com',LX_Region__c='NE');
            Insert adminUser;
            
            system.runas(adminUser)
            { 
            test.StartTest();
            
            Course__c newCourse= new Course__c(name='SitesControllerTest.course');
            insert newCourse;
            
            class__c test_class = new class__c(Course__c=newCourse.id);
            insert test_class;
            
            //class__c test_class = [select id from class__c where Course__r.name='SitesControllerTest.course' limit 1];
            Test.setCurrentPageReference(new PageReference('Page.registration_class'));
            ApexPages.currentPage().getParameters().put('id', test_class.id);
            SitesTrainingRegistrationController  controller = new SitesTrainingRegistrationController();
            system.assertEquals(controller.getClass().id, test_class.id);           
            
            controller.addATTENDEE();
            
            //needs data
            controller.submitEnrollment();
            
            controller.step1();
            system.assertequals(ApexPages.currentPage().getParameters().get('id'),test_class.id);
            
            test.StopTest();
            
            } 
        }
}