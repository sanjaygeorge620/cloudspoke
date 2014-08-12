/*********************************************************************************
Name : TestTriggerLeadConvert 
Created By : Appirio Offshore [Akhilesh Soni] 
Created Date : 17 Jan 2011
Usages : Test class for LeadConvert trigger
*********************************************************************************/
@isTest
Private class TestTriggerLeadConvert {
  @isTest
    static void testTriggerLeadConvert() {      
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
        l.Phone= '1234567890';
        l.SIC_Code__c = '123';
        l.Email = 'test@abc.com';
        l.LX_Party_Group__c = 'Customer';
        l.LX_ISS_Coverage_Model__c = 'Channel';
        l.LX_ISS_Coverage_Method__c = 'Face To Face';
        l.Street = '123 Street';
        l.City = 'Bangalore';
        l.State = 'Karnataka';
        l.PostalCode = '560040';
        l.MPS__c = true;
        
      
        test.startTest();
        insert l;
        
        User_Panel_Survey__c ups = new User_Panel_Survey__c();
        
            ups.Email_Address__c='c@k.com';
            ups.First_Name__c='test';
            ups.Last_Name__c='test';
            ups.job_title__c='test';
            ups.Lead_name__c = l.Id;
            insert ups;
            
            Marketing_Activities__c ma = new Marketing_Activities__c();
            ma.Lead_ID__c = l.Id;
            insert ma;
            
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
            
            
            UpdateUserPanelSurvey.updateSurvey(new List<Id>{l.id});
        }
        test.stopTest();
    }
}