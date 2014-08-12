trigger updateOppTypeEvent on Event (before insert,before update) {
    /*************************************
         *
         Description: To copy the opportunity Type field value when a Event is created or updated for opportunity
         *
         Date Created: 4/2/2012
         *
         Created By: Manoj Kolli
         *
     *****************************************/ 
     
   if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
     
    Set<Id> oppids = new Set<Id>();
    for(Event e:Trigger.New){
        
        if(e.WhatId != Null && String.valueOf(e.whatId).startsWith('006')){
                oppids.add(e.whatId);
        }
    }
    if(oppids.size()>0){
    	//NJ 5/17 added StageName field to query 
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select Id,Type, StageName from Opportunity where Id in :oppids]);
         
        for(Event e1:Trigger.New){
            if(e1.whatId != Null && oppMap.containsKey(e1.whatId)){
                e1.Opportunity_Type__c = oppMap.get(e1.whatId).Type;
            }
            //NJ 5/17 Added Opportunity Stage mapping when event is marked complete
            if(trigger.isInsert) {
            	
            	if(e1.whatId != Null && oppMap.containsKey(e1.whatId) && e1.Completed__c) {
            		
            		e1.Opportunity_Stage__c = oppMap.get(e1.whatId).StageName;
            	}
            }
            else if(trigger.isUpdate) {
            	
            	if(e1.whatId != Null && oppMap.containsKey(e1.whatId) && e1.Completed__c && !trigger.oldMap.get(e1.Id).Completed__c) {
            		
            		e1.Opportunity_Stage__c = oppMap.get(e1.whatId).StageName;
            	}
            }      
        }
    }
}