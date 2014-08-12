public class RequestApproval {

    public static void RequestApproval(Case caseRec) {
    
        //Adding the code for Mobile Request Record type on Case By Manoj Kolli
        Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
        Id MRrtId = rtMap.get('Mobile Request').getRecordTypeId();
        

         Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
         system.debug('case Rec id' + caseRec.id);
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(caseRec.id);
        system.debug(caseRec.Resource_Manager__c);
        List<Id> nextAppIdList = new List<Id>();
        nextAppIdList.add(caseRec.Resource_Manager__c);
        if(caseRec.RecordTypeID == MRrtId){
            nextAppIdList.add(caseRec.Approver__c);
            }
        system.debug(nextAppIDList);
        req1.setNextApproverIds(nextAppIDList);
        // Submit the approval request for the Case rec  
        
         Approval.ProcessResult result = Approval.process(req1);
        }
        
    }