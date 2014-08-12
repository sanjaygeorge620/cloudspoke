trigger UpdateTaskOnNewCaseEmail on EmailMessage (after insert) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code

  try{
    List<EmailMessage> newEmails = trigger.new;
   
   processCaseNewEmail.CaseNewEmail(newEmails);
   }
   catch(Exception e){ 

            //Continue processing
            } 


}