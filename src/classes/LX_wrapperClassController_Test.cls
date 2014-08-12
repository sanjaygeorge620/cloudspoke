/*********************************************************************************
Name : LX_wrapperClassController_Test 
Created By : Deloitte
Created Date : 20 Jan 2014
Usages : This tests wrapperClassController
*********************************************************************************/
@isTest
private class LX_wrapperClassController_Test
{
 static testMethod void testGetSalesOrg() 
 {
 Sales_Organization__c salesOrgIns = new Sales_Organization__c();
 salesOrgIns.Name = 'Test';
 salesOrgIns.Status__c = 'Active';
 salesOrgIns.LX_Country_Code__c = 'AF';
 salesOrgIns.Sales_Organization__c = '22';
 salesOrgIns.LX_Default__c = true ;
 insert salesOrgIns;
 wrapperClassController.LX_Sales_Organization_Wrapper wrapSalesInst = new wrapperClassController.LX_Sales_Organization_Wrapper(salesOrgIns);
 wrapperClassController wrapClassContrlr = new wrapperClassController();
 List<wrapperClassController.LX_Sales_Organization_Wrapper> listSalesOrgWrapper = wrapClassContrlr.getSalesOrg();
 wrapClassContrlr.processSelected();
 //System.assertEquals(0, listSalesOrgWrapper.size());
}
}