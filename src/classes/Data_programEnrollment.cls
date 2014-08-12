/**
**Author : Mayank Agarwal
**Date : 12/05/2013
**Objective: To create program enrollment data
** 
**
**/
@istest(seeAllData = true)
public class Data_programEnrollment{
    public static List<LX_Program_Enrollment__c> createEnrollment(Id accountId, Id programId, Integer noOfRecords){
        
        List<LX_Program_Enrollment__c> peRecordsList = new List<LX_Program_Enrollment__c> ();
        LX_Program_Enrollment__c peRecord;
        Integer i;
        
        for(i=0 ; i < noOfRecords; i++){
            peRecord = new LX_Program_Enrollment__c ();
            peRecord.LX_Account__c = accountId;
            peRecord.Master_Program__c = programId;
            peRecord.LX_Enrollment_Status__c = 'Proposing';
            peRecord.LX_Enrollment_Effective_Date__c = Date.today().adddays(i);
            peRecord.LX_Enrollment_End_Date__c = Date.today().adddays(i+5);
            peRecordsList.add(peRecord);
        }//end of for loop
        
        system.debug('List------>'+peRecordsList);
        Insert peRecordsList;
        
        //INSERT peRecord;
        
        return peRecordsList;
        
    }//End of testMethod createEnrollment
    
    public static List<LX_Program_Enrollment__c> createISSEnrollments(Id accountId, Id programId, Integer noOfRecords){
        List<LX_Program_Enrollment__c> peRecordsList = new List<LX_Program_Enrollment__c> ();
        LX_Program_Enrollment__c peRecord;
        Integer i;        
        for(i=0 ; i < noOfRecords; i++){
            peRecord = new LX_Program_Enrollment__c ();
            peRecord.recordtypeId = LX_SetRecordIDs.ISSPartnerEnrollment;
            peRecord.LX_Account__c = accountId;
            peRecord.LX_Program_Type__c = 'ISS';
            peRecord.Master_Program__c = programId;
            peRecord.LX_Enrollment_Status__c = 'Proposing';
            peRecord.LX_Enrollment_Effective_Date__c = Date.today().adddays(i);
            peRecord.LX_Enrollment_End_Date__c = Date.today().adddays(i+5);
            peRecord.LX_Enrollment_Proposed_Date__c = system.today() + i;
            peRecord.LX_Enrollment_Signed_Date__c = system.today()+ i ;           
            peRecordsList.add(peRecord);
        }
        Insert peRecordsList;
        return peRecordsList;
    }
}//End of class