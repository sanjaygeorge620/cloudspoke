/**
 * Name: Test_initialmilestoneUtils
 *
 * Description: to provide code coverage for initialmilestoneUtils Class
 *
 * Created Date: 4/4/2012
 */
@isTest(seeAllData=true)
private class Test_initialmilestoneUtils {



    // test method
      static testMethod void Test_initialmilestoneUtils() {
     
        Test.startTest();
        Account acc = Data_Account.createAccount4();
        Entitlement entl = new Entitlement(name='Enhanced Services',accountId = acc.Id );
        insert entl; 
        //[select id,AccountID,SlaProcessId,Name,Status from Entitlement where SlaProcessId!=null and Name != 'Enhanced Support Services' and Status = 'Active' limit 1];
        String entlId, acctid;
        if (entl != null){
          entlId = entl.Id;
          acctid = entl.AccountId;
        }  
        Account accttt = Data_Account.createAccount4();
        List<Contact> cntList = Data_Contact.createContacts(accttt.Id, 1);
        //Contact oContact = [select id from Contact where AccountID=:acctid and email!='' limit 1];
        Contact oContact = cntList[0];
        //Contact oContact = [select id from Contact where AccountID=:acctid and email!='' limit 1];
        String contactId;
        if (oContact != null)
          contactId = oContact.Id;
    
        Case newcase; 
        if (entlId != null){
          newcase = new Case(Subject = 'Test Case with Entitlement ', Severity__c='Low',EntitlementId = entlId, ContactId = contactId, recordtypeid=getRecordtypeID('Product Support'));
        }
    
        System.debug('cases: '+newcase);
        insert newcase;
        
        DateTime completionDate = System.now()+2;  
        
        List<Id> csid = new List<Id>();
        csid.add(newcase.Id);
                
        initialmilestoneUtils.initialcompleteMilestone(csid,'Initial Response',completionDate);
             
        Test.stopTest(); 
           
    }
    
     private static id getRecordtypeID(string RecordTypeName){
         
             Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
             Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
             Id recordType = rtMapByName.get(RecordTypeName).getRecordTypeId();
          
             return recordType;
      } 
      

}