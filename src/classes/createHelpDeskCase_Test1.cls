@isTest(seeAllData=true)
private class createHelpDeskCase_Test1 {
    
    static testMethod void testTrigger() {
        
pse__Timecard_Header__c abc  =  [select id from pse__Timecard_Header__c limit 1];

pse__Time_Date__c abd = new pse__Time_Date__c(pse__Timecard__c = abc.id, pse__Date__c = system.today(), pse__Hours__c = 10);
insert abd;}
}