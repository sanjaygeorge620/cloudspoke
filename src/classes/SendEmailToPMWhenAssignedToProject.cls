public with sharing class SendEmailToPMWhenAssignedToProject {



    @Future

    public static void SendEmail(List<ID> newProject) {
    ID projectRecID = null;
    string emailTextBody = null;
    
    //pass a list of ids
    //for each id, get the record & set the  values
        if (newProject!=null && newProject.size()>0)  {
       system.debug('before project');
            for (Integer i =0; i< newProject.size(); i++) {           
                projectRecID = newProject[i];
                pse__Proj__c projectRec = [select pse__project_Manager__c
                                                , pse__Account__r.owner.Email
                                                , pse__Account__r.ISR__r.Email 
                                                from pse__Proj__c where id = :projectRecID];
           
           //          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //        User SendtoUser = ([select Email, name, id from User where id = :projectRec.pse__project_Manager__c limit 1]);   // Strings to hold the email addresses to which you are sending the email.  
             //       system.debug('sentto user email: ' + SendtoUser.Email);
             //       Contact SendtoContact = ([select Email, name, id from Contact where email = :SendtoUser.email limit 1]);
             //       system.debug('sendtocontact: ' + sendtoContact.email);
                        
                        EmailTemplate template = ([select Id from EmailTemplate where Name = 'PSE: Notify PM of new Project' limit 1]);
                        system.debug('email template : ' + template.id);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(projectRec.pse__project_Manager__c);
                        system.debug('projectRec.pse__project_Manager__c: ' +projectRec.pse__project_Manager__c);
                        system.debug('projectRec.pse__Account__r.owner.Email: ' +projectRec.pse__Account__r.owner.Email);
                        system.debug('projectRec.pse__Account__r.ISR__r.Email: ' +projectRec.pse__Account__r.ISR__r.Email);
                        system.debug('projectRec.pse__Account__r.ISR__c: ' +projectRec.pse__Account__r.ISR__c);
                        mail.setTemplateId(template.Id);
                        mail.setWhatId(projectRec.ID);
                        mail.saveAsActivity = false;List<String> ccAddresses = new list<String> ();
                        ccAddresses.add(projectRec.pse__Account__r.owner.Email);
                        if (projectRec.pse__Account__r.ISR__c != null) {
                            ccAddresses.add(projectRec.pse__Account__r.ISR__r.Email);
                        }
                        mail.setCcAddresses(ccAddresses);
                        mail.setSenderDisplayName('Professional Services');                 // Specify the name used as the display name.   
                        //Added by Charan on 20-09-2013 for overcoming MASS EMAIL error in times of Deployment   
                        if(!test.isRunningTest()){
                            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
                                    
                            //check email results    
                            System.debug('Email result ' + results[0].IsSuccess());
                        }
               Database.DMLOptions dlo = new Database.DMLOptions();
              dlo.EmailHeader.triggerUserEmail = false;
                dlo.EmailHeader.triggerOtherEmail = false;
               dlo.EmailHeader.triggerAutoResponseEmail = false;
                database.update(projectRec, dlo);
            }
       }
      
    }

}