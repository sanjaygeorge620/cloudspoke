/**
**Author : Shishir Kulkarni
**Date : 11/18/2013
**Objective: To create / delete Report Summary Records based on the creation of deletion of the Enrollment Records.
** Business Objective: To link Program Enrollment to Contacts for reporting.
**
**/

trigger LX_ProgramEnrollment_UpdateReportSummary on LX_Program_Enrollment__c (after insert, after update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [04-Dec-13] : Added Bypass code
    
    List<Id> partnerAccountIdList = new List <Id>();
    List<Id> programEnrollmentIdToDeleteReportSummary = new List<Id>();
    Map<Id,Account> accountContactListMap ; 
    List<LX_Reporting_Summary__c> reportingSummaryList = new List<LX_Reporting_Summary__c>();
    List<LX_Reporting_Summary__c> reportingSummaryList_to_Del = new List<LX_Reporting_Summary__c>();
    //in case of new Program Enrollments
    if(trigger.isInsert){
        for(LX_Program_Enrollment__c pe: Trigger.new){
           if(Trigger.isInsert ){
               if(pe.LX_Account__c != null){
                   partnerAccountIdList.add(pe.LX_Account__c); 
               }
           }
           else if(Trigger.isUpdate){
               if(pe.LX_Account__c != null && pe.LX_Account__c != Trigger.oldMap.get(pe.Id).LX_Account__c){
                   partnerAccountIdList.add(pe.LX_Account__c);
                   programEnrollmentIdToDeleteReportSummary.add(pe.Id);
               }
           }
        }
        
        if(Trigger.isUpdate && programEnrollmentIdToDeleteReportSummary != null &&
                                         programEnrollmentIdToDeleteReportSummary.size()>0 ){
                                         
                  reportingSummaryList_to_Del = [select Id from LX_Reporting_Summary__c where LX_Program_Enrollment__c in: programEnrollmentIdToDeleteReportSummary ];  
        }         delete reportingSummaryList_to_Del;
        
        if(partnerAccountIdList != null && partnerAccountIdList.size() > 0){
           accountContactListMap = new Map<Id, Account>([SELECT ID, (SELECT ID FROM CONTACTS) FROM ACCOUNT 
                                                                       WHERE ID IN :partnerAccountIdList ]);
        }
        if(accountContactListMap != null && accountContactListMap.size() > 0){
        for(LX_Program_Enrollment__c enrollment: Trigger.new){
            List<Contact> partnerContactList = accountContactListMap.get(enrollment.LX_Account__c).Contacts;
            if(partnerContactList != null && partnerContactList.size() > 0){
                for(Contact con : partnerContactList ){
                  LX_Reporting_Summary__c rs = new LX_Reporting_Summary__c();
                  rs.LX_Partner_Contact__c = con.Id;
                  rs.LX_Program_Enrollment__c = enrollment.Id;
                  rs.LX_Report_Summary_Type__c = 'Program Enrollment Partner Contacts';
                  reportingSummaryList.add(rs);  
                }
            }
        }
        
        //insert the report summay list:
        if(reportingSummaryList != null && reportingSummaryList.size() > 0){
            insert reportingSummaryList;
        }   
        }
    }
}