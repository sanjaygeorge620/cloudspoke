/* Class Name : LX_Test_UpdateLexVerticalTrigger
 * Description : This is a test class for LX_Contact_BI_BU trigger.
 * Created By : Ravi Kamma (Deloitte)
 * Created Date : 09-17-2014 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer               Date          Modification ID          Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Ravi Kamma           09-17-2014                              Initial Version
 */
@isTest(seealldata=true)
private class LX_Test_UpdateLexVerticalTrigger{

static testmethod void InsertLeadCheck(){
Lead ld = Data_Lead.CreateApprovalProcessLead('Ireland','OLA');
ld.SIC_Code__c ='7220301';
update ld;
}

}