public class LX_AssignSolutionOwner {

   /* Class Name   : LX_AssignSolutionOwner 
    * Description   : This is a class written to send mails to Case Owners.
    * Created By   : Maruthi
    * Created Date : 22-07-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi                 22-07-2013               1000                  Initial Version    
    */ 
    
    ID caserecID = null;
    string emailTextBody = null;
    string yesEmail = 'No';
    string ownerName = null;
    string ownerNameID = null;
    Messaging.SingleEmailMessage objMail = null;
    //pass a list of ids
    //for each id, get the record & set the  values
    List<Case> lstCaseRecords = new List<Case>();
    //Declare a list to store collection of ownernames
    List<string> lstOwners = new List<string>();
    //Declare MAP to store case record ID and Case Owner Name
    Map<String,Case> mapCaseOwnerDetails = new Map<String,Case>();
    //Declare MAP to store Owner Email and Owner ID
    Map<String,String> mapOwnerDetails = new Map<String,String>();
    //Create set to store Owner Ids
    Set<String> setOwners = new Set<String>();
    //Declare a list to store email message object
    List<Messaging.SingleEmailMessage> lstMailMessage = new List<Messaging.SingleEmailMessage>();
    Map<String,Contact> mapContacts = new Map<String,Contact>();
    //Create variable to store email template
    EmailTemplate objTemplate = null;


    public void AssignSolutionOwnerName(List<Case> lstCaseRecords) {
   /* Description : It accepts collection of Case records and finds its Case owner .
    *  Param - NA
    *  Returns :  VOID
    */
        
        //Check if solutions list is empty if it is then return null.
        if(lstCaseRecords == null || lstCaseRecords.size() <= 0) return;
        //Get email Solution Development - Assignment Notification template 
        objTemplate = ([select Id from EmailTemplate where Name = 'Solution Development - Assignment Notification' limit 1]);
        
        for(Case objCase : lstCaseRecords)
        {
            if (objCase.status.startswith('03') ){   
                //status = 03. Quote Submitted 
                objCase.OwnerID = objCase.CreatedByID;
                ownerName = objCase.Owner.name;
                ownerNameID = objCase.CreatedByID;  
                yesEmail = 'Yes';
            }
            if (objCase.status.startswith('05')&& objCase.Solution_Developer__c != null ){  
                //status = 05. Development – Assigned
                objCase.OwnerID = objCase.Solution_Developer__c;
                ownerName = objCase.Project_Manager__c;
                ownerNameID = objCase.Project_Manager__c;
                yesEmail = 'Yes';
            }
            if (objCase.status.startswith('08')&& objCase.Project_Manager__c != null ){ 
                //status = 08. QA – Ready to Assign
                objCase.OwnerID = objCase.Project_Manager__c;
                ownerName = objCase.Owner.name;
                ownerNameID = objCase.Project_Manager__c;
                yesEmail = 'Yes';
            }
            if (objCase.status.startswith('09') && objCase.Consultant__c != null ){   
                //status = 09. QA – In Progress
                objCase.OwnerID = objCase.Consultant__c;
                ownerName = objCase.Owner.name;
                ownerNameID = objCase.Consultant__c;
                yesEmail = 'Yes';
            }
            if (objCase.status.startswith('10') ){     
                //status = 10. Implementation – Ready for Install
                objCase.OwnerID = objCase.Project_Manager__c;
                ownerName = objCase.Owner.name;
                ownerNameID = objCase.Project_Manager__c;
                yesEmail = 'Yes';
            }
            if (objCase.status.startswith('12') ){           
                //status = 12. On Hold
                objCase.OwnerID = objCase.Project_Manager__c;
                ownerNameID = objCase.Project_Manager__c;
                ownerName = objCase.Owner.name;
                yesEmail = 'Yes';
            }
            //update caseRec;
            system.debug('ownerName: ' + ownerName);
            if (ownerName == null){
                ownerName = OwnerNameID;
                lstOwners.add(ownerName);
            }
            if(yesEmail == 'Yes')
            { 
                //Add CaseID and OwnerID  with * as delimiter in map
                String strKey = objCase.Id + '*' + ownerName;
                mapCaseOwnerDetails.put(strKey,objCase);
                setOwners.add(ownerName);
            }
        }
        
        //Check the size of case owners list and call getEmailAddressList
        if(setOwners.size() >= 0) getEmailAddressDetails();
        
        //prepare mail message and update cases
        sendMailAndUpdCases(lstCaseRecords);
      
    }
    
    private void sendMailAndUpdCases(List<Case> lstCaseRecords)
    {
   /*  Description : It accepts collection of Case records and send mail to its Contact
    *  Param - lstCaseRecords: Collection of Case records 
    *  Returns :  VOID
    */    
        //Declare string variable to store Email value
        String strEmail = '';
        Contact objContact = null;
        //Iterate Case records
        for(Case objCase : lstCaseRecords)
        {
            //Get Owner Email from map
            strEmail = ((mapOwnerDetails != null && mapOwnerDetails.size() > 0) ? mapOwnerDetails.get(objCase.Owner.name) : '');
            
            //Get contact Id from the email 
            if(strEmail != '')
                objContact = ((mapContacts != null && mapContacts.size() > 0) ? mapContacts.get(strEmail) : null);
                
            //Prepare mail message
            prepareMailMessage(objCase,objContact);
        
        }
        
        //Check list of mail messages and send mails
        List<Messaging.SendEmailResult> results = null;
        if(lstMailMessage.size() > 0)
            results = Messaging.sendEmail(lstMailMessage);
            
        //Update Case records here
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
        dlo.EmailHeader.triggerOtherEmail = false;
        dlo.EmailHeader.triggerAutoResponseEmail = false;
        database.update(lstCaseRecords, dlo);
    
    }
    
    private void prepareMailMessage(Case objCase, Contact objContact)
    {
   /*  Description : It accepts Case and its Contact as inputs and prepares mail that needs to be send.
    *  Param - objCase: Case
    *  Param - objContact: Contact
    *  Returns :  VOID
    */ 
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(objContact != null)
            mail.setTargetObjectId(objContact.id);
        mail.setTemplateId(objTemplate.Id);
        if(objCase != null)
            mail.setWhatId(objCase.ID);
        mail.saveAsActivity = false;
        List<string> emails = new List<string>();
        emails.add(objContact.email);
        mail.setCcAddresses(emails);
        mail.setSenderDisplayName('Solution Development'); // Specify the name used as the display name.     
        //Add mail object to lsit here
        lstMailMessage.add(mail);       
        //List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    private void getEmailAddressDetails()
    {
      /* Description : It retrieves the email address of the Case Owner and finds the associated Contact.
       *  Param - NA
       *  Returns :  VOID
       */
        //Create a map to store Owner Email as Key and Owner ID as Value.
        for(User objUser : [select Email, name, id from User where id in: setOwners])
        {
            mapOwnerDetails.put(objUser.Name, objUser.Email);
        }
        //Query contact object based on Case Owner IDs email 
        for(Contact objContact : [select Email, name, id from Contact where email in: mapOwnerDetails.keySet()])
        {
            //Add Key as Case id and value as Contact Record
            mapContacts.put(objContact.Email,objContact);
        }
    }
}