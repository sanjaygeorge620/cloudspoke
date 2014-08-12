/**
 * Name: Test_UpdateOppTypeTask
 *
 * Description: to provide code coverage for UpdateOppTypeTask Trigger
 *
 * Created Date: 4/2/2012
 * Created By: Manoj Kolli
 */
@isTest(SeeallData = true)
public class Test_UpdateOppTypeTask{

    static testMethod void Test_UpdateOppTypeTask() {
      
      Test.startTest();
      String [] stageList = new List<String>();
      stageList.add('Negotiation');
      List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);       
      Id Oppid = test_opportunities[0].Id;
      Schema.DescribeSObjectResult d = Schema.SObjectType.Task; 
      Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
      Id recordTypeId = rtMapByName.get('Standard Task').getRecordTypeId();
      Task t = new Task(Subject = 'Test Task',Status = 'Not Started',Priority = 'Low',RecordTypeId = recordTypeId, WhatId = Oppid);
      insert t;
      Test.stopTest(); 
           
    }
          
}