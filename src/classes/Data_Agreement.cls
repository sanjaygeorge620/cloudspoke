@isTest
public with sharing class Data_Agreement {
  public static List<Agreement__c> createAgreements(String accountId,string oppId, List<Product_Model__c> productModels){
        List<Agreement__c> agreements = new List<Agreement__c>();
        Agreement__c agmnt;
        for(Product_Model__c pm : productModels ){
            agmnt = new Agreement__c (account__c = accountId);
            agreements.add(agmnt);
        }
        insert agreements;
        return agreements;
    }
    static testMethod void testTestData() {
        Account acc = Data_Account.createAccount();  
      String [] stageList = new List<String>();
      stageList.add('Negotiation');
      stageList.add('Negotiation');
      stageList.add('Negotiation');
    List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
          
       List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Agreement__c> agreementList = Data_Agreement.createAgreements(acc.Id, test_Opportunities[0].id,pmList);       
        System.assertEquals(agreementList.size(),1); 
   }  
}