/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 06-30-2013
 *
 * Author : Akanksha Gupta
 * 
 * Description : This class is being used to schedule LX_MissingTimecardNotification

**/ 
global class LX_schedulePSEreminder implements Schedulable{
   global void execute(SchedulableContext SC) {
      LX_MissingTimecardNotification mis = new LX_MissingTimecardNotification(); 
      mis.checkConditions();
   }
}