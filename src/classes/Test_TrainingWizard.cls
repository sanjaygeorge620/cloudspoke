@isTest(SeeallData = true)
public class Test_TrainingWizard
{
    Public static TestMethod void TrainingWizardController() {
String str = Lx_SetRecordIDs__c.getInstance('L1GlobalAccountRecordName').Value__c;
system.debug('str  == '+str );
    Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
    User adminUser = new User(alias = 'standt41', email='cstandarduser@lexmark.com', 
                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                  localesidkey='en_US', profileid = adminProfile.Id, 
                  timezonesidkey='America/Los_Angeles',LX_Region__c='NE', username='standarduser'+math.random()+'@testorg1.com',Legacy_Company__c = 'Lexmark');
    Insert adminUser;
    Account aNew = null;
    Contact cNew = null;
    User MyUser = null;
    system.runas(adminUser)
    {
      // Insert Account
      aNew = new Account(Name='Test Company',Physical_Country__c = 'USA', BillingCountry = 'USA');
      insert aNew;
      system.debug('Account: ' +aNew.ID + ' Name: ' + aNew.Name);  

      // Insert Contact
      cNew = new Contact(accountid=aNew.id, FirstName='John', LastName='Doe',phone='123123');
      insert cNew;
      system.debug('Contact: ' +cNew.ID + ' Name: ' + cNew.Name);  
      
      Profile p = [select id from profile where name = 'Customer Portal Manager Custom' limit 1];
      Profile prof = [select id from profile where name = 'System Administrator' limit 1];
      //UserRole objUser = [Select PortalType, PortalRole, Name, Id, ContactAccessForAccountOwner,
       //                                                      CaseAccessForAccountOwner From UserRole Where PortalType = 'CustomerPortal' Limit 1];
      // // Insert User
      
        MyUser = new User(alias = 'standt', Contactid=cNew.id, email='cstandarduser@lexmark.com', 
                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                  localesidkey='en_US', profileid = prof.Id,LX_region__c='NE',
                  timezonesidkey='America/Los_Angeles', username='standarduser@testorg.com');
      //Insert MyUser;
    }
    System.runAs(adminUser) {

    course__c course = new course__c(name='Course Name');
    insert course;

    Class__c Cempty = new Class__c(course__c=course.id, Class_Capacity__c =10000);
    insert Cempty;

    Class__c Cfull = new Class__c(course__c=course.id, Class_Capacity__c =0);
    insert Cfull;

    Test.setCurrentPageReference(new PageReference('Page.Training_Wizard_1'));
    ApexPages.currentPage().getParameters().put('id', cEmpty.id);
    ApexPages.Standardcontroller sc = New ApexPages.StandardController(cEmpty);
    TrainingWizardController controller01 = New TrainingWizardController(sc);

    Test.startTest();
    system.debug('MJF TRAINING User: ' +MyUser.ID + ' Name: ' + MyUser.lastname);

    controller01.getRegistrationData();
    controller01.step1();
    controller01.step2();
    controller01.addrow();
    controller01.enroll();
    controller01.MyRegistrations();
    ApexPages.currentPage().getParameters().put('id', cFull.id);
    ApexPages.Standardcontroller sc2 = New ApexPages.StandardController(cFull);
    TrainingWizardController controller02 = New TrainingWizardController(sc2);
    system.debug('TRAINING User: ' +MyUser.ID + ' Name: ' + MyUser.lastname);
    controller02.getRegistrationData();
    controller02.step1();
    controller02.step2();
    controller02.addrow();
    controller02.enroll();
    controller02.MyRegistrations();
    Test.stopTest();    
    }       
 }                      


}