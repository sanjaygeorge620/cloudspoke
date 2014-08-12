Public with sharing Class CaseCopyServerFields{
  //Copy Fields from Server
        public static void Execute(list<Case> triggernew, MAP<Id,Case> triggeroldmap, MAP<Id,Case> triggernewmap){ 
             
             Set<String> ServerSet = new Set<String>();
             for(Case c : TriggerNew){
                if(c.Server__c!=null)
                  ServerSet.add(c.Server__c);
             }
             //If no records, exit
             if(ServerSet.size() == 0) return;
             
             //Build Map by querying server__c   
             map<string, Server__c> ServerMap = new Map<string, Server__c>();
             for(server__c s: [Select ID, Processor__c, Database__c, Database_Version__c, Platform__c, Platform_Version__c, Brand_Text__c, Release__c From Server__c Where ID in :ServerSet]){
                 ServerMap.put(s.id,s);
             }
                
             //Iterate through Cases to update fields from server
             for(Case c : TriggerNew){   
                //Update Case Server Fields
                if(c.Server__c!=null && ServerMap.containskey(c.Server__c) && 
                    (trigger.isInsert || /* onInsert: Always update */
                    (trigger.isUpdate && c.isclosed == false)) /* onUpdate: Only update if the case is open */
                   ){
                    //Set Values from Server Map
                    c.Database__c           = ServerMap.get(c.Server__c).Database__c;
                    c.Database_Version__c   = ServerMap.get(c.Server__c).Database_Version__c;
                    c.Platform__c           = ServerMap.get(c.Server__c).Platform__c;
                    c.Platform_Version__c   = ServerMap.get(c.Server__c).Platform_Version__c;
                    c.Brand__c              = ServerMap.get(c.Server__c).Brand_Text__c;
                    c.Release__c            = ServerMap.get(c.Server__c).Release__c;
                    c.Platform_Processor__c = ServerMap.get(c.Server__c).Processor__c;
                 
                 
                 } else if(c.Server__c==null || !ServerMap.containskey(c.Server__c)) {
                    //Reset Values   
                    c.Database__c           = NULL;
                    c.Database_Version__c   = NULL;
                    c.Platform__c           = NULL;
                    c.Platform_Version__c   = NULL;
                    c.Brand__c              = NULL;
                    c.Release__c            = NULL;
                    c.Platform_Processor__c = NULL;
                 }
            }      
        }
}