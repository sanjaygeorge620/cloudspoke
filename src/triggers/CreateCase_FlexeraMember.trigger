trigger CreateCase_FlexeraMember on Flexera_Member__c (after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
List<Flexera_Member__c> facclst = new List<Flexera_Member__c>();
for(Flexera_Member__c facc : trigger.new)
{
if(trigger.oldmap.get(facc.id).Flexera_Integration_Status__c != 'Failed' && 
facc.Flexera_Integration_Status__c == 'Failed')
{
facclst.add(facc);
}
if(!facclst.isEmpty())
{ 
FlexeraEntitlements_CreateCase.createHelpdeskcase_Member(facclst);
}
}
}