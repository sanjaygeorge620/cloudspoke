/* Class Name : LX_AccountType_Eve_AI
* Description : This trigger auto-populates the Account Record type for the Event based on the WhatId and WhoId.  
from triggers
* Created By : Nam Saxena(Deloitte)
* Created Date : 18-6-2013
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer            Date       Modification ID       Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Nam Saxena           18-6-2013                        Initial Version
* Kapil                14-9-2013                        Update the Account Type to partner if the Account Name contains 'Lexmark'
*/

trigger LX_AccountType_Eve_AI on Event (after insert) 
{
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
        //Iterate through the list of events and add the event id's to the recId set.
        for(Event t : Trigger.New){
            system.debug('this is trigger new section');
            recid.add(t.Id);
        }
    }
    
    //Retrieve WhoId, WhatId and AccountType for the set of events.
    List<Event> evntlist = [Select WhatId, WhoId, Account_Type__c From Event Where id In: recid];
    if(evntlist.size() > 0){
       
        //Iterate through the tasks and update the Task's AccountType based on WhatId and WhoId.
        for(Event evnt: evntlist )
        {
            if(evnt.WhatId <> null){
            if(((String)evnt.WhatId).startsWith(accnt_prefix)){
            
                //Retrieve the Account Record type name using WhatId
                for(Account act: [Select RecordType.Name,name From Account Where id =:evnt.WhatId])
                {
                    string temp = '';
                    temp = act.name.toLowerCase();
                    if(temp.contains('lexmark')){
                        evnt.Account_Type__c = 'Partner';
                    }
                    else{
                        //Update the Event's AccountType to Account's Record type
                        evnt.Account_Type__c = act.RecordType.Name;
                    }
                }
            }
              if((evnt.WhoId == null)&&(((String)evnt.WhatId).startsWith(opp_prefix))){
                
                //Retrieve the Account Record type name using WhatId
                for(Opportunity opt: [Select id, Account.RecordType.Name From Opportunity where id =: evnt.WhatId ])
                {
                    //Update the Event's AccountType to Account's Record type
                    evnt.Account_Type__c = opt.Account.RecordType.Name;
                }
                
            }   
            if((evnt.WhoId == null)&&(((String)evnt.WhatId).startsWith(case_prefix))){
                //Retrieve the Account Record type name using WhatId
                for(Case cas: [Select id, Account.RecordType.Name From Case where id =: evnt.WhatId ])
                {    
                    //Update the Event's AccountType to Account's Record type
                    evnt.Account_Type__c = cas.Account.RecordType.Name;
                }
                
            }
            }
            if((evnt.WhatId <> null)&&(evnt.WhoId <> null)){
             
               if((((String)evnt.WhatId).startsWith(accnt_prefix))&&(((String)evnt.WhoId).startsWith(contact_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Contact con: [Select id, Account.RecordType.Name From Contact where id =: evnt.WhoId ])
                    {
                        //Update the Event's AccountType to Account's Record type
                        evnt.Account_Type__c = con.Account.RecordType.Name;
                    }
                }
                
                if((((String)evnt.WhatId).startsWith(opp_prefix))&&(((String)evnt.WhoId).startsWith(contact_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Contact con: [Select id, Account.RecordType.Name From Contact where id =: evnt.WhoId ])
                    {
                        //Update the Event's AccountType to Account's Record type
                        evnt.Account_Type__c = con.Account.RecordType.Name;
                    }
                }
                if((((String)evnt.WhatId).startsWith(opp_prefix))&&(((String)evnt.WhoId).startsWith(lead_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Lead ld: [Select id, PartnerAccount.RecordType.Name From Lead where id =:evnt.WhoId])
                    {
                        //Update the Event's AccountType to Account's Record type
                        evnt.Account_Type__c = ld.PartnerAccount.RecordType.Name;
                    }
                }
            }
            if(evnt.WhoId <> null){
                if((evnt.WhatId == null)&&(((String)evnt.WhoId).startsWith(contact_prefix))){
                    //Retrieve the Account Record type name using WhoId
                    for(Contact con: [Select id, Account.RecordType.Name From Contact where id =: evnt.WhoId ])
                    {
                        //Update the Event's AccountType to Account's Record type
                        evnt.Account_Type__c = con.Account.RecordType.Name;
                    }
                    
                }
            }
          
            
        }
        try{
            if(evntlist.size()> 0){
                update evntlist;
               
            }
        }catch (exception ex){}
            
        
    }

}