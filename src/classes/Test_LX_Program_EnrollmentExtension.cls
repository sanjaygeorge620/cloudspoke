@isTest(seeAllData=true) 
private class Test_LX_Program_EnrollmentExtension {

    static testMethod void myUnitTest1() {
        test.startTest();
        Test.setCurrentPage(Page.LX_ISSProgram_Enrollment);   
        List<LX_Partner_Program__c> globalPrograms = data_partnerprogram.createGlobalPrograms(1);
        List<LX_Partner_Program__c> globalProgramCategory = data_partnerprogram.createGlobalCategoryPrograms(1,globalPrograms[0]);
        List<LX_Partner_Program__c> localPrograms = data_partnerprogram.createLocalISSPrograms(1,globalProgramCategory[0]);
        
        ApexPages.currentPage().getParameters().put('programId',localPrograms[0].id);        
        ApexPages.currentPage().getParameters().put('RecordId',localPrograms[0].id);  
        ApexPages.currentPage().getParameters().put('RecordType',LX_SetRecordIDs.ISSPartnerEnrollment);         
        ApexPages.currentPage().getParameters().put('retURL','%2F'+localPrograms[0].id);         
        LX_Program_Enrollment__c enrollment = new LX_Program_Enrollment__c ();
        LX_Program_EnrollmentExtension controller = new LX_Program_EnrollmentExtension(new ApexPages.StandardController(enrollment));
        controller.doredirect();
        controller.ObjEnrollment.LX_Account__c = data_account.createAccount3().id;     
        controller.SaveNew();
        controller.cancel();
        test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        test.startTest();
        Test.setCurrentPage(Page.LX_ISSProgram_Enrollment);   
        List<LX_Partner_Program__c> globalPrograms = data_partnerprogram.createGlobalPrograms(1);
        List<LX_Partner_Program__c> globalProgramCategory = data_partnerprogram.createGlobalCategoryPrograms(1,globalPrograms[0]);
        List<LX_Partner_Program__c> localPrograms = data_partnerprogram.createLocalISSPrograms(1,globalProgramCategory[0]);
        
        ApexPages.currentPage().getParameters().put('programId',localPrograms[0].id);        
        ApexPages.currentPage().getParameters().put('RecordId',localPrograms[0].id);  
        ApexPages.currentPage().getParameters().put('RecordType',LX_SetRecordIDs.PSWPartnerEnrollment);         
        LX_Program_Enrollment__c enrollment = new LX_Program_Enrollment__c ();
        LX_Program_EnrollmentExtension controller = new LX_Program_EnrollmentExtension(new ApexPages.StandardController(enrollment));
        controller.doredirect();
        controller.ObjEnrollment.LX_Account__c = data_account.createAccount3().id;     
        controller.SaveNew();
        controller.cancel();
        test.stopTest();
    }
    
}