@isTest(SeeAllData = true)
public class testSkipLeadContactTriggerExecution{

    public static testmethod void testMethodSkipLeadContactTriggerExecution(){
        SkipLeadContactTriggerExecution.setSkipExecution();
        System.assert(SkipLeadContactTriggerExecution.skipTriggerExec == true);
        SkipLeadContactTriggerExecution.resetSkipExecution();
        System.assert(SkipLeadContactTriggerExecution.skipTriggerExec == false);
    }
}