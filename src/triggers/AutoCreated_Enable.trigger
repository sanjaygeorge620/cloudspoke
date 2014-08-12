trigger AutoCreated_Enable on User_Registration__c (after insert) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
     /**************************************
     Description: To perform "Enable" button logic automatically on the User Registration records 
     *            which are Auto-Created
     *
     Date Created: 1/12/2011
     *
     By: Manoj Kolli
     *****************************************/ 
    
    Set<Id> urIds = new Set<Id>();
    for(User_Registration__c ur:Trigger.New){
        if(ur.Id != Null && ur.Auto_Created__c == True && ur.Workflow_Status__c == 'Submitted'){
            urIds.add(ur.Id);
        }
    }
    Map<Id,User_Registration__c> urMap = new Map<Id,User_Registration__c>(
    [Select Id,Workflow_Status__c,Auto_Created__c,User_Contact_Computed__c,Master_Contact__c,Application__c,Profile__c from User_Registration__c where Id in :urIds]);
    
    for(User_Registration__c u : urMap.values()){
        if(urMap.get(u.Id).Auto_Created__c == True && urMap.get(u.Id).Workflow_Status__c == 'Submitted'){
            String userRegID = u.Id +':WF';
           
            ContactEnable.EnableCallout(
                                        userRegID, 
                                        urMap.get(u.Id).User_Contact_Computed__c, 
                                        urMap.get(u.Id).Master_Contact__c, 
                                        urMap.get(u.Id).Application__c, 
                                        urMap.get(u.Id).Profile__c 
                                        );
                                        
        }
    }
}