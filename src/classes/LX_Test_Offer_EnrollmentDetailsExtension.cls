/* Class Name   : LX_Test_Offer_EnrollmentDetailsExtension
 * Description  : Test Class to test LX_Offer_EnrollmentDetailsExtension
 * Created By   : Abhishek Kumar
 * Created On   : 01-Jan-14

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Abhishek Kumar           01-Jan-14          Initial version
*/

@isTest(seeAllData=true)
private class LX_Test_Offer_EnrollmentDetailsExtension {
    
    static LX_Offer__c offRecord;
    static LX_Partner_Program__c localPartnerProgram ;  
    static Sales_Organization__c salesOrg ;  
    static Account partAcc;
    static Account mdmAcc;
    static LX_SAP_Record__c sapRcrd;
    static Sales_Org_Currency__c salesOrgCur ;
    static Currency_Rate__c currRate;
    
    public static void PartnerProgram(){
        try{
        LX_Partner_Program__c globalPartnerProgram = new LX_Partner_Program__c();
        globalPartnerProgram.RecordTypeId = LX_SetRecordIDs.GlobalProgram;
        globalPartnerProgram.Program_Status__c = 'Being Defined';
        globalPartnerProgram.Program_Level__c = 'Global Program (L1)';
        globalPartnerProgram.LX_Program_Type__c = 'ISS';
        globalPartnerProgram.LX_Start_Date__c = system.today();
        globalPartnerProgram.Program_End_Date__c = system.today() +200;
        insert globalPartnerProgram ;
        
        //Global Program Category
        LX_Partner_Program__c globalPartnerProgramCategory = new LX_Partner_Program__c();
        globalPartnerProgramCategory.RecordTypeId = LX_SetRecordIDs.GlobalISSProgramCategoryRTID;
        globalPartnerProgramCategory.Global_Program__c = globalPartnerProgram.id;
        globalPartnerProgramCategory.Program_Status__c = 'Being Defined';
        globalPartnerProgramCategory.Program_Level__c = 'Global Program Category (L2)';
        globalPartnerProgramCategory.LX_Program_Type__c = 'ISS';
        globalPartnerProgramCategory.LX_Start_Date__c = system.today();
        globalPartnerProgramCategory.Program_End_Date__c = system.today() +200;
        insert globalPartnerProgramCategory;
                
        //Local program
        //LX_Partner_Program__c localPartnerProgram = new LX_Partner_Program__c();
        localPartnerProgram = new LX_Partner_Program__c();
        localPartnerProgram.RecordTypeId = LX_SetRecordIDs.LocalISSProgramRTID;
        localPartnerProgram.LX_Program_Enrolled__c = globalPartnerProgramCategory.id;
        localPartnerProgram.Program_Status__c = 'Being Defined';
        localPartnerProgram.Program_Level__c = 'Global Program Category (L3)';
        localPartnerProgram.LX_Program_Type__c = 'ISS';
        localPartnerProgram.lx_country__c = 'USA';
        localPartnerProgram.Program_Status__c = 'Active'; 
        localPartnerProgram.LX_Approval_Status__c = 'Approved'; 
        localPartnerProgram.LX_Start_Date__c = system.today();
        localPartnerProgram.Program_End_Date__c = system.today() +200;
        insert localPartnerProgram;        
        }
        catch(Exception e){ }
    
    }
    
    public static void createOffer(){
        try{
        offRecord = new LX_Offer__c();
        offRecord.Name = 'TestOffer' ;
        offRecord.Lx_Program__c = 'Deal';
        offRecord.RecordTypeId=LX_SetRecordIDs.priceProtectionOfferId;
        offRecord.daysClaimDueIn_quote__c = '54'; 
        offRecord.LX_Start_Date__c = Date.today(); 
        offRecord.LX_End_Date__c = Date.today()+ 5;
        offRecord.LX_Quote_Category__c = 'Pricelist Offer';
        offRecord.Lx_Quote_Currency__c = 'EUR';
        createSalesOrg();
        createSalesOrgCur();
        offRecord.Sales_Organization__c = salesOrg.id;
        
        insert offRecord ;
        }
        catch(Exception e){ }
    }
    
    public static void createProgramOffer(){
        try{
        LX_Program_Offer__c prOffRecord = new LX_Program_Offer__c();
        prOffRecord.LX_Offer__c = offRecord.id;
        prOffRecord.LX_Partner_Program__c = localPartnerProgram.id;
        
        insert prOffRecord ;
        }
        catch(Exception e){ }
    }
    
    public static void createMDMAccount(){
        try{
        mdmAcc = Data_Account.createMDMAccount();
       }
       catch(Exception e) { }
    }
    
     public static void createPartAccount(){
         try{
        partAcc = Data_Account.createPartnerAccount();
        }
        catch(Exception e){ }
    }
    
    public static void createEnrollment(){
        try{
        LX_Program_Enrollment__c prEnrol = new LX_Program_Enrollment__c();
        prEnrol.LX_Account__c = partAcc.Id;
        prEnrol.Master_Program__c = localPartnerProgram.id;
        
        insert prEnrol;
        }
        catch(Exception e){ }
    }
    
    public static void createSalesOrg(){
        try{
        salesOrg = new Sales_Organization__c();    
        salesOrg.LX_Country_Code__c = 'DE';
        salesOrg.Include_in_VSOE__c= True;
        salesOrg.Name = 'Germany';
        salesOrg.LX_Sales_Geo__c ='EMEA';
        salesOrg.Sales_Organization__c='1013';
        
        insert salesOrg;
        }
        catch(Exception e){ }
    }
    
    public static void createSalesOrgCur(){
        try{
        salesOrgCur = new Sales_Org_Currency__c(); 
        createCurrencyRate();   
        salesOrgCur.Sales_Organization__c = salesOrg.id;
        salesOrgCur.Currency_Name__c= currRate.Id;
        
        insert salesOrgCur;
        }
        catch(Exception e){ }
    }
    
    public static void createCurrencyRate(){
        try{
        currRate = new Currency_Rate__c();    
        currRate.Name = 'EUR';
        currRate.Rate__c= 0.73;
        
        insert currRate;
        }
        catch(Exception e) { }
    }
    
    
    public static void createSAPRecord()
    {
        try{
        sapRcrd = new LX_SAP_Record__c();
      //  sapRcrd.Name = 'Test SAP';
        //sapRcrd.LX_Sales_Org1__c='1013';
        sapRcrd.LX_Account__c = mdmAcc.id;
        sapRcrd.LX_MDM_Act__c = '1234';
        sapRcrd.LX_Sold_To_ID__c = '1122334';
        sapRcrd.LX_Status__c = 'Active' ;
        sapRcrd.RecordTypeId = LX_SetRecordIDs.SAPRecordSoldToId ;
        
        insert sapRcrd ;    
        }
        catch(Exception e) { }
    }
    
    public static void createSAPRecordSalesOrg()
    {
        try{
        LX_SAP_Record_Sales_Org__c sapRcrdSalOrg = new LX_SAP_Record_Sales_Org__c();
        //sapRcrdSalOrg.Name = 'Test SAP';
        sapRcrdSalOrg.LX_Sales_Org1__c = '1013';
        sapRcrdSalOrg.LX_Sold_To__c = sapRcrd.id; 
        sapRcrdSalOrg.LX_Status__c = 'Active'; 
        sapRcrdSalOrg.LX_Currency__c = 'EUR';
        
        insert sapRcrdSalOrg ;  
        }
        catch(Exception e) { }  
    }
    
    static testmethod void offerEnrollment()
    {    
        try{
        createMDMAccount();
        createPartAccount();
        PartnerProgram();
        createEnrollment();
        createSAPRecord();
        createSAPRecordSalesOrg();
        createOffer();
        createProgramOffer();
        pageReference pgRef = Page.LX_Offer_Enrollment;
        pgRef.getparameters().put('offerId',offRecord.Id);
        pgRef.getparameters().put('program',offRecord.Lx_Program__c);
        pgRef.getparameters().put('GEO',offRecord.salesGeo_quote__c);
        pgRef.getparameters().put('Quotecat',offRecord.LX_Quote_Category__c); 
        test.setCurrentPage(pgRef);
        LX_Offer_EnrollmentDetailsExtension offEnrol = new LX_Offer_EnrollmentDetailsExtension(new ApexPages.StandardController(offRecord));
       
        pageReference pgRef1 = Page.LX_Offer_Enrollment;
        pgRef1.getparameters().put('offerId',offRecord.Id);
        pgRef1.getparameters().put('program','No Program');
        pgRef1.getparameters().put('GEO',offRecord.salesGeo_quote__c);
        pgRef1.getparameters().put('Quotecat',offRecord.LX_Quote_Category__c);
        test.setCurrentPage(pgRef1);
        
        LX_Offer_EnrollmentDetailsExtension offEnrol1 = new LX_Offer_EnrollmentDetailsExtension(new ApexPages.StandardController(offRecord));
        offEnrol1.accountName = 'Account4TestMethod';
       // offEnrol.createOfferEnrollment();
        
        list<selectOption> purchasingMethodList = offEnrol.getpurchasingMethodList();
        system.assertNotEquals(null, purchasingMethodList); 
        
        list<selectOption> claimingPartyList = offEnrol.getclaimingPartyList();
        system.assertNotEquals(null, claimingPartyList); 
        
        list<selectOption> timingofDiscountList = offEnrol.gettimingofDiscountList();
        system.assertNotEquals(null, timingofDiscountList);
        
        list<selectOption> partyRoleList = offEnrol.getpartyRoleList();
        system.assertNotEquals(null, partyRoleList);
        
        list<selectOption> shipDebitList = offEnrol.getshipDebitList();
        system.assertNotEquals(null, shipDebitList);
        
        list<selectOption> ISSCapabilityList= offEnrol.getoptISSCapability();
        system.assertNotEquals(null, ISSCapabilityList);
        
        list<selectOption> ISSSegmentList = offEnrol.getoptISSSegment();
        system.assertNotEquals(null, ISSSegmentList);
        
        list<selectOption> ISSCoverageModelList = offEnrol.getoptISSCoverageModel();
        system.assertNotEquals(null, ISSCoverageModelList);
        
        list<selectOption> ISSCOverageStatusList = offEnrol.getoptISSCOverageStatus();
        system.assertNotEquals(null, ISSCOverageStatusList);
        
        offEnrol.partyRole = 'Business Customer';
        offEnrol.showShipDebit();
        offEnrol.getProgramOffer();
        offEnrol1.filterBasedonAccount();
        offEnrol.getProgramEnrollment();  
        offEnrol.offEnrollist[0].selected = true;
        offEnrol.createOfferEnrollment(); 
        offEnrol.SearchLogic();
        offEnrol.cancelLogic();
        
        
        LX_Offer_EnrollmentDetailsExtension.OfferEnrolWrapper offWrap = new LX_Offer_EnrollmentDetailsExtension.OfferEnrolWrapper();
        
        }
        catch(Exception e) { }
        
    }
    
    
    
}