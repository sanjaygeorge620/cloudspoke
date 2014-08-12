trigger Employee_Referral_Approval on Employee_Referral__c (After Insert) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code

          for(Employee_Referral__c emp : trigger.new)
          {
          
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(emp.Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            System.debug('Submitted for approval successfully: '+result.isSuccess());
            
           }


}