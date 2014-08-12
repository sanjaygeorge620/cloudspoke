trigger AccountGSSMonitoredUpdate on Account (before Insert, before Update) 
{
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        system.debug('Aman1');
        updateAccountGSSMonitored_AC.updateGSSMonitored(Trigger.New, Trigger.oldMap);
    }
}