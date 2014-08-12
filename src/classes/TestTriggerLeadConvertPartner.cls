/*********************************************************************************
Name : TestTriggerLeadConvertPartner
Created By : Appirio Offshore [Akhilesh Soni] 
Created Date : 17 Jan 2011
Usages : Test class for LeadConvert trigger
*********************************************************************************/
@isTest(seeAlldata=true)
Private class TestTriggerLeadConvertPartner {
  @isTest
    static void testTriggerLeadConvert() { 
        //Rahul create a dummy Flexera Custom setting record.
        FlexeraAccount__c f = new FlexeraAccount__c();
        f.Name  = 'Perceptive Software1';
        insert f; 
        Lead l = new lead();
        l.LastName = 'testLead';
        l.Status = 'open';
        l.CurrencyIsoCode = 'USD';
        l.Company = 'temp';
        l.Lead_Type__c = 'New Logo-Affiliate';
        l.Sector__c = 'Higher Education';
        l.Region__c = 'NA';
        l.Physical_Country__c ='Anguilla';   
        l.Phone='1234567890';   
        l.Country= 'Anguilla';
        l.SIC_Code__c = '123';
        l.Email = 'test@abc.com';
        l.LX_Country_Code__c = 'AI';
        l.LX_PSW_Sales_Region__c = 'LA';
        l.LXK_Region__c = 'NOLAC';
        l.Region__c = 'Latin America';
        //l.LX_Product_Type__c = 'Technology';
        //l.LX_Sales_Type__c = 'Run Rate';
        l.LX_Party_Group__c = 'Partner';
        l.LX_ISS_Coverage_Model__c = 'Channel';
        l.LX_ISS_Coverage_Method__c = 'Face To Face';
        l.Software_Solutions__c = true;
        l.Technology__c = true;
        l.Street = '123 Street';
        l.City = 'Bangalore';
        l.State = 'Karnataka';
        l.PostalCode = '560040';
        
        
       
       // Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
       // User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        //EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
       // LocaleSidKey='en_US', ProfileId = p.Id, 
       // TimeZoneSidKey='America/Los_Angeles', UserName='teststandarduser@testorg.com', LX_Region__c= 'NE');
        
        //Testing as a standard user.
        test.startTest();
        
           // try{
                    insert l;
                    system.debug('lead inserted >>>>>>>');            
                    Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(l.id);
                    
                    List<LeadStatus> convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
                    if(convertStatus.size()>0){
                    lc.setConvertedStatus(convertStatus[0].MasterLabel);
                    lc.setDoNotCreateOpportunity(false);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    System.assert(lcr.isSuccess());
                    system.debug('lead converted >>>>>>>'+lc.ConvertedStatus);
                    }
                    
               // }
           // catch(exception e){
              //  System.debug('--------lead-----'+l.country+'--'+l.International_State_Province__c);
                //System.debug('--------lead-----'+l2.country+'--'+l2.International_State_Province__c);
           // }
        
        test.stopTest();
    }
}