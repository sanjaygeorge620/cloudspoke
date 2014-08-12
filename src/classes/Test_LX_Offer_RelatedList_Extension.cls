@isTest(seeAllData=true)
private class Test_LX_Offer_RelatedList_Extension {
    static Recordtype masterOfferRtId = [select id,developername from recordtype where sobjecttype = 'LX_Offer__c' and DeveloperName = 'Master'];
    static testMethod void myUnitTest() {
        
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
        localPartnerProgram.LX_Start_Date__c = system.today();
        localPartnerProgram.Program_End_Date__c = system.today() +200;
        insert localPartnerProgram;
        
        //Offer
        LX_Offer__c offer = new lx_offer__c();
        offer.Name = 'Test Class';   
        offer.LX_Country__c = 'USA';
        offer.LX_Region__c = 'USA';
        offer.LX_Country__c = 'North America';
        offer.LX_Offer_Level__c = 'Master';
        offer.LX_Start_Date__c = system.today();
        offer.LX_End_Date__c = system.today()+200;
        //offer.RecordTypeId = '012f00000000D8n';
        //offer.RecordTypeId = schema.SObjectType.LX_Offer__c.getRecordTypeInfosByName().get('Master').getRecordTypeId();
        offer.RecordTypeId =  masterOfferRtId.id;
        //offer.RecordTypeId = LX_SetRecordIDs.parentOfferId;
        insert offer;
        
        //Offer
        LX_Offer__c childOffer = new lx_offer__c();
        childOffer.Name = 'Test Class';
        childOffer.LX_Country__c = 'USA';
        childOffer.LX_Region__c = 'USA';
        childOffer.LX_Country__c = 'North America';
        childOffer.LX_Offer_Level__c = 'Child';
        childOffer.LX_Start_Date__c = system.today();
        childOffer.LX_End_Date__c = system.today()+200;
        //childOffer.RecordTypeId = schema.SObjectType.LX_Offer__c.getRecordTypeInfosByName().get('Child').getRecordTypeId();
        //childOffer.RecordTypeId = '012f00000000D8m';
        childOffer.RecordTypeId = LX_SetRecordIDs.childOfferId;
        childOffer.LX_Parent_Offer__c = offer.id;
        insert childOffer;  
        
        //Program Offer
        LX_Program_Offer__c programOffer = new LX_Program_Offer__c();
        programOffer.LX_Partner_Program__c = localPartnerProgram.Id;
        programOffer.RecordTypeId = schema.SObjectType.LX_Program_Offer__c.getRecordTypeInfosByName().get('Program Offers').getRecordTypeId();        
        programOffer.LX_Offer__c = childOffer.id;
        insert programOffer;
        
        Test.setCurrentPage(Page.LX_Offers_RelatedList);   
        ApexPages.currentPage().getParameters().put('id',localPartnerProgram.id);          
        LX_Offer_RelatedList_Extension controller = new LX_Offer_RelatedList_Extension (new ApexPages.StandardController(localPartnerProgram) );
        controller.DeleteOffer();
    }
}