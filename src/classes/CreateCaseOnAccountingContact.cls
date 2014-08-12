/**
MODIFIED:  US1382 - 26 July 2012 - Appirio(Ben Lorenz)
           Adding check for change of language to isAccountingContactUpdate method
**/


public with sharing class CreateCaseOnAccountingContact {
    
    public static boolean isAccountingContactUpdated(Contact newContactRec , Contact oldContactRec){
        Boolean isRequired = false;
        system.debug('old contact rec: ' + oldContactRec);
        system.debug('new contact rec: ' + newContactRec);
        system.debug('new contact rec.postalcode: ' + newContactRec.Physical_Postal_Code__c);
        system.debug('old contact rec.postalcode: ' + oldContactRec.Physical_Postal_Code__c);
        if(newContactRec.FirstName != oldContactRec.FirstName 
            || newContactRec.LastName != oldContactRec.LastName
            || newContactRec.Email != oldContactRec.Email
            || newContactrec.Physical_Street_Address__c != oldContactRec.Physical_Street_Address__c
            || newContactrec.Physical_Street_Address_2__c != oldContactRec.Physical_Street_Address_2__c
            || newContactRec.Physical_City__c != OldContactRec.Physical_City__c
            || newContactrec.Address_Edit_States__c != oldContactrec.Address_Edit_States__c
            || newcontactRec.Physical_Postal_Code__c != oldContactRec.Physical_Postal_Code__c
            || newContactRec.Address_Edit_Countries__c != oldContactRec.Address_Edit_Countries__c
            || newContactRec.Region__c != oldContactRec.Region__c
            || newcontactRec.Accounting_contact__c != oldContactRec.Accounting_contact__c
            || newcontactRec.Language__c != oldContactRec.Language__c  ){
            isRequired = True;
        }
        system.debug('isRequired: ' + isRequired);
        return isRequired;
    }
    
    
   public static void createCase(set<ID>ContactIDSet, Id RecordtypeID)
   {   
     
   system.debug('increatecase:');
       List<URL_Parameter__c> mcs = URL_Parameter__c.getall().values();  
       system.debug('mcs:' + mcs); 
       string baseURL;
       if (mcs.size()>0) {
            baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); 
       }else{
           baseUrl = 'https://na5.salesforce.com';
       }
       system.debug('baseURL:'+baseUrl);
       Id queueID = [Select Id,queueid from QueueSobject  where Queue.Name = 'HelpDesk.SAP Contacts' and SobjectType ='Case' limit 1].queueid;
        Id contactId;
        String emailId;
        for(User usr : [select Id ,ContactId, Email from User where id = : userInfo.getUserId() limit 1]){
            system.debug('usr: ' + usr);
            emailId = usr.Email;              
        }
        for(Contact con : [select Id from Contact where Email = : emailId limit 1]){
            contactId  = con.id;
        }
        system.debug('contactID: ' + contactID);
        
      /*  List<Contact> contactList = new List<Contact>([select AccountID
                                                           , Account.Name
                                                           , Name
                                                           , Physical_Street_Address__c
                                                           , Account.Coverage_ID__r.Sales_Organization__c
                                                           , Account.MDM_Sold_To_Number__c
                                                           , Contact_Number__c
                                                           , Physical_Street_Address_2__c
                                                           , Physical_City__c
                                                           , Physical_Province__c
                                                           , Physical_Postal_Code__c
                                                           , Address_Edit_States__c
                                                           , Region__c
                                                           , Address_Edit_Countries__c
                                                           , Email
                                                           , SAP_Ship_To__c
                                                           , SAP_Bill_To__c
                                                           , Language__c //Added for US1190 by Manoj Kolli on 4/17/12
                                                           from Contact
                                                           where id in :ContactIDSet]);*/
                                                           

            String contactQueryStr = 'select AccountID,Account.Name,Name,Physical_Street_Address__c,Account.Coverage_ID__r.Sales_Organization__c,Account.MDM_Sold_To_Number__c,Contact_Number__c,Physical_Street_Address_2__c,Physical_City__c,Physical_Province__c,Physical_Postal_Code__c,Address_Edit_States__c,Region__c,Address_Edit_Countries__c,Email,SAP_Ship_To__c,SAP_Bill_To__c,Language__c from Contact where id in :ContactIDSet';
            
            List<Contact> contactList = new List<Contact>((List<Contact>)(database.query(contactQueryStr)));    

            
        
        String [] caseType = new List<String>();
        caseType.add('Bill To');
        caseType.add('Ship To');

        List<Case> newCases = new List<Case>();
        for(Integer s =0;s<caseType.size();s++){
            
            for(Contact contactRec : contactList){
            
            //-----------------Shravani for US1884 ------------------------------
                String attn = '';
                
                if(ContactRec.Language__c == 'Dutch' || ContactRec.Language__c == 'German' ||ContactRec.Language__c == 'English')
                {
                attn = Translation__c.getAll().get(ContactRec.Language__c).Translation__c;
                system.debug('attn' + attn );
                }
                else
                {
                attn = Translation__c.getAll().get('English').Translation__c;
                }      
              
        //-----------------Shravani for US1884 ------------------------------  
                
                String street4 = '';
                String street2 = '';
                If(contactRec.Address_Edit_Countries__c == 'United States' || contactRec.Address_Edit_Countries__c == 'USA'){
                    street4 = contactRec.Physical_Street_Address_2__c;
                }else{
                    street2 = contactRec.Physical_Street_Address_2__c;
                }
                
                String region_State = '';
                if(contactRec.Address_Edit_States__c != null){
                    region_State = contactRec.Address_Edit_States__c;
                }else{
                    region_State = contactRec.Physical_Province__c;
                }
                String SAPType;
                if (caseType[s] == 'Bill To'){
                    SAPType = contactRec.SAP_Bill_To__c;
                }else{
                    SAPType = contactRec.SAP_Ship_To__c;
                }
                
                
                Case newCase =  new Case(
                                        Type = 'Request'
                                      ,Category__c = 'Enterprise Application'
                                      , Level_1__c = 'SAP');
                    newCase.Level_2__c = caseType[s];       
                                
                    //newCase.ownerId = '00G70000001ewUE';//queueId;
                    newCase.ownerId = queueId;
                   // newCase.ownerId = UserInfo.getUserId();
                    
                    newCase.RecordTypeId = RecordtypeID;
                    system.debug('CreateCase - UserInfo.getUserType()' + UserInfo.getUserType());
                    if (UserInfo.getUserType() != 'Standard')
                    {
                        //NewCase.ContactID = '0037000000t4gzv';
                        //4.25.2013 from 139 to 141
                        //NewCase.ContactID = '003i0000007RLHA';
                         NewCase.ContactID = Lx_SetRecordIDs.AutomationAdminContactId;
                        
                    }else{
                        newCase.ContactId  = contactID;
                    }   
                    
                    newCase.Subject = caseType[s] + ' Request - Sales Org: ' + contactRec.Account.Coverage_ID__r.Sales_Organization__c
 
                                        + ' - Salesforce ID: ' + contactRec.get('Contact_Number__c')
                                        + ' - Sold to # ' + contactRec.Account.MDM_Sold_To_Number__c;
                    
                    newCase.Description = 'Sold To to Link To: ' +  contactRec.Account.MDM_Sold_To_Number__c + '\n'
                                        + 'Company & Sales Org: ' + contactRec.Account.Coverage_ID__r.Sales_Organization__c + '\n'
                                        + '\n'
                                        + 'Customer Name: '+ contactRec.Account.Name +'\n'
                                        + 'Customer Line 4: '+ attn +''+contactRec.Name +'\n'                          //-----------------Shravani for US1884 ------------------------------
                                        + 'Search Term: ' + contactRec.Name + '\n'
                                        + 'Street/House No.: ' + contactRec.Physical_Street_Address__c + '\n'
                                        + 'Street 4: ' + street4  + '\n'
                                        + 'Street 2: ' + street2 + '\n'
                                        + 'City: ' + contactRec.Physical_City__c + '\n'
                                        + 'Postal Code: ' + contactRec.Physical_Postal_Code__c + '\n'
                                        + 'Region/State: ' + region_state + '\n'
                                        + 'Country: ' + contactRec.Address_Edit_Countries__c + '\n'
                                        + 'Preferred Language: ' + contactRec.Language__c + '\n' //Added for US1190 by Manoj Kolli on 4/17/12
                                        + 'Email ID (for DFM FOM): ' + contactRec.Email + '\n'
                                        + 'Previous Account Num: ' + contactRec.get('Contact_Number__c') + '\n'
                                        + caseType[s]+ ': ' + SAPType + '\n'
                                        + 'Contact: ' + baseUrl + '/' + contactRec.id ; 
                                          
                                          
                    system.debug('return new case: ' + newCase); 
                    newCases.add(newCase); 
            }    
        }                               
        insert newCases;
                
    }
}