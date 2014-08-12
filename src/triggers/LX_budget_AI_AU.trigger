/*
Class Name : LX_budget_AI_AU 
Description : Trigger to populate budgeted hours on project based on budget hours on budgets.
Created By : Maruthi Kolla (makolla@lexmark.com)
Created Date : 11-12-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Maruthi Kolla    11-12-2013        1000                 Initial Version
*************************************************************************/
trigger LX_budget_AI_AU on pse__Budget__c (after insert, after update) {

//Added ByPass Logic on 12/23/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  

Set<ID> set_projIDs = new Set<ID>();
Map<ID,Double> map_budhours = new Map<ID,Double>();
List<pse__Proj__c> proj_listToUpdated = new List<pse__Proj__c>();

// Code to collect all project IDs from budget
for (pse__Budget__c budget : Trigger.new)
{
set_projIDs.add(budget.pse__Project__c);
}

if(Trigger.isupdate)
{
for (pse__Budget__c budget : Trigger.old)
{
set_projIDs.add(budget.pse__Project__c);
}
}

// Query the database for list of budgets for project IDs 
List<pse__Budget__c> budget_list = [Select id,Hours__c,pse__Project__c,pse__Status__c from pse__Budget__c where pse__Project__c in :set_projIDs];

// Iterate the list and build a map for project id and total budgeted hours
for(pse__Budget__c budget_temp : budget_list )
{
if(map_budhours.containskey(budget_temp.pse__Project__c))
{
if(budget_temp.pse__Status__c == 'Approved')
if(map_budhours!= null && budget_temp.pse__Project__c!=null && budget_temp.Hours__c!=null){
System.debug ('*** map'+map_budhours);
map_budhours.put(budget_temp.pse__Project__c,map_budhours.get(budget_temp.pse__Project__c)+ budget_temp.Hours__c);
}
}
else 
{
if(budget_temp.pse__Status__c == 'Approved')
map_budhours.put(budget_temp.pse__Project__c,budget_temp.Hours__c);
}
}

// Iterate the map and build a list of projects to be updated with new budgeted hours.
if(map_budhours!= null)
{
for(ID ids : map_budhours.keyset())
{
pse__Proj__c proj = new pse__Proj__c(id= ids , Budgeted_Hours__c = map_budhours.get(ids));
proj_listToUpdated.add(proj);
}
}

if(proj_listToUpdated.size()>0)
update proj_listToUpdated ;
}