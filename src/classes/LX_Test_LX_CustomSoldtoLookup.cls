@isTest(SeeAllData=true)
public class LX_Test_LX_CustomSoldtoLookup{

 /* Class Name : LX_Test_LX_CustomSoldtoLookup 
    * Description  : Test class to cover the code coverage for LX_CustomSoldtoLookup class.
    * Created By   : Sumedha
    * Created Date : 06-12-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha          06-12-2013                                           Initial Version
    
    */
    
    
    /* Description : Static Test Method to create deault data and call methods in the LX_CustomSoldtoLookup class
       to cover the fucntionlity of creating Sold TO record.
    *  Param - None
    *  Returns :  None
  */ 
 static testMethod void createSoldto(){
     
         string strcurrency='34.50';
       //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       Account acc = Data_Account.createAccount3();
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
           Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
           LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_Name__c='Sold Test',LX_Physical_Postal_Code__c='66666', RecordTypeId=idRecordType, LX_Account__c = acc.id,LX_Currency__c =20.90,LX_Payment_Terms__c ='xyz',LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec.Name);
           insert oSRec;
           LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_Name__c='Ship Test', LX_Physical_Postal_Code__c='66666',RecordTypeId=idRecordType1, LX_Account__c = acc.id,LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec1.Name);
           insert oSRec1;
           // Insert SAP Record Sales Organization
           string soldType = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
           LX_SAP_Record_Sales_Org__c sapsalesRec = new LX_SAP_Record_Sales_Org__c(LX_Ship_To__c=oSRec1.Id,RecordTypeID = soldType );
           insert sapsalesRec;
           //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
       
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
       insert opp;
       PageReference pageRef = new PageReference('/apex/LX_CustomShipToLookup?accountId='+acc.id+'&selectedRecord='+oSRec.id+'&type=SOLD&oppId='+opp.id);
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accountId',acc.id);
       ApexPages.currentPage().getParameters().put('oppId',opp.Id);
       ApexPages.currentPage().getParameters().put('type','SOLD');
       ApexPages.currentPage().getParameters().put('soldtoID',oSRec.id);
       //ApexPages.currentPage().getParameters().put('selectedRecord');
       LX_CustomSoldtoLookup sold = new LX_CustomSoldtoLookup();
       LX_CustomSoldtoLookup.customSoldToWrapper wrapper = new LX_CustomSoldtoLookup.customSoldToWrapper(sapsalesRec,FALSE);
       Sold.input1 ='ABC';
       Sold.input2 =oSRec.LX_Account__c;
       Sold.input3 =oSRec.LX_Payment_Terms__c ;
       Sold.input4 =strcurrency;
       sold.input5='xyz';
       sold.setSortDirection('ASC');
       sold.getSortDirection();
       sold.GO();
       sold.updateOpp();
        sold.OnLoad();
    }
    
/* Description : Static Test Method to create deault data and call methods in the LX_CustomSoldtoLookup class
       to cover the fucntionlity of creating Ship TO record.
    *  Param - None
    *  Returns :  None
  */ 
 static testMethod void createShipto(){
      string strcurrency='34.50';
      //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       Account acc = Data_Account.createAccount3();
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
           Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
          LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_Name__c='Sold Test', RecordTypeId=idRecordType, LX_Account__c = acc.id,LX_Currency__c =20.90,LX_Payment_Terms__c ='xyz',LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec.Name);
           insert oSRec;
           LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_Name__c='Ship Test', RecordTypeId=idRecordType1, LX_Account__c = acc.id,LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec1.Name);
           insert oSRec1;
           // Insert SAP Record Sales Organization
           string soldType = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
           LX_SAP_Record_Sales_Org__c sapsalesRec = new LX_SAP_Record_Sales_Org__c(LX_Ship_To__c=oSRec1.Id,RecordTypeID = soldType );
           insert sapsalesRec;
           //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
       
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
       insert opp;
       PageReference pageRef = new PageReference('/apex/LX_CustomShipToLookup?accountId='+acc.id+'&selectedRecord='+oSRec.id+'&type=SELL&oppId='+opp.id);
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accountId',acc.id);
       ApexPages.currentPage().getParameters().put('oppId',opp.Id);
       ApexPages.currentPage().getParameters().put('type','SELL');
       ApexPages.currentPage().getParameters().put('soldtoID',oSRec.id);
       //ApexPages.currentPage().getParameters().put('selectedRecord');
       LX_CustomSoldtoLookup sold = new LX_CustomSoldtoLookup();
       LX_CustomSoldtoLookup.customSoldToWrapper wrapper = new LX_CustomSoldtoLookup.customSoldToWrapper(sapsalesRec,FALSE);
       Sold.input1 ='ABC';
       Sold.input2 =oSRec.LX_Account__c;
       Sold.input3 =oSRec.LX_Payment_Terms__c ;
       Sold.input4 =strcurrency;
       sold.input5='xyz';
       sold.input6='test';
       sold.input7='test';
       sold.input8='test';
       sold.GO();
       sold.updateOpp();
       sold.OnLoad();
    }
    
    /* Description : Static Test Method to create deault data and call methods in the LX_CustomSoldtoLookup class
       to cover the fucntionlity of creating Sold TO record as NUll.
    *  Param - None
    *  Returns :  None
  */ 
     static testMethod void createShiptoSoldNull(){
      //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       Account acc = Data_Account.createAccount3();
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
           Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
           LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_Name__c='Sold Test', RecordTypeId=idRecordType, LX_Account__c = acc.id,LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec.Name);
           insert oSRec;
           LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_Name__c='Ship Test', RecordTypeId=idRecordType1, LX_Account__c = acc.id,LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec1.Name);
           insert oSRec1;
           // Insert SAP Record Sales Organization
           string soldType = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
           LX_SAP_Record_Sales_Org__c sapsalesRec = new LX_SAP_Record_Sales_Org__c(LX_Ship_To__c=oSRec1.Id,RecordTypeID = soldType );
           insert sapsalesRec;
           //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
       
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
       insert opp;
       PageReference pageRef = new PageReference('/apex/LX_CustomShipToLookup?accountId='+acc.id+'&selectedRecord='+oSRec.id+'&type=SELL&oppId='+opp.id);
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accountId',acc.id);
       ApexPages.currentPage().getParameters().put('oppId',opp.Id);
       ApexPages.currentPage().getParameters().put('type','SELL');
       ApexPages.currentPage().getParameters().put('soldtoID','');
       //ApexPages.currentPage().getParameters().put('selectedRecord');
       LX_CustomSoldtoLookup sold = new LX_CustomSoldtoLookup();
       LX_CustomSoldtoLookup.customSoldToWrapper wrapper = new LX_CustomSoldtoLookup.customSoldToWrapper(sapsalesRec,FALSE);
       
    }
    
    /* Description : Static Test Method to create deault data and call methods in the LX_CustomSoldtoLookup class
       to cover the fucntionlity of creating Bill TO record.
    *  Param - None
    *  Returns :  None
  */ 
 static testMethod void createBillto(){
      string strcurrency='34.50';
      //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       Account acc = Data_Account.createAccount3();
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
           Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
           
           LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_Name__c='Sold Test', RecordTypeId=idRecordType, LX_Account__c = acc.id,LX_Currency__c =20.90,LX_Payment_Terms__c ='xyz',LX_MDM_Act__c = '1');
            insert oSRec;
           LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_Name__c='Ship Test', RecordTypeId=idRecordType1, LX_Account__c = acc.id,LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec1.Name);
           System.debug('LX_SAP_Record Id ' + oSRec.Name);
           insert oSRec1;
           // Insert SAP Record Sales Organization
           string soldType = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
           LX_SAP_Record_Sales_Org__c sapsalesRec = new LX_SAP_Record_Sales_Org__c(LX_Ship_To__c=oSRec1.Id,RecordTypeID = soldType );
           insert sapsalesRec;
           //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
       
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
       insert opp;
       PageReference pageRef = new PageReference('/apex/LX_CustomShipToLookup?accountId='+acc.id+'&selectedRecord='+oSRec.id+'&type=BILL&oppId='+opp.id);
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accountId',acc.id);
       ApexPages.currentPage().getParameters().put('oppId',opp.Id);
       ApexPages.currentPage().getParameters().put('type','BILL');
       ApexPages.currentPage().getParameters().put('soldtoID',oSRec.id);
       //ApexPages.currentPage().getParameters().put('selectedRecord');
       LX_CustomSoldtoLookup sold = new LX_CustomSoldtoLookup();
       LX_CustomSoldtoLookup.customSoldToWrapper wrapper = new LX_CustomSoldtoLookup.customSoldToWrapper(sapsalesRec,FALSE);
        Sold.input1 ='ABC';
       Sold.input2 =oSRec.LX_Account__c;
       Sold.input3 =oSRec.LX_Payment_Terms__c ;
       Sold.input4 =strcurrency;
       sold.input5='xyz';
       sold.input6='test';
       sold.input7='test';
       Sold.input8 ='ABC';
       sold.GO();
       sold.updateOpp();
        sold.OnLoad();
    }
    
    /* Description : Static Test Method to create deault data and call methods in the LX_CustomSoldtoLookup class
       to cover the fucntionlity of creating Bill TO record as NUll.
    *  Param - None
    *  Returns :  None
  */ 
    static testMethod void createBilltoSOldNull(){
      //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       Account acc = Data_Account.createAccount3();
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
           Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
           LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_Name__c='Sold Test', RecordTypeId=idRecordType, LX_Account__c = acc.id,LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec.Name);
           insert oSRec;
           LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_Name__c='Ship Test', RecordTypeId=idRecordType1, LX_Account__c = acc.id,LX_MDM_Act__c = '1');
           System.debug('LX_SAP_Record Id ' + oSRec1.Name);
           insert oSRec1;
           // Insert SAP Record Sales Organization
           string soldType = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
           LX_SAP_Record_Sales_Org__c sapsalesRec = new LX_SAP_Record_Sales_Org__c(LX_Ship_To__c=oSRec1.Id,RecordTypeID = soldType );
           insert sapsalesRec;
           //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
       
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
       insert opp;
       PageReference pageRef = new PageReference('/apex/LX_CustomShipToLookup?accountId='+acc.id+'&selectedRecord='+oSRec.id+'&type=BILL&oppId='+opp.id);
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('accountId',acc.id);
       ApexPages.currentPage().getParameters().put('oppId',opp.Id);
       ApexPages.currentPage().getParameters().put('type','BILL');
       ApexPages.currentPage().getParameters().put('soldtoID','');
       //ApexPages.currentPage().getParameters().put('selectedRecord');
       LX_CustomSoldtoLookup sold = new LX_CustomSoldtoLookup();
       LX_CustomSoldtoLookup.customSoldToWrapper wrapper = new LX_CustomSoldtoLookup.customSoldToWrapper(sapsalesRec,FALSE);
       
    }
     
}