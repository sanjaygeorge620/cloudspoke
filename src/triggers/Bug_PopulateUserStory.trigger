trigger Bug_PopulateUserStory on Bug__c (before insert, before update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    List<Id> bugIds = new List<Id>();
    
    for(Bug__c bug: Trigger.new)
    {
    if(bug.Detailed_Requirement__c != null)
    /*
    The following line stores the Bug's related Detailed Requirement ids in a list
    that will later be used to query for the User Story . Null check is added above .
    */
    bugIds.add(bug.Detailed_Requirement__c );
    }

    // Folllowing SOQL queries for the User Story field from the related Detailed Requirement
    List<DetailedRequirement__c> lstDetailedRequirements = [Select User_Story__c 
                                                            From   DetailedRequirement__c 
                                                            Where  id in :bugIds];
    
    for(Bug__c bug: Trigger.new)
    {
        for (DetailedRequirement__c drq: lstDetailedRequirements )
        {
          if(bug.Detailed_Requirement__c == drq.id) 
            {
            //Here we assign the user story value to the bug         
            bug.User_Story__c = drq.User_Story__c;    
            }
        }
    }
    
}