/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-30-2013
 *
 * Author : Akanksha Gupta
 * 
 * Description : This class is being used to schedule

**/ 
global class LX_scheduleTimeCardApprovalReminder implements Schedulable{
   global void execute(SchedulableContext SC) {
      LX_ApprovalPendingTimeCards mis = new LX_ApprovalPendingTimeCards(); 
      mis.execute();
      
   }
}