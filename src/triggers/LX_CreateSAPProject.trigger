trigger LX_CreateSAPProject on SAP_Contract__c (after insert, after update) {
    // Get the Opportunity details from the SAP Contract record when Opportunity is not null
    Set<Id> setOpptyIds = new Set<Id>();
    List<LX_Project_SAP_Contract__c> lstProjSapContract = new List<LX_Project_SAP_Contract__c>();
    for(SAP_Contract__c sapCon: trigger.new) {
        if(sapCon.Opportunity__c != null) {
            setOpptyIds.add(sapCon.Opportunity__c);
        }
    }
    if(setOpptyIds.size() >0){
        map<Id, Opportunity> mapOpportunities = new map<Id,Opportunity>([Select Id,(Select Id from pse__Projects__r) from Opportunity where Id in :setOpptyIds]);


        for(SAP_Contract__c sapCon: trigger.new) {
            if(mapOpportunities.get(sapCon.Opportunity__c) != null && mapOpportunities.get(sapCon.Opportunity__c).pse__Projects__r.size() >0){
                //If any projects found for the opportunity then create a SAP Project record:
                for(pse__Proj__c proj: mapOpportunities.get(sapCon.Opportunity__c).pse__Projects__r){
                    lstProjSapContract.add(new LX_Project_SAP_Contract__c(LX_Project__c = proj.Id, LX_SAP_Contract__c = sapCon.Id));
                }            
            }
        }
        try{
            // Insert any SAP Project Contract records if found.
            insert lstProjSapContract;
        }
        catch(Exception e){
            // If any exception found ....
        }
    }
}