trigger CheckFederalSection on Opportunity (before insert, before update) {
   
        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
   
    /*****************************************************************
    check 1
    //when Opportunity State = 'closed Won' and Sector = 'National Government' the following fields are required:
    //          requisition Number
    //          CLIN Contract Number
    //          Order Number
    //          Solicitation Number
    //          at least 1 record from the CLIN Information object
    //********************************************************************/
    Set<ID> OppIdSet = new Set<ID>();
    Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>();
    List<Opportunity> oppList = new List<Opportunity>();
  //  List<Profile> profiles = new List<Profile>();//'[Select id from Profile where name in('System Administrator', 'Tech IS')]);
  //  profiles[0] = ''
     //get listing of opportunities
     for (Opportunity  oppRec : Trigger.new){
        //Rahul added condition to bypass ISS opportunities
        if (oppRec.Sector__c == 'National Government' && oppRec.StageName == 'Closed Won' && oppRec.LX_Opportunity_Division__c != 'ISS'){
           
            String continueCheck = 'Yes';
      //      system.debug('WhatProfilecomesback: ' + [Select id from Profile where name in('System Administrator', 'Tech IS')] );
            system.debug('UserInfo.GetProfileID()' + UserInfo.GetProfileID());

    //        for( Profile profileRec : profiles){
    //          system.debug('continueCheck: ' + continueCheck);
    //          system.debug('profileRec.ID' + profileRec.ID);
                if(UserInfo.GetProfileID() == '00e70000000zmIT'){       //techIS profile
                    continueCheck = 'No';
                }
                if(UserInfo.GetProfileID() == '00e70000000yZmI'){       //System administrator profile
                    continueCheck = 'No';
                }
                if(UserInfo.GetProfileID() == '00e70000000yZmIAAU'){
                    continueCheck = 'No';
                }
      //      }
            if (continueCheck == 'Yes'){
              OppIdSet.add(oppRec.id);
              system.debug('OppIdSet:' + OppIdSet);   
              oppMap.put(opprec.id,opprec);   
              oppList.add(oppRec);
            }  
         }   
     }
     
     //get listing of all CLIN information record related the oppIDset
     system.debug('oppIDset.size()' + oppIDset.size());
     if (oppIDset.size()> 0) {
        List<CLIN_Information__c> clinList = new List<CLIN_Information__C>([select opportunity__c from CLIN_Information__c where opportunity__c in :OppIdSet]);
     
         String errorMessageBegin = 'The following field(s): ';
         String errorMessageEnd = ' must be completed to move this opportunity to closed won status.';
         String errorMessageBody;
         for (Opportunity newOppRec : oppList){
            if (newOppRec.Requisition_Number__c == null){
                errorMessageBody = 'Requisition Number';
            }
            if (newOppRec.CLIN_Contract_Number__c == null){
                if (errorMessageBody != null) {                 //need so that commas can be inserted only if contains other fields prior
                    errorMessageBody = errorMessageBody + ', Federal Contract Number';
                }else{
                errorMessageBody = 'Federal Contract Number';
                }
            }
            if (newOppRec.Order_Number__c == null){
                if (errorMessageBody != null) {                 //need so that commas can be inserted only if contains other fields prior
                    errorMessageBody = errorMessageBody + ', Order Number';
                }else{
                errorMessageBody = 'Order Number';
                }
            }
            if (newOppRec.Solicitation_Number__c == null){
                if (errorMessageBody != null) {                 //need so that commas can be inserted only if contains other fields prior
                    errorMessageBody = errorMessageBody + ', Solicitation Number';
                }else{
                errorMessageBody = 'Solicitation Number';
                }
            }
            if (newOppRec.Period_of_Performance__c == null){
                if (errorMessageBody != null) {                 //need so that commas can be inserted only if contains other fields prior
                    errorMessageBody = errorMessageBody + ', Period of Performance';
                }else{
                errorMessageBody = 'Period of Performance';
                }
            }

          if (clinList.size()< 1){
               if (errorMessageBody != null) {                 //need so that commas can be inserted only if contains other fields prior
                   errorMessageBody = errorMessageBody + ', CLIN Information Record';
                }else{
                     errorMessageBody = 'CLIN Information Record';
                }
            }   
            if (errorMessageBody != null) {
                newOppRec.addError(errorMessageBegin + errorMessageBody + errorMessageEnd); 
            }
         }
     }
}