@isTest(seealldata = True)
public Class batchVersionControlScheduler_Test
{
public static testmethod void testScheduleClass()
{
       Test.startTest();
       batchVersionControlScheduler m = new batchVersionControlScheduler();
       String sch = '0 55 * * * ?';
       system.schedule('batchVersionControlScheduler', sch, m);
       Test.stopTest();  
}

public static testmethod void testBatchClass()
{
       Test.startTest();
       String Query_Class = 'SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp FROM ApexClass where NamespacePrefix = \'\' limit 1';   
       batchVersionControl batchController_Class = new batchVersionControl(Query_Class,'Apex Class');       
       Database.executeBatch(batchController_Class); 
       Test.stopTest();  
}

public static testmethod void testBatchTrigger()
{         
Test.startTest();
            String Query_Trigger = 'SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp,TableEnumOrId,UsageAfterDelete,UsageAfterInsert,UsageAfterUndelete,UsageAfterUpdate,UsageBeforeDelete,UsageBeforeInsert,UsageBeforeUpdate,UsageIsBulk FROM ApexTrigger where NamespacePrefix = \'\' limit 1';    
            batchVersionControl batchController_Trigger = new batchVersionControl(Query_Trigger,'Apex Trigger');     
            Database.executeBatch(batchController_Trigger);      
            Test.stopTest();  
}

public static testmethod void testBatchPage()
{   
           Test.startTest();     
           String Query_Page = 'SELECT ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,IsAvailableInTouch,IsConfirmationTokenRequired,LastModifiedById,LastModifiedDate,Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp FROM ApexPage where NamespacePrefix = \'\' limit 1';   
           batchVersionControl batchController_Page = new batchVersionControl(Query_Page,'Visualforce Page');          
           Database.executeBatch(batchController_Page);     
           Test.stopTest();            
}

public static testmethod void testBatchComponent()
{   
       Test.startTest();     
       String Query_Component = 'SELECT ApiVersion,ControllerKey,ControllerType,CreatedById,CreatedDate,Description,Id,LastModifiedById,LastModifiedDate,Markup,MasterLabel,Name,NamespacePrefix,SystemModstamp FROM ApexComponent where NamespacePrefix = \'\' limit 1';   
       batchVersionControl batchController_Component = new batchVersionControl(Query_Component,'Apex Component');    
       Database.executeBatch(batchController_Component); 
       Test.stopTest();  
}
}