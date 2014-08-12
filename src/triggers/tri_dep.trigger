trigger tri_dep on Lead (before insert, before update) {

List<LX_Dep_picklist__c> lstValues =LX_Dep_picklist__c.getall().values();

Set<Id> leadIds = new Set<Id>();

for(integer i=0; i<trigger.new.size(); i++) {
leadIds.add(Trigger.new[i].Id);
}

Map<Id,Lead> mapLead = new Map<Id,Lead>([Select Id from Lead where Id IN: leadIds]);

for(LX_Dep_picklist__c lst:lstValues) {
        
}


}