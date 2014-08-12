@isTest(seealldata=true)
public with sharing class Data_Lead {
    public static Lead createLeads(Id campaign){    
         list<RecordType> rdtype= [select Id from RecordType where Name = 'Simple Partner' and SobjectType = 'Lead'];
         Lead newLead = new Lead( 
                               LastName='Test Contact',
                               firstName='TestFirst',
                               Status = 'Open' ,
                               Company ='Testing Company', 
                               Sector__c ='Cross Industry',
                               Lead_Type__c ='Expansion-Add On',
                               LX_ISS_Coverage_Model__c = 'OLA',
                               LX_ISS_Coverage_Method__c = 'Face To Face',
                               TR_Status__c = 'Off',
                               City = 'abc',
                               RecordType=rdtype[0],
                               RecordTypeId = rdtype[0].id,
                               PostalCode = '4237',
                               Street = 'xyz',
                               State = 'testcity',
                               phone = '1234567890',
                               email = 'test@yahoo.co.in',
                              // Campaign = campaign,
                               
                               LX_Country_Code__c ='US',
                               Region__c = 'USA',
                               LX_PSW_Sales_Region__c = 'USA',
                               LXK_Region__c ='USA',
                               Preferred_Language__c = 'English');
                               system.debug('new contact record: ' + newLead);
              
         insert newLead;
         
         return newLead;
  }
  public static Lead CreateApprovalProcessLead(string StrCountryName,string strBusinessUnit){    
         
    list<RecordType> rdtype= [select Id from RecordType where Name = 'Simple Partner' and SobjectType = 'Lead'];
    list<user> tempuser = [select id from user limit 1];
    Lead ld = new Lead (LX_ISS_Coverage_Method__c='Face To Face',
                        TR_Status__c='Off',
                        Sector__c='Education',
                        Vertical_Subtype__c='Higher Ed',
                        LX_ISS_Coverage_Model__c='OLA',
                        LX_Party_Role__c='Business Customer',
                        LX_Party_Type__c='Standard',
                        Business_Unit__c=strBusinessUnit,
                        Physical_Country__c=StrCountryName,
                        Company='deloitte',
                        Firstname='sanjay',
                        LastName='kamma',
                        LX_Country_Code__c='IN',
                        Region__c='Asia Specific',
                        LX_PSW_Sales_Region__c='APAC',
                        LX_Party_Group__c = 'partner', 
                        RecordSubmittedForApproval__c = false,
                        LXK_Region__c=StrCountryName,
                        status='Open',
                        RecordType=rdtype[0],
                        RecordTypeId = rdtype[0].id,
                        SIC_Code__c='7220300',
                        Email='sageorge@deloitte.com',
                        Street='street1',
                        City='city',
                        State='Andhra1TEST',
                        PostalCode='1234test1',
                        LX_Coverage_Status__c='Active');

                        system.debug('new contact record: ' + ld);
              
         insert ld;
         
         return ld;
  }
  
  public static Lead TestConvertLead()
  {
           List<sales_organization__c> objsalesorg = [select id from sales_organization__c where LX_Country_Code__c='IN' limit 1];
           List<User> objUser = [select id from User where isactive=true limit 1];
           List<RecordType> rdtype= [select Id from RecordType where Name = 'Simple Partner' and SobjectType = 'Lead'];
           Lead ld = new Lead (LX_ISS_Coverage_Method__c='Face To Face',
                          LX_Additional_Comments__c='Test Comments',
                          LX_expected_to_close_within_5_days__c='Yes',
                          Physical_Country__c='India',
                          OwnerId=UserInfo.getUserId() ,
                          Company='testcompany',
                          LX_Sales_Type__c='New Project',
                          //Recordtype.developerName=rdtype[0].DeveloperName,
                          LX_Partner_buy_directly_from_Lexmark__c='Yes',
                          LX_Do_you_need_to_create_an_opportunity__c='Yes',
                          LX_Requested_Credit_Limit__c=45,
                          CurrencyIsoCode ='USD',
                          LX_Payment_Terms__c ='Net 45 Days',
                          Status ='Open',
                          LX_Sales_Organization__c=objsalesorg[0].id,
                          //LX_Account_Owner__c=objUser.id,
                          //LX_Account_Owner__r.Name=objUser.Name,
                          Technology__c =true,
                          Software_Solutions__c=true,
                          MPS__c =true,
                        D_U_N_S_Number__c ='1234567',
                        Was_Datacom_Used__c =true,
                        TR_Status__c='Off',
                        Sector__c='Education',
                        Vertical_Subtype__c='Higher Ed',
                        LX_ISS_Coverage_Model__c='Channel',
                        LX_Party_Role__c='Business Customer',
                        LX_Party_Type__c='Standard',
                        Business_Unit__c='strBusinessUnit',
                        Firstname='Test',
                        LastName='Sample',
                        LX_Country_Code__c='IN',
                        Region__c='Asia Specific',
                        LX_PSW_Sales_Region__c='APAC',
                        LX_Party_Group__c = 'Partner', 
                        RecordSubmittedForApproval__c = false,
                        LXK_Region__c='India',
                        RecordType=rdtype[0],
                        RecordTypeId = rdtype[0].id,
                        SIC_Code__c='7220300',
                        Email='test@lexmark.com',
                        Street='street1',
                        City='city',
                        State='Andhra1TEST',
                        PostalCode='1234test1',
                        LX_Coverage_Status__c='Active');

              Insert ld;
              return ld;
  }
  
          
  static testMethod void testTestData() {
      Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');   
      Lead newLead = Data_Lead.createLeads(pCam.id);    
      System.assert(newLead.id != null);
  } 
  
  static testMethod void testCreateApprovalProcessLead() { 
      Lead newLead = Data_Lead.TestConvertLead();    
      System.assert(newLead.id != null);
  } 
  
  static testMethod void testCreateLeadConvert() { 
      Lead newLead = Data_Lead.CreateApprovalProcessLead('India','ISS');    
      System.assert(newLead.id != null);
  } 
}