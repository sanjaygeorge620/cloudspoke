@isTest(seealldata=true)

public class LX_Test_LX_OpportunityLineItem_BD
{

public static testMethod void deleteLineItem(){

    Account testAcc = new Account();
    testAcc = Data_Account.createAccount();
    List<OpportunityLineItem> testOppLineList = new List<OpportunityLineItem>();
    testOppLineList = [Select id,PricebookEntry.Product2.Replicate_Full_Environment__c,PricebookEntry.Product2.Core_Product__c,
    PricebookEntry.Product2Id,Opportunity.AccountId,OpportunityId,PricebookEntry.Product2.Product_Model__r.Asset_Required__c,
    PricebookEntry.Product2.SMSA_Product__c,PricebookEntry.Product2.Product_Model__r.Name,Opportunity.Account.Name,
    PricebookEntry.Product2.Parent_Product__r.Product_Model__r.Name,PricebookEntry.Product2.Environment__c,
    PricebookEntry.Product2.Test_Environments_Needed__c,PricebookEntry.Product2.Failover_Environments_Needed__c,
    PricebookEntry.Product2.Exclude_from_Test_Clone__c,PricebookEntry.Product2.Test_Environments_Allowed__c,
    PricebookEntry.Product2.Failover_Environments_Allowed__c
    from OpportunityLineItem
    where Opportunity.Account.RecordType.Name = 'Location Customer'
    limit 1];
    test.starttest();
    delete testOppLineList ;
    test.stoptest();   
   }
   
 }