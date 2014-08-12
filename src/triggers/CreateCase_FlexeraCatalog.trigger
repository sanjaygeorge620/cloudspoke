trigger CreateCase_FlexeraCatalog on Flexera_Catalog__c (after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
List<Flexera_Catalog__c> facclst = new List<Flexera_Catalog__c>();
for(Flexera_Catalog__c facc : trigger.new)
{
if(trigger.oldmap.get(facc.id).Flexera_Integration_Status__c != 'Failed' && 
facc.Flexera_Integration_Status__c == 'Failed')
{
facclst.add(facc);
}
if(!facclst.isEmpty())
{ 
FlexeraEntitlements_CreateCase.createHelpdeskcase_Catalog(facclst);
}
}
}