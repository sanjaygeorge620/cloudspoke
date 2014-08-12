/* Class Name   : LX_SendDailyNotification  
    * Description   : This class is being used to schedule LX_SendDailyNotification
    * Created By   : Maruthi Kolla
    * Created Date : 01-08-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi Kolla        01-08-2014               1000                Initial Version    
    */
global class LX_scheduleDailyNote implements Schedulable{
   global void execute(SchedulableContext SC) {
      LX_SendDailyNotification sendEmails = new LX_SendDailyNotification(); 
      sendEmails.sendEmail();
   }
}