/*******************************************************
Class Name : createTaskAndNotificationOnOpp
Created Date : 19th June 2012
Related Story : US1347
Author : Appirio Offshore(Hemant)
Purpose : create a new Task, send notification to Sales Operations Queue
          when Submitted for Review field on the Opportunity is checked.
**********************************************************/

public class createTaskAndNotificationOnOpp{
    
    //Boolean var to create Task only single time
    static Boolean isTaskCreated = false;
    static User m_User = null;
    static RecordType m_RecType = null;
    public static void createTaskAndNotification(List<Opportunity> oppList){
        system.debug('************'+isTaskCreated);
        if(isTaskCreated){
            return;
        }else{
            isTaskCreated = true;
        }
        List<Task> taskToInsert = new List<Task>();
        Task tsk;
        Id salesOpTaskRTypeId , SalesOperationsUserId;
        if(m_User == null)
        {
            List<User> usersList = [Select id , name from User where Name = 'Sales Operations'];
            if(usersList != null && usersList.size() > 0)
                m_User = usersList[0];
        }
        SalesOperationsUserId = m_User.Id;
        
        if(m_RecType == null)
        {
            List<RecordType> recTypeList = [Select Id from RecordType where DeveloperName = 'StandardTask' AND SobjectType = 'Task'];
            if(recTypeList != null && recTypeList.size() > 0)
                m_RecType = recTypeList[0];
        }
        salesOpTaskRTypeId = m_RecType.Id;
        
        /*for(User u : [Select id , name from User where Name = 'Sales Operations']){
            SalesOperationsUserId = u.Id;
        }
        for(RecordType rt : [Select Id from RecordType where Name = 'Sales Operations Task' AND SobjectType = 'Task']){
             salesOpTaskRTypeId = rt.Id;
             break;
        }*/
        for(Opportunity opp : oppList){
            
            //create task
            tsk = new Task();
            if(salesOpTaskRTypeId != null)
                tsk.RecordTypeId = salesOpTaskRTypeId;
            tsk.Subject = 'Opportunity Review';
            tsk.CurrencyIsoCode = 'USD';
            tsk.Status = 'Assigned';
            tsk.Priority =  'Normal';
            if(SalesOperationsUserId != null)
                tsk.OwnerId = SalesOperationsUserId;
            tsk.WhatId = opp.Id;
            taskToInsert.add(tsk);
        }
        
        //insert tasks
        if(taskToInsert.size() > 0){
            insert taskToInsert;
        }
    }
    
@isTest(SeeAllData = true)
public static void createTaskAndNotificationOnOppTest(){
    
    list<String> stageList = new List<String>();
    stageList.add('Proposing');
    stageList.add('Qualifying');
    List<Opportunity> oppList = Data_Opportunity.createOpportunity(stageList, 2);
    List<Id> oppIdList = new List<Id>();
    
    createTaskAndNotificationOnOpp createTask = new createTaskAndNotificationOnOpp();
    createTaskAndNotificationOnOpp.createTaskAndNotification(oppList);
    
    for(Opportunity opp : oppList){
        oppIdList.add(opp.Id);
    }
    List<Task> taskList = [Select id from Task where WhatId in :oppIdList];
    System.assertNotEquals(0,taskList.size());
    
    
}
}