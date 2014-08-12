trigger createCampaignClone on Campaign(After insert,Before Update)
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

         Schema.DescribeSObjectResult des = Schema.SObjectType.Campaign; 
         Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
         Id MRrtId = rtMap.get('Child Campaign').getRecordTypeId();
         

List<Campaign> cmpLst = new List<Campaign>();
Set<Id> cmpId = new Set<Id>();         
List<Campaign_Clone__c> cmpclnlst = new List<Campaign_Clone__c>();
List<Campaign_Clone__c> upslst = new List<Campaign_Clone__c>();
map<ID,Campaign_Clone__c> cp_ccln = new map<ID,Campaign_Clone__c>();
if(Trigger.isinsert || Trigger.isUpdate)
{
for(Campaign cp : Trigger.new)
{         
if(cp.recordtypeid == MRrtId)
{
//cmpLst.add(cp);
cmpId.add(cp.id);
}      
}

cmpLst = [Select ID,Partner_Account_ID__c,name,ParentID,Parent.Partner_Account_ID__c from Campaign where ID in: cmpId];

if(!cmpLst.isEmpty() && !cmpId.isEmpty())
{
cmpclnlst = [Select ID,Campaign__c from Campaign_Clone__c where Campaign__c in: cmpId];

if(!cmpclnlst.isEmpty())
{
for(Campaign_Clone__c ccl : cmpclnlst)
{
cp_ccln.put(ccl.campaign__c,ccl);
}
}
for(Campaign cp :cmpLst)
{
if(cp_ccln.containskey(cp.id))
{
Campaign_Clone__c ccl = cp_ccln.get(cp.id);
ccl.Account__c = cp.Partner_Account_ID__c;
ccl.Name = cp.name;
ccl.Parent_Campaign__c = cp.ParentID;
ccl.Parent_Campaign_Account__c = cp.Parent.Partner_Account_ID__c;
upslst.add(ccl);
}
else
{
Campaign_Clone__c newcl = new Campaign_Clone__c (Campaign__c = cp.id,Account__c = cp.Partner_Account_ID__c,Name = cp.name,Parent_Campaign__c = cp.ParentID,Parent_Campaign_Account__c = cp.Parent.Partner_Account_ID__c );
upslst.add(newcl);
}
}
if(!upslst.isEmpty())
{
Upsert upsLst;
}
}
}
}