global class LX_Schedule_user_batch implements schedulable{


 global void execute(SchedulableContext SC)
   {
    Database.executebatch(new LX_user_batch(),2);
    }
}