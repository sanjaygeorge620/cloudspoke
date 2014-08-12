/* Class Name : LX_AccountType_AI
* Description : This trigger auto-populates the Account Record type for the task based on the WhatId and WhoId.  
from triggers
* Created By : Nam Saxena(Deloitte)
* Created Date : 17-6-2013
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer            Date       Modification ID       Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Nam Saxena           17-6-2013                        Initial Version
* Nam Saxena           18-6-2013 
* Kapil                14-9-2013                        Update the Account Type to partner if the Account Name contains 'Lexmark'
*/

trigger LX_AccountType_AI on Task (after insert) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

    /* Save the Salesforce three digit object prefixes for Account, Case, Contact, Lead and Opportunity.*/
    
    String contact_prefix = Schema.SObjectType.Contact.getKeyPrefix();
    String accnt_prefix = Schema.Sobjecttype.Account.getKeyPrefix();
    String case_prefix = Schema.SobjectType.Case.getKeyPrefix();
    String lead_prefix = Schema.SobjectType.Lead.getKeyPrefix();
    String opp_prefix = Schema.SobjectType.Opportunity.getKeyPrefix();
    //String objectAPIName = '';
    //String queryString = 'SELECT AccountId FROM ' + objectAPIName + 'Where';
    Set<Id> recid = new Set<Id>();
    
    //Check the type of the trigger
    if(trigger.isInsert && trigger.isAfter){
    
    //Iterate through the list of tasks and add the task id's to the recId set.
        for(Task t : Trigger.New){
            system.debug('this is trigger new section');
            recid.add(t.Id);
        }
    }
    
    //Retrieve WhoId, WhatId and AccountType for the set of tasks.  
    List<Task> tsklist = [Select WhatId, WhoId, Account_Type__c From Task Where id In: recid];
    
    if(tsklist.size() > 0){
               
       //Iterate through the tasks and update the Task's AccountType based on WhatId and WhoId.
       for(Task tsk: tsklist)
       {
        if(tsk.WhatId <> null){
            if(((String)tsk.WhatId).startsWith(accnt_prefix)){
            
                //Retrieve the Account Record type name using WhatId
                for(Account act: [Select RecordType.Name,Name From Account Where id =:tsk.WhatId])
                {   
                    string temp = '';
                    temp = act.name.toLowerCase();                  
                    if(temp.contains('lexmark')){
                        tsk.Account_Type__c = 'Partner';
                    }
                    else{
                    //Update the Task's AccountType to Account's Record type
                        tsk.Account_Type__c = act.RecordType.Name;
                    }
                }
            }
            if((tsk.WhoId == null)&&(((String)tsk.WhatId).startsWith(opp_prefix))){
                //Retrieve the Account Record type name using WhatId
                for(Opportunity opt: [Select id, Account.RecordType.Name From Opportunity where id =: tsk.WhatId ])
                {
                    //Update the Task's AccountType to Account's Record type
                    tsk.Account_Type__c = opt.Account.RecordType.Name;
                }
                
            }   
            if((tsk.WhoId == null)&&(((String)tsk.WhatId).startsWith(case_prefix))){
                //Retrieve the Account Record type name using WhatId
                for(Case cas: [Select id, Account.RecordType.Name From Case where id =: tsk.WhatId ])
                {
                    //Update the Task's AccountType to Account's Record type
                    tsk.Account_Type__c = cas.Account.RecordType.Name;
                }
                
            }
        }
        if((tsk.WhatId <> null)&&(tsk.WhoId <> null))
           {
                 if((((String)tsk.WhatId).startsWith(accnt_prefix))&&(((String)tsk.WhoId).startsWith(contact_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Contact con: [Select id, Account.RecordType.Name From Contact where id =: tsk.WhoId ])
                    {
                        //Update the Task's AccountType to Account's Record type
                        tsk.Account_Type__c = con.Account.RecordType.Name;
                    }
                }
                                
                if((((String)tsk.WhatId).startsWith(opp_prefix))&&(((String)tsk.WhoId).startsWith(contact_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Contact con: [Select id, Account.RecordType.Name From Contact where id =: tsk.WhoId ])
                    {
                        //Update the Task's AccountType to Account's Record type
                        tsk.Account_Type__c = con.Account.RecordType.Name;
                    }
                }
                
                if((((String)tsk.WhatId).startsWith(opp_prefix))&&(((String)tsk.WhoId).startsWith(lead_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Lead ld: [Select id, PartnerAccount.RecordType.Name From Lead where id =:tsk.WhoId])
                    {
                        //Update the Task's AccountType to Account's Record type
                        tsk.Account_Type__c = ld.PartnerAccount.RecordType.Name;
                    }
                }
            }
            
            if(tsk.WhoId <> null){
                if((tsk.WhatId == null)&&(((String)tsk.WhoId).startsWith(contact_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Contact con: [Select id, Account.RecordType.Name From Contact where id =: tsk.WhoId ])
                    {
                        //Update the Task's AccountType to Account's Record type
                        tsk.Account_Type__c = con.Account.RecordType.Name;
                    }
                    
                }
            }
            
        }
        try
        {
            //Update tasks.
            if(tsklist.size()> 0){
                
                update tsklist;
            }
        }catch (exception ex){}
            
        
    }

}