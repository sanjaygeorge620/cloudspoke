@isTest(seeAlldata=true)
private class TEST_ABSI_MassTaskController1 {
    static testMethod void myUnitTest() {
        Test.startTest();
        Account acc1 =Data_Account.createAccount3();
        Account acc2 = Data_Account.createAccount3();        
        
        
        List<Contact> contacts1 = Data_Contact.createContacts(acc1.Id,3);     
        List<Contact> contacts2 = Data_Contact.createContacts(acc2.Id,3);     
        
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
        PageReference pPageReference = Page.ABSI_Mass_Task_Action1;
        pPageReference.getParameters().put('objIds',acc1.Id+','+acc2.Id);
        pPageReference.getParameters().put('retUrl','');
        Test.setCurrentPage(pPageReference);
        
        ABSI_MassTaskController1 controler = new ABSI_MassTaskController1();
        
        controler.getTableDisplayNames();
        controler.saveNew();
        controler.save();
        controler.back();

        //Simulate the page for Who Id
        pPageReference = Page.ABSI_Mass_Task_Action1;
        pPageReference.getParameters().put('objIds',contacts1[0].Id+','+contacts2[0].Id);
        pPageReference.getParameters().put('retUrl','');
        Test.setCurrentPage(pPageReference);
        controler = new ABSI_MassTaskController1();
        
        controler.getTableDisplayNames();
        controler.getselReminderOptions();
        controler.saveNew();
        Pagereference pageRef = controler.save();
        
        controler.back();
        
        Account acc = data_account.createAccount10();
        List<LX_Offer_Enrollment__c> offerList = Data_Offer_Enrollment.createOfferEnrollments(acc,2); 

        pPageReference = Page.ABSI_Mass_Task_Action1;
        pPageReference.getParameters().put('objIds',offerList[0].Id+','+offerList[1].Id);
        pPageReference.getParameters().put('retUrl','');
        Test.setCurrentPage(pPageReference);
        controler = new ABSI_MassTaskController1();
        
        controler.getTableDisplayNames();
        controler.getselReminderOptions();
        controler.saveNew();
        Pagereference pageRef1 = controler.save();
        
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
        
        
        
        Test.stopTest();
    }
    
}