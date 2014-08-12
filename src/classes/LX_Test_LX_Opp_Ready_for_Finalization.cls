@isTest(SeeAllData=true)
public class LX_Test_LX_Opp_Ready_for_Finalization{
 
 static testMethod void createQuote(){
     
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
       /*    Id idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
           Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Ship To').getRecordTypeId();
           LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_MDM_Act__c='12345',LX_Name__c='Sold Test',LX_Physical_Postal_Code__c='66666', RecordTypeId=idRecordType, LX_Account__c = acc.id,LX_Currency__c =20.90,LX_Payment_Terms__c ='xyz');
           System.debug('LX_SAP_Record Id ' + oSRec.Name);
           insert oSRec;
           LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_MDM_Act__c='12345',LX_Name__c='Ship Test', LX_Physical_Postal_Code__c='66666',RecordTypeId=idRecordType1, LX_Account__c = acc.id);
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
        test.starttest();
        //insert opp
       Opportunity opp = new Opportunity(AccountID = acc2.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='New Logo',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',CampaignID= camp.id);
       insert opp;
       //insert quote
       BigMachines__Quote__c Quote2=new BigMachines__Quote__c(BigMachines__Opportunity__c=opp.id,
                                                                name='quote2',BigMachines__Is_Primary__c=true);                                                           
  
       insert Quote2;
       
       LX_Opp_Ready_for_Finalization.OppId = opp.id;
       LX_Opp_Ready_for_Finalization.getPrimaryQuote();
       LX_Opp_Ready_for_Finalization.GetOpp(opp.id);
       test.stoptest();
      */
    }
 }