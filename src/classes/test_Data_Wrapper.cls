public class test_Data_Wrapper 
{
public testgenData createData(testdataform tf)
{ 
testgenData td = new testgenData();
RecordType rtype =[Select id from RecordType where name='Location Customer'];   
Profile portalProfile = [select id from profile where name = 'Perceptive Customer Portal Admin' limit 1];
list<User> u = [select id from user where UserRoleID != null limit 1];
if(tf.Act)
{

 Account acc = new Account();
         acc.recordTypeId = rtype.id;
         acc.name='Test Account';
         acc.ownerID = u[0].id;
         acc.LX_Sales_Team_Assigned__c='Banking';
         acc.Industry_Subtype__c='Banking';
               acc.Physical_Country__c = 'USA';
               acc.BillingCountry = 'USA';
         insert acc;
         td.Act = acc;
       if(tf.Act)
       {  
         Contact con = new Contact(lastName='TestCon',accountId = acc.Id,email='a@b.com',Lx_Lexmark_Vertical__c='Banking');
         insert con; 
         td.Con = con;
       
       if(tf.cus_user)
       {  
         User portalUser = new User(alias = 'standt', email='cstandarduser@testorg1.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = portalProfile.Id,contactId = con.Id, 
         timezonesidkey='America/Los_Angeles',username='stsdadndarduser@testorg1.com',
         LX_Region__C='NE');
         
         insert portalUser;         
         td.cus_user = portalUser;  
       } 
       if(tf.serv)
       { 
         Server__c s= new Server__c(Name = acc.Name,Status__c='Active',Server_Name__c='T2',Account__c=acc.Id);
         insert s; 
         td.serv = s;
       }
       } 
}
return td;           
}

public testgenData createData_Partner(testdataform tf)
{ 
testgenData td = new testgenData();
RecordType rtype =[Select id from RecordType where name='Location Partner'];   
Profile portalProfile = [select id from profile where name = 'Perceptive Channel Portal Admin' limit 1];
list<User> u = [select id from user where UserRoleID != null limit 1];
if(tf.Act)
{
 Account acc = new Account();
         acc.recordTypeId = rtype.id;
         acc.name='Test Account';
         acc.ownerID = u[0].id;
         acc.LX_Sales_Team_Assigned__c='Banking';
         acc.Industry_Subtype__c='Banking';  
         acc.Physical_Country__c = 'USA';
               acc.Physical_Country__c = 'USA';
                            acc.BillingCountry = 'USA';
     
         insert acc;
         td.Act = acc;
       if(tf.Act)
       {  
         Contact con = new Contact(lastName='TestCon',accountId = acc.Id,email='a@b.com',Lx_Lexmark_Vertical__c='Banking');
         insert con; 
         td.Con = con;
       
       if(tf.cus_user)
       {  
         User portalUser = new User(alias = 'stapa', email='cstandarduser@testorg1.com', 
         emailencodingkey='UTF-8', lastname='Testingpartner', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = portalProfile.Id,contactId = con.Id, 
         timezonesidkey='America/Los_Angeles',username='stsdadndarduserpartner@testorg1.com',
         LX_Region__C='NE');
         
         insert portalUser;         
         td.cus_user = portalUser;  
       } 
       if(tf.serv)
       { 
         Server__c s= new Server__c(Name = acc.Name,Status__c='Active',Server_Name__c='T2',Account__c=acc.Id);
         insert s; 
         td.serv = s;
       }
       } 
}
return td;           
}



 @isTest(SeeAllData=true)
 static void testTestData() 
 {
 testdataform tf = new testdataform();
 tf.serv = True;
 test_Data_Wrapper t = new test_Data_Wrapper();
 testgenData td = t.createData(tf);
 testgenData td2 = t.createData_Partner(tf);
 }
}