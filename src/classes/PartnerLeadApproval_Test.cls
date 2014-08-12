@isTest(seeAlldata=true)
private class PartnerLeadApproval_Test {

/*Description:This is the test method written to test PartnerLeadApproval by passing test data for Lead object.
*Param:None
*Returns:VOID
*/ 
    static testmethod void m1(){
    Account accnt = Data_Account.createAccount3();
    accnt.Type = 'Partner';
    accnt.ISS_Coverage_Model__c ='Channel';
    update accnt;
    Campaign pCam=Data_Campaign.createCampaign('Parent Campaign', '');
    Lead leadTemp=Data_Lead.createLeads(pCam.id);
    
    RecordType rec = [Select id from RecordType where sobjectType='Lead' and name='Unlocked']; 
         
    leadTemp.RecordTypeID = rec.id;
    leadTemp.Primary_Partner__c = accnt.Id;
    leadTemp.Partner_Approved__c=null;
    Test.startTest();
    update leadTemp;
    Test.stopTest();
    }
}