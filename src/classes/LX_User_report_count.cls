/* 

* 
* Description : Batch class for populating 'Sales Territory Type'  field on users.
*
* Maruthi Kolla: 05/23/2014: Updated to calculate 'MPS' and 'Number of lexmark verticals' on user record. 
* Sanjay Chaudhary: 06/09/2014: Updated as per US3787 to update Partner STT Calculation to be based 'Partner ISS Capability Segment' on instead of 'ISS Internal Segment' 
*/

global class LX_User_report_count implements Database.batchable<sObject>
{
    Public Set<String> PartyGroup;
    Public Set<String> IntSegment ;
    Public Set<String> MPS_Qualification;
    Public Set<String> ISS_Local_Priority;
    Public Set<String> TR_Status;
    Public Set<String> ISS_Coverage;
    //String id1='005i0000000ZKWl';
    List<Account> acct2;
    Public Set<String> Lexmark_Verticals;
    Public Boolean Flag;
    Public List<Database.saveresult> updateResults;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Name,Reporting_Level_4__c,Reporting_Level_5__c FROM User where Reporting_Level_5__c <> null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> userObj)
    {
      /*  integer reportCount;
        if(userObj.size()>0)
        {
            reportCount = userObj.size();
        }
         for(User a : userObj)
         {
             a.Name = a.Name + 'Updated';            
         }
        */
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }  
}