@isTest(seeAllData=true)
public class LX_Test_Enrollment_ProgramsController{
    
    private static testMethod void m1(){
        test.StartTest();        
        account acc = Data_Account.createPartnerAccount();
        list<LX_Partner_Program__c> globalPrograms = Data_partnerProgram.createGlobalPrograms(1);
        list<LX_Partner_Program__c> globalProgramCategories = Data_partnerProgram.createGlobalCategoryPrograms(1,globalPrograms[0]);
        list<LX_Partner_Program__c> localPrograms = Data_partnerProgram.createLocalISSPrograms(1,globalProgramCategories[0]);   
        
        PageReference pageRef = Page.customPartnerPrograms;     
        Test.setCurrentPage(pageRef);  
        System.currentPageReference().getParameters().put('lksrch','test');
        System.currentPageReference().getParameters().put('programId',localPrograms[0].id);        
        System.currentPageReference().getParameters().put('fromPartner','true');
        
        LX_Enrollment_ProgramsController controller = new LX_Enrollment_ProgramsController();        
        test.Stoptest();    
    }
    
    private static testMethod void m2(){
        test.StartTest();        
        account acc = Data_Account.createPartnerAccount();
        list<LX_Partner_Program__c> globalPrograms = Data_partnerProgram.createGlobalPrograms(1);
        list<LX_Partner_Program__c> globalProgramCategories = Data_partnerProgram.createGlobalCategoryPrograms(1,globalPrograms[0]);
        list<LX_Partner_Program__c> localPrograms = Data_partnerProgram.createLocalISSPrograms(1,globalProgramCategories[0]);   
        
        PageReference pageRef = Page.customPartnerPrograms;     
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('lksrch','test');
        System.currentPageReference().getParameters().put('accountID',acc.id);        
        System.currentPageReference().getParameters().put('fromPartner','false');
        
        LX_Enrollment_ProgramsController controller = new LX_Enrollment_ProgramsController();        
        test.Stoptest();    
    }   
    
    private static testMethod void m3(){
        test.StartTest();        
        account acc = Data_Account.createPartnerAccount();
        list<LX_Partner_Program__c> globalPrograms = Data_partnerProgram.createGlobalPrograms(1);
        list<LX_Partner_Program__c> globalProgramCategories = Data_partnerProgram.createGlobalCategoryPrograms(1,globalPrograms[0]);
        list<LX_Partner_Program__c> localPrograms = Data_partnerProgram.createLocalISSPrograms(1,globalProgramCategories[0]);   
        
        PageReference pageRef = Page.customPartnerPrograms;     
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('lksrch','test');
        LX_Enrollment_ProgramsController controller = new LX_Enrollment_ProgramsController();        
        test.Stoptest();    
    }   
    
    private static testMethod void m4(){
        test.StartTest();        
        account acc = Data_Account.createPartnerAccount();
        list<LX_Partner_Program__c> globalPrograms = Data_partnerProgram.createGlobalPrograms(1);
        list<LX_Partner_Program__c> globalProgramCategories = Data_partnerProgram.createGlobalCategoryPrograms(1,globalPrograms[0]);
        list<LX_Partner_Program__c> localPrograms = Data_partnerProgram.createLocalISSPrograms(1,globalProgramCategories[0]);   
        
        PageReference pageRef = Page.customPartnerPrograms;     
        Test.setCurrentPage(pageRef);         
        LX_Enrollment_ProgramsController controller = new LX_Enrollment_ProgramsController();   
        controller.search();
        controller.getformTag();
        controller.gettextBox();
        //controller.performSearch('test');     
        controller.searchPartnerPrograms();
        test.Stoptest();    
    }   
}