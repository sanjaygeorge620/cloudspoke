@isTest(seeAllData=true)
private class Test_LX_Program_offers_contr {
    static testMethod void myUnitTest() {
       //Global Program
        LX_Partner_Program__c globalPartnerProgram = new LX_Partner_Program__c();
        //globalPartnerProgram .RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Global Program').getRecordTypeId();
        globalPartnerProgram .RecordTypeId = LX_SetRecordIDs.GlobalProgram;
        globalPartnerProgram.Program_Status__c = 'Being Defined';
        globalPartnerProgram.Program_Level__c = 'Global Program (L1)';
        globalPartnerProgram.LX_Program_Type__c = 'ISS';
        globalPartnerProgram.LX_Start_Date__c = system.today();
        globalPartnerProgram.Program_End_Date__c = system.today() +200;
        insert globalPartnerProgram ;
        
        //Global Program Category
        LX_Partner_Program__c globalPartnerProgramCategory = new LX_Partner_Program__c();
        //globalPartnerProgramCategory.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Global ISS Program Category').getRecordTypeId();
        globalPartnerProgramCategory.RecordTypeId = LX_SetRecordIDs.GlobalISSProgramCategoryRTID;
        globalPartnerProgramCategory.Global_Program__c = globalPartnerProgram .id;
        globalPartnerProgramCategory.Program_Status__c = 'Being Defined';
        globalPartnerProgramCategory.Program_Level__c = 'Global Program Category (L2)';
        globalPartnerProgramCategory.LX_Program_Type__c = 'ISS';
        globalPartnerProgramCategory.LX_Start_Date__c = system.today();
        globalPartnerProgramCategory.Program_End_Date__c = system.today() +200;
        insert globalPartnerProgramCategory;
                
        //Local program
        LX_Partner_Program__c localPartnerProgram = new LX_Partner_Program__c();
        //localPartnerProgram.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Local ISS Program').getRecordTypeId();
        localPartnerProgram.RecordTypeId = LX_SetRecordIDs.LocalISSProgramRTID;
        localPartnerProgram.LX_Program_Enrolled__c = globalPartnerProgramCategory.id;
        localPartnerProgram.Program_Status__c = 'Being Defined';
        localPartnerProgram.Program_Level__c = 'Global Program Category (L3)';
        localPartnerProgram.LX_Program_Type__c = 'ISS';
        localPartnerProgram.lx_country__c = 'USA';
        localPartnerProgram.Program_Status__c = 'Active'; 
        localPartnerProgram.LX_Approval_Status__c = 'Approved'; 
        localPartnerProgram.LX_Start_Date__c = system.today();
        localPartnerProgram.Program_End_Date__c = system.today().addDays(200);
        insert localPartnerProgram;
        
        //Offer
        LX_Offer__c offer = new lx_offer__c();
        offer.Name = 'Test Class';   
        offer.LX_Country__c = 'USA';
        offer.LX_Region__c = 'USA';
        offer.LX_Country__c = 'North America';
        offer.LX_Offer_Level__c = 'Master';
        offer.LX_Start_Date__c = system.today().addDays(15);
        offer.LX_End_Date__c = system.today().addDays(200);
        offer.RecordTypeId =  LX_SetRecordIDs.SpiffRecordtypeID;        
        offer.salesRegion_quote__c = 'USA';
        insert offer;  
        
        Test.setCurrentPage(Page.LX_Program_offers);   
        ApexPages.currentPage().getParameters().put('ProgramID',localPartnerProgram.id);          
        LX_Program_offers_contr controller = new LX_Program_offers_contr();                
        controller.Save();
        controller.cancel();        
    }
}