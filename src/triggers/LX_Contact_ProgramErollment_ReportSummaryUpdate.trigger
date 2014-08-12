/**
**Author : Shishir Kulkarni
**Date : 11/18/2013
**Objective: To create / delete Report Summary Records based on the creation of deletion of the Contact Records.
** Business Objective: To link Program Enrollment to Contacts for reporting.
**
**/

trigger LX_Contact_ProgramErollment_ReportSummaryUpdate on Contact (after insert, after update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [04-Dec-13] : Added Bypass code
    if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
    
    //in case of Contacts creation
    if(Trigger.isInsert || Trigger.isUpdate){
        List<Id> parentAccountIdList = new LIst<Id>();
        LIst<Id> parentContactIdToDelFromReportSummary  = new List<Id>();
        List<LX_Reporting_Summary__c> reportingSummaryList = new List <LX_Reporting_Summary__c>();
        List<LX_Reporting_Summary__c> reportingSummaryList_toDelete = new  List <LX_Reporting_Summary__c>();
        for(Contact con : Trigger.new){
           if(Trigger.isInsert){
               parentAccountIdList.add(con.AccountId); 
           }
           else if(Trigger.isUpdate){
               if(con.AccountId != Trigger.oldMap.get(con.Id).AccountId){
                  parentAccountIdList.add(con.AccountId);
                  parentContactIdToDelFromReportSummary.add(con.Id);     
               }
           }
        }
        if(parentContactIdToDelFromReportSummary != null && parentContactIdToDelFromReportSummary.size() > 0){
             reportingSummaryList_toDelete =   [Select Id from LX_Reporting_Summary__c where LX_Partner_Contact__c in : parentContactIdToDelFromReportSummary ];
             if(reportingSummaryList_toDelete != null && reportingSummaryList_toDelete.size() > 0){
                 delete reportingSummaryList_toDelete;
             } 
        }
        if(parentAccountIdList != null && parentAccountIdList.size() > 0){
            Map<Id,Account> accountEnrollmentsMap = new Map<Id,Account>([select id, (select Id from Enrollments1__r) from Account 
                                                                                        where id in : parentAccountIdList and type = 'Partner'  ]);
            if(accountEnrollmentsMap != null && accountEnrollmentsMap.size() > 0){
                for(Contact conRec : Trigger.new){
                    if(accountEnrollmentsMap.get(conRec.AccountId) != null &&
                    accountEnrollmentsMap.get(conRec.AccountId).Enrollments1__r != null &&
                    accountEnrollmentsMap.get(conRec.AccountId).Enrollments1__r.size() > 0){
                        for(LX_Program_Enrollment__c pe : accountEnrollmentsMap.get(conRec.AccountId).Enrollments1__r){
                        LX_Reporting_Summary__c rs = new LX_Reporting_Summary__c();
                        rs.LX_Program_Enrollment__c = pe.Id;
                        rs.LX_Partner_Contact__c = conRec.Id;
                        rs.LX_Report_Summary_Type__c = 'Program Enrollment Partner Contacts';
                        reportingSummaryList.add(rs);
                        }
                    }
                }
                if(reportingSummaryList != null && reportingSummaryList.size() > 0){
                insert reportingSummaryList;
                }
            }
        }
       
    }
    
    
}