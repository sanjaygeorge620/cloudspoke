global Class ContactEnable{
    /**************************************
     Description: Made as asynchronous since the method is called from AutoCreated_Enable trigger in User Registration object 
     *            Added Line 12,changed the webservice method return type from String[] to void in line 13 
     *            and Commented line 49 and 54. Modified line 36 from Perceptive Customer Portal to perceptive Partner Portal
     *
     Date Modified: 12/22/2011
     *
     By: Manoj Kolli
     *****************************************/  
    
   @future(callout=true) 
   WebService static void EnableCallout (string RegID, String RegContactID, string RegMasterContactID, string RegApplication, String RegProfile) {
            
         //ENTER CODE HERE
         Try{
            Contact contactRec = [select firstName, LastName, id, email from Contact where id = :RegContactID];
            
            system.debug('contact rec' + contactRec);
            
            Contact MasterContactRec =[Select firstName, LastName, id, email from Contact where id = :RegMasterContactID];
            
            AccountManagementService.UserAccount userAccount = new AccountManagementService.UserAccount();
            userAccount.AccountType = RegApplication;
            system.debug('RegApplication' + RegApplication);
            system.debug('RegContactID ' + RegContactID);
             system.debug('RegContactID ' + contactRec.Id);
            system.debug('RegMasterContactID ' + RegMasterContactID);
             system.debug('MasterContactRec ID ' + MasterContactRec.Id);
            userAccount.Email = contactRec.email;
            userAccount.firstname = contactRec.FirstName;
            userAccount.LastName = contactRec.lastName;
            userAccount.ContactId = contactRec.Id;
            useraccount.MasterContactId = MasterContactRec.Id;
            //set profileType based on selection picked
            string profileID ;
            string profileName;
            system.debug('RegProfile' + RegProfile); 
           /* if (RegProfile != ''){
             profileName = 'Perceptive Partner Portal ' + RegProfile;
             system.debug('profileName' + profileName);
             profileID = [select id from Profile where name = :profileName limit 1].id;
            }else {
             profileID = '';
            }*/
            system.debug('profileID: ' + profileID);
            //userAccount.SalesForceProfileId = profileID;
            userAccount.SalesForceProfileId = RegProfile;
            userAccount.UserRegistrationID = RegID;
            AccountManagementService.AccountManagementServiceSoap stub = new AccountManagementService.AccountManagementServiceSoap();
            //Commented end point URL as it is pointing to production.
            //stub.endpoint_x = 'https://login.perceptivesoftware.com/SOAP/v1/AccountManagementService.asmx';
            String strEndPointDomain = LX_IDM_End_Points__c.getAll().get('EndPoint').End_Point__c;
            stub.endpoint_x =  strEndPointDomain + '/SOAP/v1/AccountManagementService.asmx';
            system.debug('END POINT:' +stub.endpoint_x);
            AccountManagementService.AccountServiceResponse output;
            output = stub.Enable(userAccount);
            //return output.Errors.Message;
          }
          catch (Exception err) {
               String[] error = new String[1];
               error[0] = err.getMessage();
               //return error;
          }
          
         
   }
   
}