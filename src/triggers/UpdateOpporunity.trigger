trigger UpdateOpporunity on Order__c (after update) 
{
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
IF(FirstRun_Check.FirstRun_OrderShellCreation)
{
set<ID> ordID = new set<ID>();
map<ID,Opportunity> m_op = new map<ID,Opportunity>();
map<ID,ID> m_od = new map<ID,ID>();
List<Opportunity> opplst = new List<Opportunity>();

for(Order__c ord : trigger.new)
{
if(ord.Status__c)
{
ordID.add(ord.Opportunity__c);
m_od.put(ord.Opportunity__c,ord.ID);
}
}

for(Opportunity opp : [Select ID,Partner_Next_Steps__c from Opportunity where ID in : ordID])
{
m_op.put(m_od.get(opp.ID),opp);
}

for(order__c od : trigger.new)
{
if(m_op.containskey(od.ID))
{
opportunity opp = m_op.get(od.ID);
opp.Partner_Next_Steps__c = od.Partner_Next_Steps__c;
opplst.add(opp);
}
}

if(!opplst.Isempty())
{
update opplst;
}
FirstRun_Check.FirstRun_OrderShellCreation = True;
}
}