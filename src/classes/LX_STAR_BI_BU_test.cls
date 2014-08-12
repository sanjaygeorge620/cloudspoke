/* Class Name   : LX_STAR_BI_BU_test
* Description  : This is a test class for the trigger LX_STAR_BI_BU.
* Created By   : Maruthi Kolla
* Created Date : 2/3/2014
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Maruthi Kolla              2/3/2014             1000                   Initial Version
*/    

@isTest
Private class LX_STAR_BI_BU_test
{
    static testmethod void m1()
    {
        STAR__c str = new STAR__c();
        
        User u1 =new User();
        Profile userProfileObj = [select id from profile where name= 'System Administrator' limit 1];
         u1 = new User(alias ='LXSta9', email='abc@lexmark.com', emailencodingkey='UTF-8', lastname='lastName1', languagelocalekey='it', profileid = userProfileObj.Id, 
   timezonesidkey='Europe/Berlin', username='abc@lexmark.com', localesidkey = 'it_IT',Legacy_Company__c='Lexmark',EmployeeNumber = '1234');
   insert(u1);         
        
        //user u1 = [select id from user where isActive = true and profile.name='System Administrator' limit 1];
        str.Assigned_Resource__c = u1.id;
        insert str;
       
        //user u2 = [select id from user where isActive = true and profile.name='System Administrator' and id !=:u1.id limit 1];
        User u2 =new User();
         u2 = new User(alias ='LXS20', email='abc@lexmark.com', emailencodingkey='UTF-8', lastname='lastName1', languagelocalekey='it', profileid = userProfileObj.Id, 
   timezonesidkey='Europe/Berlin', username='abc20@lexmark.com', localesidkey = 'it_IT', Legacy_Company__c='Lexmark', EmployeeNumber='1234');
   insert(u2);        
        str.Assigned_Resource__c = u2.id;
        update str;
        
        
    }
}