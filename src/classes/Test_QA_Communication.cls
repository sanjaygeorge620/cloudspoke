/**********************************************************************************************
Name : TestTriggerUpdateCSA
Purpose : gives test coverage for UpdateCSA
author : Mike Fitzgerald
Date : September 2010
************************************************************************************************/
@isTest
Private class Test_QA_Communication {
    @isTest
    static void Test_QA_Communication() {
      
      Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
    User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                  localesidkey='en_US', profileid = adminProfile.Id, 
                  timezonesidkey='America/Los_Angeles', username='standqazxswarduser@testorgsss1.com',LX_Region__c = 'NE',Legacy_Company__c = 'Acuo');
    Insert adminUser; 
     Account myAccount = null;
     Contact myContact = null;
    system.runas(adminUser)
    {
        // Insert Account
        //Account myAccount = new Account(Name='Test Company',Address_Edit_States__c='ks');
        //insert myAccount;
         myAccount = Data_Account.createAccount();   
         
             
     // Insert Contact
         myContact = new Contact(accountid=myAccount.id, FirstName='John', LastName='Doe', email='test@perceptivesoftware.com',Contact_Role__c='User',Lx_Lexmark_Vertical__c = 'Manufacturing');
         insert myContact;
    
    }
    
    // Query Portal Profile    
        Profile p2 = [select id from profile where name like 'Perceptive Customer Portal%' limit 1]; 
        
        //UserRole usrrole = new UserRole(Name = myContact.Name);
        //insert usrrole;
    // Insert Portal User
       // User myUser2 = new User(alias = 'stand2', Contactid=myContact.id, email='MichaelJordan2@testorg.com.test', 
           // emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US', 
            //localesidkey='en_US', profileid = p2.Id, 
            //timezonesidkey='America/Los_Angeles', username='standarduser2@testorg.com',UserRoleId = usrrole.Id);
        // insert myuser2; 
         
    // Query Support Profile         
        Profile p1 = [select id from profile where name like 'System Administrator' limit 1]; 
    
    // Insert Internal User
        User myUser1 = new User(alias = 'stand1', email='MichaelJordan1@lexmark.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p1.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser110310@testorg.com',LX_Region__c = 'NE',Legacy_Company__c = 'Acuo');
         insert myuser1;   

                  
    //Add Case
        Case c = new Case();
        c.Subject = 'Test Title';
        c.Description = 'test Description';
        c.Accountid = MyAccount.id;
        c.Contactid = MyContact.id;
        c.ownerid=myUser1.id;
        c.Secondary_Case_Owner__c=myUser1.id;
        c.Leadership_Case_Owner__c=myUser1.id;
        c.RD_StakeHolder_1__c=myUser1.id;
        c.RD_StakeHolder_2__c=myUser1.id;
        c.RD_StakeHolder_3__c=myUser1.id;
        insert c;
    
    List<QA_Communication__c> Comms = new List<QA_Communication__c>();
    for(Integer i = 0; i < 10; i++){
        QA_Communication__c QA = new QA_Communication__c(Name = 'Test Title ' + i,Case__c = c.id,Description__c = 'test Description');
        Comms.add(QA);
    }
    
    //Send out 10 emails
    System.runAs(myUser1){
        test.startTest();
            insert comms;
        test.stopTest();
    }    
    
  
    
    /***********************
    *    assert records      *
    ***********************/
    
    List<QA_Communication__c> X =[select q.id from QA_Communication__c q where q.Case__c = :c.id];
    system.debug('FITZ myEMInvokes:'+Limits.getEmailInvocations()); 
    system.debug('FITZ myEMLimit :'+Limits.getLimitEmailInvocations() ); 
    //system.assertEquals(X.Size(),10);
    }
}