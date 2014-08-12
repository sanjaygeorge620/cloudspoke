global class updateCampaignMembers{
    WebService static void updateCampaign(List<String> campaignID,String strContactId) {
    system.debug('campaignID == '+campaignID);
    system.debug('strContactId== '+strContactId);
        Map<String, String> campOwnerEmailMap = new Map<String, String>();
        List<Campaign> campList = [select Lx_Enable_Opt_Out__c,Owner.Email, Id from Campaign where id IN: campaignID];
        for(Campaign c: campList){
            //c.Lx_Enable_Opt_Out__c = true;
            campOwnerEmailMap.put(c.Id, c.Owner.Email);
        }
        update campList;
        
        List<CampaignMember> campMemberList = [select Campaign.Owner.Email,Id,Status,Campaign.Id from CampaignMember where Campaign.Id IN: campaignID and Contactid =: strContactId];
        for(CampaignMember cm: campMemberList){
            if(cm.status != 'Opt-Out Requested' &&  cm.status != 'Opted-Out' &&  cm.status != 'Opt-Out Denied'){
                cm.status = 'Opt-Out Requested'; 
                cm.Lx_Campaign_Owner_Email__c = campOwnerEmailMap.get(cm.Campaign.Id);
            }
        }
        update campMemberList;
    }
    
    WebService static void updateCampaignMem(List<String> campaignMemID) {
        List<CampaignMember> campMemberList = [select Campaign.Owner.Email,Id,Status,Campaign.Id,
                                            Lx_Campaign_Owner_Email__c  from CampaignMember where Id IN: campaignMemID];
        for(CampaignMember cm: campMemberList){
        system.debug('cm.status === '+cm.status);
            if(cm.status != 'Opt-Out Requested' &&  cm.status != 'Opted-Out' &&  cm.status != 'Opt-Out Denied'){
                cm.status = 'Opt-Out Requested'; 
                cm.Lx_Campaign_Owner_Email__c = cm.Campaign.Owner.Email;
                }
        }
        system.debug('campMemberList === '+campMemberList);
        update campMemberList;
    }
}