/********************************************************************
  Trigger logic is handled in ScheduledJobTriggerHandler apex class
********************************************************************/
trigger ScheduledJobTrigger on Scheduled_Job__c (before insert, before update, before delete) {
    List<CronTrigger> CronTriggers = new List<CronTrigger>();
    ScheduledJobTriggerHandler handler = new ScheduledJobTriggerHandler(Trigger.isExecuting, Trigger.Size);    
       
    if (Trigger.isInsert && Trigger.isBefore){ 
        handler.OnBeforeInsert(Trigger.new);        
    }   
    else if (Trigger.isUpdate && Trigger.isBefore){
    	handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
    }   
    else if(Trigger.isDelete && Trigger.isBefore){
        handler.OnBeforeDelete(Trigger.old);
    }
}