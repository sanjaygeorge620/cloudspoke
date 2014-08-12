trigger UpdateURL_on_Case on Mobile_Agreement__c (after insert) {

     /**************************************
     *
     Description: Updating Mobile Agreement link on related case record
     *
     *
     Date: 11/27/2011
     *
     By: Manoj Kolli
     *
     *****************************************/ 
     if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
     Set<Id> maIds = new Set<Id>();
     Set<Id> cIds = new Set<Id>();
     for(Mobile_Agreement__c ma : Trigger.New){
         if(ma.Id != null){
             maIds.add(ma.Id);
             cIds.add(ma.Case_Number__c);
         }
     }
     Map<Id,Mobile_Agreement__c> maMap = new Map<Id,Mobile_Agreement__c>([Select Id,Case_Number__c from Mobile_Agreement__c where Id in :maIds]);
     Map<Id,Case> caseMap = new Map<Id,Case>([Select Id,CaseNumber,Link_to_Mobile_Agreement__c from case where Id in:cIds]);
     
     for(Mobile_Agreement__c ma1 : maMap.values()){
         String fullURL;
         for(Case c : caseMap.values()){
             if(c.Id == ma1.Case_Number__c){
                 fullURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ma1.id;
                 caseMap.get(c.Id).Link_to_Mobile_Agreement__c = fullURL;
             }
         }
         
     }
     update caseMap.values();
     
}