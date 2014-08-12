trigger ProcessInstallations on Opportunity (before update) {

        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;      


    List<ID> opportunities = new List<ID>();
    for (Opportunity postUpdate : Trigger.new) {
        /* Only fire when QAStatus__c is being changed to Complete */
        if ( (postUpdate.SAP_Status__c == 'SUBMITTED' || postUpdate.SAP_Status__c == 'OVERRIDE') 
                    && System.Trigger.oldMap.get(postUpdate.Id).SAP_Status__c != 'SUBMITTED'
                    && System.Trigger.oldMap.get(postUpdate.Id).SAP_Status__c != 'OVERRIDE') {
            //US3823 - Avoiding Non-Tradional Programs from entering the loop
            if(postUpdate.LX_Local_Program_ID__c  != Label.LX_NonStandardUser){
                postUpdate.InstallationStatus__c = 'Started';
            }
        }
    }
    system.debug('opportunities.size(): '+ opportunities.size() );
}