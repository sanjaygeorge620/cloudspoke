@isTest
private class Test_UpdateCurrentFlag {

    static testMethod void Test_UpdateCurrentFlag() {
        
		Account acc = Data_Account.createAccount3(); 
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);       
        System.assertEquals(contacts.size(),1); 
         Employee_Change_Request__c cR = Data_EmployeeChangeRequest.createEmployeeChangeRequest(Contacts[0].id); 
         cr.IsCurrent__c = True;
         update cr;
         System.assert(cR.id != null);
         Employee_Change_Request__c cR1 = Data_EmployeeChangeRequest.createEmployeeChangeRequest(Contacts[0].id);       
         System.assert(cR1.id != null);

    }
}