/*************************************************************************************
Name : Test_LX_SAP_Record_AI_AU
Created By : USI
Created Date : 9th June , 2013
Description : -Test class for coverage of trigger LX_SAP_Record_AI_AU
*************************************************************************************/
@isTest(SeeallData = true)
Private Class Test_LX_SAP_Record_AI_AU{
    @isTest
    static void testLXSAPRecordAIAU (){
        //Account acnt = Data_Account.createAccount();
        //system.assertNotEquals(acnt.Id , null);
        pse__Region__c regVar = new pse__Region__c();
        regVar.Name = 'test';
        insert regVar;
        
        LX_SAP_Record__c lxSAP = new LX_SAP_Record__c();
        lxSAP.LX_Contact_First_Name__c = 'testTrigger';
        lxSAP.LX_Contact_Last_Name__c = 'test';
        lxSAP.LX_Region__c=regVar.Id;//'a4de0000000CiTg';
        lxSAP.LX_Phone__c = '435345';
        lxSAP.LX_SAP_Bill_To_ID__c = 'abcd';
        lxSAP.LX_SAP_Ship_To_ID__c = 'efgh';
        lxSAP.LX_Physical_State__c = 'Florida';
        lxSAP.LX_Collections__c = true;
        lxSAP.LX_Default_Bill_To__c = true;
        lxSAP.LX_SMSA__c = true;
        RecordType obj = [select id from recordtype where SobjectType = 'LX_SAP_Record__c' limit 1];
        //lxSAP.RecordTypeId = '012i0000000MmDX';
        lxSAP.RecordTypeId = obj.id;
        lxSAP.LX_MDM_Act__c = '1';
        insert lxSAP;                
     
        system.assertNotEquals(lxSAP.Id , null);
        
        LX_SAP_Record__c lxSAPUpdate = new LX_SAP_Record__c();
        lxSAPUpdate = [Select id,LX_Contact_First_Name__c,LX_Collections__c,LX_Default_Bill_To__c,LX_SMSA__c FROM LX_SAP_Record__c where id =: lxSAP.Id];
        lxSAPUpdate.LX_Contact_First_Name__c = 'Triggertest';
        lxSAPUpdate.LX_Collections__c = false;
        lxSAPUpdate.LX_Default_Bill_To__c = false;
        lxSAPUpdate.LX_SMSA__c = false;
        lxSAPUpdate.LX_Status__c = 'Completed';
        lxSAP.LX_MDM_Act__c = '1';
        update lxSAPUpdate;
        system.assertNotEquals(lxSAPUpdate.Id , null);
        
        LX_SAP_Record__c lxSAPUpdate2 = new LX_SAP_Record__c();
        lxSAPUpdate2 = [Select id,LX_Contact_First_Name__c,LX_Collections__c,LX_Default_Bill_To__c,LX_SMSA__c FROM LX_SAP_Record__c where id =: lxSAPUpdate.Id];
        lxSAPUpdate2.LX_Contact_First_Name__c = 'Triggertest123';
        lxSAPUpdate2.LX_Collections__c = true;
        lxSAPUpdate2.LX_Default_Bill_To__c = true;
        lxSAPUpdate2.LX_SMSA__c = true;
        lxSAP.LX_MDM_Act__c = '1';
        update lxSAPUpdate2;
        system.assertNotEquals(lxSAPUpdate2.Id , null);
        
        
    }
}