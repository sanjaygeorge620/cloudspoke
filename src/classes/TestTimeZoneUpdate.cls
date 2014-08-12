@isTest(Seealldata = true)
public class TestTimeZoneUpdate{
    static testmethod void Hoursupdate(){
  Set<String> customerUserTypes = new Set<String> {'PowerCustomerSuccess'};
 Account acc = Data_Account.createAccount();
       
        
  
Contact con = new Contact ();
        con.AccountId = acc.id;
        con.LastName = 'portalTestUser';
        con.Time_Zone__c='America/Los_Angeles';
        con.Business_Hours_To__c='8:00 AM';
        con.Business_Hours_From__c='5:00 PM';
        insert con;
     
  
Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
 
User U = new User();
        
        U.profileId = p.id;
        U.username = 'newUser@yahoo.com';
        U.email = 'pb@ff.com';
        U.emailencodingkey = 'UTF-8';
        U.localesidkey = 'en_US';
        U.languagelocalekey = 'en_US';
        U.timezonesidkey = 'America/Los_Angeles';
        U.lastname='lastname';
        U.From__c='8:00 AM';
        U.To__c='5:00 PM';
        U.contactId = con.id;
        U.alias='nuser';
        insert U;
        
       
          Test.Starttest();
           System.runAs(U){
   U.Timezonesidkey = 'Pacific/Kiritimati';
     U.From__c='5:00 AM';
      U.To__c='6:00 PM';
     update U;
     
       }
        con.Time_Zone__c= 'Asia/Colombo';
        con.Business_Hours_To__c='9:00 AM';
        con.Business_Hours_From__c='10:00 PM';
        update con;
        
               Test.StopTest();
        }
}