/***************************************************************************
Trigger Name   : PSE_BillingEventDetermineApprover
Created by     : Appirio
Created Date   : November 11, 2009
Purpose        : Set the Approver to be the Project's PM. 
*****************************************************************************/

trigger PSE_BillingEventDetermineApprover on pse__Billing_Event__c (after insert) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    Set<String>  setBillingEventID = new Set<String>();

    // Create a list to hold Billing Events that have been inserted
    List< pse__Billing_Event__c > Billing_Events = new List< pse__Billing_Event__c >();
    Boolean flagUpdate = false;

    // Set approver to be the Project's PM for every BillingEvent that is inserted
    // First get list of ID's to use in lookup
    For(pse__Billing_Event__c  billingevents : Trigger.New){ 
        setBillingEventID.Add(billingevents.ID);
    }
          

    // Now get the PM's SFDC User Id
    Billing_Events = [SELECT id, pse__Project__c, 
                    pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c,
                    pse__Approver__c, pse__Project__r.pse__Project_Manager__r.Name  
                    from pse__Billing_Event__c
                    where id in : setBillingEventId];

    // Now set the Approver to be the PM's SFDC User Id
    for(pse__Billing_Event__c billingevent :Billing_Events){
        if(billingevent.pse__Project__r.pse__Project_Manager__c != null){
                //System.debug('DEBUG BE Approver: ' + billingevent.pse__Project__r.pse__Project_Manager__r.Name);
                billingevent.pse__Approver__c = billingevent.pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c;
                flagUpdate = true;
        }
    }

    if(flagUpdate)
        update Billing_Events;

// NOTE: Uncomment this section if SFDC Approval process to be used on Billing Events -S.Clune 11/17/09
//  
//  // Initiate approval process for all Billing Events (note Approval process will hit when BE has status of 'Submitted; which is default status)
//  For(pse__Billing_Event__c  approve_billingevents : Trigger.New){
//      Approval.ProcessSubmitRequest approval_request = new Approval.ProcessSubmitRequest();
//      approval_request.setComments('Submitting Billing Event for approval.');
//      approval_request.setObjectId(approve_billingevents.id);
//      Approval.ProcessResult rqst_result = Approval.Process(approval_request);
//      System.assert(rqst_result.isSuccess());
//  } 
}