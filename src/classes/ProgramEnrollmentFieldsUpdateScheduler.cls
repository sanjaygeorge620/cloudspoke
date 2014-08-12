/*********************************************************************************
Name : ProgramEnrollmentFieldsUpdateScheduler
Created By : Perceptive
Created Date : Aug 2013
Usages : This schedules BatchProgramEnrollmentFieldsUpdate  run
*********************************************************************************/
global class ProgramEnrollmentFieldsUpdateScheduler implements Schedulable{
        
    global void execute(SchedulableContext SC) 
    {
       BatchProgramEnrollmentFieldsUpdate batchController = new BatchProgramEnrollmentFieldsUpdate (); 
       Database.executeBatch(batchController);
    }
    
     public static testMethod void batchTest(){
       Test.startTest();
       ProgramEnrollmentFieldsUpdateScheduler m = new ProgramEnrollmentFieldsUpdateScheduler();
       String sch = '00 25 06 * * ?';
       system.schedule('Program Enrollment Update Field Schedule48', sch, m);
       Test.stopTest();
   } 
}