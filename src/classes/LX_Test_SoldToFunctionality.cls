/* Class Name : LX_Test_SoldToFunctionality 
    * Description  : Test class to cover the code in LX_CustomSoldtoLookup.
    * Created By   : Sumedha
    * Created Date : 06-12-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha          06-12-2013                                           Initial Version
    
    */
@isTest(seeallData=true)
private class LX_Test_SoldToFunctionality {

    static LX_Shipto_Billto_Cntrl billShipCntrl;
    static Account OppAccount,ParentAccount;
    static Opportunity soldToOpp;
    static Sales_Organization__c salesOrg;
    static LX_SAP_Record__c soldToSAP;
    static LX_SAP_Record_Sales_Org__c oppSoldTo;
    static LX_CustomSoldtoLookup custLookup;

    static testMethod void loadData() {
        //Test.loadData(Lx_SetRecordIDs__c.sObjectType,'SetRecordIDTestData');
        OppAccount  = LX_TestData.createAccountForOpportunity(); 
        salesOrg    = LX_TestData.createSalesOrgForOpportunity();
        soldToSAP   = LX_TestData.createSAPsoldTo();
        oppSoldTo   = LX_TestData.createOppSoldTo();
        soldToOpp   = LX_TestData.createOpportunity();

        
    }
    
    static testMethod void testVoidSalesOrgToData(){
        loadData();
        Apexpages.currentPage().getParameters().put('accountId',OppAccount.id);
        Apexpages.currentPage().getParameters().put('oppId',soldToOpp.id);
        Apexpages.currentPage().getParameters().put('type','SOLD');
        custLookup = new LX_CustomSoldtoLookup();
        soldToOpp.AccountID = null;
        update soldToOpp;
        test.startTest();
        Apexpages.currentPage().getParameters().put('accountId',OppAccount.id);
        Apexpages.currentPage().getParameters().put('oppId',soldToOpp.id);
        Apexpages.currentPage().getParameters().put('type','SOLD');
        custLookup = new LX_CustomSoldtoLookup();
        custLookup.onLoad();
        string testString = custLookup.getSortDirection();
        custLookup.setSortDirection('ASC');
        testString = custLookup.getSortDirection();
        custLookup.createSoldto();
        system.assertEquals(custLookup.isError, true);
        test.stopTest();

    }
     static testMethod void testSoldTo(){
        loadData();
        Opportunity loadedOpp = [select id, Account.ParentID from Opportunity where id =:soldToOpp.id];
        soldToSAP.LX_Account__c = loadedOpp.Account.ParentID;
        update soldToSAP;
        test.startTest();
        Apexpages.currentPage().getParameters().put('accountId',OppAccount.id);
        Apexpages.currentPage().getParameters().put('oppId',soldToOpp.id);
        Apexpages.currentPage().getParameters().put('type','SOLD');
        soldToOpp.Sales_Organization__c = salesOrg.id;
        update soldToOpp;
        custLookup = new LX_CustomSoldtoLookup();
        custLookup.sortExpression = 'ASC';
        string direcetion = custLookup.sortExpression;
        custLookup.onLoad();
        custLookUp.input1 ='test';
        custLookUp.input2 ='test';
        custLookUp.input3 ='test';
        //custLookUp.input4 =120;
        custLookUp.input5 ='test';
        custLookUp.input6 ='test';
        custLookUp.input7 ='test';
        custLookUp.input8 ='test';
        custLookUp.Go();
        custLookUp.updateOpp();
        custLookup.setSortDirection('DESC');
        custLookUp.Go();
        system.assertEquals(custLookup.isError, false);
        test.stopTest();
    }
     
/*    static testMethod void testHappyFlow(){
        loadData();
        Opportunity loadedOpp = [select id, Account.ParentID from Opportunity where id =:soldToOpp.id];
        soldToSAP.LX_Account__c = loadedOpp.Account.ParentID;
        update soldToSAP;
        test.startTest();
        Apexpages.currentPage().getParameters().put('accountId',OppAccount.id);
        Apexpages.currentPage().getParameters().put('oppId',soldToOpp.id);
        Apexpages.currentPage().getParameters().put('type','SOLD');
        soldToOpp.Sales_Organization__c = salesOrg.id;
        soldToOpp.LX_Sold_To_New__c     = oppSoldTo.id;
        update soldToOpp;
        billShipCntrl = new LX_Shipto_Billto_Cntrl();
        
    } */
    //Added by Charan
    static testmethod void m1(){
    
    
    }
}