/**
 * Name: Test_UpdateOppTypeEvent
 *
 * Description: to provide code coverage for UpdateOppTypeEvent Trigger
 *
 * Created Date: 4/2/2012
 * Created By: Manoj Kolli
 */
@isTest(SeeallData = true)
public class Test_UpdateOppTypeEvent{

    static testMethod void Test_UpdateOppTypeEvent() {
      
      Test.startTest();
      String [] stageList = new List<String>();
      stageList.add('Negotiation');
      List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);       
      Id Oppid = test_opportunities[0].Id;
      Schema.DescribeSObjectResult d = Schema.SObjectType.Event; 
      Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
      Id recordTypeId = rtMapByName.get('Standard').getRecordTypeId();
      Datetime startDateTime=Datetime.newInstance(Date.Today(), Time.newInstance(12, 0, 0, 0));
      Datetime endDateTime=Datetime.newInstance(Date.Today()+1, Time.newInstance(12, 0, 0, 0));
      Event e = new Event(Subject = 'Test Event',StartDateTime = startDateTime,EndDatetime = endDateTime,RecordTypeId = recordTypeId,WhatId = Oppid);
      insert e;
      Test.stopTest(); 
           
    }
      
}