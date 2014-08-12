/*
Class Name : LX_ShipDel_BI_BU_Test
Description : Test Class for LX_ShipDel_BI_BU.
Created By : Akanksha Gupta (akagupta@deloitte.com)
Created Date : 12-23-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Akanksha Gupta   12-23-2013        1000                 Initial Version
*************************************************************************/
@isTest(seeAllData = true)
public class LX_WBS_request_AITest{
    
    public static testMethod void testWBS_request_AI(){
        Test.startTest();
        Company_Code__c code = new Company_Code__c();
        code.Company_Code_Description__c = 'Company code description';
        code.Company_Code_Value__c = 'code value';
        insert code;
        
        Account acc = new Account();
        acc.Name = 'Test Account1';
        acc.CurrencyIsoCode = 'USD';
        acc.LX_Country_Code__c = 'IN';
        acc.Physical_Country__c = 'India';
        acc.BillingCountry = 'India';
        acc.LXK_Region__c = 'India';
        acc.LX_Geo__c = 'Asia Pacific';
        acc.PSW_Sales_Region__c = 'APAC';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Oppty1';
        opp.Sector__c = 'Education';
        opp.closeDate = Date.today();
        opp.MPS__c = true;
        opp.Technology__c = true;
        opp.Software_Solutions__c = true;
        opp.Amount = 10000;
        opp.StageName = 'Qualifying';
        opp.Probability =40.0;
        opp.Next_Steps__c = 'Next steps';
        opp.CurrencyIsoCode = 'USD';
        opp.Account = acc;
        insert opp;
        
        WBS_Request__c wbs = new WBS_Request__c();
        wbs.LX_Case_Status__c = 'Case Status';
        wbs.LX_Company_code__c = code.id;
        wbs.LX_Opportunity__c = opp.id;
        insert wbs;
        
        Test.stopTest();
        
    }

}