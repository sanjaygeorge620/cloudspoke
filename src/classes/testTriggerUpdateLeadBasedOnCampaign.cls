@isTest(SeeAllData=true)
private class testTriggerUpdateLeadBasedOnCampaign {

static testMethod void testTriggerUpdateLeadBasedOnCampaign(){
    
    Test.startTest();
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    User u = new User(Alias = 'standt', Email='standarduser@lexmark.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',EmployeeNumber = '1234', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles',LX_Ability_to_Create_Accounts__c= 'Yes', UserName='teststandarduser1248@lexmark.com', LX_Region__c= 'NE', Legacy_Company__c = 'Lexmark');

    //Testing as a standard user.

    System.runAs(u) {
    
        Lead l = new lead();
        l.LastName = 'testLead';
        l.Status = 'open';
        l.CurrencyIsoCode = 'USD';
        l.Company = 'temp';
        l.Lead_Type__c = 'New Logo-Affiliate';
        l.Sector__c = 'Higher Education';
        l.Region__c = 'NA';
        l.Physical_Country__c ='Anguilla';      
        l.Country= 'Anguilla';
        l.Email = 'test@abc.com';
        l.LX_Product_Type__c = 'Software';
        l.LX_Sales_Type__c = 'New Project';
        l.LX_ISS_Coverage_Model__c = 'Channel';
        l.LX_ISS_Coverage_Method__c = 'Face To Face';
        l.LX_Party_Group__c = 'Partner';
        l.LX_Party_Role__c = 'Distributor';
        l.LX_Party_Type__c = 'Pan-National';
        l.Street = '123 Street';
        l.City = 'Bangalore';
        l.State = 'Karnataka';
        l.PostalCode = '560040';
        l.Phone = '1234567890';
                               l.LX_Country_Code__c ='IN';
                               l.Region__c = 'Asia Pacific';
                               l.LX_PSW_Sales_Region__c = 'APAC';
                               l.LXK_Region__c ='India';
        
        RecordType parentRecType = [select Id from RecordType where Name = 'Parent Campaign' and SobjectType = 'Campaign'];
        RecordType childRecType = [select Id from RecordType where Name = 'Child Campaign' and SobjectType = 'Campaign'];
        
        Campaign parentCmp = new Campaign();
        parentCmp.Name = 'Test Campaign';
        parentCmp.Areas_of_Interest__c = 'Content';
        parentCmp.type = 'Content Syndication';
        parentCmp.CurrencyIsoCode = 'USD';
        parentCmp.RecordTypeId = parentRecType.id;
        insert parentCmp;
    
        Campaign childCmp = new Campaign();
        childCmp.Name = 'Test Campaign';
        childCmp.Areas_of_Interest__c = 'Content';
        childCmp.type = 'Content Syndication';
        childCmp.CurrencyIsoCode = 'USD';
        childCmp.RecordTypeId = childRecType.Id;
        childCmp.ParentId = parentCmp.Id;
    
        insert childCmp;
        insert l;
        
        
        CampaignMember cmpMem = new CampaignMember();
        cmpMem.LeadId = l.Id;
        cmpMem.CampaignId = childCmp.Id;
        
        insert cmpMem;
        List<Lead> leadList = [Select Id, LeadSource, Name from Lead where Id =: l.Id];
        System.assertEquals(leadList[0].LeadSource, 'Content Syndication');
        
        Account A = new Account();
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.MDM_Sold_To_Number__c = '56A47657';
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'India';
        A.BillingCountry  = 'India';
        A.Primary_Sector_Focus__c = 'Manufacturing';
        insert A;
        List<Contact> con = Data_Contact.createContacts(A.id, 1);
        CampaignMember cmpMem2 = new CampaignMember();
        cmpMem2.ContactId = con[0].Id;
        cmpMem2.CampaignId = childCmp.Id;
        insert cmpMem2;
        
      }
        
        Test.stopTest();
    }
}