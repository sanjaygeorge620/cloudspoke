@isTest
private class TestUpdateOpp
{
 static testMethod void testTestData() 
 {
/*Profile p = [SELECT Id FROM Profile WHERE Name='Marketing']; 
      User u = new User(Alias = 'mark', Email='standardmarkuser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Markuser', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standardmarkuser@testorg.com');


      System.runAs(u) {*/
   Account aa = Data_Account.createAccount();
    
    aa.Interested_Parties__c = 'Lexmark';
    aa.LX_Sales_Team_Assigned__c = 'Federal';
    update aa;
        
    Contact cc = new Contact();
    cc.LastName = 'Test Contact';
    cc.AccountId = aa.Id;
    cc.Default_Bill_To__c = true;
    cc.Contact_Role__c = 'User';
    cc.email = 'abc@abc.com';
    cc.phone = '+1 222 222 2222';
    cc.Lx_Lexmark_Vertical__c = 'Federal';
    insert cc;
  RecordType rr1 = [select id,name from RecordType where name = 'Expansion-Add On' and sObjectType = 'Opportunity'];
    
    Test.STarttest();
    Opportunity oo = new Opportunity();
    oo.Technology__c = true;
    oo.LX_Sales_Type__c = 'Add On';
    oo.Name = 'Test Opp';
    oo.AccountId = aa.Id;
    oo.Sector__c = 'Federal';
    oo.CloseDate = System.today() +  365;
    oo.Amount = 50000;
    oo.StageName = 'Validation';
    oo.Partner_Referral_Fee_Applicable__c = 'CGS'; 
    oo.RecordTypeId = rr1.Id;
    insert oo;
    Test.StopTest();
}}
//}