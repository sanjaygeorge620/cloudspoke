public with sharing class NotifyNewOpportunity_Project {
  public static void NotifyNewOpportunity_Project (List<ID> contactIdSet, ID opportunityID){
    EmailTemplate template = ([select Id from EmailTemplate where Name = 'NewOpportunityNotification_Project' limit 1]);
    for (Integer i =0;i<contactIdset.size();i++){
                
         system.debug('email template : ' + template.id);
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setTargetObjectId(contactIdSet[i]);        //use for production - sends email to Contact email address
         //mail.setTargetObjectId('0037000000XOCLm');      //use this for testing - send to Jennifer Dauernheim Contact email address
         system.debug('sendtocontact: ' + contactIdset[i]);
         mail.setWhatId(opportunityID);                
         mail.setTemplateId(template.Id);
        
         mail.saveAsActivity = false;
                      
         mail.setSenderDisplayName('Perceptive Software');                 // Specify the name used as the display name.
         //Added by Charan on 20-09-2013 for overcoming MASS EMAIL error in times of Deployment
            if(test.isRunningTest()){      
         List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
                                  
         //check email results    
         System.debug('Email result ' + results[0].IsSuccess());
         }
    }
  }

}