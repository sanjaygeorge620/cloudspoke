@isTest(SeeAllData=true)
public class Test_LX_SeedOrderAutopopulate_BI_BU{

 public static testMethod void testEvaluationUnit(){
    //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       Account acc = Data_Account.createAccount3();
       acc.ParentId = acc1.id;
       acc.RecordTypeID = accRecordType;
      update acc;
       Id accRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
       Account acc2 = Data_Account.createAccount3();
       acc2.ParentId = acc1.id;
       acc2.RecordTypeID = accRecordType1;
       acc2.BillingStreet = 'test';
       acc2.BillingCity = 'test';
       acc2.BillingState = 'test';
       acc2.BillingPostalCode = '46789';
       acc2.BillingCountry = 'Test';
       acc2.Physical_Country__c ='Test';
       update acc2;
       
       LX_Seed_Order_Request__c eval = new LX_Seed_Order_Request__c(LX_Account__c=acc2.Id);
       insert eval;
 }
}