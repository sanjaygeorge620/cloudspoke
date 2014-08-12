/*************************************************************************************
Name : TestUpdateHasSolutionOfOppTrigger
Created By : Jyoti Singh(Appirio Offshore)
Created Date : 20th dec , 2012
Description : -Test class for coverage of trigger UpdateHasSolutionOfOpp
*************************************************************************************/
@isTest(SeeallData = true)
Private Class TestUpdateHasSolutionOfOppTrigger{
    @isTest
    static void testUpdateHasSolutionOfOppTrigger1 (){
        Account acnt = Data_Account.createAccount();
        system.assertNotEquals(acnt.Id , null);
                        
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);       
        Solution_Business_Process__c solProcess = new Solution_Business_Process__c();
        solProcess.Solution_Status__c = 'Sold';
        solProcess.Sector__c = 'State/Local';
        solProcess.Account__c = acnt.Id;
        solProcess.Opportunity__c = test_opportunities.get(0).Id;   
        test.starttest();    
        insert solProcess;
        solProcess.Solution_Status__c = 'Lost';
        update solProcess;       
        delete solProcess;        
        test.stoptest();        
        }
    
}