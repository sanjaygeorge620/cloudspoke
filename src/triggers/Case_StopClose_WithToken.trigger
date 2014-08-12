trigger Case_StopClose_WithToken on Case (before insert, before update) {

    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
    
    
    Set<ID> caseIdSet = new Set<ID>();
    Map<ID, Case> caseMap = new Map<ID, Case>();
    List<Case> CaseList = new List<Case>();
    
    for (Case caseRec : Trigger.new){

        if (caseRec.Require_Token__c == 'Yes' & caseRec.Status == 'Closed'){
            caseIdSet.add(caseRec.id);
            system.debug('caseIdSet:' + caseIdSet);   
            caseMap.put(caseRec.id,caseRec);   
            CaseList.add(caseRec);  
         }   
     }
     String errorMessageBody = '';
      //get listing of all CLIN information record related the oppIDset
     if (caseIdSet.size()> 0) {
        List<Token__c> tokenList = new List<Token__c>([select ID from Token__c where case__c in :caseIdSet]);
     
        
         
         for (Case newCaseRec : caseList){
            system.debug('caseList' + caseList);
            system.debug('newCaseRec.Token_Quantity__c' + newCaseRec.Token_Quantity__c);
            if (newCaseRec.Token_Quantity__c == null){
                errorMessageBody = 'Token Quantity is required to close this case.';
            }else{
                system.debug('tokenList.size()' + tokenList.size());
                if (tokenList.size()< 1){
                    errorMessageBody = 'Please assign correct number of tokens before closing this case.';
                }else{
                    system.debug('newCaseRec.token_Quantity__c.intvalue():' + newCaseRec.token_Quantity__c.intvalue());
                    if(tokenList.size() != newCaseRec.token_Quantity__c.intvalue()){
                        errorMessageBody = 'Please assign correct number of tokens before closing this case.';
                    }
                }
            }  
            if (errorMessageBody != '') {
                newCaseRec.addError(errorMessageBody); 
            }  
         } 
         
     }
     
}