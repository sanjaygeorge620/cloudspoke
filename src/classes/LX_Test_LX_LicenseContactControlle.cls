@isTest(SeeAllData=true)
public class LX_Test_LX_LicenseContactControlle{
 
 static testMethod void createLicensecon(){
        Account acc1 = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       Account acc = Data_Account.createAccount3();
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     User u = new User(Alias = 'standt', Email='standarduser@lexmark.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',EmployeeNumber = '1234', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@lexmark.com', LX_Ability_to_Create_Accounts__c='Yes',Legacy_company__c = 'PACSGEAR');
          insert u;
       acc.ParentId = acc1.id;
       acc.RecordTypeID = accRecordType;
      update acc;
       Id accRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
       Account acc2 = Data_Account.createAccount3();
       acc2.ParentId = acc1.id;
       acc2.RecordTypeID = accRecordType1;
       update acc2;
           // Inserting test data
           Id idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
           //Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Ship To').getRecordTypeId();
           LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_MDM_Act__c='12345',LX_Name__c='Sold Test', RecordTypeId=idRecordType, LX_Account__c = u.name,LX_Physical_Postal_Code__c='66666');
           System.debug('LX_SAP_Record Id ' + oSRec.Name);
           insert oSRec;
           LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_MDM_Act__c='2345',LX_Name__c='Ship Test', RecordTypeId=idRecordType, LX_Account__c = u.name,LX_Physical_Postal_Code__c='66666');
           System.debug('LX_SAP_Record Id ' + oSRec1.Name);
           insert oSRec1;
           // Insert SAP Record Sales Organization
           string soldType = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
           LX_SAP_Record_Sales_Org__c sapsalesRec = new LX_SAP_Record_Sales_Org__c(LX_Ship_To__c=oSRec1.Id,RecordTypeID = soldType );
           try
           {
           insert sapsalesRec;
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
           //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
       
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',LX_Bill_To_Email_Address__c='user@lexmark.com',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Product_Type__c = 'Technology'/*,LX_Ship_To_New__c=sapsalesRec.id */);
       insert opp;
       list<contact> COnList= Data_Contact.createContacts(acc1.id,1);
      // COnList[0].Phone='9123456789';
       //COnList[0].MobilePhone='9123456789';
        //COnList[0].Fax='9123456789';
        update COnList;
       LX_Contact_ShiptoSalesOrg__c LicCOn=new LX_Contact_ShiptoSalesOrg__c(Contact__c=COnList[0].id,LX_SAP_Record_Sales_Organization__c=sapsalesRec.id ,LX_Ship_To__c=oSRec1.id);
       try
           {
             insert LicCOn;
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
     
       test.startTest();
       PageReference pageRef = new PageReference('/apex/LX_LicenseContact?'+'&selectedRecord='+oSRec.id+'&oppId='+opp.id);
       Test.setCurrentPage(pageRef);
       //ApexPages.currentPage().getParameters().put('accountId',acc.id);
       ApexPages.currentPage().getParameters().put('oppId',opp.Id);
      // ApexPages.currentPage().getParameters().put('type','SOLD');
       //ApexPages.currentPage().getParameters().put('soldtoID',oSRec.id);
       //ApexPages.currentPage().getParameters().put('selectedRecord');
       LX_LicenseContactController  Lcon = new LX_LicenseContactController ();
       LX_LicenseContactController.customLicenseConWrapper wrapper = new LX_LicenseContactController.customLicenseConWrapper(LicCOn,FALSE);
       Lcon.setSortDirection('ASC');
       Lcon.getSortDirection();
       Lcon.Go();
       Lcon.updateOpp();
       Lcon.cancel();
       Lcon.getresultList();
       test.stopTest();
        }
    }