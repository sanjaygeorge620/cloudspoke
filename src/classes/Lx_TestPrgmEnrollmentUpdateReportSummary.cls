/**
**Author : Mayank Agarwal
**Date : 12/05/2013
**Objective: Test class to cover LX_ProgramEnrollment_UpdateReportSummary
** 
**
**/
@isTest(SeeAllData = true)
public class Lx_TestPrgmEnrollmentUpdateReportSummary{
    static Integer TOTAL_RECORDS_WITH_ACCOUNT = 2;
    static Integer TOTAL_PARTNER_PROGRAMS = 1;
    static testmethod void ProgramEnrollment(){
    
         List<Contact> cntctRecords = new List<Contact> ();
         List<LX_Program_Enrollment__c> enrollmentRecords = new List<LX_Program_Enrollment__c> ();
         List<LX_Partner_Program__c> programRecord  = new List<LX_Partner_Program__c> ();
         
         programRecord = Data_partnerProgram.createPartnerProgram(TOTAL_PARTNER_PROGRAMS);
         Account accRecord = Data_Account.createPartnerAccount();
         
         cntctRecords =  Data_Contact.createContacts(accRecord.Id, TOTAL_RECORDS_WITH_ACCOUNT);
         enrollmentRecords = Data_programEnrollment.createEnrollment(accRecord.Id, programRecord[0].id, TOTAL_RECORDS_WITH_ACCOUNT); 
          
    }
}//End of class