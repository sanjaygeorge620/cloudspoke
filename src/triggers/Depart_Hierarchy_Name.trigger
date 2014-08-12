trigger Depart_Hierarchy_Name on Department_Hierarchy__c (before insert) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
    /**************************************
     *
     Description: code to assign Hierarchys on Name and alias in department hierarchy records when a new record is created
     Created Date: 11/29/2011
     By: Manoj Kolli
     *
     Date Revision: 12/8/2011 (Modified code)
     *
     By: Manoj Kolli
     *
    *****************************************/ 
    
    set<Id> pids = new set<Id>();
    for(Department_Hierarchy__c dep: Trigger.New){
       if(dep.Parent_Department__c != Null){
           pids.add(dep.Parent_Department__c);
       }
    }
    
    Map<Id,Department_Hierarchy__c> depMap = new Map<Id,Department_Hierarchy__c>(
    [Select Id,Parent_Department__c,Name,Alias__c,Hierarchy_Alias__c,Hierarchy_Name__c from Department_Hierarchy__c where Id in :pids]);
         
    for(Department_Hierarchy__c dh: Trigger.New){
       if(dh.Parent_Department__c == Null){
           dh.Hierarchy_Name__c = dh.Name;
           dh.Hierarchy_Alias__c = dh.Alias__c;
       }
       else{
           dh.Hierarchy_Name__c = depMap.get(dh.Parent_Department__c).Hierarchy_Name__c +'.'+dh.Name;
           dh.Hierarchy_Alias__c = depMap.get(dh.Parent_Department__c).Hierarchy_Alias__c +'.'+dh.Alias__c;
       }
              
    }
}