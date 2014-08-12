global class batchProcessCloneScheduler implements Schedulable
{
  global void execute(SchedulableContext SC) 
  {
    string q = 'Select ID,AccountID,CurrencyIsoCode,Name,IsCompetitorProduct,Contact.ID,Description,InstallDate,Price,PurchaseDate,Quantity,SerialNumber,Status,UsageEndDate,Agreement__r.ID,Company_Number__c,End_Date__c,License_Option__c,License_Type__c,Part_Number__c,prodpk__c,Product__r.ID,Product_Key__c,Product_Model__r.ID,Product_Name__c,Quantity__c,Rate__c,SAP_Contract_Item__r.ID,Server__r.ID,Server_ID__c,SKU__c,SKU_Description__c,Start_Date__c,Product_Status__c,Total__c,Units__c,Usage__c,Users__c,Process_Later__c from asset where Process_Later__c = true';                                           
    string ty = 'Asset';    
        
       batchProcessClones batchController = new batchProcessClones(q,ty); 
         if(!Test.isRunningTest()){     
         Database.executeBatch(batchController); 
      }
  } 
  
  /* public static testMethod void batchTest()
   {
       Test.startTest();
       batchProcessCloneScheduler m = new batchProcessCloneScheduler();
       String sch = '00 25 06 * * ?';
       system.schedule('Batch Clone Scheduler', sch, m);
       Test.stopTest();
   }  */ 
}