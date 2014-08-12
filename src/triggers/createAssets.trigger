trigger createAssets on Data_Center_Requirements_Sizing__c (after insert,after update) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

if(Trigger.isInsert)
{
for(Data_Center_Requirements_Sizing__c dsc : Trigger.New)
{
if(dsc.Create_Assets__c && FirstRun_Check.FirstRun_assetcheck)
{
FirstRun_Check.FirstRun_assetcheck = False;
createAcuoInstallations.create(dsc.id,dsc.Opportunity__c);
}
}
}
if(Trigger.isUpdate)
{
for(Data_Center_Requirements_Sizing__c dsc : Trigger.New)
{
if(dsc.Create_Assets__c && FirstRun_Check.FirstRun_assetcheck && (Trigger.oldmap.get(dsc.id).Create_Assets__c  != dsc.Create_Assets__c))
{
FirstRun_Check.FirstRun_assetcheck = False;
createAcuoInstallations.create(dsc.id,dsc.Opportunity__c);
}
}

}
}