/* 
* ©Lexmark Front Office 2013, all rights reserved
* 
* Created Date : 02/13/2014
*
* Author : Deloitte USI.
* 
* Description : Test Class for 'LX_SLDBReportControlr' Class.

*/

@istest
Public class Test_LX_SLDBReportControlr 
{
    Static testmethod void sLDBReportControlrTest(){
        LX_SLDBReportControlr sldbCont = new LX_SLDBReportControlr();
        sldbCont.Dashbrd();
        sldbCont.LoySumm();
        sldbCont.LoyInfo();
        sldbCont.GapAnaly();
        sldbCont.Back();
    }
}