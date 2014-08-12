@isTest(seeAllData = true)
private class LX_Test_leadConvertController{

    static testMethod void myUnitTest() {
        
        Id locPartnerId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Location Partner').getRecordTypeId(); 
        
        Geography_Coverage__c gc2 = Data_GeographyCoverage.createGeographyCoverage2(); 
        Account newAccount = new Account(name='Account4TestMethod2');   
        newAccount.BillingState= 'AndhraPradesh';  
        newAccount.Name = 'testAccount2';
        newAccount.Sector__c = 'State/Local';
        newAccount.Type = 'Customer';  
        newAccount.Party_Role__c = 'Perpetual';
        newAccount.Party_Type__c =  'Commercial';
        newAccount.Coverage_ID__c = gc2.id;
        newAccount.MDM_Sold_To_Number__c = '56A47657';
        newAccount.RecordtypeID = locPartnerId;
        newAccount.Physical_Country__c = 'USA';
        newAccount.BillingCountry = 'USA';
        
        Account acc = Data_Account.createAccount3(); 
        //insert newAccount; 

        Id simplePartnerId = Schema.SObjectType.Lead.RecordTypeInfosByName.get('Simple Partner').RecordTypeId;
        
        Lead ld = new Lead();
        ld.Lastname = 'Test';
        ld.Status = 'Open';
        ld.Lead_Type__c = 'Expansion-Add On';
        ld.License_Option__c = 'Perpetual';
        ld.Company = 'Test';
        ld.Sector__c = 'Cross Industry';
        ld.Preferred_Language__c = 'English';
        ld.Region__c = 'NA';
        ld.Physical_Street_Address__c = 'Physical_Street_Address__c';
        ld.Physical_City__c = 'Shawnee';
        ld.Physical_Postal_Code__c = '66226';
        ld.Primary_Partner__c = acc.ID;
        ld.LX_ISS_Coverage_Model__c = 'Channel';
        ld.LX_ISS_Coverage_Method__c = 'Face To Face';
        ld.LX_Party_Group__c = 'Partner';
        ld.LX_Party_Role__c = 'Distributor';
        ld.LX_Party_Type__c = 'Pan-National';
        ld.Street = '123 Street';
        ld.City = 'Bangalore';
        ld.State = 'Karnataka';
        ld.PostalCode = '560040';
        ld.Physical_Country__c = 'India';
        ld.email = 'abc@lexmark.com';
        ld.LX_Country_Code__c = 'IN';
        ld.LX_PSW_Sales_Region__c = 'APAC';
        ld.LXK_Region__c = 'India';
        insert ld;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(ld);
        leadConvertController leadController = new leadConvertController(stdController);
        
        leadcontroller.leadToConvert = ld;
        
        leadController.convertLead();
        leadController.getMyComponentController();
        
        
    }
    
}