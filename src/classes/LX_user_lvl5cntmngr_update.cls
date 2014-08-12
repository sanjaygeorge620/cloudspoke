/* 
* ©Lexmark Front Office 2013, all rights reserved
* Created Date : 06/29/2014
* Author : DMI 
* Description : Batch class for populating 'Reporting_level_5_count__c' field on users.
*/

global class LX_user_lvl5cntmngr_update implements Database.batchable<sObject>
{
    Public List<Database.saveresult> updateResults;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
	// Get the id for all reporting level 5 users who have reporting lvl6 populated       
        String Query ='SELECT Id,name,Reporting_Level_1__c,Reporting_Level_4__c,Reporting_Level_5__c,Reporting_Level_6__c,Reporting_Level_7__c,Reporting_Level_8__c FROM User WHERE Reporting_Level_6__c !=  \'\' and Reporting_Level_5__c !=  \'\' AND IsActive = TRUE';
        return Database.getQueryLocator(query);
    }
	//for every Lvl4 user update the no of lvl4 users reporting to the same Lvl5 manager    
    global void execute(Database.BatchableContext BC, List<User> Lvl5users)
    {
     List<User> lvl4users = new List<User>();
     For(integer i=0; i<Lvl5users.size();i++)
        {
           List<user> Lvl4reporteelist =[Select id,Reporting_level_5_count__c from User where Reporting_Level_5__c = :Lvl5users[0].id];
          	if(Lvl4reporteelist.size()>0)
            {
                For(user lvl4: Lvl4reporteelist)
                {
                    lvl4.Reporting_level_5_count__c = Lvl4reporteelist.size();
                    lvl4users.add(lvl4);
                }
                if(lvl4users.size()>0)
                {
                   updateResults = database.update(lvl4users,False);
                	for(Integer k=0;k<updateResults.size();k++)
                	{
                    if (!updateResults.get(k).isSuccess())
                        LX_CommonUtilities.createExceptionLog(updateResults.get(k).getErrors().get(0).getmessage()); // Creating the exception log record with the error message.
                 	}
            	}
			            
    		}
       }
    }
    global void finish(Database.BatchableContext BC)
    {
    }  
}