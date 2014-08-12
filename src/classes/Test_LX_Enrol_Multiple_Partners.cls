/* Class Name   : Test_LX_Enrol_Multiple_Partners
 * Description  : Test Class to test Apex Class LX_Enrol_Multiple_Partners
 * Created By   : Sanjay Chaudhary
 * Created On   : 02-Jan-14

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Sanjay Chaudhary           10-Jan-14          Created
 * Abhishek Kumar             06-Feb-2014        Modified
*/
@isTest(SeeallData = true)
private class Test_LX_Enrol_Multiple_Partners {
    static testMethod void myUnitTest() {
        
        List <Account> accList = new List<Account>();
            
        Account account1 = new Account();
        account1.Name = 'Test_Account_01';
        account1.BillingCountry = 'USA';
        account1.Physical_Country__c='USA';
        account1.RecordTypeId = LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
//      account1.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L5LocationPartnerAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L5LocationPartnerAccountRecordName').Value__c:'').getRecordTypeId();
//      account1.RecordTypeId ='012i0000000MmKx';
        account1.ISS_Coverage_Method__c = 'Face to Face';
        account1.LX_GEO__c = 'North America';
        account1.LXK_Region__c = 'USA';
        account1.Party_Type__c = 'Alliance Partner';
        accList.add(account1);
        
        Account account2 = new Account();
        account2.Name = 'Test_Account_02';
        account2.BillingCountry = 'USA';
        account2.Physical_Country__c='USA';
        account2.RecordTypeId = LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
//      account2.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get(Lx_SetRecordIDs__c.getAll().get('L5LocationPartnerAccountRecordName')!=null?Lx_SetRecordIDs__c.getAll().get('L5LocationPartnerAccountRecordName').Value__c:'').getRecordTypeId();
//      account2.RecordTypeId ='012i0000000MmKx';
        account2.ISS_Coverage_Method__c = 'Face to Face';
        account2.LX_GEO__c = 'North America';
        account2.LXK_Region__c = 'USA';
        account2.Party_Type__c = 'Alliance Partner';
        accList.add(account2);
        
        insert accList;
        
        List<LX_Partner_Program__c> progList = new List <LX_Partner_Program__c> ();

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
        localPartnerProgram.LX_Country__c = 'USA';
        localPartnerProgram.LX_Start_Date__c = system.today();
        localPartnerProgram.Program_End_Date__c = system.today() +200;
        
        localPartnerProgram.LX_ISS_Coverage_Method__c = 'Face to Face';
        localPartnerProgram.LX_GEO__c = 'North America';
        localPartnerProgram.LX_Region__c = 'USA';
        localPartnerProgram.Party_Group__c = 'Partner';
        localPartnerProgram.LX_Party_Type__c = 'Alliance Partner';
        
        progList.add(localPartnerProgram);
        
                 //Local program
        LX_Partner_Program__c localPartnerProgram1 = new LX_Partner_Program__c();
        //localPartnerProgram1.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Local ISS Program').getRecordTypeId();
        localPartnerProgram1.RecordTypeId = LX_SetRecordIDs.LocalISSProgramRTID;
        localPartnerProgram1.LX_Program_Enrolled__c = globalPartnerProgramCategory.id;
        localPartnerProgram1.Program_Status__c = 'Being Defined';
        localPartnerProgram1.Program_Level__c = 'Global Program Category (L3)';
        localPartnerProgram1.LX_Program_Type__c = 'ISS';
        localPartnerProgram1.LX_Country__c = 'USA';
        localPartnerProgram1.LX_Start_Date__c = system.today();
        localPartnerProgram1.Program_End_Date__c = system.today() +200;
        
        localPartnerProgram1.LX_ISS_Coverage_Method__c = 'Face to Face';
        localPartnerProgram1.LX_GEO__c = 'North America';
        localPartnerProgram1.LX_Region__c = 'USA';
        localPartnerProgram1.Party_Group__c = 'Partner';
        localPartnerProgram1.LX_Party_Type__c = 'Alliance Partner';
        
        progList.add(localPartnerProgram1);
        
        insert progList;
        
        List <LX_program_Enrollment__c> progenrollst= new List <LX_program_Enrollment__c> ();
         
         //Program Enrollment
        LX_program_Enrollment__c programEnrollment = new LX_program_Enrollment__c();
  
       
       Test.setCurrentPage(Page.LX_Enrol_Multiple_Partners); 
       
       ApexPages.currentPage().getParameters().put('programId',progList[0].Id);                     
       ApexPages.StandardController Apptcontroller = new ApexPages.StandardController(programEnrollment);                     
       LX_Enrol_Multiple_Partners controller = new LX_Enrol_Multiple_Partners (Apptcontroller); 
       controller.partnerAccountsList[0].chk = true;
       controller.partnerAccountsList[1].chk = true;
	   try{
       controller.enrolMultiplePartners();
       controller.cancel();
	   }
	   catch(exception e){}
      
          
    }
}