@isTest(SeeallData = true)
public class Test_CreateFlexCase
{

static testMethod void Test_Flex_entitlement()
{
Test.startTest();
Flexera_Entitlement__c flex1 = new Flexera_Entitlement__c();
insert flex1;
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testtesttesttesttesttesttesttesttesttesttesttest';
Update Flex1;
Test.StopTest();
}
static testMethod void Test_Flex_entitlement_bulk()
{

List<Flexera_Entitlement__c> flexlst = new List<Flexera_Entitlement__c>();
List<Flexera_Entitlement__c> flexupdlst = new List<Flexera_Entitlement__c>();
for(integer i=0;i<1;i++)
{
Flexera_Entitlement__c flex1 = new Flexera_Entitlement__c();
flexlst.add(flex1);
}
insert flexlst;
for(Flexera_Entitlement__c flex1 : flexlst)
{
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}

static testMethod void Test_Flex_EntitlementItems()
{
Test.startTest();
Flexera_Entitlement_Items__c flex1 = new Flexera_Entitlement_Items__c();
insert flex1;
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
Update Flex1;
Test.StopTest();
}
static testMethod void Test_Flex_EntitlementItems_Bulk()
{

List<Flexera_Entitlement_Items__c> flexlst = new List<Flexera_Entitlement_Items__c>();
List<Flexera_Entitlement_Items__c> flexupdlst = new List<Flexera_Entitlement_Items__c>();
for(integer i=0;i<1;i++)
{
Flexera_Entitlement_Items__c flex1 = new Flexera_Entitlement_Items__c();
flexlst.add(flex1);
}
insert flexlst;
for(Flexera_Entitlement_Items__c flex1 : flexlst)
{
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}
static testMethod void Test_Flexera_Account()
{
Test.startTest();
Flexera_Account__c flex1 = new Flexera_Account__c();
insert flex1;
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
Update Flex1;
Test.StopTest();
}

static testMethod void Test_Flexera_Account_Bulk()
{

List<Flexera_Account__c> flexlst = new List<Flexera_Account__c>();
List<Flexera_Account__c> flexupdlst = new List<Flexera_Account__c>();
for(integer i=0;i<1;i++)
{
Flexera_Account__c flex1 = new Flexera_Account__c();
flexlst.add(flex1);
}
insert flexlst;
for(Flexera_Account__c flex1 : flexlst)
{
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}
//------------------------------------------------------------
static testMethod void Test_Flexera_Member()
{
Test.startTest();
Flexera_Member__c flex1 = new Flexera_Member__c();
insert flex1;
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
Update Flex1;
Test.StopTest();
}

static testMethod void Test_Flexera_Member_Bulk()
{

List<Flexera_Member__c> flexlst = new List<Flexera_Member__c>();
List<Flexera_Member__c> flexupdlst = new List<Flexera_Member__c>();
for(integer i=0;i<1;i++)
{
Flexera_Member__c flex1 = new Flexera_Member__c();
flexlst.add(flex1);
}
insert flexlst;
for(Flexera_Member__c flex1 : flexlst)
{
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}
//------------------------------------------------------------
static testMethod void Test_Flexera_Catalog()
{
Test.startTest();
Flexera_Catalog__c flex1 = new Flexera_Catalog__c();
insert flex1;
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
Update Flex1;
Test.StopTest();
}

static testMethod void Test_Flexera_Catalog_Bulk()
{

List<Flexera_Catalog__c> flexlst = new List<Flexera_Catalog__c>();
List<Flexera_Catalog__c> flexupdlst = new List<Flexera_Catalog__c>();
for(integer i=0;i<1;i++)
{
Flexera_Catalog__c flex1 = new Flexera_Catalog__c();
flexlst.add(flex1);
}
insert flexlst;
for(Flexera_Catalog__c flex1 : flexlst)
{
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}
//------------------------------------------------------------
static testMethod void Test_Flexera_File()
{
Test.startTest();
Flexera_File__c flex1 = new Flexera_File__c();
insert flex1;
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
Update Flex1;
Test.StopTest();
}

static testMethod void Test_Flexera_File_Bulk()
{

List<Flexera_File__c> flexlst = new List<Flexera_File__c>();
List<Flexera_File__c> flexupdlst = new List<Flexera_File__c>();
for(integer i=0;i<1;i++)
{
Flexera_File__c flex1 = new Flexera_File__c();
flexlst.add(flex1);
}
insert flexlst;
for(Flexera_File__c flex1 : flexlst)
{
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}

//------------------------------------------------------------
static testMethod void Test_Flexera_Product()
{
Test.startTest();
Flexera_Product__c flex1 = new Flexera_Product__c();
insert flex1;
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
Update Flex1;
Test.StopTest();
}

static testMethod void Test_Flexera_Product_Bulk()
{

List<Flexera_Product__c> flexlst = new List<Flexera_Product__c>();
List<Flexera_Product__c> flexupdlst = new List<Flexera_Product__c>();
for(integer i=0;i<1;i++)
{
Flexera_Product__c flex1 = new Flexera_Product__c();
flexlst.add(flex1);
}
insert flexlst;
for(Flexera_Product__c flex1 : flexlst)
{
flex1.Flexera_Integration_Status__c = 'Failed';
flex1.Flexera_Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}

static testMethod void Test_SAP_SalesOrder_Case()
{
Test.startTest();
SAP_Sales_Order__c sa1 = new SAP_Sales_Order__c();
insert sa1;
sa1.Status__c = 'Error';
sa1.Error_Description__c = 'testtesttesttesttesttesttesttesttesttesttesttest';
Test.StopTest();
}

static testMethod void Test_SAP_SalesOrder_Case_bulk()
{

List<SAP_Sales_Order__c> flexlst = new List<SAP_Sales_Order__c>();
List<SAP_Sales_Order__c> flexupdlst = new List<SAP_Sales_Order__c>();
for(integer i=0;i<1;i++)
{
SAP_Sales_Order__c flex1 = new SAP_Sales_Order__c();
flexlst.add(flex1);
}
insert flexlst;
for(SAP_Sales_Order__c flex1 : flexlst)
{
flex1.Status__c = 'Error';
flex1.Error_Description__c = 'testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting';
flexupdlst.add(flex1);
}
Test.startTest();
Update Flexupdlst;
Test.StopTest();
}



}