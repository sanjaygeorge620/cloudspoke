/* 
* ©Lexmark Front Office 2013, all rights reserved
* Created Date : 06/29/2014
* Author : DMI 
* Description : Schedule class for populating 'Reporting_level_5_count__c' field on users.
*/

@isTest(seeAllData=true)
public class Lx_Test_schedule_user_lvl5_mngr_batch{
    
    static testmethod void m1(){
        test.starttest();
        LX_Schedule_user_lvl5_mngr_batch obj = new LX_Schedule_user_lvl5_mngr_batch();
        String tym = '0 10 * * * ?';
        System.schedule('Userlvl5mngrjob',tym,obj);
        test.stoptest();
    }
}