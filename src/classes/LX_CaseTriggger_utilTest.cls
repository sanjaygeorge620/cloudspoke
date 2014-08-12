@isTest(seeAlldata = true)
public class LX_CaseTriggger_utilTest{

     static testMethod void LX_CaseTriggger_utilMethod() {
     
     string KeyUserQueue_AP = 'Key_user_AP';
     system.assertequals(KeyUserQueue_AP ,'Key_user_AP');
     string KeyUserQueue_EMEA = 'Key_user_EMEA';
      system.assertequals(KeyUserQueue_EMEA,'Key_user_EMEA');
     string KeyUserQueue_LA = 'key_user_LA';
      system.assertequals(KeyUserQueue_LA,'key_user_LA');
     string KeyUserQueue_NA = 'Key_User_NA';
      system.assertequals(KeyUserQueue_NA ,'Key_User_NA');
     string Geo_AP = 'Asia Pacific';
      system.assertequals(Geo_AP,'Asia Pacific');
     string Geo_EMEA = 'EMEA';
      system.assertequals(Geo_EMEA ,'EMEA');
     string Geo_LA ='Latin America';
      system.assertequals(Geo_LA ,'Latin America');
     string Geo_NA ='North America';
      system.assertequals(Geo_NA ,'North America');
      
     //Create a Approver 
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     User u = new User(Alias = 'standt', Email='standarduser@lexmark.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',EmployeeNumber = '1234', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@lexmark.com', LX_Ability_to_Create_Accounts__c='Yes',Legacy_Company__c= 'PACSGEAR');
          insert u;

     
      //Opportunity
      List<Opportunity> opp = new List<Opportunity>();
      opp = Data_Opportunity.createOpportunity(new string[]{'Negotiation'},1);
      
      //Contact
      Contact objCont = new Contact();  
      objCont = [select LastName,firstName,AccountId,Contact_Role__c,Region__c,email,Physical_street_address__c,Physical_City__c,address_edit_countries__c,License_Contact__c,
                  Accounting_Contact__c,areas_of_need__c,pse__Is_Resource__c,pse__Is_Resource_Active__c,phone,MobilePhone,Fax,Status__c,Industry__c,Lx_Lexmark_Vertical__c
                  from contact where id =: Opp[0].Project_Contact__c];
        
       //Account 
       Account RefAccount = new Account();
       RefAccount = [select BillingState,Name,Sector__c,Type,Party_Role__c,Party_Type__c,MDM_Sold_To_Number__c,Physical_Country__c,BillingCity,LX_Country_Code__c,
              BillingCountry,LX_Geo__c,MPS_Qualification__c,LXK_Region__c,TR_Status__c,ISS_Coverage_Method__c,ISS_Coverage_Model__c,
              Primary_Sector_Focus__c,RecordTypeId from account where id =: opp[0].AccountID];
      
      
      //Case
      List<Case> oldCase = Data_Case.createCase(RefAccount,objCont,'MDM Integration',4);
      List<Case> newCase = new List<Case>();
      for(case cs: newCase)
      {
       Case ObjCase1 = new Case();
       cs.Status = 'Submitted';
     //  cs.LX_Opportunity__c = opp.id;
    //   cs.LX_Sales_Organization_Country__c;
       cs.LX_Payment_Terms__c = 'Cash With Order';
       
  //     cs.ContactId = ContactId;
       cs.CurrencyIsoCode = 'USD - U.S. Dollar';
       objcase1 = cs;
       newCase.add(objcase1);
      }
      
      List<Id> IDS = new List<ID>();
      for(case cs: newCase)
      {
       ID tempid = cs.id;
       IDS.add(tempid);
      }
      
      //LX_CaseTriggger_util objLX_CaseTriggger_util= new LX_CaseTriggger_util();
  //  LX_CaseTriggger_util.submitforApproval(cc.id,u.id);
      id tempid = LX_CaseTriggger_util.GetKeyuserQueue('India');
      LX_CaseTriggger_util.updateOwnership(IDS);
    
      LX_CaseTriggger_util.LX_CaseFieldPopulation(newCase,oldCase);
      
    }
}