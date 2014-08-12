@istest(seeAllData = true)
public class Data_Contact
{
 public static List<Contact> QueryContacts(ID accid)
 {
 //changed on 4.16.2013 from 16-17 lines
 List<Contact> contacts = [Select ID,Lastname,Firstname,Accountid,Contact_Role__c, 
                           Region__c,email,Physical_street_address__c,
                           Physical_City__c,
                           address_edit_countries__c,
                           License_Contact__c,
                          // pse__Salesforce_User__c,
                           Accounting_Contact__c,
                           areas_of_need__c,
                           //pse__Is_Resource__c,
                          // pse__Is_Resource_Active__c,
                          // pse__Action_Update_Current_Time_Period__c,
                         //  phone from Contact where AccountID =: accid and Portal_User_Type__c = '' and email != '' and pse__Salesforce_User__c != null];
                           phone from Contact where AccountID =: accid and Portal_User_Type__c = '' and email != '' and License_Contact__c = true];
                           return contacts; 
 }
 
 

 public static List<Contact> createContacts(Id accountId,Integer size){  
   system.debug('Acct ID in Contact######' + accountID);
     List<Contact> contacts = new List<Contact>();    
     Set<Id> contactIds = new Set<Id>();    
     Contact con;  
     
     Set<String> userProfile = new Set<String>();
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           ProfileIds.add(profile.id);
      } 
      //4.17.2013 from 37 to 39
      //ProfileIds.add('00ei0000000WaeA');   
      //ProfileIds.add('00ei0000000WaeAAAS');         

      //List<User> userList = Data_User.createUser(1, profileIds);       
    // system.debug('userLIst in datacontact: ' + userList);
     String varAlias = string.valueof(system.currentTimeMillis());
     system.debug('varAlias' + varAlias);
     Integer aliaslength = varAlias.length();  
     integer u = 0;
     for(Integer i =0;i<size;i++){        
         con = new Contact(
                           LastName='Test Contact1 '+i+varAlias.subString(aliaslength-2,aliaslength),
                           firstName='TestFirst',
                           AccountId = accountId,
                           Contact_Role__c ='Executive', 
                           Region__c='NA',
                           email='test'+i+varAlias.subString(aliaslength-2,aliaslength)+'@lexmark.com',
                           Physical_street_address__c = '74553 W',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           License_Contact__c=true,
                           //pse__Salesforce_User__c = userList[u].id,
                           Accounting_Contact__c = true,
                           areas_of_need__c = 'Content',
                          pse__Is_Resource__c = true,
                          pse__Is_Resource_Active__c = true,
                          // pse__Action_Update_Current_Time_Period__c = false,
                           phone='123456789'+i,
                           MobilePhone='9123456789',
                            Fax='9123456789',
                           Status__c = 'Active' ,
                           Industry__c = 'Manufacturing',
                           Lx_Lexmark_Vertical__c='Manufacturing');
                           system.debug('new contact record: ' + con);
           if (u < profileIDs.size()-1){
                u++;
                system.debug('u:' + u);

           }
         contacts.add(con);   
     }
     insert contacts;
     
     return contacts;
  }    
  
  public static List<Contact> createContacts_nonAccountingContact(Id accountId,Integer size){    
     List<Contact> contacts = new List<Contact>();    
     Set<Id> contactIds = new Set<Id>();    
     Contact con;  
     
     Set<String> userProfile = new Set<String>();
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      /*for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           ProfileIds.add(profile.id);
      } */
      
      //4.17.2013 from 92 to 94
      //ProfileIds.add('00ei0000000WaeA');   
      ProfileIds.add('00ei0000000WaeAAAS');         
      
      //List<User> userList = Data_User.createUser(1, profileIds);       
     //system.debug('userLIst in datacontact: ' + userList);
     String varAlias = string.valueof(system.currentTimeMillis());
     system.debug('varAlias' + varAlias);
     Integer aliaslength = varAlias.length();  
     integer u = 0;
     for(Integer i =0;i<size;i++){        
         con = new Contact(
                           LastName='Test Contact '+i+varAlias.subString(aliaslength-2,aliaslength),
                           firstName='TestFirst',
                           AccountId = accountId,
                           Contact_Role__c ='Executive', 
                           Region__c='NA',
                           email='test'+i+varAlias.subString(aliaslength-2,aliaslength)+'@lexmark.com',
                           Physical_street_address__c = '74553 W',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           areas_of_need__c = 'Content',
                           Industry__c = 'Manufacturing' ,
                           License_Contact__c=true, 
                           //pse__Salesforce_User__c = userList[u].id,
                            Accounting_Contact__c = true,
                          // pse__Is_Resource__c = true,
                          pse__Is_Resource_Active__c = true,
                          Status__c = 'Active',
                          // pse__Action_Update_Current_Time_Period__c = false,
                            phone='123456789'+i,
                           MobilePhone='9123456789',
                            Fax='9123456789',
                            Lx_Lexmark_Vertical__c='Manufacturing');
                           system.debug('new contact record: ' + con);
           if (u < profileIDs.size()-1){
                u++;
                system.debug('u:' + u);

           }
         contacts.add(con);   
     }
     insert contacts;
     
     return contacts;
  }    
  
  static testMethod void testTestData() {
      Account acc = Data_Account.createAccount(); 
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);       
      //System.assertEquals(contacts.size(),3); 
      List<Contact> contacts_nonAccounting = Data_Contact.createContacts_nonAccountingContact(acc.Id,3);       
      //System.assertEquals(contacts_nonAccounting.size(),3);
      account acc2 = Data_Account.createAccount4();
      List<Contact> contacts2 = Data_Contact.QueryContacts(acc2.ID);
   
       
  }  
  
  public static List<Contact> createContacts2(Id accountId,Integer size){  
   system.debug('Acct ID in Contact######' + accountID);
     List<Contact> contacts = new List<Contact>();    
     Set<Id> contactIds = new Set<Id>();    
     Contact con;  
     
     Set<String> userProfile = new Set<String>();
      userProfile.add('System Administrator');
      
      List<ID> ProfileIds = new List<ID>();
         
      for(Profile profile : [Select Id,Name from Profile where Name in : userProfile]){
           ProfileIds.add(profile.id);
      } 
      //4.17.2013 from 37 to 39
      //ProfileIds.add('00ei0000000WaeA');   
      //ProfileIds.add('00ei0000000WaeAAAS');         

      //List<User> userList = Data_User.createUser(1, profileIds);       
    // system.debug('userLIst in datacontact: ' + userList);
     String varAlias = string.valueof(system.currentTimeMillis());
     system.debug('varAlias' + varAlias);
     Integer aliaslength = varAlias.length();  
     integer u = 0;
     for(Integer i =0;i<size;i++){        
         con = new Contact(
                           LastName='Test Contact '+i+varAlias.subString(aliaslength-2,aliaslength),
                           firstName='TestFirst',
                           AccountId = accountId,
                           Contact_Role__c ='Executive', 
                           Region__c='NA',
                           email= userInfo.getUserEmail(),
                           Physical_street_address__c = '74553 W',
                           Physical_City__c = 'shawnee',
                           address_edit_countries__c = 'United States',
                           License_Contact__c=true,
                           //pse__Salesforce_User__c = userList[u].id,
                           Accounting_Contact__c = true,
                           areas_of_need__c = 'Content',
                          pse__Is_Resource__c = true,
                          pse__Is_Resource_Active__c = true,
                          // pse__Action_Update_Current_Time_Period__c = false,
                           phone='123456789'+i,
                           MobilePhone='9123456789',
                            Fax='9123456789',
                           Status__c = 'Active' ,
                           Industry__c = 'Manufacturing',
                           Lx_Lexmark_Vertical__c='Manufacturing');
                           system.debug('new contact record: ' + con);
           if (u < profileIDs.size()-1){
                u++;
                system.debug('u:' + u);

           }
         contacts.add(con);   
     }
     insert contacts;
     
     return contacts;
  }
       
}