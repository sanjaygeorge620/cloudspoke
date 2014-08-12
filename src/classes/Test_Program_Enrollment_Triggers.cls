/**
**Author : Kapil
**Date : 12/05/2013
**Objective: To test all enrollment triggers.
** 
**/

@isTest(seeAllData=true)
public class Test_Program_Enrollment_Triggers {
     
    static testMethod void myUnitTest() {
        //Global Program
        LX_Partner_Program__c globalPartnerProgram = new LX_Partner_Program__c();
        //globalPartnerProgram .RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Global Program').getRecordTypeId();
        globalPartnerProgram .RecordTypeId = LX_SetRecordIDs.GlobalProgram;
        globalPartnerProgram.Program_Status__c = 'Being Defined';
        globalPartnerProgram.Program_Level__c = 'Global Program (L1)';
        globalPartnerProgram.LX_Program_Type__c = 'ISS';
        globalPartnerProgram.LX_Start_Date__c = system.today();
        globalPartnerProgram.Program_End_Date__c = system.today() +200;
        insert globalPartnerProgram ;
        
        //Global Program Category
        LX_Partner_Program__c globalPartnerProgramCategory = new LX_Partner_Program__c();
        //globalPartnerProgramCategory.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Global ISS Program Category').getRecordTypeId();
        globalPartnerProgramCategory.RecordTypeId = LX_SetRecordIDs.GlobalISSProgramCategoryRTID;
        globalPartnerProgramCategory.Global_Program__c = globalPartnerProgram .id;
        globalPartnerProgramCategory.Program_Status__c = 'Being Defined';
        globalPartnerProgramCategory.Program_Level__c = 'Global Program Category (L2)';
        globalPartnerProgramCategory.LX_Program_Type__c = 'ISS';
        globalPartnerProgramCategory.LX_Start_Date__c = system.today();
        globalPartnerProgramCategory.Program_End_Date__c = system.today() +200;
        insert globalPartnerProgramCategory;
                
        //Local program
        LX_Partner_Program__c localPartnerProgram = new LX_Partner_Program__c();
        //localPartnerProgram.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Local ISS Program').getRecordTypeId();
        localPartnerProgram.RecordTypeId = LX_SetRecordIDs.LocalISSProgramRTID;
        localPartnerProgram.LX_Program_Enrolled__c = globalPartnerProgramCategory.id;
        localPartnerProgram.Program_Status__c = 'Being Defined';
        localPartnerProgram.Program_Level__c = 'Global Program Category (L3)';
        localPartnerProgram.LX_Program_Type__c = 'ISS';
        localPartnerProgram.LX_Start_Date__c = system.today();
        localPartnerProgram.Program_End_Date__c = system.today() +200;
        insert localPartnerProgram;        
                
        //Program Enrollment
        LX_program_Enrollment__c programEnrollment = new LX_program_Enrollment__c();
        //programEnrollment.RecordTypeId = Schema.SObjectType.LX_program_Enrollment__c.getRecordTypeInfosByName().get('ISS Program Enrollment').getRecordTypeId();
        programEnrollment.RecordTypeId = LX_SetRecordIDs.ISSPartnerEnrollment;
        programEnrollment.LX_Program_Type__c = 'ISS';
        programEnrollment.User__c = userInfo.getUserId();
        programEnrollment.LX_Account__c = data_account.createAccount3().id;
        programEnrollment.Master_Program__c = localPartnerProgram.id;
        programEnrollment.LX_Enrollment_Proposed_Date__c = system.today();
        programEnrollment.LX_Enrollment_Signed_Date__c = system.today();
        programEnrollment.LX_Enrollment_Effective_Date__c = system.today();
        programEnrollment.LX_Enrollment_End_Date__c = system.today()+30; 
        insert programEnrollment;              
        
        programEnrollment.LX_Apply_to_All_Reseller_Locations__c = true;
        programEnrollment.LX_Enrollment_Status__c = 'Active';
        programEnrollment.Approval_Status__c = 'Approved';
        update programEnrollment;
        
        programEnrollment.LX_Apply_to_All_Reseller_Locations__c = false;        
        update programEnrollment;
        
        delete programEnrollment;
        
    }   
    
    
    
    static testMethod void m1()
    {
        test.startTest();       
        Account mdmAcc1 = data_account.createMDMAccount();
        Account mdmAcc2 = data_account.createMDMAccount();
        Account Acc = Data_Account.createPartnerAccount();
        list<LX_Partner_Program__c> globalPrograms = Data_partnerProgram.createGlobalPrograms(1);
        list<LX_Partner_Program__c> globalProgramsCategory = Data_partnerProgram.createGlobalCategoryPrograms(1, globalPrograms[0]);
        list<LX_Partner_Program__c> localPrograms = Data_partnerProgram.createLocalISSPrograms(1, globalProgramsCategory[0]);       
        list<LX_Program_Enrollment__c> localProgramEnrollments = Data_programEnrollment.createISSEnrollments(Acc.id, localPrograms[0].id, 1);    
        
        localProgramEnrollments[0].LX_Apply_to_All_Reseller_Locations__c = true;
        localProgramEnrollments[0].LX_Enrollment_Status__c = 'Active';
        localProgramEnrollments[0].Approval_Status__c = 'Approved';
        update localProgramEnrollments[0];
        
        localProgramEnrollments[0].LX_Apply_to_All_Reseller_Locations__c = false;        
        update localProgramEnrollments[0];  
        
        delete localProgramEnrollments;        
        test.stopTest();            
    }    
    
    
}