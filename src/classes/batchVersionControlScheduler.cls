global class batchVersionControlScheduler implements Schedulable
{
  global void execute(SchedulableContext SC) 
  {
   String Query_Class = 'SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp FROM ApexClass where NamespacePrefix = \'\'';
   
       batchVersionControl batchController_Class = new batchVersionControl(Query_Class,'Apex Class'); 
         if(!Test.isRunningTest())
         {     
         Database.executeBatch(batchController_Class); 
         }
         
   String Query_Trigger = 'SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp,TableEnumOrId,UsageAfterDelete,UsageAfterInsert,UsageAfterUndelete,UsageAfterUpdate,UsageBeforeDelete,UsageBeforeInsert,UsageBeforeUpdate,UsageIsBulk FROM ApexTrigger where NamespacePrefix = \'\'';
   
       batchVersionControl batchController_Trigger = new batchVersionControl(Query_Trigger,'Apex Trigger'); 
         if(!Test.isRunningTest())
         {     
         Database.executeBatch(batchController_Trigger); 
         }
         
       String Query_Page = 'SELECT ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,IsAvailableInTouch,IsConfirmationTokenRequired,LastModifiedById,LastModifiedDate,Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp FROM ApexPage where NamespacePrefix = \'\'';
   
       batchVersionControl batchController_Page = new batchVersionControl(Query_Page,'Visualforce Page'); 
         if(!Test.isRunningTest())
         {     
         Database.executeBatch(batchController_Page); 
         }
         
         
       String Query_Component = 'SELECT ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,LastModifiedById,LastModifiedDate,Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp FROM ApexComponent where NamespacePrefix = \'\'';
   
       batchVersionControl batchController_Component = new batchVersionControl(Query_Component,'Apex Component'); 
         if(!Test.isRunningTest())
         {     
         Database.executeBatch(batchController_Component); 
         }
         
  }
}