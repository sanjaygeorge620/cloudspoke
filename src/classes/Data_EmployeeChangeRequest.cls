@isTest
public class Data_EmployeeChangeRequest {
     public static Employee_Change_Request__c createEmployeeChangeRequest(id contactID){   
      
        Account acc = Data_Account.createAccount3(); 
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);       
        System.assertEquals(contacts.size(),1); 

        List<Contact> contacts_nonAccounting = Data_Contact.createContacts_nonAccountingContact(acc.Id,1);    
      
            
        Employee_Change_Request__c cR = new Employee_Change_Request__c(Contact_Name__c=contacts_nonAccounting[0].id);       
        cR.Change_Reason__c = 'Transfer';

        insert cR;
        System.Debug(cR);       
        return cR;  
        
       
        
     }
     
     
     
     @isTest(SeeAllData=true)
      static  void testTestData() {
      
      Account acc = Data_Account.createAccount3(); 
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);       
        System.assertEquals(contacts.size(),1); 
         Employee_Change_Request__c cR = Data_EmployeeChangeRequest.createEmployeeChangeRequest(Contacts[0].id);       
         System.assert(cR.id != null);
        
      }   
}