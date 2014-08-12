public class UserStoryTriggerClass{

       public static void createNewACHistoryRecord(Map<Id,String> mapStoryACHistory)
        {
         List<AC_History__c> lstACHistoryRecords = new List<AC_History__c>();
        
         for(Id UserStoryId : mapStoryACHistory.keySet())
           {
               AC_History__c newACHistoryRecord = new AC_History__c();
               newACHistoryRecord.Acceptance_Criteria__c = mapStoryACHistory.get(UserStoryId);
               newACHistoryRecord.User_Story__c          = UserStoryId;
                 lstACHistoryRecords.add(newACHistoryRecord);
            }
            insert lstACHistoryRecords;
        }
            
        
        

}