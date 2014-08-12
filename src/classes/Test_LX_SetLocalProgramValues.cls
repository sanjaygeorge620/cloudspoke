/*************************************************************************************
Name : Test_LX_SetLocalProgramValues
Created By : USI
Created Date : 9th June , 2013
Description : -Test class for coverage of trigger LX_SetLocalProgramValues
*************************************************************************************/
@isTest(SeeallData = true)
Private Class Test_LX_SetLocalProgramValues{
    @isTest
    static void testLXPartnerProgram (){

        LX_Partner_Program__c lxPartnerProg = new LX_Partner_Program__c();
        lxPartnerProg.LX_Program_Type__c = 'Software';
        lxPartnerProg.LX_Region__c = 'India';
        lxPartnerProg.RecordTypeId = Schema.SObjectType.LX_Partner_Program__c.getRecordTypeInfosByName().get('Global PSW Program Category').getRecordTypeId();
        insert lxPartnerProg;
        
        LX_Partner_Program__c lxPartnerProg2 = new LX_Partner_Program__c();
        lxPartnerProg2.LX_Program_Type__c = 'Technology';
        lxPartnerProg2.LX_Region__c = 'India';
        lxPartnerProg2.LX_Program_Enrolled__c = lxPartnerProg.Id;
        insert lxPartnerProg2;                
     
        system.assertNotEquals(lxPartnerProg.Id , null);
        
        LX_Partner_Program__c lxPartnerProgUPdate = new LX_Partner_Program__c();
        lxPartnerProgUPdate = [Select id,LX_Program_Type__c FROM LX_Partner_Program__c where id =: lxPartnerProg.Id];
        lxPartnerProgUPdate.LX_Program_Type__c = 'Technology';
        update lxPartnerProgUPdate;
        system.assertNotEquals(lxPartnerProgUPdate.Id , null);
        
        
    }
}