@isTest(SeeAllData=true)

class LX_Test_SchedContactBirthday {

   static testmethod void testContactBirthday() {
      Test.startTest();
      Id oRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
      Account oAcct = new Account(name='Test Account',Industry='Retail',Industry_Subtype__c='Hospitality', RecordTypeId=oRecordTypeId,BillingCountry = 'USA',Physical_Country__c='USA');
      insert oAcct;
      oRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Business Contact').getRecordTypeId();
      Contact oCon = new Contact(FirstName='Test',LastName='Contact',AccountId=oAcct.Id,RecordTypeId=oRecordTypeId,Birthdate=Date.today(),Email='tester@test.com');
      insert oCon;
      
      
   // Schedule the test job

      String jobId = System.schedule('Test SchedContactBirthday','0 0 8 * * ?', new LX_SchedContactBirthday());
   // Get the information from the CronTrigger API object

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same
      System.assertEquals('0 0 8 * * ?',ct.CronExpression);

   // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

   // Verify the next time the job will run
    //  System.assertEquals('2022-09-03 00:00:00',String.valueOf(ct.NextFireTime));
     // System.assertNotEquals('testScheduledApexFromTestMethodUpdated',[SELECT id, name FROM account WHERE id = :a.id].name);

      Test.stopTest();

      //System.assertEquals('testScheduledApexFromTestMethodUpdated',[SELECT Id, Name FROM Account WHERE Id = :a.Id].Name);

   }
}