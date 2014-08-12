/*************************************************************************************
Name : TestAssignCurrencyAndOwner
Created By : Reena Acharya(Appirio Offshore)
Created Date : 15th May , 2012
Description : -Test class for coverage of trigger AssignCurrencyAndOwner
*************************************************************************************/
@isTest(SeeallData = true)
Private Class TestAssignCurrencyAndOwner{
    @isTest
    static void testAssignCurrencyAndOwner (){
        Account acnt = Data_Account.createAccount();
        system.assertNotEquals(acnt.Id , null);
                        
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);       
       
        Qualification__c qualification = new Qualification__c (Opportunity__c = test_opportunities.get(0).Id );
        insert qualification;
        system.assertNotEquals(qualification.Id , null);
        
        test_opportunities = [Select id,Owner.Name from Opportunity where id =: test_opportunities.get(0).Id];
        acnt = [Select id,CurrencyIsoCode from Account where id =: acnt.Id];
        
        qualification = [Select id ,Opportunity_Owner__c ,CurrencyIsoCode from qualification__c where id =: qualification.ID];
        
      //  system.assertEquals(qualification.Opportunity_Owner__c , test_opportunities.get(0).Owner.Name);
      //  system.assertEquals(qualification.CurrencyIsoCode , acnt.CurrencyIsoCode  );
        
    }
}