/** 
* ©Lexmark Front Office 2013, all rights reserved *  
* Created Date : 19-07-2013 *
* Author : Akanksha Gupta   * 
* Description : After 45 days if the Project status is Closed or Transferred to Implementation,
the status of the Assignments on the porject should be set to Closed.
**/ 

trigger LX_Project_SetAssignmentStatus on pse__Proj__c (after insert,after update) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return;

List <pse__Proj__c> proList= new List <pse__Proj__c>();
List <ID> proIDList= new List <ID>();
List <pse__Assignment__c> asList = new List <pse__Assignment__c>();
for(pse__Proj__c pro:Trigger.New)
        {
           proIDList.add(pro.Id);    
        }
System.debug('ProIDListCheck'+proIDList);
if(proIDList.size()>0)
proList=[SELECT Id from pse__Proj__c WHERE (pse__Is_Active__c = FALSE AND pse__Closed_for_Time_Entry__c = TRUE) AND Id IN:proIDList];
System.debug('ProListCheck'+proList);
List <pse__Assignment__c> updateasList = new List <pse__Assignment__c>();
updateasList=[Select Id from pse__Assignment__c WHERE pse__Status__c != 'Closed' AND pse__Project__c IN:proList];
for(pse__Assignment__c pa:updateasList)
    {
        System.debug('AssignmentID'+pa.Id);    
        pa.pse__Status__c = 'Closed';
    }
    if(updateasList.size()>0)
    update updateasList;



}