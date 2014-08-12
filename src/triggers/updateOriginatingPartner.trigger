trigger updateOriginatingPartner on Account (before update) {
    Set<Id> accIds = new Set<Id>();
    for(Account acc:trigger.new){
        if(acc.Originating_Partner__c == null && acc.Type == 'Customer' && trigger.oldMap.get(acc.Id).Type == 'Prospect'){
            accIds.add(acc.Id);              
        }
    }
    Map<id, Account> accMap = new Map<Id, Account>([Select Id,Originating_Partner__c ,(Select Primary_Partner__c,StageName From Opportunities where StageName = 'Closed Won' And Primary_Partner__c != null order by LastModifiedDate desc Limit 1) From Account where Id In: accIds]); 
    for(Account acc: accMap.values()){
        if(acc.Opportunities.size() > 0)
            trigger.newMap.get(acc.id).Originating_Partner__c = acc.Opportunities.get(0).Primary_Partner__c;
    }

}