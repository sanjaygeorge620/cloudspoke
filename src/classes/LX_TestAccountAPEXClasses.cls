/*************************************************************************************
Name : LX_TestAccountAPEXClasses
Created By : Arun thakur(arunsingh6@deloitte.com)
Created Date : 10th June , 2013
Description : -Test class for coverage of LX_CreateAndSubmitMDMRequest and 
LX_IntegrationMDMandSFDCAccount APEX classes
*************************************************************************************/


@isTest(SeeallData = true)
private class LX_TestAccountAPEXClasses 
{
static testMethod void myUnitTest() 
{

  Account acct = Data_Account.createAccount();
LX_CreateAndSubmitMDMRequest ObjCreateAndSubmitMDMRequest=new LX_CreateAndSubmitMDMRequest();
ObjCreateAndSubmitMDMRequest.DoMDMWebHttpRequest();


LX_IntegrationMDMandSFDCAccount ObjIntegrationMDMandSFDCAccount=new LX_IntegrationMDMandSFDCAccount();
ObjIntegrationMDMandSFDCAccount.DoAccountUpdateFromWebHttpRequest();


}


}