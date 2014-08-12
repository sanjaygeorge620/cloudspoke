public with sharing class ProcessInstallations_GetOpportunity {
    public static List<Opportunity> OpportunityList (List<ID> Opportunityids){
     // Changed by Sumedha on 7/29/2013
     List<Opportunity> OpportunityRecs = new List<Opportunity>();
     OpportunityRecs = (List<Opportunity>)(Database.Query('Select Id,AccountId,Ship_To__c,Opportunity_Number__c From Opportunity Where Id in :Opportunityids'));                                                                      
        return OpportunityRecs;                                                                     
    }
}