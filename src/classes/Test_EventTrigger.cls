@isTest(seealldata=true)
Public class Test_EventTrigger{
 static testMethod void TestUnit1(){
     Test.StartTest();
     System.runas(new user(id=Userinfo.getuserid())){
         Account acc= new account(Name='Sample', Account_Status__c='Suspect',Physical_Country__c = 'USA',BillingCountry = 'USA', ownerid=Userinfo.getuserid());
         insert acc;
     
     Contact cnt = new contact(account = acc,Language__c ='English',Lastname='Test_contact',Phone='1234567890');
     insert cnt;
     
    system.debug('cnt-->'+cnt);
    System.debug('cnt.accountId-->'+cnt.accountId);
    System.debug('cnt.account-->'+cnt.account);
    System.debug('cnt.account.ID-->'+cnt.account.ID);
     Event evnt = new Event(subject='Test',Completed__c=true,Lx_Activity_Method__c='F2F',whoid=cnt.id,DurationInMinutes=15,ActivityDateTime=system.now(),Lx_Activity_Type__c='Sales Activity',Lx_Activity_Detail__c='Briefing',Lx_Technology_Topic__c='Color');
     insert evnt;
     Event evnt1 = new Event(subject='Test',Lx_Activity_Method__c='Phone',whoid=cnt.id,DurationInMinutes=15,ActivityDateTime=system.now(),Lx_Activity_Type__c='Sales Activity',Lx_Activity_Detail__c='Briefing',Lx_Technology_Topic__c='Color');
     insert evnt1;
     evnt1.Completed__c=true;
     update evnt1;
     Test.StopTest();
     }
 }

}