public class AssignSolutionOwner {

    @Future

    public static void AssignSolutionOwnerName(List<ID> newSolutions) {
    ID caserecID = null;
    string emailTextBody = null;
    string yesEmail = 'No';
    string ownerName = null;
       string ownerNameID = null;
       string ownerNameID1 = null;
    //pass a list of ids
    //for each id, get the record & set the  values
        if (newSolutions!=null && newSolutions.size()>0)  {
       system.debug('before caserec');
            for (Integer i =0; i< newSolutions.size(); i++) {           
                CaseRecID = newSolutions[i];
           
                Case CaseRec = ([Select id, status, createdbyID, Solution_Developer__c, Project_Manager__c, Consultant__c, 
                                 caseNumber, Development_Type__c, ContactID, Contact.Name, Internal_Case_Account__c, Name_of_Component__c, Requirements__c 
                                 from Case where id= :caseRecID]);
       
                if (caseRec.status.startswith('03') ){                                                          //status = 03. Quote Submitted 
                    caseRec.OwnerID = caseRec.CreatedByID;
                    ownerName = caseRec.Owner.name;
  
 ownerNameID = caseRec.CreatedByID;  
              yesEmail = 'Yes';
                   
                }
                if (caseRec.status.startswith('05')&& CaseRec.Solution_Developer__c != null ){                  //status = 05. Development – Assigned
                     caseRec.OwnerID = caseRec.Solution_Developer__c;
                     ownerName = caseRec.Project_Manager__c;
ownerNameID = caseRec.Project_Manager__c;
ownerNameID1= caseRec.Solution_Developer__c;
                     yesEmail = 'Yes';
                   }
                if (caseRec.status.startswith('08')&& caseRec.Project_Manager__c != null ){                     //status = 08. QA – Ready to Assign
                     caseRec.OwnerID = caseRec.Project_Manager__c;
                     ownerName = caseRec.Owner.name;
ownerNameID = caseRec.Project_Manager__c;
                     yesEmail = 'Yes';
                    
                }
                if (caseRec.status.startswith('09') && CaseRec.Consultant__c != null ){                         //status = 09. QA – In Progress
                     caseRec.OwnerID = caseRec.Consultant__c;
                     ownerName = caseRec.Owner.name;
ownerNameID = caseRec.Consultant__c;
                     yesEmail = 'Yes';
                }
                if (caseRec.status.startswith('10') ){                                                          //status = 10. Implementation – Ready for Install
                     caseRec.OwnerID = caseRec.Project_Manager__c;
                     ownerName = caseRec.Owner.name;
ownerNameID = caseRec.Project_Manager__c;
                     yesEmail = 'Yes';
                }
                if (caseRec.status.startswith('12') ){                                                          //status = 12. On Hold
                     caseRec.OwnerID = caseRec.Project_Manager__c;
ownerNameID = caseRec.Project_Manager__c;
                     ownerName = caseRec.Owner.name;
                     yesEmail = 'Yes';
                }
                try
                {
                update caseRec;
                }
                Catch(exception e)
                {
                }
                system.debug('ownerName: ' + ownerName);
if (ownerName == null){
    ownerName = OwnerNameID;
    system.debug('ownerName' + ownerName);}

    
                   if(yesEmail == 'Yes'){
                     try
                     {
          //          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    User SendtoUser = ([select Email, name, id from User where id = :ownerName limit 1]);   // Strings to hold the email addresses to which you are sending the email.  
                    system.debug('sentto user email: ' + SendtoUser.Email);
                    Contact SendtoContact = ([select Email, name, id from Contact where email = :SendtoUser.email limit 1]);
                    system.debug('sendtocontact: ' + sendtoContact.email);
                        
                        EmailTemplate template = ([select Id from EmailTemplate where Name = 'Solution Development - Assignment Notification' limit 1]);
                        system.debug('email template : ' + template.id);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(SendtoContact.id);
                        system.debug('sendtocontact: ' + sendtoContact.id);
                        mail.setTemplateId(template.Id);
                        if(ownerNameID1 != null)
                        {
                         User SendtoUser1 = ([select Email, name, id from User where id = :ownerNameID1 limit 1]);
                         Contact SendtoContact1 = ([select Email, name, id from Contact where email = :SendtoUser1.email limit 1]);
                         List<string> emails = new List<string>();
                         emails.add(SendtoContact1.email);
                         mail.setCcAddresses(emails);
                         }
                        mail.setWhatId(caseRec.ID);
                        mail.saveAsActivity = false;
                    
                        mail.setSenderDisplayName('Solution Development');                 // Specify the name used as the display name.      
                        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                                
                        //check email results    
                        System.debug('Email result ' + results[0].IsSuccess());
                        }
                        Catch(Exception ex)
                        {}
                }
               Database.DMLOptions dlo = new Database.DMLOptions();
              dlo.EmailHeader.triggerUserEmail = false;
                dlo.EmailHeader.triggerOtherEmail = false;
               dlo.EmailHeader.triggerAutoResponseEmail = false;
                database.update(caseRec, dlo);
            }
       }
      
    }
}