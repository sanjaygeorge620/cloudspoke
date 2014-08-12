/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 
  /******************************************************
 * Description      : Test Coverage for ABSI_MassTaskController (98%)
 * @author          : Malaka Silva
 * @since           : May 07, 2010  
 * Copyright 2010 ABSI. All rights reserved. 
 ******************************************************/
@isTest
private class ABSI_TEST_MassTaskController {

    static testMethod void myUnitTest() {
        Test.startTest();
        
        //Create Accounts
        Account account1 = new Account();
        account1.Name = 'Test_Account_01';
        account1.BillingCountry = 'USA';
        account1.Physical_Country__c='USA';
        insert account1;
        
        Account account2 = new Account();
        account2.Name = 'Test_Account_02';
        account2.BillingCountry = 'USA';
        account2.Physical_Country__c='USA';
        insert account2;        
        
        //Create Contacts
        Contact contact1 = new Contact();
        contact1.LastName = 'Test_Contact_01';
        contact1.Email='abc1@lexmark.com';
        insert contact1;
        
        Contact contact2 = new Contact();
        contact2.LastName = 'Test_Contact_01';
        contact2.Email='abc2@lexmark.com';
        insert contact2;
        
        //Get a profile from SFDC
        Profile profile = [select Id from Profile limit 1];
        
        //Create a user
        User user = new User();
        user.Username = 'Test_user_name@test.com';
        user.LastName = 'Test_last_name';
        user.ProfileId = profile.Id;
        user.Alias = 'tst';
        user.Email = 'Test_email@lexmark.com';
        user.CommunityNickname = 'Test_nick_name';
        user.TimeZoneSidKey = 'GMT';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Legacy_Company__c= 'ISYS';
        insert user;
        
        //Simulate the page for What Id
        PageReference pPageReference = Page.ABSI_Mass_Task_Action;
        pPageReference.getParameters().put('objIds',account1.Id+','+account2.Id);
        pPageReference.getParameters().put('retUrl','');
        Test.setCurrentPage(pPageReference);
        
        ABSI_MassTaskController controler = new ABSI_MassTaskController();
        System.assertEquals(controler.showWhoId, true);
        controler.getTableDisplayNames();
        controler.saveNew();
        controler.save();
        controler.back();

        //Simulate the page for Who Id
        pPageReference = Page.ABSI_Mass_Task_Action;
        pPageReference.getParameters().put('objIds',contact1.Id+','+contact2.Id);
        pPageReference.getParameters().put('retUrl','');
        Test.setCurrentPage(pPageReference);
        controler = new ABSI_MassTaskController();
        System.assertEquals(controler.showWhoId, false);
        controler.getTableDisplayNames();
        controler.getselReminderOptions();
        controler.saveNew();
        Pagereference pageRef = controler.save();
        //System.assertEquals(pageRef, null);
        controler.back();
        
        controler.task.OwnerId = user.Id;
        controler.task.Subject = 'Test_Subject';
        controler.task.Status = 'Completed';
        controler.task.Priority = 'High';
        //Set the reminder
        controler.task.IsReminderSet = true;
        controler.contact.Birthdate = Date.today();
        controler.reminderTime = '23:30';
        //Send Email notification
        controler.sendNotificationEmailCheckBox = true;
        
        controler.saveNew();
        pageRef = controler.save();
        System.assertNotEquals(pageRef, null);
        
        Test.stopTest();
    }
}