@isTest(SeeallData = true)
private class test_UpdateLeadClone
{

public static Schema.DescribeSObjectResult des = Schema.SObjectType.Lead; 
public static Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
public static Id MRrtId = rtMap.get('Unlocked').getRecordTypeId();  

public static Schema.DescribeSObjectResult des1 = Schema.SObjectType.Account; 
public static Map<String,Schema.RecordTypeInfo> rtMap1 = des1.getRecordTypeInfosByName();
 


Static testMethod Void testSingleInsert()

{
    Id MRrtacctId = rtMap1.get('Location Partner').getRecordTypeId(); 
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];  
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
      //System.runAs(u){
      
        Geography_Coverage__c gc2 = Data_GeographyCoverage.createGeographyCoverage2(); 
        Account A = new Account(name='Account4TestMethod2');   
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.Coverage_ID__c = gc2.id;
        A.MDM_Sold_To_Number__c = '56A47657';
        A.RecordtypeID = MRrtacctId;
        A.Physical_Country__c = 'USA';
        A.BillingCountry = 'USA';
        insert A;       
  

        Lead ld = new Lead();
        ld.RecordTypeID = MRrtId;
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
        ld.Primary_Partner__c = A.ID;
        ld.LX_ISS_Coverage_Model__c = 'Channel';
        ld.LX_ISS_Coverage_Method__c = 'Face To Face';
        ld.LX_Party_Group__c = 'Partner';
        ld.LX_Party_Role__c = 'Distributor';
        ld.LX_Party_Type__c = 'Pan-National';
        ld.Street = '123 Street';
        ld.City = 'Bangalore';
        ld.State = 'Karnataka';
        ld.PostalCode = '560040';
        insert ld;
        
        delete ld;
//}
}
}