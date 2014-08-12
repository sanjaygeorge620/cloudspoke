/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

Public class SitesFeedbackController extends SitesController{


//-------------------------------------------------------------------------------
// Feedback
//-------------------------------------------------------------------------------    
    
    //Feedback Options from Sites Record
    public List<SelectOption> getFeedbackOptions() {
        list<string> feedbacks = SITE_FEEDBACK_OPTIONS.split(';');
        list<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','-- None --'));
                for(String f : feedbacks){
                    options.add(new SelectOption(f,f));}
            return options;
          }
    
    public portal_feedback__c Feedback{
          get {
              if (Feedback == null)
                Feedback= new portal_feedback__c();
              return Feedback;
            }
          set;
          }
         
    public PageReference submitFeedback() {
        string retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        string refURL;
        
            try {
              //Requiring Logic
                string errormsgs ='';
                if (Feedback.Reference_Title__c==null || Feedback.Reference_Title__c.trim()=='')
                    {errormsgs+='Subject is Required <br />';} 
                if (Feedback.Reference_Type__c==null || Feedback.Reference_Type__c.trim()==''){
                    errormsgs+='Area is Required <br />';}
                if (Feedback.Comment__c==null || Feedback.Comment__c.trim()==''){
                    errormsgs+='Comment is Required <br />';}
                //print error msg    
                if (errormsgs.trim()!=''){
                    throw new SitesException(errormsgs);
                }
                
                if (retURL!=null && retURL!=''){
                    if (retURL.length() > 255) {
                        refURL= retURL.substring(0,255);}  
                } else {
                    refURL ='None';
                }       
                
                Feedback.Reference_URL__c = refURL; //Reference Type
                Feedback.Site__c = SITE_NICKNAME;
              insert Feedback;
            
            } catch (SitesException e){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
               return null;  
            } catch (DMLException e) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting Feedback'));
                  ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesFeedbackController.submitFeedback','High','DML');
                  return null;
            } 
            
            
            PageReference pageRef;
              if (retURL!=null && retURL!=''){
                  pageRef= new PageReference(retURL);}
              else{
                  pageRef= page.home;}         
              pageRef.setRedirect(true);
           return pageRef; 
          }
    


}