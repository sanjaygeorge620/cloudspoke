@istest(seealldata=true)
public class LX_test_LX_Shipto_Billto_Cntrl{
public static testmethod void accnbext () {
    
    
    
         Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 
    
        LX_SAP_Record_Sales_Org__c SAP_Rec_Sales_org = new LX_SAP_Record_Sales_Org__c();
        SAP_Rec_Sales_org.CurrencyIsoCode = 'USD';
        try
           {
          insert SAP_Rec_Sales_org;
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
       
    
        List<Opportunity> Opplist = new  List<Opportunity>();
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Qualifying',CloseDate=System.today());
       // Opp. LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
        Opplist.add(Opp);
        
        Opportunity opp1 = new Opportunity(AccountId = acc.Id,name='test Opp 1',stageName='Qualifying',CloseDate=System.today());
       // Opp. LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
        Opplist.add(Opp1);
        insert Opplist;
        
         PageReference pRef = Page.LX_CustomBillToLookup;   
         
      
         pRef.getParameters().put('oppId',Opp.id);
         pRef.getParameters().put('newOrderID',LX_OpportunityHelper.newOrderID);
         pRef.getParameters().put('type',LX_OpportunityHelper.type);
         pRef.getParameters().put('projID',LX_OpportunityHelper.projID);
         pRef.getParameters().put('opp',opp1.id);
         
         Test.setCurrentPage(pRef);
     
         //ApexPages.currentPage().getParameters().put(LX_OpportunityHelper.oppid,Opp.id);
         
    
    LX_Shipto_Billto_Cntrl shipto_billto_ctrl = new LX_Shipto_Billto_Cntrl();
    
    shipto_billto_ctrl.createShipBill();
    shipto_billto_ctrl.input1 = 'test';
    shipto_billto_ctrl.input2 = 'testa';
    shipto_billto_ctrl.input3 = 'testb';
    shipto_billto_ctrl.input4 = 'testc';
    shipto_billto_ctrl.input5 = 'testd';
    shipto_billto_ctrl.input6 = 'teste';
    shipto_billto_ctrl.input7 = 'testf';
    shipto_billto_ctrl.input8 = 'testg';
    shipto_billto_ctrl.input9 = 'testh';
    shipto_billto_ctrl.input10 = 'testi';

    shipto_billto_ctrl.searchBill();
   shipto_billto_ctrl.input1 = 'test';
    shipto_billto_ctrl.input2 = 'testa';
    shipto_billto_ctrl.input3 = 'testb';
    shipto_billto_ctrl.input4 = 'testc';
    shipto_billto_ctrl.input5 = 'testd';
    shipto_billto_ctrl.input6 = 'teste';
    shipto_billto_ctrl.input7 = 'testf';
    shipto_billto_ctrl.input8 = 'testg';
    shipto_billto_ctrl.input9 = 'testh';
    shipto_billto_ctrl.input10 = 'testi';
    shipto_billto_ctrl.searchShip();
 //   shipto_billto_ctrl.updateShipTo();
//    shipto_billto_ctrl.updateBillTo();
    shipto_billto_ctrl.Cancel();
    shipto_billto_ctrl.modifyBilltoInfo();
    shipto_billto_ctrl.modifyShiptoInfo();
    shipto_billto_ctrl.onLoad();
    shipto_billto_ctrl.getSortDirection();
    shipto_billto_ctrl.sortFilter();
    
    // shipto_billto_ctrl.LX_Shipto_Billto_Cntrl();
   
}
public static testmethod void m1(){
LX_Shipto_Billto_Cntrl shipto_billto_ctrl_m1 = new LX_Shipto_Billto_Cntrl();

       
    
      //   ApexPages.currentPage().getParameters().put('opp.id',opp.id); 
        
    Sales_Organization__c sales_org = new Sales_Organization__c();
    sales_org.Name = '1047';
    sales_org.Status__c = 'Active';
    sales_org.CurrencyIsoCode = 'USD';
    sales_org.Sales_Organization__c = '1047';
    try
           {
         insert sales_org;
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
    
    
      Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
         try
           {
         insert acc; 
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
        
    
        LX_SAP_Record_Sales_Org__c SAP_Rec_Sales_org = new LX_SAP_Record_Sales_Org__c();
        SAP_Rec_Sales_org.CurrencyIsoCode = 'USD';
        try
           {
          insert SAP_Rec_Sales_org;
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
        
    
        List<Opportunity> Opplist = new  List<Opportunity>();
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Qualifying',CloseDate=System.today());
       opp.Sales_Organization__c = sales_org.Id;
       // Opp. LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
        Opplist.add(Opp);
        
        Opportunity opp1 = new Opportunity(AccountId = acc.Id,name='test Opp 1',stageName='Qualifying',CloseDate=System.today());
       Opp.LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
        Opplist.add(Opp1);
        insert Opplist;
        
         PageReference pRef = Page.LX_CustomBillToLookup;   
         
      
         pRef.getParameters().put('oppId',Opp.id);
         pRef.getParameters().put('newOrderID',LX_OpportunityHelper.newOrderID);
         pRef.getParameters().put('type',LX_OpportunityHelper.type);
         pRef.getParameters().put('projID',LX_OpportunityHelper.projID);
         pRef.getParameters().put('opp',opp1.id);
         
         Test.setCurrentPage(pRef);
        
       
        
      
      /*  ApexPages.currentPage().getParameters().put('oppId',LX_OpportunityHelper.oppId);
         ApexPages.currentPage().getParameters().put('newOrderID',LX_OpportunityHelper.newOrderID);*/
           
 
 
}
public static testmethod void m2(){
LX_Shipto_Billto_Cntrl shipto_billto_ctrl_m2 = new LX_Shipto_Billto_Cntrl();

  /*      PageReference pRef = Page.LX_CustomBillToLookup;   
         Test.setCurrentPage(pRef);*/
    
    Sales_Organization__c sales_org = new Sales_Organization__c();
    sales_org.Name = '1047';
    sales_org.Sales_Organization__c = '1047';
    sales_org.Status__c = 'Active';
    sales_org.CurrencyIsoCode = 'USD';
    try
           {
        insert sales_org;
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
    
    
      Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 
    
        LX_SAP_Record_Sales_Org__c SAP_Rec_Sales_org = new LX_SAP_Record_Sales_Org__c();
        SAP_Rec_Sales_org.CurrencyIsoCode = 'USD';
        
         try
           {
          insert SAP_Rec_Sales_org;
           }
            catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
           }
    
        List<Opportunity> Opplist = new  List<Opportunity>();
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Qualifying',CloseDate=System.today());
       opp.Sales_Organization__c = sales_org.Id;
       // Opp. LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
        Opplist.add(Opp);
        
        Opportunity opp1 = new Opportunity(AccountId = acc.Id,name='test Opp 1',stageName='Qualifying',CloseDate=System.today());
        Opp.LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
        Opplist.add(Opp1);
        insert Opplist;
        
         PageReference pRef = Page.LX_CustomBillToLookup;   
         
      
         pRef.getParameters().put('oppId',Opp.id);
         pRef.getParameters().put('newOrderID',LX_OpportunityHelper.newOrderID);
         pRef.getParameters().put('type',LX_OpportunityHelper.type);
         pRef.getParameters().put('projID',LX_OpportunityHelper.projID);
         pRef.getParameters().put('opp',opp.id);
         
         Test.setCurrentPage(pRef);
        

}
public static testmethod void m3(){
LX_Shipto_Billto_Cntrl shipto_billto_ctrl_m3 = new LX_Shipto_Billto_Cntrl();

     
    Sales_Organization__c sales_org = new Sales_Organization__c();
    sales_org.Name = '1047';
    sales_org.Status__c = 'Active';
    sales_org.Sales_Organization__c = '1047';
    sales_org.CurrencyIsoCode = 'USD';
    insert sales_org;
    
      Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA',MDM_Account_Level__c = '1047'); 
        insert acc; 
        
        
          RecordType rec = [Select id from Recordtype where developername = 'LX_Sold_To' and SobjecttYpe='LX_SAP_Record__c'];
          LX_SAP_Record__c srec = new LX_SAP_Record__c();
         // srec.Name = 'test';
          srec.LX_Sold_To_ID__c = '1047';
          srec.LX_MDM_Act__c = '1047';
          srec.recordtypeId = rec.Id;
          insert srec;
          
          RecordType sapSalesRec = [Select id from Recordtype where developername = 'LX_Sold_To_Sales_Org' and SobjecttYpe='LX_SAP_Record_Sales_Org__c'];

        LX_SAP_Record_Sales_Org__c SAP_Rec_Sales_org = new LX_SAP_Record_Sales_Org__c();
        SAP_Rec_Sales_org.CurrencyIsoCode = 'USD';
        SAP_Rec_Sales_org.LX_Sold_To__c = srec.id;
        SAP_Rec_Sales_org.RecordTypeID = sapSalesRec.id;
        SAP_Rec_Sales_org.LX_Status__c = 'Active';
        insert SAP_Rec_Sales_org;
    
        List<Opportunity> Opplist = new  List<Opportunity>();
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Qualifying',CloseDate=System.today());
       opp.Sales_Organization__c = sales_org.Id;
       Opp.LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
       insert Opp;
       // Opplist.add(Opp);
        
       /* Opportunity opp1 = new Opportunity(AccountId = acc.Id,name='test Opp 1',stageName='Closed Lost',CloseDate=System.today());
        Opp. LX_Sold_To_New__c = SAP_Rec_Sales_org.id;
        Opplist.add(Opp1);
        insert Opplist;
        */
         PageReference pRef = Page.LX_CustomBillToLookup;   
         
      
         pRef.getParameters().put(LX_OpportunityHelper.oppId,Opp.id);
        // pRef.getParameters().put('newOrderID',LX_OpportunityHelper.newOrderID);
        // pRef.getParameters().put('type',LX_OpportunityHelper.type);
       //  pRef.getParameters().put('projID',LX_OpportunityHelper.projID);
          pRef.getParameters().put(LX_OpportunityHelper.type,'BILL');
          pRef.getParameters().put('accountId',acc.id);
          // pRef.getParameters().put('opp',opp1.id);
         
         Test.setCurrentPage(pRef);
        
 

}
}