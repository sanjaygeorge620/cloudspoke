/*
Class Name : LX_ShipDel_BI_BU_Test
Description : Test Class for LX_ShipDel_BI_BU.
Created By : Sunil Kati skati@deloitte.com)
Created Date : 05-02-2014
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Sunil Kati    05-02-2014       1000                 Initial Version
*************************************************************************/
@isTest(seealldata = true)
public class LX_WBSElement_Test
{
  static testMethod void WbsElement() 
  {	
     List<Company_Code__c> CompanyCodeList = [select Company_Code_Description__c, Company_Code_Value__c from Company_Code__c limit 10];
     String code1 =  CompanyCodeList[0].Company_Code_Value__c;
  	WBS_Element__c w = new WBS_Element__c();
    insert w;
      w.Company_Code__c = code1;
      update w;
  }
  
}