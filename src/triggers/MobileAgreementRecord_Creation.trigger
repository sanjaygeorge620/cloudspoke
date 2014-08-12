trigger MobileAgreementRecord_Creation on Case (after insert) {
     /**************************************
     Description: Creating Mobile Agreement record when Mobile request case is approved
     *
     *
     Date Created: 11/17/2011
     *
     *
     Date Revision: 11/27/2011
     *
     By: Manoj Kolli
     *****************************************/ 
     
    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
     
     Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
     static Map<String,Schema.RecordTypeInfo> rtMap ;
     if(!test.isRunningTest()){
     	rtMap = des.getRecordTypeInfosByName();
     }else{
     	if(rtMap == null){
     		rtMap = des.getRecordTypeInfosByName();
     	}
     }
     
     Id MRrtId = rtMap.get('Mobile Request').getRecordTypeId();
     List<Mobile_Agreement__c> malist = new List<Mobile_Agreement__c>();
     
     for(Case caseRec : Trigger.New){
             if(caseRec.RecordTypeID == MRrtId && caseRec.Status == 'New' ){
                 Mobile_Agreement__c ma = new Mobile_Agreement__c();
                 ma.Case_Number__c = caseRec.Id;
                 malist.add(ma); 
                }     
        }
     insert malist;      
}