@isTest
Public class Test_AccountTrigger{

 static void TestUnit1(){
     Test.StartTest();
     LX_AuditTrail__c cus_sett = new LX_AuditTrail__c(LX_API_Name__c ='Account_Status__c',LX_Field_Name__c = 'Account Status',LX_Object__c='Account');   
     insert cus_sett;
     Account acc= new account(Name='Sample', Account_Status__c='Suspect');
     insert acc;
     acc.Account_Status__c='Dormant';
     update acc;
     Test.StopTest();
 }

}