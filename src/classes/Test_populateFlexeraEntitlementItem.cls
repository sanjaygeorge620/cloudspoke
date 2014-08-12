/**
 * Name: Test_populateFlexeraEntitlementItem
 *
 * Description: to provide code coverage for populateFlexeraEntitlementItem Trigger
 * Created By: Manoj Kolli
 * Created Date: 4/18/2012
 */
@isTest(seeAllData=true)
public class Test_populateFlexeraEntitlementItem{

    Public static testMethod void Test_populateFlexeraEntitlementItem() {
      
      Test.startTest();
      Account acc = Data_Account.createAccount();
      Server__c s= new Server__c(Name = acc.Name,Status__c='Active',Server_Name__c='T2',Account__c=acc.Id);
      insert s;
      Asset a = new Asset(Name = 'TestAsset0',AccountId = acc.Id,server__c = s.Id);
      insert a;
      
            
      Asset_Item__c ai = new Asset_Item__c(Name = 'TestAssetItem0', Asset__c = a.Id , Quantity__c = 10 );
      insert ai;
      Flexera_Entitlement__c fe = new Flexera_Entitlement__c(Account_Name2__c=acc.Name,Order_ID__c='12345',Order_Date__c= Date.Today());
      insert fe;
      
      ai.Quantity__c = 15;
      update ai;
      ai.Quantity__c = 20;
      update ai;
      
      delete ai;
      
         Test.stopTest();
    }
}