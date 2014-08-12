/**
 * A trigger that fires as soon as an Opportunity is set to QAStatus = Complete, which is
 * at the end of the Opportunity QA Approval Process.
 *
 * @author Ray Dehler <ray+ps@appirio.com> 2010-11-16
 */

trigger CreateInstallations on Opportunity (before update) {
    List<Opportunity> opportunities = new List<Opportunity>();
    for (Opportunity postUpdate : Trigger.new) {
        /* Only fire when QAStatus__c is being changed to Complete */
        if ( (postUpdate.SAP_Status__c == 'SUBMITTED' || postUpdate.SAP_Status__c == 'OVERRIDE') 
                    && System.Trigger.oldMap.get(postUpdate.Id).SAP_Status__c != 'SUBMITTED'
                    && System.Trigger.oldMap.get(postUpdate.Id).SAP_Status__c != 'OVERRIDE' ) {
            postUpdate.InstallationStatus__c = 'In Queue';
            opportunities.add(postUpdate);
        }
    }
    if(opportunities.size() > 0){
        //CreateInstallations.runInstallations();  
    }
}