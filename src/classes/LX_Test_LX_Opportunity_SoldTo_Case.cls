/*****************************************************************************************************************
*Class Name : LX_Test_LX_Opportunity_SoldTo_Case
*Description : test class for LX_Test_LX_Opportunity_SoldTo_Case
*Created By :Veenu Trehan (vtrehan@deloitte.com)
*Created Date : 1/13/2014
*Modification Log:
*-----------------------------------------------------------------------------------------------------------------
*Developer                Date            Modification ID        Description
*-----------------------------------------------------------------------------------------------------------------
*Veenu Trehan              1-13-2014        1000                   Initial Version
*
******************************************************************************************************************/
@isTest(SeeAllData=true)
public with sharing class LX_Test_LX_Opportunity_SoldTo_Case {
    
     /* Description : Static Test Method to create default data and call methods in the LX_Opportunity_SoldTo_Case class
     *  Param - None
    *  Returns :  None
  */ 
  
    Static testmethod void test(){
    // inserting account,opportunity,contact records
        list<string> stage = new list<String>();
        stage.add('Developing');
         string AccType= account.sObjectType.getDescribe().getRecordTypeInfosByName().get('MDM Customer').getRecordTypeId();
        account testaccount = Data_account.createaccount2();
        testaccount.RecordTypeID=AccType;
        update testaccount ;
         account testaccount1 = Data_account.createaccount2();
          update testaccount1 ;
        list<contact> testcontact = Data_contact.createContacts(testaccount.Id,1);
        list<opportunity> testopportunity = Data_opportunity.createOpportunity3(stage,1,testaccount1 ,testcontact);
        Id idRecordType1 = Schema.SObjectType.LX_SAP_Record__c.getRecordTypeInfosByName().get('Sold To').getRecordTypeId(); 
         LX_SAP_Record__c oSRec1 = new  LX_SAP_Record__c(LX_Name__c='Ship Test', LX_Physical_Postal_Code__c='66666',RecordTypeId=idRecordType1, LX_Account__c = testaccount.id,LX_MDM_Act__c = '1',
                                                             LX_Payment_Terms__c='ZCWO');
           System.debug('LX_SAP_Record Id ' + oSRec1.Name);
           insert oSRec1;
           // Insert SAP Record Sales Organization
           string soldType = LX_SAP_Record_Sales_Org__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Sold To Sales Org').getRecordTypeId();
           LX_SAP_Record_Sales_Org__c sapsalesRec = new LX_SAP_Record_Sales_Org__c(LX_Ship_To__c=oSRec1.Id,RecordTypeID = soldType );
           insert sapsalesRec;
           testopportunity[0].LX_Sold_To_New__c =sapsalesRec.id;        
           update testopportunity[0];
           LX_Opportunity_SoldTo_Case ClassVar=new LX_Opportunity_SoldTo_Case();
           test.startTest();
           
           ClassVar.CreateOpportunitiesSoldToCaseNewRequest(testopportunity);
            ClassVar.CreateOpportunitiesSoldToCaseRequesttoCEBU(testopportunity);
           ClassVar.CreateOpportunitiesSoldToCaseExtendedRequest(testopportunity);
           test.stopTest();
    }
    
    


}