global class LX_SchedContactBirthday implements Schedulable{
   global void execute(SchedulableContext SC) {   
      LX_BatchContactBirthday callBatch = new LX_BatchContactBirthday();
      ID batchprocessid = Database.executeBatch(callBatch);
      
   }
}