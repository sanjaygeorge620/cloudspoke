/**
 * Name: Test_FlexeraEntitlements_CreateCase
 *
 * Description: to provide code coverage for FlexeraEntitlements_CreateCase class
 * Created By: Manoj Kolli
 * Created Date: 4/23/2012
 */
@isTest(seeAllData=true)
public class Test_FlexeraEntitlements_CreateCase{

    Public static testMethod void Test_FlexeraEntitlements_CreateCase() {
      
      Test.startTest();
      Account acc = Data_Account.createAccount();
      Server__c s= new Server__c(Name = acc.Name,Status__c='Active',Server_Name__c='T2',Account__c=acc.Id);
      insert s;
      Asset a = new Asset(Name = 'TestAsset0',AccountId = acc.Id,server__c = s.Id);
      insert a;
      Asset_Item__c ai = new Asset_Item__c(Name = 'TestAssetItem0', Asset__c = a.Id , Quantity__c = 10 );
      insert ai;
      String errormesg = 'Didnot created New FLEXERA Entitlement Items for Asset Item since the account name is not matched';
      List<Case> CasestoInsert = new List<Case>();
      FlexeraEntitlements_CreateCase.FlexeraEntitlements_CreateCase(ai,errormesg,CasestoInsert);
      Test.stopTest();
    
    }
 }