@isTest
private class Test_UpdateSalesOrganizationFromAccount 
{

    static testMethod void testUpdateSalesOrganization() 
    {
    
      Account acc = Data_Account.createAccount();   
      acc.type = 'Partner-Channel Level 1';
  update acc;
    
      String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
     
      
        List<Opportunity> oppList = Data_Opportunity.createOpportunity(stageList, 1);
        
        for (Opportunity OppRec : oppList)
        {
            
        }
        Test.startTest();
        Set<String> oppIdSet = new Set<String>();
        List<String> accIdSet = new List<String>();
        for(Integer i =0;i<oppList.size();i++){
            oppIdSet.add(oppList[i].id);
            accIdSet.add(oppList[i].accountid);
        }
        
        List<Account> accs = [select id, coverage_ID__r.sales_Organization__c from Account where id in :accIdSet];

        
        List<Sales_Organization__c> salesOrgs = [select id from Sales_Organization__c where id = :accs[0].coverage_ID__r.sales_Organization__c];
        
        
        for(Opportunity opp1 : [select Id,Account.Coverage_ID__r.Sales_Organization__c,AccountId from Opportunity where id in : oppIdSet ])
        {
            if(opp1.AccountId == accIdSet.get(0))
            {
                //System.assertEquals(opp1.Account.Coverage_ID__r.Sales_Organization__c,salesOrgs[0].id);
            }
        }
         for (Opportunity OppRec : oppList)
        {
          oppRec.Primary_Partner__c = acc.id;
        }
        
        update opplist;
         Test.stoptest();
    }
    
    
}