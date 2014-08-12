/*
Class Name : LX_SAPProjectRequest_AI_AU_BI_BU_test
Description : Test Class for LX_SAPProjectRequest_AI_AU_BI_BU.
Created By : Sunil Kati skati@deloitte.com)
Created Date : 12-23-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Sunil Kati   12-23-2013        1000                 Initial Version
*************************************************************************/
@isTest(seealldata=true)
public class LX_SAPProjectRequest_AI_AU_BI_BU_test{

   public static testmethod void m1(){
   
   Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
       
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
        insert Opp;

      
         Company_Code__c c = new Company_Code__c(Company_Code_Description__c='1003', Company_Code_Value__c='Belgium');  
         insert c;
      
        SAP_Project_Request__c s1= new SAP_Project_Request__c (Opportunity__c=opp.id,Company_Code__c=c.id,Request_Type__c='MPS',Division__c='ISS');
         System.Test.StartTest();
        insert s1;
          System.Test.StopTest();   
    }
    

}