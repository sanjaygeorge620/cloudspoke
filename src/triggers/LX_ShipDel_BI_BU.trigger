/*
Class Name : LX_ShipDel_BI_BU 
Description : Trigger to create populate fields.
Created By : Maruthi Kolla (makolla@lexmark.com)
Created Date : 17-12-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Maruthi Kolla    17-12-2013        1000                 Initial Version
*************************************************************************/
trigger LX_ShipDel_BI_BU on Shipment_and_Delivery__c (before insert, before update) {

//Added ByPass Logic on 12/23/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  

Set<ID> proj_id = new Set<ID>();
Map<ID,ID> ship_proj_ID = new Map<ID,ID>();

//Collecting related project ids and bulding a map for shipment and corresponding project ids.
For(Shipment_and_Delivery__c ship_del : Trigger.new)
{
proj_id.add(ship_del.Project__c);
ship_proj_ID.put(ship_del.id,ship_del.Project__c);
}

// Querying for corresponding project records
Map<ID,pse__proj__C> proj_Map = new Map<ID,pse__proj__c>([Select name,pse__Account__c,pse__Opportunity__c from pse__proj__c where id in :proj_id]);

// Populating the account,opportunity and assignedTo fields.
For(Shipment_and_Delivery__c ship_del : Trigger.new)
{
ship_del.Account_Name__c = proj_Map.get(ship_proj_ID.get(ship_del.id)).pse__Account__c;
ship_del.Opportunity__c = proj_Map.get(ship_proj_ID.get(ship_del.id)).pse__Opportunity__c;
ship_del.Assigned_To__c = UserInfo.getUserId();
}
}