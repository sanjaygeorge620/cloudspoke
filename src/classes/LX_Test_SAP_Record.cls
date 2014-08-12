/* Class Name   : LX_Test_SAP_Record
 * Description  : Test Class to test Trigger LX_SAP_Record_AI_AU
 * Created By   : Anita Koshi
 * Created On   : 10-Jun-13

 * Modification Log:  
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer                Date            Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Anita Koshi           10-Jun-13          Initial version
 * Anita Koshi           19-Jul-13          Added code to pass validation rule :MDM_ID_Validation  
 * Kapil Reddy Sama          8/14/2013                                Commented the describe methods for recordtype as record types are deleted.
*/

@isTest 
private class LX_Test_SAP_Record {
        /*Description:This is the test method written to test the Trigger LX_SAP_Record_AI_AU
        *Param:None
        *Returns:VOID
        */
    static testMethod void validateRecord() {
       Id idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId();
       LX_SAP_Record__c oSRec = new  LX_SAP_Record__c(LX_MDM_Act__c='12345',LX_Name__c='Sold Test', RecordTypeId=idRecordType);
       System.debug('LX_SAP_Record Id ' + oSRec.Name);

       // Insert Sold To
       insert oSRec;
       LX_SAP_Record__c oSRec2;
       // Retrieve the new book
       oSRec2= [SELECT LX_Name__c FROM LX_SAP_Record__c WHERE Id =:oSRec.Id];
       System.debug('LX_SAP_Record Id Fetched ' + oSRec2.LX_Name__c);
       String sSoldId =oSRec2.Id;  
       // Test that the trigger correctly inserted Sold To
       System.assertEquals('Sold Test',oSRec2.LX_Name__c);
       // Insert Bill To -First Record
       //idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Bill To').getRecordTypeId();
       //oSRec = new  LX_SAP_Record__c(LX_MDM_Act__c='12345',LX_Name__c='Bill Test1', LX_Sold_To__c=sSoldId, RecordTypeId=idRecordType,LX_Collections__c =true,LX_Default_Bill_To__c=true,LX_SMSA__c=true );
       //System.debug('LX_SAP_Record Id ' + oSRec.Id);
       //insert oSRec;
      // String oBillId =  oSRec.Id;
       // Insert Bill To -Second Record
       //oSRec = new  LX_SAP_Record__c(LX_MDM_Act__c='12345',LX_Name__c='Bill Test2', LX_Sold_To__c=sSoldId, RecordTypeId=idRecordType,LX_Collections__c =false,LX_Default_Bill_To__c=false,LX_SMSA__c=false);
       //System.debug('LX_SAP_Record Id ' + oSRec.Id);
       //insert oSRec;
        
       // Retrieve the Second Record
    //   oSRec2= [SELECT LX_Name__c, LX_Default_Bill_To__c FROM LX_SAP_Record__c WHERE Id =:oSRec.Id];
     //  System.debug('LX_SAP_Record Name Fetched ' + oSRec2.LX_Name__c);

       // Test that the trigger correctly inserted Bill To
       //System.assertEquals('Bill Test2',oSRec2.LX_Name__c);
       //Update Bill To -Second Record
    /*   oSRec2.LX_Collections__c=true;
       oSRec2.LX_Default_Bill_To__c=true;
       oSRec2.LX_SMSA__c=true;
       update oSRec2;
       //Fetch Bill To - First Record
       oSRec2= [SELECT LX_Name__c, LX_Default_Bill_To__c FROM LX_SAP_Record__c WHERE Id =:oBillId];
       System.debug('LX_SAP_Record Name Fetched ' + oSRec2.LX_Name__c);
         // Test that the trigger correctly updated Bill To
       //System.assertEquals(False,oSRec2.LX_Default_Bill_To__c);
      
       idRecordType = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Ship To').getRecordTypeId();
       oSRec = new  LX_SAP_Record__c(LX_MDM_Act__c='12345',LX_Name__c='Ship Test', LX_Sold_To__c=sSoldId, RecordTypeId=idRecordType );
      // System.debug('LX_SAP_Record Id ' + oSRec.Id);

       // Insert Ship To
       insert oSRec;
        
       // Retrieve the new Ship To
       oSRec2= [SELECT LX_Name__c FROM LX_SAP_Record__c WHERE Id =:oSRec.Id];
       System.debug('LX_SAP_Record Name Fetched ' + oSRec2.LX_Name__c);
        // Test that the trigger correctly inserted Ship To
       System.assertEquals('Ship Test',oSRec2.LX_Name__c);
        */
    }
}