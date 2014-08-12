trigger createCase_SAPSalesOrder on SAP_Sales_Order__c (after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
List<SAP_Sales_Order__c> Sorderlst = new List<SAP_Sales_Order__c>();
for(SAP_Sales_Order__c sa : trigger.new)
{
if(trigger.oldmap.get(sa.id).Status__c != 'Error' && sa.Status__c == 'Error')
{
Sorderlst.add(sa);
}
if(!Sorderlst.isEmpty())
{ 
FlexeraEntitlements_CreateCase.createHelpdeskcase_SAP_SalesOrder(Sorderlst);
}
}
}