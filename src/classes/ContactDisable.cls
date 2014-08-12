global Class ContactDisable{

   WebService static String[] DisableCallout (string RegID, String RegContactID, string RegMasterContactID, string RegApplication, String RegProfile) {
            
         //ENTER CODE HERE
         Try{
            Contact contactRec = [select firstName, LastName, id, email from Contact where id = :RegContactID];
            
            system.debug('contact rec' + contactRec);
            
            Contact MasterContactRec =[Select firstName, LastName, id, email from Contact where id = :RegMasterContactID];
            
            AccountManagementService.UserAccount userAccount = new AccountManagementService.UserAccount();
            userAccount.AccountType = RegApplication;
            system.debug('RegApplication' + RegApplication);
            system.debug('RegContactID ' + RegContactID);
            system.debug('RegMasterContactID ' + RegContactID);
            userAccount.Email = contactRec.email;
            userAccount.firstname = contactRec.FirstName;
            userAccount.LastName = contactRec.lastName;
            userAccount.ContactId = contactRec.Id;
            userAccount.MasterContactID = MasterContactRec.Id;
            //set profileType based on selection picked
            string profileID ;
            string profileName;
            system.debug('RegProfile' + RegProfile); 
            /*if (RegProfile != ''){
             profileName = 'Perceptive Customer Portal ' + RegProfile;
             system.debug('profileName' + profileName);
             profileID = [select id from Profile where name = :profileName limit 1].id;
            }else {
             profileID = '';
            }*/
            
            userAccount.SalesForceProfileId = RegProfile;
            userAccount.UserRegistrationID = RegID;
            AccountManagementService.AccountManagementServiceSoap stub = new AccountManagementService.AccountManagementServiceSoap();
            //Commented end point URL as it is pointing to production.
            //stub.endpoint_x = 'https://login.perceptivesoftware.com/SOAP/v1/AccountManagementService.asmx';
            String strEndPointDomain = LX_IDM_End_Points__c.getAll().get('EndPoint').End_Point__c;
            stub.endpoint_x = strEndPointDomain + '/SOAP/v1/AccountManagementService.asmx';
            AccountManagementService.AccountServiceResponse output;
            output = stub.Disable(userAccount);
            return output.Errors.Message;
          }
          catch (Exception err) {
               String[] error = new String[1];
               error[0] = err.getMessage();
               return error;
          }
          
         
   }
   
}