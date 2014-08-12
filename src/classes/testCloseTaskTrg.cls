@isTest
private class testCloseTaskTrg {

    static testMethod void testCloseTask() {
    
    Task tsk = new Task();
    Opportunity opp = [Select Id from Opportunity LIMIT 1];
    tsk.Subject = 'WFT-Request SE';
    tsk.status = 'Completed';
    tsk.Description = 'This is a test';
    tsk.WhatId = opp.Id;
    insert tsk;
    
    }
}