@isTest(Seealldata = true)
private class Test_UpdateOppFields {

    static testMethod void myUnitTest() {
            String [] stageList = new List<String>();
            stageList.add('Negotiation');

              List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);  
              

            Map<ID, Account> OppAccountMap = new Map<ID, Account> ();    
            List<Account> OppAccounts = new List<Account>([select area_of_interest_s__c, Legacy_Company_Originator__c from Account where ID = :test_Opportunities[0].id]);
            for (Account accRec : OppAccounts){
                OppAccountMap.put(accRec.id, AccRec);
                AccRec.Area_of_Interest_s__c = 'Content';
                AccRec.Legacy_Company_Originator__c = 'Pallas Athena';
             }
             
             update OppAccounts;
   
            Test_Opportunities[0].Special_Notes__c = 'test';
            Test_Opportunities[0]. Area_of_Interest_s__c = '';
            Test_Opportunities[0].Legacy_Company_Originator__c = '';
            
            update test_opportunities;
            Opportunity TestOpportunities=[SELECT Area_of_Interest_s__c, Legacy_Company_Originator__c  FROM Opportunity where id= :test_opportunities[0].id];
            system.debug('Test Opps: ' + TestOpportunities);
            
           // system.assertEquals(TestOpportunities.Area_of_Interest_s__c, null);
          //  system.assertEquals(TestOpportunities.Legacy_Company_Originator__c, null);
            
    
              
  
    }
}