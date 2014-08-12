/*
Class Name : LX_UpdateMqliBatch
Description : Batch class to update the MQLU
Created By : Kapil Sama Reddy (ksama@deloitte.com)
Created Date : 10-6-2013
Modification Log:
-------------------------------------------------------------------------
Developer            Date            Modification ID        Description
-------------------------------------------------------------------------
Shubashish Rai      2-4-2013        1000                   Initial Version
    

*************************************************************************/
global class LX_schedule_UpdateMqliBatch implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        LX_UpdateMqliBatch b = new LX_UpdateMqliBatch();
        database.executebatch(b,200);
    }
}