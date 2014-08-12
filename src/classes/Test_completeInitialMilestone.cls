/**
 * Name: Test_completeInitialMilestone
 *
 * Description: to provide code coverage for completeInitialMilestone Trigger
 *
 * Created Date: 4/3/2012
 * Created By: Manoj Kolli
 */
@isTest(SeeallData = true)
public class Test_completeInitialMilestone{

    static testMethod void Test_completeInitialMilestone() {
      
      Test.startTest();
       Account acc = Data_account.createAccount();
    
    Entitlement entl = new Entitlement(AccountID = acc.Id,name='test Entitlement');
    insert entl;
        //Entitlement entl = [select id,AccountID,SlaProcessId,Name,Status from Entitlement where SlaProcessId!=null and Name != 'Enhanced Support Services' and Status = 'Active' limit 1];
        
        String entlId, acctid;
        if (entl != null){
          entlId = entl.Id;
          acctid = entl.AccountId;
        }  
        Account accttt = Data_Account.createAccount();
        List<Contact> cntList = Data_Contact.createContacts(accttt.Id, 1);
        //Contact oContact = [select id from Contact where AccountID=:acctid and email!='' limit 1];
        Contact oContact = cntList[0];
        String contactId;
        if (oContact != null)
          contactId = oContact.Id;
    
        Case newcase; 
        if (entlId != null){
          newcase = new Case(Subject = 'Test Case with Entitlement ',Severity__c = 'Low', EntitlementId = entlId, ContactId = contactId, recordtypeid=getRecordtypeID('Product Support','Case'));
        }
    
        System.debug('cases: '+newcase);
        insert newcase;
                        
        Id CaseId = newcase.Id;
        Task t = new Task(Subject = 'Email',Status = 'Completed',Priority = 'Low',RecordTypeId = getRecordtypeID('Standard Task','Task'), WhatId = Caseid);
        insert t;
      
      Test.stopTest(); 
           
    }
    
     private static id getRecordtypeID(string RecordTypeName,string objName){
         Id recordType;
         if(objName=='Case'){
             Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
             Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
             recordType = rtMapByName.get(RecordTypeName).getRecordTypeId();
          }
         else if(objName=='Task'){
             Schema.DescribeSObjectResult d = Schema.SObjectType.Task;
             Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
             recordType = rtMapByName.get(RecordTypeName).getRecordTypeId(); 
          }
         return recordType;
      }
          
}