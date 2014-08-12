trigger ChangeListMemberOwner on List_Member__c (before insert) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
    set<id> listIds = new set<id>();    
     
        for (List_Member__c lmo:Trigger.new){
        
            //Get the list id's of the list members 
            
            if(lmo.List__c!=null)
                listIds.add(lmo.List__c);
                
           system.debug('List IDs: '+listIds);
            
           }
           
     // create a map so that the List is locatable by its Id   
        
     Map<Id,List__c> listMap = new Map<Id,List__c>(
         [SELECT Id,Name,OwnerId FROM List__c WHERE Id IN :listIds]
         ); 
         
         System.debug('List Map: '+listMap);  
          
        for(List_Member__c lmo:Trigger.new){
        
            // fetch the List Name from the map by its Id
            
            if(lmo.List__c!=null){
                
                system.debug('List Name: '+listMap.get(lmo.List__c).Name+' and List Onwer Id is:'+listMap.get(lmo.List__c).OwnerId);
                
               lmo.Subscribed_List_Owner__c=listMap.get(lmo.List__c).OwnerId;  
            }
              
        }                
}