trigger ValidateOpportunityLineItem on OpportunityLineItem (before update, before insert) {

 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    // Trigger Switch
    Boolean LX_Switch = false; 
    static integer index = 0;    
    // Get current profile custom setting.
    LX_Profile_Exclusion__c LXProfile = LX_Profile_Exclusion__c.getvalues(UserInfo.getProfileId()); 
    // Get current Organization custom setting.
    LX_Profile_Exclusion__c LXOrg = LX_Profile_Exclusion__c.getvalues(UserInfo.getOrganizationId());
    // Get current User custom setting.
    LX_Profile_Exclusion__c LXUser = LX_Profile_Exclusion__c.getValues(UserInfo.getUserId());
    
    // Allow the trigger to skip the User/Profile/Org based on the custom setting values
    if(LXUser != null)
        LX_Switch = LXUser.Bypass__c;
    else if(LXProfile != null)
        LX_Switch = LXProfile.Bypass__c;
    else if(LXOrg != null)
        LX_Switch = LXOrg.Bypass__c;
    if(LX_Switch)
        return;    

    /*****************************************************************
    //when Opportunity Stage = 'closed Won' and contract Indicator != '',
    //          no update allowed for product Line items
    //********************************************************************/

    Set<ID> OppIdSet = new Set<ID>();
    Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>();
     //get listing of opportunities
     for (OpportunityLineItem  oppRec : Trigger.new){
            OppIdSet.add(oppRec.Opportunityid);
            system.debug('OppIdSet:' + OppIdSet);   
     }
     
     //get listing of all CLIN information record related the oppIDset
     List<Opportunity> oppList = new List<Opportunity>([select ID
                                                                , StageName
                                                                , Contract_Indicator__c 
                                                                , Locked__c
                                                                from Opportunity 
                                                                where id in :OppIdSet]);
    system.debug('oppList' + oppList);
    for(Opportunity OppRec : oppList){
        oppMap.put(oppRec.id, OppRec);
    }                                                               
                                                                
     for (OpportunityLineItem  oppLineItemRec : Trigger.new){ 
        Opportunity OppRec = oppMap.get(oppLineitemRec.OpportunityID);
        if (OppRec.Locked__c == 'Yes' ){
            oppLineItemRec.addError('You cannot update/create product line items for this Closed won opportunity'); 
        }
     }
}