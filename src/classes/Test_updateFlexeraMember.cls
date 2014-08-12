@isTest(SeeallData = true)
public class Test_updateFlexeraMember 
{
  public static Account a = new Account();
  public static List<Contact> c = new List<Contact>();
  public static List<Contact> conli = new List<Contact>();
  public static Flexera_Member__c fm = new Flexera_Member__c();
  public static List<Flexera_Member__c> fmlist = new List<Flexera_Member__c>();
  public Static Integer Count1 = 0;  
  public Static Set<String> cnum = new set<String>();  
    
 
 
public static testMethod void testSingleInsert()
{
 a = Data_Account.createAccount2();
 Test.Starttest();  
 c = Data_Contact.createContacts(a.Id,1);  
 c[0].Portal_User_Status__c = 'Active';
 c[0].Portal_User_Type__c = 'Customer Portal'; 
 update c;
 
 c[0].FIrstname = 'Changed';
 
 Update c;
 
 a.BillingStreet= 'Test address';
 
 update a;

 Delete c;
    
 Test.StopTest();    
}

public static testMethod void testSingleInsert_Internal()
{
 a = Data_Account.createAccount2();
 a.Type = 'Internal';
 Update a;
 Test.Starttest();  
List<Contact> cnt = Data_Contact.createContacts(a.Id,1);
COntact con = cnt[0];
 //insert con;
 
// update c;
 
 con.FIrstname = 'Changed';
 
 Update con;
 
 a.BillingStreet= 'Test address';
 //a.Physical_Street_Address_2__c = 'Test Address 2';
 
 update a;

 Delete con;
    
 Test.StopTest();    
}

public static testMethod void testSingleUpdate_Internal()
{
 a = Data_Account.createAccount();
 a.Type = 'Internal';
 Update a;
 Test.Starttest();  
List<Contact> cnt = Data_Contact.createContacts(a.Id,1);
COntact con = cnt[0];
 //insert con;
 
// update c;
 
 con.FIrstname = 'Changed';
 con.Flexera_Account_Checkbox__c  = true;
 
 Update con;
 
 a.BillingStreet= 'Test address';
 //a.Physical_Street_Address_2__c = 'Test Address 2';
 
 update a;

 Delete con;
    
 Test.StopTest();    
}




 public static testMethod void testBulkUpdate()
{
  a = Data_Account.createAccount();
 Test.Starttest(); 
 c = Data_Contact.createContacts(a.Id,1);   
     
    for(Contact con : c)
    {
    cnum.add((String)con.get('Contact_Number__c'));
    con.LastName = 'Test';    
    con.FirstName = 'Contact'; 
      
    }
    
    update c;
      
 Test.StopTest();   
    
}

public static testmethod void m1(){

 Account acc = Data_Account.createAccount3();
 List<Contact> lst = Data_Contact.createContacts(acc.Id,1);
 map<Id,account> mpAcc = new Map<Id,account>();
 mpAcc.put(acc.Id,acc); 
 lst[0].Portal_User_Type__c ='Channel';
 update lst[0];
 CreateFlexeraAccount.createSalesOrder(lst,new map<ID,ID>(),mpAcc);

} 
    

}