@isTest(seeAllData=true)
public class Test_LX_Offer_Recordtype_Selection{

    static LX_Offer__c createOffer(){
        LX_Offer__c offer = new LX_Offer__c(salesRegion_quote__c = 'Test');
        insert Offer;
        return offer;
    }  
    
    static testMethod void myUnitTest2(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));     
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'Yes';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        controller.offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c = 'test';
        controller.offer.maxPayoutForVIR_Quote__c = 'test';
        controller.offer.revenueBaseForCalculation_quote__c = 'test';
        controller.offer.LX_payoutSchedule_quote__c = 'test';
        controller.offer.targetBasedOn_quote__c = 'test';
        controller.selectRecordType();
    }
    
    static testMethod void myUnitTest3(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));     
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'Yes';        
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest4(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));     
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'No';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        controller.offer.ValidateSerialNos_quote__c = 'test';
        controller.offer.sellInOut_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.promotionDescription_quote__c = 'test';
        controller.offer.promotionsGroups_quote__c = 'test';
        controller.offer.promotionCategory_quote__c = 'Test';
        controller.offer.thresh_hold_quote__c = 'Test';
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest5(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Sales Incentives';     
        controller.incentivizer = 'Company';
        controller.target = 'No';        
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest6(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_Type__c = 'special Price for a Partner for an un-specified end user';
        controller.onChangeOfferType();     
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest7(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_Type__c = 'special Price for a Partner for an un-specified end user';           
        controller.offer.LX_Start_Date__c = System.today() ;
        controller.offer.LX_End_Date__c = System.today() +30; 
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest8(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_Type__c = 'special Price for a Partner for an un-specified end user';           
        controller.offer.LX_Start_Date__c = System.today()  ;
        controller.offer.LX_End_Date__c = System.today() +120; 
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest9(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_Type__c = 'special Price for a Partner for an un-specified end user';           
        controller.offer.LX_Start_Date__c = System.today() +120 ;
        controller.offer.LX_End_Date__c = System.today() ; 
        controller.selectRecordType();
        test.stopTest();
    }
    
    
    
    static testMethod void myUnitTest10(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_Type__c = 'special Price for a Partner for an un-specified end user';           
        controller.offer.LX_Start_Date__c = System.today() + 120 ;
        controller.offer.LX_End_Date__c = System.today() ; 
        controller.selectRecordType();
        test.stopTest();
    }
    
    
    static testMethod void myUnitTest11(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_Type__c = 'special Price for a Partner for an un-specified end user';           
        controller.offer.LX_Start_Date__c = System.today()  ;
        controller.offer.LX_End_Date__c = System.today() + 92; 
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest12(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Logistics Rebate';               
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest13(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Logistics Rebate';   
        controller.offer.LX_Start_Date__c = System.today();  
        controller.offer.LX_End_Date__c = System.today() + 120;     
        controller.offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c = 'Test';    
        controller.offer.lRPurpose__c = 'Test'; 
        controller.offer.maxPayoutForVIR_Quote__c = 'Test'; 
        controller.offer.revenueBaseForCalculation_quote__c = 'Test';   
        controller.offer.targetBasedOn_quote__c = 'Test';   
        controller.selectRecordType();
        test.stopTest();
    
    }
    static testMethod void myUnitTest14(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Price Protection';
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest15(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Price Protection';
        controller.offer.daysClaimDueIn_quote__c = 'Test';
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.selectRecordType();
    }
    
    static testMethod void myUnitTest16(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Marketing Development Fund';    
        test.stopTest();
    }
    
    static testMethod void myUnitTest17(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Marketing Development Fund';
        controller.offer.LX_mDFBudgetAmount_quote__c = 123;
        controller.offer.LX_annualPayout_quote__c = 123;
        controller.offer.LX_payoutSchedule_quote__c = 'Test';
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest18(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Offer without Dealdesk Quote';     
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.selectRecordType();
        test.stopTest();
    }
    
    static testMethod void myUnitTest19(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer()));
        controller.offer.LX_Offer_type__c = 'Pricelist Offer';      
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.offer.salesregion_quote__c = 'Test';
        controller.m_sessionCurrency = 'Test';
        controller.offer.quote_type__c = 'Test';
        controller.offer.LX_Description__c = 'Test';        
        controller.selectRecordType();
        test.stopTest();
    }
    
    
    static testMethod void myUnitTest1(){
        test.startTest();
        Test.setCurrentPage(Page.LX_Offer_Recordtype_Selection);
        LX_Offer_Recordtype_Selection_Extension controller = new LX_Offer_Recordtype_Selection_Extension (new ApexPages.StandardController(createOffer())); 
        controller.offer.LX_Offer_Type__c = 'Sales Incentives';
        controller.onChangeOfferType();    

        controller.offer.LX_Offer_Type__c = 'special Price for a Partner for an un-specified end user';
        controller.onChangeOfferType();     

        controller.offer.LX_Offer_Type__c = 'Logistics Rebate';
        controller.onChangeOfferType();
    
        controller.offer.LX_Offer_Type__c = 'Price Protection';
        controller.onChangeOfferType();   
        
        controller.offer.LX_Offer_Type__c = 'Marketing Development Fund';
        controller.onChangeOfferType(); 
        
        controller.isQuestion = 'No';   
        controller.onChangeQuestion();    
        controller.isQuestion2 = 'No';  
        controller.onChangeQuestion2();   
        
        controller.incentivizer = 'Company';
        controller.onChangeIncentives();
        
        controller.target = 'Yes';
        controller.onChangeTarget();
        
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_Start_Date__c = system.today() +100;
        controller.onDateInput();
        test.StopTest();
        
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_Start_Date__c = system.today() +20;
        controller.onDateInput();
        
        controller.isQuestion2 = 'Yes';
        controller.offer.LX_Offer_Type__c = '';
        controller.selectRecordType();
        
        controller.isQuestion2 = 'No';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Sales Rep';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'No';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'Yes';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        controller.offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c = 'test';
        controller.offer.maxPayoutForVIR_Quote__c = 'test';
        controller.offer.revenueBaseForCalculation_quote__c = 'test';
        controller.offer.LX_payoutSchedule_quote__c = 'test';
        controller.offer.targetBasedOn_quote__c = 'test';
        controller.selectRecordType();
       
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'No';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        controller.selectRecordType();
       
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'No';
        controller.offer.LX_Start_Date__c = System.today();
        controller.offer.LX_End_Date__c = System.today() + 35;
        controller.offer.ValidateSerialNos_quote__c = 'test';
        controller.offer.sellInOut_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.promotionDescription_quote__c = 'test';
        controller.offer.promotionsGroups_quote__c = 'test';
        controller.offer.promotionCategory_quote__c = 'Test';
        controller.offer.thresh_hold_quote__c = 'Test';
        controller.selectRecordType();
       
        controller.offer.LX_Offer_type__c = 'special Price for a Partner for an un-specified end user';       
        controller.offer.LX_Start_Date__c = System.today() +30;
        controller.offer.sellInOut_quote__c = 'test';     
        controller.offer.ValidateSerialNos_quote__c = 'test';     
        controller.offer.doesThisQuoteRequireAnSPR_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.thresh_hold_quote__c = 'test';       
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'special Price for a Partner for an un-specified end user';       
        controller.offer.LX_Start_Date__c = System.today() ;
        controller.offer.LX_End_Date__c = System.today() +30; 
        controller.offer.sellInOut_quote__c = 'test';     
        controller.offer.ValidateSerialNos_quote__c = 'test';     
        controller.offer.doesThisQuoteRequireAnSPR_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.thresh_hold_quote__c = 'test';       
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'special Price for a Partner for an un-specified end user';       
        controller.offer.LX_Start_Date__c = System.today() ;
        controller.offer.LX_End_Date__c = System.today() +120;    
        controller.offer.sellInOut_quote__c = 'test';     
        controller.offer.ValidateSerialNos_quote__c = 'test';     
        controller.offer.doesThisQuoteRequireAnSPR_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.thresh_hold_quote__c = 'test';       
        controller.selectRecordType();
        
    
        controller.offer.LX_Offer_type__c = 'special Price for a Partner for an un-specified end user';       
        controller.offer.LX_Start_Date__c = System.today() +120;
        controller.offer.LX_End_Date__c = System.today() ;    
        controller.offer.sellInOut_quote__c = 'test';     
        controller.offer.ValidateSerialNos_quote__c = 'test';     
        controller.offer.doesThisQuoteRequireAnSPR_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.thresh_hold_quote__c = 'test';       
        controller.selectRecordType();
       
        controller.offer.LX_Offer_type__c = 'special Price for a Partner for an un-specified end user';  
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'special Price for a Partner for an un-specified end user';       
        controller.offer.LX_Start_Date__c = System.today() +120;
        controller.offer.LX_End_Date__c = System.today() ;    
        controller.offer.sellInOut_quote__c = 'test';     
        controller.offer.ValidateSerialNos_quote__c = 'test';     
        controller.offer.doesThisQuoteRequireAnSPR_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.thresh_hold_quote__c = 'test';       
        controller.selectRecordType();
        
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.onDateInput();         
        
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 30;
        controller.onDateInput();         
        
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'Yes';        
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Sales Incentives';
        controller.incentivizer = 'Company';
        controller.target = 'Yes';        
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Logistics Rebate';               
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Logistics Rebate';   
        controller.offer.LX_Start_Date__c = System.today();  
        controller.offer.LX_End_Date__c = System.today() + 120;     
        controller.offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c = 'Test';    
        controller.offer.lRPurpose__c = 'Test'; 
        controller.offer.maxPayoutForVIR_Quote__c = 'Test'; 
        controller.offer.revenueBaseForCalculation_quote__c = 'Test';   
        controller.offer.targetBasedOn_quote__c = 'Test';   
        controller.selectRecordType();
       
        controller.offer.LX_Offer_type__c = 'Price Protection';
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Price Protection';
        controller.offer.daysClaimDueIn_quote__c = 'Test';
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Marketing Development Fund';       
        controller.selectRecordType();
       
        controller.offer.LX_Offer_type__c = 'Marketing Development Fund';
        controller.offer.LX_mDFBudgetAmount_quote__c = 123;
        controller.offer.LX_annualPayout_quote__c = 123;
        controller.offer.LX_payoutSchedule_quote__c = 'Test';
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Offer without Dealdesk Quote';     
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'Pricelist Offer';      
        controller.offer.LX_Start_Date__c = system.today();
        controller.offer.LX_End_Date__c = system.today() + 120;
        controller.offer.salesregion_quote__c = 'Test';
        controller.m_sessionCurrency = 'Test';
        controller.offer.quote_type__c = 'Test';
        controller.offer.LX_Description__c = 'Test';        
        controller.selectRecordType();
        
        controller.offer.LX_Offer_type__c = 'special Price for a Partner for an un-specified end user';       
        controller.offer.LX_Start_Date__c = System.today() +120;
        controller.offer.LX_End_Date__c = System.today() ;    
        controller.offer.sellInOut_quote__c = 'test';     
        controller.offer.ValidateSerialNos_quote__c = 'test';     
        controller.offer.doesThisQuoteRequireAnSPR_quote__c = 'test';
        controller.offer.daysClaimDueIn_quote__c = 'test';
        controller.offer.thresh_hold_quote__c = 'test';       
        controller.selectRecordType();
       
        Sales_Organization__c salesOrg = new Sales_Organization__c(LX_Default__c = true,Name = 'Test',Sales_Organization__c  = '123');
        insert salesOrg;
        Currency_Rate__c cr = new Currency_Rate__c(name = 'Test');
        insert cr;
        Sales_Org_Currency__c salesOrgCurrency = new Sales_Org_Currency__c(Sales_Organization__c = salesOrg.id,Currency_Name__c = cr.id);
        insert salesOrgCurrency;
        
        controller.offer.LX_Offer_Type__c = 'Sales Incentives';
        controller.onChangeOfferType(); 
        
        controller.onChangeQuestion();
        controller.onChangeQuestion2();
        controller.onChangeIncentives();        
        controller.onChangeTarget();
        controller.onDateInput();
        controller.getQuestions();
        controller.getQuestions2();
        controller.getincentivizersList();
        controller.getTargetList();
        controller.getSalesOrgSelectOptions();
        controller.selectRecordType();      
        
        controller.getQuestions();
        controller.getQuestions2();
        controller.getincentivizersList();
        controller.getTargetList();
        
    }

}