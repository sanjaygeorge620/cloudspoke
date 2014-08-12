@isTest(Seealldata = true)
private class test_UpdateOpporunity
{
Static testMethod void testExecute()
{
 String [] stageList = new List<String>();
            stageList.add('Negotiation');
            
Opportunity opp = Data_Opportunity.createOpportunity(stageList, 1)[0];       
system.debug('OPPORTUNITY ID--' +opp.ID);

order__c ord = new order__c(Opportunity__c = opp.id);

insert ord;

ord.Partner_Next_Steps__c = 'testing next steps';
ord.Status__c = true;
update ord;

}




}