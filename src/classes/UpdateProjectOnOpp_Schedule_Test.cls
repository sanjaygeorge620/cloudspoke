@isTest(seealldata=false)
private class UpdateProjectOnOpp_Schedule_Test {

    static testMethod void myUnitTest() {
        // Schedule the test job 
    

      UpdateProjectOnOpp_Schedule m = new UpdateProjectOnOpp_Schedule ();
      String sch = '0 5 * * * ?';
      String jobId = system.schedule('Update Project on Opportunity -x05 Test', sch, m);
   // Get the information from the CronTrigger API object 
    

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                             FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same 
    
   Test.startTest();
   
    //system.assertEquals(oppRec.pse__primary_Project__c, projects2[0].id);
    
      System.assertEquals('0 5 * * * ?', ct.CronExpression);

   // Verify the job has not run 
    
      System.assertEquals(0, ct.TimesTriggered);
      //system.abortJob(jobId);

   Test.stopTest();

    }
}