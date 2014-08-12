/**
**Author : Mayank Agarwal
**Date : 12/05/2013
**Objective: To create partner program data
** 
**
**/
@istest(seeAllData = true)
public class Data_partnerProgram{
    public static List<LX_Partner_Program__c> createPartnerProgram(Integer noOfRecords){
        List<LX_Partner_Program__c> ppRecordsList = new List<LX_Partner_Program__c> ();
        LX_Partner_Program__c ppRecord;
        Integer i;
        for(i=0 ; i < noOfRecords; i++){
            ppRecord = new LX_Partner_Program__c ();
            //Program name
            ppRecord .Name = 'testPartnerProgram' + i; 
            //Program Hierarchy
            ppRecord .Program_Level__c = 'Global Program (L1)'; 
            //Program Division
            ppRecord .LX_Program_Type__c = 'PSW'; 
            //Program status
            ppRecord .Program_Status__c = 'Active';
            
            //Add the record in the partner program list
            ppRecordsList.add(ppRecord);
        }//end of for loop
        Insert ppRecordsList;
        
        return ppRecordsList;
    }//End of testMethod createEnrollment
    
    
    public static list<LX_Partner_Program__c> createLocalISSPrograms(integer size,LX_Partner_Program__c globalPartnerProgramCategory){
        list<lx_partner_program__c> localPartnerPrograms = new list<LX_partner_program__c>();
        //Local program
        LX_Partner_Program__c localPartnerProgram ;
        //localPartnerProgram.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Local ISS Program').getRecordTypeId();
        for(integer i = 0 ;i < size ;i++){
            localPartnerProgram = new LX_Partner_Program__c();
            localPartnerProgram.RecordTypeId = LX_SetRecordIDs.LocalISSProgramRTID;
            localPartnerProgram.LX_Program_Enrolled__c = globalPartnerProgramCategory.id;
            localPartnerProgram.Program_Status__c = 'Being Defined';
            localPartnerProgram.Program_Level__c = 'Global Program Category (L3)';
            localPartnerProgram.LX_Program_Type__c = 'ISS';
            localPartnerProgram.LX_Start_Date__c = system.today();
            localPartnerProgram.Program_End_Date__c = system.today() +200;      
            localPartnerPrograms.add(localPartnerProgram);          
        }
        insert localPartnerPrograms;
        return localPartnerPrograms;         
    }
    
    public static list<LX_Partner_Program__c> createGlobalCategoryPrograms(integer size,LX_Partner_Program__c globalPartnerProgram){
        list<lx_partner_program__c> globalPartnerProgramCategoryList = new list<LX_partner_program__c>();
        //Global Program Category
        LX_Partner_Program__c globalPartnerProgramCategory ;
        //globalPartnerProgramCategory.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Global ISS Program Category').getRecordTypeId();
        for(integer i = 0 ;i < size ;i++){
            globalPartnerProgramCategory = new LX_Partner_Program__c();
            globalPartnerProgramCategory.RecordTypeId = LX_SetRecordIDs.GlobalISSProgramCategoryRTID;
            globalPartnerProgramCategory.Global_Program__c = globalPartnerProgram.id;
            globalPartnerProgramCategory.Program_Status__c = 'Being Defined';
            globalPartnerProgramCategory.Program_Level__c = 'Global Program Category (L2)';
            globalPartnerProgramCategory.LX_Program_Type__c = 'ISS';
            globalPartnerProgramCategory.LX_Start_Date__c = system.today();
            globalPartnerProgramCategory.Program_End_Date__c = system.today() +200;
            globalPartnerProgramCategoryList.add(globalPartnerProgramCategory);
        }
        insert globalPartnerProgramCategoryList;
        return globalPartnerProgramCategoryList;
    }
    
    public static list<LX_Partner_Program__c> createGlobalPrograms(integer size){
        List<LX_Partner_Program__c> globalProgramList = new List<LX_Partner_Program__c> ();
        LX_Partner_Program__c globalPartnerProgram ;
        //globalPartnerProgram .RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Global Program').getRecordTypeId();
        for(integer i = 0; i < size; i++){
            globalPartnerProgram = new LX_Partner_Program__c();
            globalPartnerProgram .RecordTypeId = LX_SetRecordIDs.GlobalProgram;
            globalPartnerProgram.Program_Status__c = 'Being Defined';
            globalPartnerProgram.Program_Level__c = 'Global Program (L1)';
            globalPartnerProgram.LX_Program_Type__c = 'ISS';
            globalPartnerProgram.LX_Start_Date__c = system.today();
            globalPartnerProgram.Program_End_Date__c = system.today() +200;
            globalProgramList.add(globalPartnerProgram);
        }
        insert globalProgramList ;
        return globalProgramList ;
    }
}//End of class