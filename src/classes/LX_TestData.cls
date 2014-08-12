/*
Class Name : LX_TestData
Description : Class that generates the test data for the Sold To Functionality
Created By : Rahul Raghunathan (rraghunathan@deloitte.com)
Created Date : 01-08-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Rahul Raghunathan      01-08-2013        1000                   Initial Version
*************************************************************************/

@isTest(seeAllData=true)
public class LX_TestData {

    static Account OppAccount;
    static Account ParentAccount;
    static Opportunity soldToOpp;
    static Sales_Organization__c salesOrg;
    static LX_SAP_Record__c soldToSAP;
    static LX_SAP_Record_Sales_Org__c oppSoldTo;



    /*
     * 
     * Description : This methods create a Location Paryner and MDM partner account.
     * Param - : none
     * Returns : instance of an account record
    */    
    static public testMethod Account createAccountForOpportunity() {
        ID Lx_MDM_Partner       = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('MDM Partner').getRecordTypeId();
        ID Lx_Location_Partner  = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
        
              
        ParentAccount  = new Account(Name = 'Parent Account',RecordTypeId=Lx_MDM_Partner,BillingCountry='USA',Physical_Country__c = 'USA');
        insert ParentAccount;

        OppAccount  = new Account(Name = 'Opp Account',RecordTypeId=Lx_Location_Partner,ParentID=ParentAccount.Id,BillingCountry='USA',Physical_Country__c = 'USA');
        insert OppAccount;
        return OppAccount;
    }
    
     /*
     * 
     * Description : This method is used to create Opportunity with the Account created in the createAccountForOpportunity() method 
     * Param - : none
     * Returns : instance of an opportunity record
    */    
    static public testmethod Opportunity createOpportunity(){
        if(soldToOpp == null){
            createAccountForOpportunity();
        }
        soldToOpp = new Opportunity(AccountID =OppAccount.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='Add On Solution',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');   
            
            soldToOpp.Technology__c = true;
           
        insert soldToOpp;   
        return soldToOpp;
    }


     /*
     * 
     * Description :     This method is used to create sales organization with the country code as 'US' and Sales Org Id as '5097' 
     * Param - : none
     * Returns : instance of an Sales_Organization__c record
    */    

    static public testmethod Sales_Organization__c createSalesOrgForOpportunity(){
    ID Lx_MDM_Partner       = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('MDM Partner').getRecordTypeId();
        Account ParentAccount1  = new Account(Name = 'Parent Account',RecordTypeId=Lx_MDM_Partner,BillingCountry='USA',Physical_Country__c = 'USA');
        insert ParentAccount1;
        salesOrg = new Sales_Organization__c();
        salesOrg.LX_Country_Code__c = 'US';
        salesOrg.Sales_Organization__c='5097';
        salesOrg.LX_Available_Currencies__c = 'USD';
        //salesOrg.LX_Sold_to_Account__c = ParentAccount1.id;
        salesOrg.Name='United States';
        insert salesOrg;
        return salesOrg;
    }

    /*
     * 
     * Description : This method is used to create SAP Sales Org for the given org. 
     * Param - : none
     * Returns : instance of an LX_SAP_Record__c record
    */    

    static public testmethod LX_SAP_Record__c createSAPsoldTo(){
    ID Lx_MDM_Partner       = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
     string soldToRecordTypeId = LX_SAP_Record__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
     Account ParentAccount1  = new Account(Name = 'Parent Account',RecordTypeId=Lx_MDM_Partner,BillingCountry='USA',Physical_Country__c = 'USA');
        insert ParentAccount1;
     soldToSAP = new LX_SAP_Record__c();
     soldToSAP.LX_Account__c = ParentAccount1.id; 
     //soldToSAP.LX_Sold_To_ID__c='307892';
     soldToSAP.LX_Status__c='Active';
     soldToSAP.LX_MDM_Act__c='123456';
     soldToSAP.recordtypeid=soldToRecordTypeId;
     insert soldToSAP;
     return soldToSAp;
    }

    /*
     * 
     * Description :     This method is used to create SAP Sales Org for the given org. 
     * Param - : none
     * Returns : instance of an LX_SAP_Record_Sales_Org__c record
    */    
    
    static public testmethod LX_SAP_Record_Sales_Org__c createOppSoldTo(){
        LX_SAP_Record__c soldToSAP1 = createSAPsoldTo();
        string soldToRecordTypeId = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
        oppSoldTo = new LX_SAP_Record_Sales_Org__c();
        oppSoldTo.recordtypeid=soldToRecordTypeId; 
        oppSoldTo.LX_Sold_To__c=soldToSAP1.id;
        oppSoldTo.LX_Status__c='Active';
        oppSoldTo.LX_Sales_Org1__c='5097';
        oppSoldTo.LX_Currency__c = 'INR';
        oppSoldTo.LX_Sold_To_And_Sales_Org_Concat_Key__c = oppSoldTo.LX_Sales_Org1__c+ soldToSAP1.LX_Sold_To_ID__c;
        
        list<LX_SAP_Record_Sales_Org__c> testrecord  = [select id from LX_SAP_Record_Sales_Org__c  where LX_Sold_To_And_Sales_Org_Concat_Key__c =:oppSoldTo.LX_Sold_To_And_Sales_Org_Concat_Key__c];
        
        if(testrecord.size() > 0){
            oppSoldTo.id = testrecord[0].id;
            update oppSoldTo;
        }else{
            try{
                insert oppSoldTo;        
            }catch (exception ex){
                string str = ex.getMessage();
                str = str.substringAfterLast('id: ');
                str = str.substringBeforeLast(':');
                oppSoldTo.id = str;
            }
        }        
         

        return oppSoldTo;
    }

}