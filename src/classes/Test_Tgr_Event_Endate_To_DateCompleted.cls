@isTest(SeeAllData=true)

public class Test_Tgr_Event_Endate_To_DateCompleted{

    public static testmethod void testEventTrigger(){

        list<Event> test_Evt_Rec = [Select id from Event where owner_role_name__c like 'ISS%' and owner_role_name__c like '%Sales%' limit 1];
        
        update test_Evt_Rec;        
        
    }

}