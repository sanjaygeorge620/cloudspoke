/*****************************************************************
Created By :Rahul Jain, Metacube (Appirio Inc)
Created On : May 22 2009
Purpose    : To copy server object fields in case object on before insert 
and on before update.
******************************************************************/
trigger copyServerFields on Case (before insert,before update) {

    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 
   
   Set<String> setServerIds = new Set<String>();
   for(Case c : Trigger.New){
     setServerIds.add(c.Server__c);
   }
   if(setServerIds.size() <= 0) return;
   List<Server__c> lstServer = [Select id,Database_Text__c 
                          ,Database_Version_Text__c
                          ,Platform_Text__c
                          ,Platform_Version_Text__c
                          ,Brand_Text__c
                          ,Release_Text__c
                          ,Account__r.id                          
                           from Server__c where id in :setServerIds];
      
   for(Case c : Trigger.New){       
      Server__c ServerObj = getServerObject(String.valueOf(c.Server__c));
      if(ServerObj != null){
        if(c.Database__c != ServerObj.Database_Text__c){  
          c.Database__c = ServerObj.Database_Text__c;
        }
        
        if(c.Database_Version__c != ServerObj.Database_Version_Text__c){  
          c.Database_Version__c = ServerObj.Database_Version_Text__c;
        }
        
        if(c.Platform__c != ServerObj.Platform_Text__c){
          c.Platform__c = ServerObj.Platform_Text__c;
        }
        
        if(c.Platform_Version__c != ServerObj.Platform_Version_Text__c){
          c.Platform_Version__c = ServerObj.Platform_Version_Text__c;
        }
        if(c.Brand__c != ServerObj.Brand_Text__c){
          c.Brand__c = ServerObj.Brand_Text__c;
        }
        
        if(c.Release__c != ServerObj.Release_Text__c){
          c.Release__c = ServerObj.Release_Text__c;
        }
        
        //if(c.AccountId == null){
        //    c.AccountId = ServerObj.Account__r.id;         
        //}
      }
   }
   
   public Server__c getServerObject(String ServerId){
     for(Server__c serv : lstServer){
       if(serv.id == ServerId){
         return serv;
       }
     }
     return null;
   }
   
}