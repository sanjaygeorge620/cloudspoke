/*
Class Name : LX_AccountPlanApproval
Description : class for capturing Manager Name from Manager Id in Account Plan Approval Process
Created By : Abhishek Kumat (abhishekkumar3@deloitte.com)
Created Date : 30-9-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Abhishek Kumar  24-9-2013           1000                   Initial Version
*************************************************************************/

public without sharing class LX_AccountPlanApproval {
    
    public List<String> accIdLst = new List<String>();
    public static list<Account> accList ;
    
    public LX_AccountPlanApproval(List<String> accLst)
    {
        accIdLst = accLst;
        updateApprovedBy(accIdLst);
    }

    public void updateApprovedBy(List<String> tempLst) {
        set<String> mgrId = new set<String>();
        List<User> managerList = new List<User>();
        accList = new List<Account>();
        List<Account> updateAccList = new List<Account>();
        
        system.debug('@@@@@accLst'+tempLst);
        //accList =[select Id,Name,Hidden_Submitter_ManagerId__c from Account where Id IN:tempLst];
        
        for(Account acc:[select Id,Name,Hidden_Submitter_ManagerId__c from Account where Id IN:tempLst] )
        {
          mgrId.add(acc.Hidden_Submitter_ManagerId__c);
        }
        if(!(mgrId.isEmpty()))
        {
            managerList = [select Id, name from User where Id IN : mgrId];
            system.debug('@@@@@managerList '+managerList );
        }
        for(Account acc:[select Id,Name,Hidden_Submitter_ManagerId__c from Account where Id IN:tempLst])
        {
            for(User u:managerList)
            {
                 if(u.id==acc.Hidden_Submitter_ManagerId__c)
                 {
                     acc.Account_Plan_Approved_By__c = u.Name;
                     updateAccList.add(acc); 
                     system.debug('@@@@@'+updateAccList);
                 }   
            }
              
        }
        if(updateAccList.size() > 0)
            update updateAccList;       
  }
}