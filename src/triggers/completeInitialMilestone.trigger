trigger completeInitialMilestone on Task (after insert,after update) {
     /*************************************
         *
         Description: Code to handle US1112 for Completed Task that contains call or chat or vm in Communication Subject field for a 
                      Product Support Cases only that needs the Initial Response Milestone completed.
         *
         Date Created: 4/3/2012
         *
         Created By: Manoj Kolli
         *
     *****************************************/ 
   if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    
    Set<Id> cids = new Set<Id>();
    Set<Id> caseids = new Set<Id>();
    List<Id> completeInitialResponseCaseids = new List<Id>();
    DateTime completionDate = System.now();
    String milestoneName = 'Initial Response';
    
    Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Id recordTypeId = rtMapByName.get('Product Support').getRecordTypeId();
    
    for(Task t:Trigger.New){
        
        if(t.WhatId != Null && String.valueOf(t.whatId).startsWith('500') && t.Status == 'Completed' && 
            (t.Subject.toLowerCase().contains('call') || t.Subject.toLowerCase().contains('chat') || t.Subject.toLowerCase().contains('vm')||
            (t.Subject.contains('Email')&&(t.Activity_Subject__c == Null || (t.Activity_Subject__c != Null &&t.Activity_Subject__c != 'Auto Processed'))))){
                cids.add(t.whatId);
        }
    }
    
    if(cids.size()>0){
        Map<Id,Case> caseMap = new Map<Id,Case>([select Id,RecordTypeId,EntitlementId,Entitlement.Name,Entitlement.Status from Case where Id in :cids 
                                and Entitlement.Name != 'Enhanced Support Services' and Entitlement.Status = 'Active' and RecordTypeId = :recordTypeId]);
        
        if(caseMap.size()>0){
            caseids = caseMap.keySet();
            completeInitialResponseCaseids.addAll(caseids);
            
            if(completeInitialResponseCaseids.size()>0){
                    initialmilestoneUtils.initialcompleteMilestone(completeInitialResponseCaseids, 'Initial Response', completionDate);
             }   
         }       
    }
}