/*
Class Name : LX_ShipDel_BI_BU_Test
Description : Test Class for LX_ShipDel_BI_BU.
Created By : Sunil Kati skati@deloitte.com)
Created Date : 12-23-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Sunil Kati   12-23-2013        1000                 Initial Version
*************************************************************************/
@isTest(seealldata = true)
public class LX_ShipDel_BI_BU_Test{
    static testMethod void ShipDel_1() {
    
    
     pse__Region__c region = new pse__Region__c();
    region.Name = 'testregion';
    region.CurrencyIsoCode = 'USD';
    region.pse__Hierarchy_Depth__c = 0;
    insert region;
    
     pse__Practice__c practice = new pse__Practice__c();
    practice.Name = 'TestPractice';
    practice.CurrencyIsoCode = 'USD';
    region.pse__Hierarchy_Depth__c = 0;
    insert practice;
    
     Account testAccount = new Account();
    testAccount.Name = 'testAccount';
    testAccount.Physical_Country__c = 'USA';
    testAccount.BillingCountry = 'USA';
    insert testAccount;
     pse__Proj__c project = new pse__Proj__c(Name='test_project');
    project.pse__Is_Billable__c = false;
    project.pse__Is_Active__c = true;
    project.pse__Project_Status__c = 'Green';
    project.pse__Allow_Timecards_Without_Assignment__c = true; 
    project.pse__Start_Date__c = Date.today().addMonths(-1);
    project.pse__End_Date__c = Date.today().addMonths(4);
    project.pse__Region__c = region.Id;     
    project.pse__Billing_Type__c = 'Administrative';
    project.pse__Practice__c = practice.Id;  
    project.CurrencyIsoCode ='USD';
    project.pse__Account__c = testAccount.id;
    project.Product_Line_s__c ='ISS';
   insert project; 
   
        //Account ac= Data_account.createAccount3();
        //List<pse__Proj__c> Projects = Data_Project.createProject(1);
        //  List<pse__Region__c> regions = [select Id from pse__Region__c where pse__Parent_Region__c = null]; 
         //  List<pse__Practice__c> practices = [select Id from pse__Practice__c where pse__Parent_Practice__c = null];
         Shipment_and_Delivery__c ship = new Shipment_and_Delivery__c();
        //list<RecordType> recordTypeList = [SELECT DeveloperName, Name, Id FROM RecordType where name = 'ISS Implementation Project'];
         Id rec=pse__Proj__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('ISS Implementation Project').getRecordTypeId();
        pse__Proj__c pro = project;
        pro.RecordTypeId = rec;
        update pro;
        ship.Project__c = pro.ID;
        insert ship;
    
    
    }
    
}