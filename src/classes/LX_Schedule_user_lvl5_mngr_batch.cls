/* 
* ©Lexmark Front Office 2013, all rights reserved
* Created Date : 06/29/2014
* Author : DMI 
* Description : Schedule class for populating 'Reporting_level_5_count__c' field on users.
*/

global class LX_Schedule_user_lvl5_mngr_batch implements schedulable{
 global void execute(SchedulableContext SC)
   {
    Database.executebatch(new LX_user_lvl5cntmngr_update(),700);
    }
}