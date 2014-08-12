trigger AccountPlanApproval on Account (after update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return;
    
    List<String> accIdLst = new List<String>();
   
    if(trigger.isUpdate)
    {
        for(Account acc:Trigger.new)
        {
            if(trigger.oldMap.get(acc.Id).Account_Plan_Approved__c != trigger.newMap.get(acc.Id).Account_Plan_Approved__c )
            {
               // System.debug('######trigger.oldMap.get(acc.Id).Account_Plan_Approved__c'+trigger.oldMap.get(acc.Id).Account_Plan_Approved__c+'###trigger.newMap.get(acc.Id).Account_Plan_Approved__c'+trigger.newMap.get(acc.Id).Account_Plan_Approved__c);
                accIdLst.add(acc.Id);               
                //LX_AccountPlanApproval accApp = new  LX_AccountPlanApproval(accIdLst);
            }
        }   
        LX_AccountPlanApproval accApp = new  LX_AccountPlanApproval(accIdLst);
    }      
               
    
}