@isTest
private class testLX_SendDailyNotification  {

   public static testmethod void DalilyNotify () {    
      
        Group testGroup = new Group();
        testGroup.Name = 'testGroup';
        testGroup.DeveloperName = 'LX_STAR_Test';
        testGroup.type='Queue';
        INSERT testGroup;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = testGroup.Id, SobjectType = 'Star__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
 
      Id rec=Star__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('STAR').getRecordTypeId();

      STAR__c st = new STAR__c();
      st.Geo__c = 'Latin America';
      st.start_date__c = System.today().addDays(3);
      st.end_date__c = System.today().addDays(10);
      st.Division__c = 'ISS';
      st.Lexmark_Vertical__c='Banking';
      st.Name = 'Test Request';
      st.recordTypeId =  rec;
      st.ownerId = testGroup.Id; 
      st.Urgency_Reason__c='Testing';      
      insert st;
    
      LX_SendDailyNotification nots = new LX_SendDailyNotification();
      nots.sendEmail();
      

  }
 }