@isTest
private class TestLX_Account_AI_AU_BI_BU {
    static testMethod void myUnitTest() 
    {           Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();      

           Account A = new Account(name='Account4TestMethod');       
 //     A.Address_Edit_States__c = 'Rajasthan'; 
        A.BillingState= 'Rajasthan';  
        A.Name = 'testAccount';
        A.Sector__c = 'State/Local';
        A.Type = 'Partner';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc.id;
        A.MDM_Sold_To_Number__c = '56A47657';
       A.Primary_Sector_Focus__c = 'Manufacturing';  
       A.Legacy_Company_Originator__c = 'Acuo';
       A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.MDM_Account_Number__c = '1234';
        a.MDM_Account_Level__c = 'Transactional';
        A.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
        A.LX_Country_Code__c = 'US';
        A.LX_Is_Contact_Opt_Status__c = true;
        insert A;  
        A.LX_Country_Code__c= 'UK';
        A.LX_Is_Contact_Opt_Status__c = false;
        update A;
        
    }
}