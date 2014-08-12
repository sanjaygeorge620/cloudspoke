public class initialmilestoneUtils {
    /*************************************
         *
         Description: Code to handle US1112 from trigger completeInitialMilestone such that the cases that comes in to the class will get the Initial Response Milestone completed.
         *
         Date Created: 4/3/2012
         *
         Created By: Manoj Kolli
         *
     *****************************************/ 
    
    public static void initialcompleteMilestone(List<Id> caseIds, String milestoneName, DateTime complDate) {
        system.assertnotequals(milestoneName,'');               
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate
                       from CaseMilestone cm
                       where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName and completionDate = null];
        
        
        if (cmsToUpdate.isEmpty() == false){
          for (CaseMilestone cm : cmsToUpdate){
                cm.completionDate = complDate;
          }
          update cmsToUpdate;
        } 
      }
 }