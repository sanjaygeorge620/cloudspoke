trigger updateLeadBasedOnCampaign on CampaignMember (after insert, after update,before delete)
{
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    SkipLeadContactTriggerExecution.setSkipExecution();
    List<id> lstId = new List<Id>();
    boolean isContact = false;
    boolean isLead = false;
    public static boolean isAlreadyExecuted = false;
    List<CampaignMember> lstCmp = new List<CampaignMember>();
    List<Campaign> lstCampgn = new List<Campaign>();
    Map<Id, Campaign> mapCmpIdCmp = new  Map<Id, Campaign>();
    Map<id,CampaignMember> mapCmIdCmpMem = new Map<id,CampaignMember>();
    
    //System.debug('YYYYYYYY Executing trigger updateLeadBasedOnCampaign');
    //System.debug('+++++++++ Trigger.New'+Trigger.New);
     //Check is current user is marketing user or not
    User objUser = [select id,UserPermissionsMarketingUser from user where id =: userInfo.getUserId()];
    //Record is deleting and user is not marketing user then throw error message
    system.debug('objUser  == '+objUser );
    if(trigger.isBefore && trigger.isDelete)
    {
        for(CampaignMember obj : trigger.old)
        {
            if(!objUser.UserPermissionsMarketingUser)
                obj.addError('You are not authorized to remove campaign members. Please select Opt-Out to request removal of a campaign member from a campaign.');
        }
        
    }
    else
    {
        if(isAlreadyExecuted == false){
            for(CampaignMember c : Trigger.New)
            {
                lstCmp.add(c);
                System.debug('++++++++++ ID '+c.id);
                lstId.add(c.id);
            }
             
            System.debug('***** lstLead '+lstCmp +' size '+lstCmp.size() +'List Id Size '+lstId.size());
            List<CampaignMember> cms=[SELECT CampaignID, LeadID, ContactId, Status FROM CampaignMember WHERE Id IN: lstId];
            System.debug('***** CampaignMembers '+cms.size());
            Set<ID> CampaignIDs= new Set<ID>(); 
             
             for (CampaignMember cm:cms)
            { 
                CampaignIDs.add(cm.CampaignID); 
                if(string.isNotBlank(cm.ContactId)){    // Check if the Campaign member is assigned to a Contact    
                    mapCmIdCmpMem.put(cm.ContactId,cm); 
                    isContact = true;
                }
                if(string.isNotBlank(cm.LeadId)){  // Check if the Campaign member is assigned to a Lead      
                    mapCmIdCmpMem.put(cm.LeadId,cm);
                    isLead = true;
                }
            } 
             
             System.debug('***** CampaignIDs '+CampaignIDs);
             lstCampgn = [Select Id,name,Type from Campaign where Id IN:CampaignIDs];
             
             for(Campaign Cmp :lstCampgn )
             {
                 mapCmpIdCmp.put(Cmp.id,cmp);
             }     
               System.debug('***** lstCampgn '+lstCampgn);
             Campaign camp;
             if(isLead){
                 List<Lead> leads = [Select Id, LeadSource, Name, Lx_Original_Campaign__c,Lead_Source_Most_Recent__c from Lead where Id in :mapCmIdCmpMem.KeySet() and IsCOnverted =: false];
                
                 for(Lead leadObj : leads){
                     camp = mapCmpIdCmp.get(mapCmIdCmpMem.get(leadObj.id).campaignId);
                     System.debug('## camp '+camp.type);
                     if(String.isBlank(leadObj.Lx_Original_Campaign__c)) //Check if a Campaign is already associated with a Lead
                     {
                         leadObj.Lx_Original_Campaign__c = camp.id;
                         System.debug('+++++++++++leadObj.Lx_Original_Campaign__c  '+leadObj.Lx_Original_Campaign__c + ' camp.id '+camp.id);
                         leadObj.LeadSource = camp.Type;  //Lead source original
                         leadObj.Lead_Source_Most_Recent__c = camp.Type;
                     }
                     else
                     {
                         leadObj.Lead_Source_Most_Recent__c = camp.Type;
                     }
                     
                 }
                 if(leads.size() > 0){
                 system.debug('>>>>>>>>>>>>>>>>>> updating leads' +leads);
                     update leads;
                 }
              }
              else if(isContact){
                  List<Contact> contacts = [Select Id, LeadSource, Name, Lx_Original_Campaign__c,Lead_Source_Most_Recent__c from Contact where Id in :mapCmIdCmpMem.KeySet()];
                
                 for(Contact contactObj: contacts){
                     camp = mapCmpIdCmp.get(mapCmIdCmpMem.get(contactObj.id).campaignId);
                     System.debug('## camp '+camp.type);
                     if(String.isBlank(contactObj.Lx_Original_Campaign__c)) //Check if a Campaign is already associated with a Contact
                    {
                         contactObj.Lx_Original_Campaign__c = camp.id;
                         System.debug('+++++++++++contactObj.Lx_Original_Campaign__c  '+contactObj.Lx_Original_Campaign__c + ' camp.id '+camp.id);
                         contactObj.LeadSource = camp.Type;  //Lead source original
                         contactObj.Lead_Source_Most_Recent__c = camp.Type;
                    }
                     else
                    {
                         contactObj.Lead_Source_Most_Recent__c = camp.Type;
                    }
                     
                }
                 if(contacts.size() > 0){
                 system.debug('>>>>>>>>>>>>>>>>>> updating contacts' +contacts);
                     update contacts;
                }
              
            }
            isAlreadyExecuted = true;
        }   
   }
     
     //Update Campaign Member Owner Details
     
     if(Trigger.isInsert){
         List<CampaignMember> cms=[SELECT CampaignID, LeadID, Status, Campaign_Member_Owner__c, Campaign_Member_Owner__r.Email, CreatedById FROM CampaignMember WHERE Id IN: lstId];
         Id cmId;
         for(CampaignMember cm : cms){
             //cmId = cm.Campaign_Member_Owner_ID__c;
             cm.Campaign_Member_Owner__c = cm.CreatedById;
             cm.Lx_Campaign_Owner_Email__c = cm.Campaign_Member_Owner__r.Email;
         }
         
         if(cms.size() > 0){
             update cms;
         }
     }
     SkipLeadContactTriggerExecution.resetSkipExecution();
}