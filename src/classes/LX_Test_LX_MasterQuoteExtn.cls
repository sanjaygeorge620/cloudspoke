@isTest(SeeAllData=true)
public class LX_Test_LX_MasterQuoteExtn{

 /* Class Name : LX_Test_LX_MasterQuoteExtn 
    * Description  : Test class to cover the code coverage for LX_MasterQuoteExtn.
    * Created By   : Rashi
    * Created Date : 18-12-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Rashi                  18-12-2013                                   Initial Version
    
    */
    
    
    /* Description : Static Test Method to create default data and call methods in the LX_MasterQuoteExtn class
     *  Param - None
     *  Returns :  None
     */ 
 static testMethod void deleteMasterQuote(){
       
         string strcurrency='34.50';
       //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Account acc = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       acc.ParentId = acc1.id;
       acc.RecordTypeID = accRecordType;
      update acc;
       Id accRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
       Account acc2 = Data_Account.createAccount3();
       acc2.ParentId = acc1.id;
       acc2.RecordTypeID = accRecordType1;
       update acc2;
       test.starttest();
       //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
       //test.stopTest();
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
       //Test.startTest();      
       insert opp;
       Test.stopTest();
       LX_Master_Quote_Line_Item__c mqli1 = new LX_Master_Quote_Line_Item__c(LX_Opportunity__c = opp.id,LX_ParentID__c = 'parent2');
       insert mqli1;
       LX_Master_Quote_Line_Item__c mqli2 = new LX_Master_Quote_Line_Item__c(LX_Opportunity__c = opp.id,LX_ParentID__c = 'parent2');
       insert mqli2;
       ApexPages.StandardController ApptController = new ApexPages.StandardController(mqli1);
     //  cntStocksetImageBrowser objc = new cntStocksetImageBrowser(ApptController);

       PageReference pageRef = new PageReference('/apex/LX_OverrideDel_MasterQuote');
       Test.setCurrentPage(pageRef);
      
       LX_MasterQuoteExtn controller = new LX_MasterQuoteExtn(ApptController);
       controller.deleteSingle();
       Test.setCurrentPage(pageRef);
       controller.Cancel();
     
    }
static testMethod void deleteMasterQuoteList(){
    
         string strcurrency='34.50';
       //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Account acc = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       acc.ParentId = acc1.id;
       acc.RecordTypeID = accRecordType;
      update acc;
       Id accRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
       Account acc2 = Data_Account.createAccount3();
       acc2.ParentId = acc1.id;
       acc2.RecordTypeID = accRecordType1;
       update acc2;
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
       test.startTest();
       insert opp;
       
       //Test.stopTest();
       LX_Master_Quote_Line_Item__c mqli1 = new LX_Master_Quote_Line_Item__c(LX_Opportunity__c = opp.id,LX_ParentID__c = 'parent2');
       insert mqli1;
       LX_Master_Quote_Line_Item__c mqli2 = new LX_Master_Quote_Line_Item__c(LX_Opportunity__c = opp.id,LX_ParentID__c = 'parent2');
       insert mqli2;
       Test.stopTest();
       ApexPages.StandardController ApptController = new ApexPages.StandardController(mqli1);
     //  cntStocksetImageBrowser objc = new cntStocksetImageBrowser(ApptController);

       PageReference pageRef = new PageReference('/apex/LX_OverrideDel_MasterQuote');
       Test.setCurrentPage(pageRef);
      
       LX_MasterQuoteExtn controller = new LX_MasterQuoteExtn(ApptController);
       controller.deleteList();
     //  controller.deleteSingle();
     
    } 
 static testMethod void deleteMasterQuoteList2(){
    // test.startTest();
         string strcurrency='34.50';
       //Insert Account
       Account acc1 = Data_Account.createAccount3();
       Account acc = Data_Account.createAccount3();
       Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
       acc.ParentId = acc1.id;
       acc.RecordTypeID = accRecordType;
      update acc;
       Id accRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
       Account acc2 = Data_Account.createAccount3();
       acc2.ParentId = acc1.id;
       acc2.RecordTypeID = accRecordType1;
       update acc2;
       //Insert Campaign record
       string camprecType = Campaign.sObjectType.getDescribe().getRecordTypeInfosByName().get('Parent Campaign').getRecordTypeId();
       Campaign camp = new Campaign(Name='Test', Type='Ad - Online Banner',Status='In Progress',RecordTypeID = camprecType);
       insert camp;
      // test.stopTest();
       List<String> str = new List<String>();
       str.add('Closed Won');
      // List<Opportunity> opp = Data_Opportunity.createOpportunity(str,1);
      //Insert Opportunity
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id,LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
       Test.startTest();
       insert opp;
       //Test.stopTest();
       LX_Master_Quote_Line_Item__c mqli1 = new LX_Master_Quote_Line_Item__c(LX_Opportunity__c = opp.id,LX_ParentID__c = 'parent2');
       insert mqli1;
       LX_Master_Quote_Line_Item__c mqli2 = new LX_Master_Quote_Line_Item__c(LX_Opportunity__c = opp.id,LX_ParentID__c = 'parent2');
       insert mqli2;
       Test.stopTest();
       ApexPages.StandardController ApptController = new ApexPages.StandardController(mqli1);
     //  cntStocksetImageBrowser objc = new cntStocksetImageBrowser(ApptController);

       PageReference pageRef = new PageReference('/apex/LX_OverrideDel_MasterQuote');
       Test.setCurrentPage(pageRef);
      
       LX_MasterQuoteExtn controller = new LX_MasterQuoteExtn(ApptController);
       controller.deleteList();
       controller.deleteList();
      
    }       
 }