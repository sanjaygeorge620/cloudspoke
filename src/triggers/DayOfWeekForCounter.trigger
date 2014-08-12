trigger DayOfWeekForCounter on pse__Time_Date__c (before insert, before update) 
{

    if(LX_CommonUtilities.ByPassBusinessRule()) return;

    for (pse__Time_Date__c td : Trigger.new) 
    {
        if (td.pse__Day_Of_Week__c != null && td.pse__Day_Of_Week__c != '')                
        {
            td.True_Day__c = td.pse__Day_Of_Week__c;
        }
    }        
}