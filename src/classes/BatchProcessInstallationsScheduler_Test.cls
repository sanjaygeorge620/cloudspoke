@isTest(seealldata = True)
public Class BatchProcessInstallationsScheduler_Test
{
    public static testmethod void testInstallationsBatchProcess()
        {
         Account acc= new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
         insert acc;
      
         Opportunity oppy= new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
         insert oppy;

         oppy.SAP_Status__c = 'SUBMITTED';
         update oppy;
          
         Test.startTest();
         BatchProcessInstallationsScheduler m = new BatchProcessInstallationsScheduler();
         String sch = '00 30 00 * * ?';
         system.schedule('Batch ProcessInstall Schedule', sch, m);
         Test.stopTest();    
         }
}