/*
This trigger is for creating statuses for opt-out notification. Also this trigger puts id in campaign member field 
from value in Campaign Creator field

*/
trigger createStatuses on Campaign (after Insert, after update){
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // Added Bypass code
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        List<CampaignMemberStatus> cms=new List<CampaignMemberStatus>();
        Set<Id> campId = new Set<Id>(); // for user story 3163
        List<String> emailIds = new List<String>(); // for user story 3163
        for (Campaign c: trigger.new){
            cms.add(new CampaignMemberStatus(CampaignId=c.Id, HasResponded=false, Label='Opt-Out Requested', SortOrder=3));
            cms.add(new CampaignMemberStatus(CampaignId=c.Id, HasResponded=false, Label='Opted-Out', SortOrder=4));
            cms.add(new CampaignMemberStatus(CampaignId=c.Id, HasResponded=false, Label='Opt-Out Denied', SortOrder=5));
            campId.add(c.Id); // for user story 3163
        }
        if(cms.size() > 0){
            insert cms;
        }
        // for user story 3163 start
        List<CampaignMember> campMemList = new List<CampaignMember>();
        campMemList = [SELECT CampaignID, LeadID,LX_Campaign_Creator__c FROM CampaignMember WHERE CampaignID IN: campId];
        for(CampaignMember c : campMemList){
            emailIds.add(c.LX_Campaign_Creator__c);  // for user story 3163
        }
        Map<String,Id> userEmailUserIdMap = new Map<String,Id>();
        List<CampaignMember> campMemListtoUpdate = new List<CampaignMember>();
        List<User> userInfo = [Select Id, Name, Email From User where Email IN: emailIds];
        For(User userInfoRec : userInfo){
            if(!userEmailUserIdMap.containsKey(userInfoRec.Email)){
            userEmailUserIdMap.put(userInfoRec.Email,userInfoRec.Id);
            }
        }
        for(CampaignMember c : campMemList){
            if(userEmailUserIdMap.containsKey(c.LX_Campaign_Creator__c)){
            c.LX_Campaign_Creator_ID__c = userEmailUserIdMap.get(c.LX_Campaign_Creator__c);
            }
        campMemListtoUpdate.add(c);
        }
        if(campMemListtoUpdate.size()>0 && campMemListtoUpdate != null){
        update campMemList;
        }
        // for user story 3163 end
    }
}