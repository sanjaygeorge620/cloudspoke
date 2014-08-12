trigger FieldUpdate on Account (before Update,before Insert) {
            List<Account> accLst = new List<Account>();
            for(Account acc : Trigger.new)
            {
                    if(acc.Account_Status__c != Trigger.oldMap.get(acc.id).Account_Status__c && acc.Account_Status__c == 'Active')
                    {  
                    if(acc.Account_Status__c == 'Active')  {
                    
                        accLst.add(acc);
                    }
                       System.debug('---------------------------------------------------------------------------------------------->'+accLst);   
               }
                       
            }
            System.debug('---------------------------------------------------------------------------------------------->'+accLst);
            if(!accLst.isEmpty())
            {
                   update_Account_Enrolment.updateAccount(accLst);
            }
       
        
 
 
 
}