@isTest(SeeAllData=true)
private class LX_Test_SetRecordIDs {

/* Class Name   : LX_Test_SetRecordIDs 
    * Description   : This is a Test class to call the LX_SetRecordIDs class. 
    * Created By   : Arun Singh
    * Created Date : 04-29-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Arun Singh                04-29-2013                                Initial Version

    */

 static testMethod void SetRecordIDs(){
ID GlobalRecordTypeId = [select id from RecordType where DeveloperName = 'Lx_Global' and sobjectType = 'Account'].id;
 Account Acc = new Account(Name = 'test', recordTypeID = GlobalRecordTypeId,BillingCountry = 'USA',Physical_Country__c='USA');
 insert acc; 
  
  
 ID recordTypeId= [SELECT RecordTypeId FROM Account WHERE RecordType.Name = 'Global' LIMIT 1].RecordTypeId;
 Boolean result = LX_SetRecordIDs.isActiveRecordType(recordTypeId,'Account');
 system.assert(true,result);
    
 LX_SetRecordIDs getRecordType=new LX_SetRecordIDs();
 getRecordType.getRecordTypeID('Global','Account');
 }
 
 }