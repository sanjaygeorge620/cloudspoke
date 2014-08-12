global Class MasterContactSetController{


  WebService static boolean makeCallout (string email, string newMasterContactId) {
            
            Contact newMasterContact =[Select firstName, LastName, id, email from Contact where id = :newMasterContactID];
            AccountManagementService.AccountServiceResponse output;
            //ENTER CODE HERE
            
                AccountManagementService.AccountManagementServiceSoap stub = new AccountManagementService.AccountManagementServiceSoap();
                //Commented end point URL as it is pointing to production.
                //stub.endpoint_x = 'https://login.perceptivesoftware.com/SOAP/v1/AccountManagementService.asmx';
                String strEndPointDomain = LX_IDM_End_Points__c.getAll().get('EndPoint').End_Point__c;
                stub.endpoint_x = strEndPointDomain + '/SOAP/v1/AccountManagementService.asmx';
             if(!test.isrunningtest())
            {
               
                system.debug('End Point == '+stub.endpoint_x);
                output = stub.setasMaster(eMail,newMasterContact.Id);
                system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +output);
                return output.ActionSuccessful;
            }
                return null;
       }
}