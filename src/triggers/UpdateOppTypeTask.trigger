trigger UpdateOppTypeTask on Task (before insert,before update) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

     /*************************************
         *
         Description: To copy the opportunity Type field value when a task is created or updated for opportunity
         *
         Date Created: 4/2/2012
         *
         Created By: Manoj Kolli
         *
     *****************************************/ 
            
      if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    Set<Id> oppids = new Set<Id>();
    Set<Id> Starids = new Set<Id>();

    for(Task t:Trigger.New){
        

        if(trigger.isInsert && t.Subject == 'Auto Activity Trigger: Closed Won Opportunity') {

            t.LX_Activity_Detail__c = 'Closed Won Opportunity';
            t.Lx_Activity_Method__c = 'F2F';
        }

        //Added by arun thakur :set Task Completed date=now if status=completed
    if(t.Status=='Completed'&& t.Date_Completed__c==null)
    {
        t.Date_Completed__c=Date.today();
        t.Status__c = 'Complete'; //Added by NJ 6/5/14
        t.Completed__c = true;

    }
        if(t.WhatId != Null && String.valueOf(t.whatId).startsWith('006')){
                oppids.add(t.whatId);
        }
        
        System.debug('&&&&&&&&&&&&&&&'+t.recordtypeid+'^^^^^^^^^^^^^^^^^^^^^'+t.recordtype.developername);
        if(t.whatID!=Null && String.valueof(t.whatId).startswith(Label.LX_STAR_Prefix) && t.Status =='Completed' && t.RecordTypeID == Label.LX_STAR_Task)
        {
        Starids.add(t.whatId);
        }
        
    }
    if(oppids.size()>0){
        //NJ 5/17 added StageName field to query
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select Id,Type, StageName from Opportunity where Id in :oppids]);
         
        for(Task t1:Trigger.New){
            if(t1.whatId != Null && oppMap.containsKey(t1.whatId)){
                t1.Opportunity_Type__c = oppMap.get(t1.whatId).Type;
            }    
            
            //NJ 5/17 Added Opportunity Stage mapping when task is marked complete
            if(trigger.isInsert) {
                
                if(t1.whatId != Null && oppMap.containsKey(t1.whatId) && t1.Status == 'Completed') {
                    
                    t1.Opportunity_Stage__c = oppMap.get(t1.whatId).StageName;
                }
            }
            else if(trigger.isUpdate) {
                
                if(t1.whatId != Null && oppMap.containsKey(t1.whatId) && t1.Status == 'Completed' && trigger.oldMap.get(t1.Id).Status != 'Completed') {
                    
                    t1.Opportunity_Stage__c = oppMap.get(t1.whatId).StageName;
                }
            }    
        }
    }
    
 // Flagging a checkbox on Star record if any one of the tasks associated are completed.
    if(Starids.size()>0){
    List<Star__c> starRecords = new List<Star__C>();
    For(Star__C starTemp : [select LX_Task_Count__c from star__c where id in : Starids])
    {
    starTemp.LX_Task_Count__c = true;
    starRecords.add(starTemp);
    }
    update starRecords;
    }
}