@isTest(seealldata=True)
private class Test_SetAccountAndExpirationTrigger
{
 static testMethod void testTestData() 
 {

   Account aa = Data_Account.createAccount();
        
    Contact cc = new Contact();
    cc.LastName = 'Test Contact';
    cc.AccountId = aa.Id;
    cc.Default_Bill_To__c = true;
    cc.Contact_Role__c = 'User';
    cc.Email = 'Test@test.com';
    cc.Physical_Street_Address__c  = '33hrtshk';
    cc.Physical_City__c  = 'Shawnee';
    cc.Address_Edit_States__c  = 'Kansas';
    cc.Address_Edit_Countries__c  = 'US';
    cc.Region__c = 'NA';
    cc.FirstName = 'Test';
    cc.Phone = '874884738';
  cc.pse__Is_Resource__c = true;
    cc.Billing_Contact__c = true;
    insert cc;
  
  pse__Skill__c ps = new pse__Skill__c();
  ps.name = 'Test';
  ps.pse__Certification_Source__c = 'Salesforce.com';
  ps.pse__Description__c = 'dcff';
  ps.pse__Group__c = 'Salesforce.com';
  ps.pse__Skill_Or_Certification__c = 'Certification';
  ps.pse__Type__c = 'Technical';
  
  insert ps;  
    
    Test.STarttest();
    pse__Skill_Certification_Rating__c  sc = new pse__Skill_Certification_Rating__c ();
    sc.Account__c = aa.id;
    sc.pse__Resource__c = cc.id;
    sc.pse__Skill_Certification__c = ps.id;
    sc.Valid_Date__c = date.today();
    insert sc;
    Test.StopTest();
}}