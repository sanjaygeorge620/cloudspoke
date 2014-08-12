trigger PartnerLeadApproval on Lead (after insert,after update) {
 
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
 if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update
 String unlockedRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get('Unlocked').getRecordTypeId();
 //RecordType recType = [select Id from RecordType where Name = 'Unlocked' and SobjectType = 'Lead'];
 for (Integer i = 0; i < Trigger.new.size(); i++){
     if(Trigger.new[i].RecordTypeId==unlockedRecordTypeId &&(Trigger.new[i].Partner_Type__c =='Partner')&&(Trigger.new[i].Partner_Approved__c!='Declined'&&Trigger.new[i].Partner_Approved__c!='Pending'&&Trigger.new[i].Partner_Approved__c!='Approved'&&Trigger.new[i].Partner_Approved__c!='Recalled')){
      Approval.ProcessSubmitRequest partnerleadApproval = new Approval.ProcessSubmitRequest();
      partnerleadApproval.setObjectId(Trigger.new[i].Id);
      Approval.ProcessResult result = Approval.process(partnerleadApproval);
      }
 }

}