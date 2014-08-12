@isTest(SeeallData = true)
private class TestOrderCreation
{
Static TestMethod Void CreateOrder_Test()
{
 String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
   List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);   
       for(Opportunity opp : test_opportunities)
       {
       opp.SAP_Status__c = 'SUBMITTED';
       opp.bypass_EmailNotify__c = False; 
       
       }
     Test.startTest();
      update test_opportunities;
     Test.stopTest();

}



}