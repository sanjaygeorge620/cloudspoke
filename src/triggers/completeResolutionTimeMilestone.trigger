trigger completeResolutionTimeMilestone on Case (after update) {

    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
    

    // Cannot be a portal user
    if (UserInfo.getUserType() == 'Standard'){
        DateTime completionDate = System.now();
            List<Id> ActionPlanCases = new List<Id>();
            List<Id> RemedyCases = new List<Id>();
            List<Id> ResolvedCases = new List<Id>();
            
            
            //aggregate Cases by Status
            for (Case c : Trigger.new){
                //Action Plan status
                if ((c.isClosed== false)&&(c.Status_Detail__c == 'Action Plan Provided')&&(c.SlaStartDate <= completionDate)&&(c.SlaExitDate == null)){
                    ActionPlanCases.add(c.Id);
                
                //Remedy Provided
                } else if ((c.isClosed== false)&&(c.Status_Detail__c == 'Remedy Provided')&&(c.SlaStartDate <= completionDate)&&(c.SlaExitDate == null)){
                    RemedyCases.add(c.Id);
                
                //Resolution provided or Closed   
                } else if ((c.Status == 'Closed' || c.Status_Detail__c == 'Resolution provided')&&(c.SlaStartDate <= completionDate)&&(c.SlaExitDate == null)){
                    ResolvedCases.add(c.Id);
                }       
            }
            

            //Action Plan
            if (ActionPlanCases.isEmpty() == false){
                milestoneUtils.completeMilestone(ActionPlanCases, 'Action Plan Provided', completionDate);
            }
            
            //Remedy
            if (RemedyCases.isEmpty() == false){
                milestoneUtils.completeMilestone(RemedyCases, 'Remedy Provided', completionDate);
            }
            
            //Resolved
            if (ResolvedCases.isEmpty() == false){
                milestoneUtils.completeMilestone(ResolvedCases, 'Resolved', completionDate);
            }
            
        }
}