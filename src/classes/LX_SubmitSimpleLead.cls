/**************************************************************
Trigger Name   : SubmitSimpleLead
Created by   : Sneha
Created Date : 03/Oct/2013
Modified By : Sneha
Modified Date : 03/Oct/2013
Purpose      : When a Simple Lead is created, it must be submitted for approval on-click of Convert button. This class is called on click of
               Convert button and submits the lead for approval. 
***************************************************************/


public with Sharing class LX_SubmitSimpleLead{
    
    public LX_SubmitSimpleLead(ApexPages.StandardController stdController) {
        
    }
    
    public pageReference submitLeadForApproval(){
        
        String theId = '';
        Boolean submitForApproval = false;
        Boolean convertLeads = false;
        theId = Apexpages.CurrentPage().getParameters().get('id');
        List<Lead> leads = [Select Status, Region__c, Submitter__c, ApproverBasedOnLocation__c, ApproverBasedOnLocation2__c, RecordSubmittedForApproval__c, RecordRejectedAtApproval__c, LX_Party_Group__c, Business_Unit__c, LX_ISS_Coverage_Model__c from Lead where id =: theId];
        submitForApproval = leads[0].RecordSubmittedForApproval__c;
        System.debug('&&&& Leads '+leads);
        
        String UsaApprover1 = Label.ApproverForUSA;
        String GermanyApprover1 = Label.ApproverForGermany;
        String UsaApprover2 = Label.ApproverForUSA2;
        String GermanyApprover2 = Label.ApproverForGermany2;
                       
                       
        List<User> SubmitterManager = [Select Id, Name, ManagerId from User where id =:UserInfo.getUserId() AND ManagerId != null];             
        List<User> ApproverList = [Select Id, Name, LastName, FirstName from User where (Name =:UsaApprover1 OR Name =:GermanyApprover1 OR Name =:UsaApprover2 OR Name =:GermanyApprover2) AND isActive = true];
        /*for(Lead l :leads){
            
             //Get the details of the user who submitted the request  
                l.Submitter__c = UserInfo.getUserId();
                System.debug('&&** User Id: '+UserInfo.getUserId() + 'l.Submitter__c '+l.Submitter__c);
                
                //Get the details of submitter's Manager
                if(SubmitterManager.size() > 0)
                    l.LX_SubmitterManager__c= SubmitterManager[0].ManagerId;    
        
        }
        //Update lead record here to make sure that the manager details are available for approval process.
        if(leads.size()>0)
            update leads; */
        
        for(Lead l :leads){
        if (l.LX_Party_Group__c == 'Partner' && l.Business_Unit__c == 'ISS' ||( l.Business_Unit__c == 'ISS' && l.LX_Party_Group__c == 'Customer' && (l.LX_ISS_Coverage_Model__c == 'OLA' || l.LX_ISS_Coverage_Model__c == 'SMB'))) {
            
            //Submit the lead if it is not submitted already or was rejected by an approval process
            if((!l.RecordSubmittedForApproval__c && l.Status == 'Open') || (!l.RecordSubmittedForApproval__c && l.RecordRejectedAtApproval__c && l.Status != 'Qualified'))
            {
                //If a Lead was rejected by the approval process - Set its status to open and reset RecordRejectedAtApproval__c
                if(l.RecordRejectedAtApproval__c){
                    l.Status = 'Open';
                    l.RecordRejectedAtApproval__c = false;
                }
                
               //Get the details of the user who submitted the request  
                l.Submitter__c = UserInfo.getUserId();
                System.debug('&&** User Id: '+UserInfo.getUserId() + 'l.Submitter__c '+l.Submitter__c);
                
                //Get the details of submitter's Manager
                if(SubmitterManager.size() > 0)
                 l.LX_SubmitterManager__c= SubmitterManager[0].ManagerId; 
                
                //Update lead record here to make sure that the manager details are available for approval process.
                update l;
                
                //Check if the approvers are set
                if(l.ApproverBasedOnLocation__c == null || l.ApproverBasedOnLocation2__c == null)
                    {

                           for(User approver : ApproverList){
                               if(l.Region__c == 'North America'){
                                   if(approver.Name == UsaApprover1)
                                       l.ApproverBasedOnLocation__c = approver.Id;
                                   
                                   if(approver.Name == UsaApprover2)
                                       l.ApproverBasedOnLocation2__c = approver.Id;
                               }
                               else
                               if(l.Region__c == 'EMEA'){
                                   if(approver.Name == GermanyApprover1)
                                       l.ApproverBasedOnLocation__c = approver.Id;
                                   
                                   if(approver.Name == GermanyApprover2)
                                       l.ApproverBasedOnLocation2__c = approver.Id;
                               }
                               System.debug('***** System.debug l.ApproverBasedOnLocation__c ' +l.ApproverBasedOnLocation__c +' Name : '+approver);
                               System.debug('&&&& Users ' + ApproverList);
                           }
                    }
                
                 
                
                    
                // create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                System.debug('***** In First if ');
                req.setObjectId(l.Id);
                // submit the approval request for processing
                Approval.ProcessResult result = Approval.process(req);
                
                l.RecordSubmittedForApproval__c = true;
                submitForApproval = l.RecordSubmittedForApproval__c;
                    
                
                
                // display if the reqeust was successful
                System.debug('Submitted for approval successfully: '+result.isSuccess());
                
            }
            else
            if(!l.RecordSubmittedForApproval__c && l.Status == 'Qualified' ){ //&& l.Owner == 'Key_Users'
                convertLeads = true;
                System.debug('***** In Second if ');
            }
            System.debug('+++++ l.RecordSubmittedForApproval__c '+l.RecordSubmittedForApproval__c +'l.Status '+l.Status);
            System.debug('^^^^^^ convertLeads '+convertLeads +' Leads: '+l);
        }
        else
            submitForApproval = false;
            
            System.debug('&&&&& submitForApproval '+submitForApproval);
            
          
      }
      
      if(!leads[0].RecordSubmittedForApproval__c || convertLeads == true) // submitForApproval 
      {
          System.debug('***** In Convert Leads if ');
          //update leads; // Causes the trigger to execute
          String pg = '/lead/leadconvert.jsp?retURL=%2F'+theId+'&id='+theId+'&nooppti=1';
          PageReference convertLeadPg = new PageReference(pg);
          System.debug('**** page '+pg);
          return convertLeadPg;
      }
      
    
        
    if(leads.size() > 0){
        //update leads;
    }    
    PageReference pageRef = new PageReference('/' + theId);
    pageRef.setRedirect(true);
    return pageRef;
    }

}