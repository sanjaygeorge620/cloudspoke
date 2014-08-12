trigger CreateFlexCase_ent_item on Flexera_Entitlement_Items__c (after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
List<Flexera_Entitlement_Items__c> fentlst = new List<Flexera_Entitlement_Items__c>();
for(Flexera_Entitlement_Items__c fenti : trigger.new)
{
if(trigger.oldmap.get(fenti.id).Flexera_Integration_Status__c != 'Failed' && 
fenti.Flexera_Integration_Status__c == 'Failed')
{
fentlst.add(fenti);
}
if(!fentlst.isEmpty())
{
FlexeraEntitlements_CreateCase.createHelpdeskcase_item(fentlst);
}
}
}