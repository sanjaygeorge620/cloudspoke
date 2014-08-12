@isTest
private class Test_UpdateContactAddress {

    static testMethod void Test_UpdateContactAddress() {
/*      Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3); 
         
        
        //update standard address fields
        For (Contact contactRec : contacts){
            contactRec.MailingStreet = '12365 Street';
            contactRec.MailingCity = 'TestingCity';
            contactRec.MailingState = 'Alabama';
            contactRec.MailingPostalCode = '12365';
            contactRec.MailingCountry = 'United States';
            contactRec.Accounting_Contact__c = false;
        }   
                
        system.debug('contacts:' + contacts);
        test.startTest();
        update contacts;
        test.stopTest();
        
        system.AssertEquals('12365 Street',
            [select Physical_Street_Address__c from Contact where id = :contacts[0].id].Physical_Street_Address__c);
            
        system.AssertEquals('TestingCity',
            [select Physical_City__c from Contact where id = :contacts[0].id].Physical_City__c);

        system.AssertEquals('Alabama',
            [select Address_Edit_States__c from Contact where id = :contacts[0].id].Address_Edit_States__c);
            
        system.AssertEquals('12365',
            [select Physical_Postal_Code__c from Contact where id = :contacts[0].id].Physical_Postal_Code__c);  
        
        system.AssertEquals('United States',
            [select Address_Edit_Countries__c from Contact where id = :contacts[0].id].Address_Edit_Countries__c);    
        */              
    }
}