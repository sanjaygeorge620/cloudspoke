@isTest(seealldata=true)
private class LX_Test_LeadConvertTrigger{
    static testmethod void TestLeadConvert(){
      //List<User> objUser = [select id from User where isactive=true limit 1];
      
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'standt', Email='standarduser@lexmark.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',EmployeeNumber = '1234', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@lexmark.com', LX_Ability_to_Create_Accounts__c='Yes');
          insert u;

      
      Lead newLead = Data_Lead.TestConvertLead();          
      system.debug('TestClass Lead Inserted with ID: '+ newLead.id);
      List<Opportunity> opp = new List<Opportunity>();
      opp = Data_Opportunity.createOpportunity(new string[]{'Negotiation'},1);
        
       // objCont = [select LastName,firstName,AccountId,Contact_Role__c,Region__c,email,Physical_street_address__c,Physical_City__c,address_edit_countries__c,License_Contact__c,
        //Accounting_Contact__c,areas_of_need__c,pse__Is_Resource__c,pse__Is_Resource_Active__c,phone,MobilePhone,Fax,Status__c,Industry__c,Lx_Lexmark_Vertical__c
         //  from contact where id =: Opp[0].Project_Contact__c];
        
        //objCont.id = Opp[0].Project_Contact__c;
        Account RefAccount = new Account();
        RefAccount = [select BillingState,Name,Sector__c,Type,Party_Role__c,Party_Type__c,MDM_Sold_To_Number__c,Physical_Country__c,BillingCity,LX_Country_Code__c,
              BillingCountry,LX_Geo__c,MPS_Qualification__c,LXK_Region__c,TR_Status__c,ISS_Coverage_Method__c,ISS_Coverage_Model__c,
              Primary_Sector_Focus__c,RecordTypeId from account where id =: opp[0].AccountID];
      
      
      Database.LeadConvert leadConvert = new database.LeadConvert();
      leadConvert.setLeadid(newLead.id);         
      leadConvert.setConvertedStatus('Qualified');
      leadConvert.setOpportunityName('TestOpp'); 
      leadConvert.setDoNotCreateOpportunity(false);
      //leadConvert.setAccountId(RefAccount.ID); 
      leadConvert.setOwnerId(u.id);
    
      Test.Starttest();    
      Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);   
      system.debug('TestClass LeadConverted Result --> ' + leadConvertResult.Success );
      System.assertEquals(leadConvertResult.success,True);
      Test.Stoptest();

    }
    
     static testmethod void TestLeadConvert1(){
      //List<User> objUser = [select id from User where isactive=true limit 1];
      
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'standt1', Email='standarduser1@lexmark.com', 
          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',EmployeeNumber = '1234', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@lexmark.com', LX_Ability_to_Create_Accounts__c='Yes');
          insert u;

      
      Lead newLead = Data_Lead.TestConvertLead();
      newLead.LX_Party_Group__c  = 'Customer';
      update newLead;
                
      system.debug('TestClass Lead Inserted with ID: '+ newLead.id);
      List<Opportunity> opp = new List<Opportunity>();
      opp = Data_Opportunity.createOpportunity(new string[]{'Negotiation'},1);
        
       // objCont = [select LastName,firstName,AccountId,Contact_Role__c,Region__c,email,Physical_street_address__c,Physical_City__c,address_edit_countries__c,License_Contact__c,
        //Accounting_Contact__c,areas_of_need__c,pse__Is_Resource__c,pse__Is_Resource_Active__c,phone,MobilePhone,Fax,Status__c,Industry__c,Lx_Lexmark_Vertical__c
         //  from contact where id =: Opp[0].Project_Contact__c];
        
        //objCont.id = Opp[0].Project_Contact__c;
        Account RefAccount = new Account();
        RefAccount = [select BillingState,Name,Sector__c,Type,Party_Role__c,Party_Type__c,MDM_Sold_To_Number__c,Physical_Country__c,BillingCity,LX_Country_Code__c,
              BillingCountry,LX_Geo__c,MPS_Qualification__c,LXK_Region__c,TR_Status__c,ISS_Coverage_Method__c,ISS_Coverage_Model__c,
              Primary_Sector_Focus__c,RecordTypeId from account where id =: opp[0].AccountID];
      
      
      Database.LeadConvert leadConvert = new database.LeadConvert();
      leadConvert.setLeadid(newLead.id);         
      leadConvert.setConvertedStatus('Qualified');
      leadConvert.setOpportunityName('TestOpp'); 
      leadConvert.setDoNotCreateOpportunity(false);
      leadConvert.setAccountId(RefAccount.ID); 
      leadConvert.setOwnerId(u.id);
    
      Test.Starttest();    
      Database.LeadConvertResult leadConvertResult = Database.convertLead(leadConvert);   
      system.debug('TestClass LeadConverted Result --> ' + leadConvertResult.Success );
      System.assertEquals(leadConvertResult.success,True);
      Test.Stoptest();

    }
}