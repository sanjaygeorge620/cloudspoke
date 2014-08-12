@isTest
private class Test_GenerateThreadID {
//-------------------------------------------------------------------------------
// TEST SitesController - COMPLETED
//-------------------------------------------------------------------------------
         static testMethod void Test_GenerateThreadID() {
        
        //[First 4 digits of the OrganizationID followed by all digits after the last zero].[First 4 digits of the CaseID followed by all digits after the last zero]
		//	Thread ID = 00DXased23.00a4DDs2
        	string orgID = '00DQ00000005NRX';
        	string caseID = '500Q0000003Qz68';
        	string threadID = generateThreadID.generateThreadID(orgID,caseID);
        	system.assertEquals('00DQ5.500Q3Q', threadID);
        //	 system.assertequals(a.pse__Status__c,'Closed');       
        	
         }
}