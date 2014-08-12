@isTest(SeeAllData=true)
private class Test_UpdateLeadFields {

    static testMethod void myUnitTest() {
              Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');   
      Lead newLead = Data_Lead.createLeads(pCam.id);   
      
      newLead.areas_of_need__c = 'Content';
      newLead.Legacy_Company_Originator__c = 'Brainware';

      
      update newLead;
      
      
      Lead areaOfInterest=[SELECT account_Area_of_Interest_s__c, contact_Legacy_company_originator__c
      , Opportunity_Area_Of_Interest__c, Opportunity_Legacy_Company_Originator__c FROM Lead where id= :newLead.id];


     
/*      system.assertEquals(areaOfInterest.account_Area_of_Interest_s__c, 'Content');
      system.assertEquals(areaOfInterest.contact_Legacy_Company_Originator__c, 'Brainware');
      system.assertEquals(areaOfInterest.opportunity_Legacy_Company_Originator__c, 'Brainware');
      system.assertEquals(areaOfInterest.opportunity_Area_of_Interest__c, 'Content');*/


     
      
    }
}