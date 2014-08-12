/*
--- Public or Private Tasks---
Make public if contact's email address is contained within the from, to, cc, or bcc
because the email should have already been communicated to the contact
*/
trigger AutoSetTaskPublicPrivate on EmailMessage (after insert)
 
 {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
  Try {
        //Activity Set
        Set<ID> Activities = new Set<ID>();       
        for (EmailMessage emailRec : trigger.new){   
            Activities.add(emailRec.Activityid);}
       
        //Map of the Related Activity from Set
        Map<ID, Task> TaskMap = new Map<ID, Task>([select id from Task where id in :Activities]); 

        //Map of the Emails from Trigger.New to get Parent Contact Email
        Map<ID, EmailMessage> EmailMap = new Map<ID, EmailMessage>([select Parent.Contact.email from EmailMessage where id = :Trigger.New]);      
        
        //Looping through all Emails
        for(EmailMessage Email : trigger.new){ 
                Task taskObject = TaskMap.get(Email.activityID);
                If (taskObject!=null){ //Does Email have an Activity?
                      string ContactEmail = EmailMap.get(Email.Id).Parent.Contact.email;
                      system.debug('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' +ContactEmail);
                      if (ContactEmail!=null){ // Need to have a related Contact
                              boolean isPublic= false;
                              /*Contact Email*/
                              System.debug('ContactEmail: '+ContactEmail);
                              
                              /*From Address*/  if (makePublic(ContactEmail,Email.fromAddress)){isPublic=true;}
                              System.debug('From Address: '+Email.fromAddress);
                              
                              /*To Address  */  if (makePublic(ContactEmail,Email.ToAddress)){isPublic=true;}
                              System.debug('To Address: '+Email.ToAddress);
                              
                              /*CC Address  */  if (makePublic(ContactEmail,Email.CCAddress)){isPublic=true;}
                              System.debug('CC Address: '+Email.CCAddress);
                              
                              /*BCC Address */  if (makePublic(ContactEmail,Email.BCCAddress)){isPublic=true;}
                              System.debug('BCC Address: '+Email.BCCAddress);
                              
                          if (isPublic==true){
                              taskObject.IsVisibleInSelfService = true;
                              update taskObject;
                              }
                      }    
                    }
           }
         }  
         catch(Exception e){
             /*
             Don't want to hold up emails if an error occurs.
             Printing to Error Log for Analysis and follow up.
             */
             ErrorLogUtility.createErrorRecord(e.getMessage(),'Trigger: AutoSetTaskPublicPrivate','Medium','Generic');
         }
       
        
        private boolean makePublic(string ContactEmail, string EmailField){
            /*Checking if the passed value and the contact email is equal*/
            if (ContactEmail!=null && EmailField!=null){
               EmailField = EmailField.tolowercase();
               ContactEmail = ContactEmail.tolowercase();
               return EmailField.Contains(ContactEmail);
            }
        return false;
        }
}