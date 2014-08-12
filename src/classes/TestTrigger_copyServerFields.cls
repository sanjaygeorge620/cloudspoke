/*****************************************************************
Created By :Rahul Jain, Metacube (Appirio Inc)
Created On : May 22 2009
Purpose    : To Test the trigger copyServerFields
******************************************************************/
@istest
public class TestTrigger_copyServerFields{
   public static testmethod void testcopyServerFields()
   {     
  /*   Account acc = new Account();
     acc.name = 'name';
     insert acc;  */
     
      Account acc = Data_Account.createAccount();
     
     Server__c server = new Server__c();
     server.Database_Text__c = null;
     server.Database_Version_Text__c = '9i';
     server.Platform_Text__c = 'HP/UX';
     server.Platform_Version_Text__c = '11.11';
     server.Brand_Text__c = 'ImageNow';
     server.Release_Text__c = '6.5.1';
     server.Account__c = acc.id;
     server.Server_Name__c = 'Server'; 
     insert server;
     
     Server__c serverUpdate = new Server__c();
     serverUpdate.Database_Text__c = 'Oracle_Up';
     serverUpdate.Database_Version_Text__c = '9i_Up';
     serverUpdate.Platform_Text__c = 'HP/UX_Up';
     serverUpdate.Platform_Version_Text__c = '11.11_Up';
     serverUpdate.Brand_Text__c = 'ImageNow_Up';
     serverUpdate.Release_Text__c = '6.5.1';
     serverUpdate.Account__c = acc.id; 
     serverUpdate.Server_Name__c = 'Server Update';
     insert serverUpdate;
     
     // Check for insert condition
     List<Contact> contacts = Data_Contact.createContacts(acc.Id,3); 
    List<Case> cases = Data_Case.createCase(acc, contacts[0], 'Product Support', 1);        
     
     Case c = cases[0];

     c.Subject = 'Test';
     c.Description = 'Test Desc';
     c.Server__c = server.id;
     update c; 
   
   
     Case cs = [Select id,Database__c,Database_Version__c
                ,Platform__c,Platform_Version__c
                ,Brand__c,Release__c
                ,AccountId from case where id = : c.id]; 
                
                
     //Assert the results for trigger before insert of case.
     //System.assertEquals(cs.Database__c,server.Database_Text__c);
     //System.assertEquals(cs.Database_Version__c,null);
     //System.assertEquals(cs.Platform__c,null);
     //System.assertEquals(cs.Platform_Version__c,null);
    // System.assertEquals(cs.Brand__c,server.Brand_Text__c);     //SK Commented 10/1
    //VT 8/25:Commented System.assertEquals(cs.Release__c,null);
  //   System.assertEquals(cs.AccountId,server.Account__c);     
     
     
     // Check for update condition
     cs.Server__c = serverUpdate.id;     
     update cs;
     
     Case csUpdate = [Select id,Database__c,Database_Version__c
                ,Platform__c,Platform_Version__c
                ,Brand__c,Release__c
                ,AccountId from case where id = : cs.id]; 
     
 
     //Assert the results for trigger before update of case.
     //System.assertEquals(csUpdate.Database__c,null);
     //System.assertEquals(csUpdate.Database_Version__c,null);
     //System.assertEquals(csUpdate.Platform__c,null);
     //System.assertEquals(csUpdate.Platform_Version__c,null);
     //System.assertEquals(csUpdate.Brand__c,server.Brand_Text__c);     
     //System.assertEquals(csUpdate.Release__c,null);
     
     
 //    System.assertEquals(csUpdate.AccountId,server.Account__c); 
     
     // Check for insert condition
     
    List<Case> cases_noServer = Data_Case.createCase(acc, contacts[0], 'Product Support', 1);    
     Case csForNoServer = cases_noServer[0];
     csForNoServer.Subject = 'Test';
     csForNoServer.Description = 'Test Desc';     
     update csForNoServer;
     
     //System.assertEquals(csForNoServer.Database__c,null);
     //System.assertEquals(csForNoServer.Database_Version__c,null);
     //System.assertEquals(csForNoServer.Platform__c,null);
     //System.assertEquals(csForNoServer.Platform_Version__c,null);
     //System.assertEquals(csForNoServer.Brand__c,null);     
     //System.assertEquals(csForNoServer.Release__c,null);
     
         
     
   }
   
   public static testmethod void TestAccountChange()
   {
   Account acc = Data_Account.createAccount();
   Account acc2 = Data_Account.createAccount();
 
   test.StartTest();
     Server__c server = new Server__c();  
     server.Database_Text__c = null;
     server.Database_Version_Text__c = '9i';
     server.Platform_Text__c = 'HP/UX';
     server.Platform_Version_Text__c = '11.11';
     server.Brand_Text__c = 'ImageNow';
     server.Release_Text__c = '6.5.1';
     server.Account__c = acc.id;
     server.Server_Name__c = 'Server'; 
     insert server;
     
       asset asst = new Asset(name='test1234',AccountID=acc.ID,Status='Active',Start_Date__c=System.Today(),server__c = server.id);
   insert asst;
   
     asset asst2 = new Asset(name='test1234',AccountID=acc.ID,Status='Active',Start_Date__c=System.Today(),server__c = server.id);
   insert asst2;
        
     server.account__c = acc2.id;
    update Server;  
   test.StopTest();     
   }
   
   
}