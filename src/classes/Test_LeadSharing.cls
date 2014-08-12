@isTest
private class Test_LeadSharing {
	public static Schema.DescribeSObjectResult des1 = Schema.SObjectType.Account; 
	public static Map<String,Schema.RecordTypeInfo> rtMap1 = des1.getRecordTypeInfosByName();
    static testMethod void myUnitTest() {
                    

            Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');   
            Lead newLead = Data_Lead.createLeads(pCam.id);        
            Account acc = Data_Account.createAccount(); 
            Id MRrtacctId = rtMap1.get('Location Partner').getRecordTypeId();  
            acc.RecordTypeID = MRrtacctId;
            update acc;
            
            newLead.Primary_Partner__c = acc.id;
            update newLead;
            
    }
}