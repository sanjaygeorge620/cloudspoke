trigger updateLastWorkedBy on Version_Control__c(before update)
{
for(Version_Control__c vc : Trigger.new)
{
id curUser = userinfo.getuserid();
if(vc.Status__c == 'Locked' && Trigger.oldmap.get(vc.id).Status__c != 'Locked')
{
vc.Locked_By__c = curUser;
}
if(vc.Status__c == 'Unlocked' && Trigger.oldmap.get(vc.id).Status__c == 'Locked')
{
vc.Locked_By__c = null;
vc.Last_Worked_By__c = curUser;
}
}
}