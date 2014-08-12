public class milestoneUtils {
     
    public static void completeMilestone(List<Id> caseIds, String milestoneName, DateTime complDate) {
        system.assertnotequals(milestoneName,'');               
        List<CaseMilestone> cmsToUpdate = [select Id, completionDate
                       from CaseMilestone cm
                       where caseId in :caseIds and cm.MilestoneType.Name=:milestoneName and completionDate = null limit 1];
        
        
        if (cmsToUpdate.isEmpty() == false){
          for (CaseMilestone cm : cmsToUpdate){
                cm.completionDate = complDate;
          }
          update cmsToUpdate;
        } 
      }
      
  
  
  
  
  // test methods
  static testMethod void testCompleteMilestoneCase(){
    Account acc = Data_account.createAccount();
    
    Entitlement et = new Entitlement(AccountID = acc.Id,name='test Entitlement');
    insert et;
    
   
    
    String entlId, acctid;
    if (et != null){
      entlId = et.Id;
      acctid = et.AccountId;
    }  
    Account acctt = Data_Account.createAccount();
    List<Contact> cntList = Data_Contact.createContacts(acctt.Id, 1);  
    Contact oContact = cntList[0];
    String contactId;
    if (oContact != null)
      contactId = oContact.Id;
    
    Case newcase; 
    if (entlId != null){
      newcase = new Case(Subject = 'Test Case with Entitlement ', ContactId = contactId, recordtypeid=getRecordtypeID('Product Support'));
    }
    
    System.debug('cases: '+newcase);
    insert newcase;
    
    //Cycle through the different stages to kick off milestones   
    newcase.Status = 'Open-Working';
    newcase.Status_Detail__c = 'Action Plan Provided';
    update newcase;
    system.assertequals(newcase.Status_Detail__c,'Action Plan Provided');
    
    
    newcase.Status_Detail__c = 'Remedy Provided';
    update newcase;
    system.assertequals(newcase.Status_Detail__c,'Remedy Provided');
    
    newcase.Status_Detail__c = 'Resolution provided';
    update newcase;
    system.assertequals(newcase.Status_Detail__c,'Resolution provided');
    
    newcase.status='Closed';
    update newcase;
    system.assertequals(newcase.status,'Closed');
 
    
    }
    
  
    static testMethod void testCompleteMilestoneViaCase(){
        
        Contact oContact = [select id from Contact where email!=''  limit 1];
        String contactId;
        List<Id> caseId = new List<Id>();
        if (oContact != null)
          contactId = oContact.Id;
          
        // Perform data preparation
         Account acc = Data_account.createAccount();
    
    Entitlement entl = new Entitlement(AccountID = acc.Id,name='test Entitlement');
    insert entl;
        //Entitlement entl = [select id from Entitlement where SlaProcessId!=null limit 1];
        String entlId;
        if (entl != null)
            entlId = entl.Id;
        List<Case> cases = new List<Case>{};
        for(Integer i = 0; i < 1; i++){
            Case c = new Case(Subject = 'Test Case ' + i, recordtypeid=getRecordtypeID('Product Support'));
            cases.add(c);
            if (entlId != null){
                c = new Case(Subject = 'Test Case with Entitlement ' + i, ContactId = contactId, recordtypeid=getRecordtypeID('Product Support'));
                cases.add(c);
            }
        }
        
        // Insert the Account records that cause the trigger to execute.
        insert cases;

        List<CaseComment> ccs = new List<CaseComment>{};
        for(Case c : cases){
            CaseComment cc = new CaseComment(CommentBody='TestPublic', IsPublished=true, ParentId=c.Id);
            ccs.add(cc);
            cc = new CaseComment(CommentBody='TestPrivate', IsPublished=false, ParentId=c.Id);
            ccs.add(cc);
        }
        if (ccs.isEmpty()==false)
            insert ccs;
    
    // Now create emailmessage objects for them.
    
        List<EmailMessage> emails = new List<EmailMessage>();
        for(Case c : cases){
            emails.add(new EmailMessage(parentId = c.id));
        }
        if(emails.isEmpty()==false)
            database.insert(emails);
        
        for(Case c : cases){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddr = new String[] {'mramsey@salesforce.com.test'};
            mail.setToAddresses(toAddr);
            mail.setSaveAsActivity(false);
            mail.setTargetObjectId(c.ContactId);
            mail.setWhatId(c.Id);
            mail.setHtmlBody('TestHTMLBody');
            mail.setPlainTextBody('TestTextBody');
            //Added by Charan on 20-09-2013 for overcoming MASS EMAIL error in times of Deployment
            if(test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    
    for(Case c : cases){
      c.Status = 'Open-Working';
      c.Status_Detail__c = 'Action Plan Provided';
      caseId.add(c.id);
    }
    update cases;
    
    milestoneUtils.completeMilestone(caseId,'TestMilestone',Date.today());   
  
    }

private static id getRecordtypeID(string RecordTypeName){
     Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
     Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
     Id recordType = rtMapByName.get(RecordTypeName).getRecordTypeId();
     
     return recordType;
     }

}