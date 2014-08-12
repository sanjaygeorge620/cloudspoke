/******************************************************************************

Name     : SetAccountType_Customer

Purpose  : set the Type field to "Customer" on the account when the opportunity is set to "Closed Won"

Author   : jennifer dauernheim

Date     : March 15, 2010

******************************************************************************/

trigger SetAccountType_Customer on Opportunity (before insert, before Update){

 /*   Set<ID> idSet = new Set<ID>();
    //for any opp updated, only add to idSet if stageName = 'Closed Won'.
    for (Opportunity oppRec : Trigger.new){
         if (oppRec.StageName == 'Closed Won') {
            idSet.add(oppRec.Accountid);
            system.debug('idSet:' + idset);
         }   
    }
    //List to hold all updated Accounts with their correct information
    List<Account> updatedAcctRecList = new List<Account>();
    
    //get a list of account record related to opportunities in idSet
    List<Account> AcctRecList = new List<Account> ([select id, Type from Account where id in :idSet]);
                            
    for(Account UpdateAcctRec : AcctRecList) {
         UpdateAcctRec.Type = 'Customer';
         UpdatedAcctRecList.add(UpdateAcctRec);      
    
    }
    update   UpdatedAcctRecList;
*/
}