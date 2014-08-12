/*********************************************************************************
Name : LX_ScheduleCreateInstallations_Test 
Created By : Deloitte
Created Date : 21 Jan 2014
Usages : This tests ScheduleCreateInstallations
*********************************************************************************/
@isTest
private class LX_ScheduleCreateInstallations_Test {

    static testMethod void testCreateInstallations() {        
         test.starttest();
         ScheduleCreateInstallations scheduleIns = new ScheduleCreateInstallations();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, scheduleIns);
         test.stopTest();
    }
}