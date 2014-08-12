trigger createProjBillingItems_DS on Opportunity (after update) 
{
List<Opportunity> sendthis = new List<Opportunity>();
Map<pse__Proj__c,List<Project_Billing_Items__c>> usethis = new Map<pse__Proj__c,List<Project_Billing_Items__c>>();
pse__Proj__c pj = new pse__Proj__c();
for(Opportunity Op : Trigger.New)
{
Opportunity oldOp = Trigger.oldmap.get(op.ID);
System.debug('New COntract Number ****' +op.Contract_Number__c);
System.debug('Old COntract Number ****' +Oldop.Contract_Number__c);

if(op.Contract_Number__c != NULL && op.Contract_Number__c != oldOp.Contract_Number__c && FirstRun_Check.FirstRun_Project_Billing_ITem)
{
sendthis.add(op);
}
}
if(!sendThis.Isempty())
{

//usethis = createProjBillingItems_DS.Create(sendThis);
//createProjBillingItems_DS.Create(sendThis,pj);
FirstRun_Check.FirstRun_Project_Billing_ITem = false;

}
}