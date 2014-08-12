trigger UpdateLeadFields on Lead (before insert, before update) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
if(SkipLeadContactTriggerExecution.skipTriggerExec) return; // Do no execute the trigger if it is fired from a campaign update

Set<ID> CampaignCloneIDs = new Set<ID>();
List<Campaign_Clone__c> cclst = new List<Campaign_Clone__c>();
Map<ID,ID> cclnmap = new map<ID,ID>();

     
   for(Lead l : Trigger.New)
   {   
       system.debug('l.areas_of_need__c:' + l.areas_of_need__c);
       system.debug(  'l.account_Area_of_Interest_s__c :' + l.account_Area_of_Interest_s__c);
       system.debug('l.Legacy_Company_Originator__c:' + l.Legacy_Company_Originator__c);
       system.debug(  'l.contact_Legacy_Company_Originator__c :' + l.contact_Legacy_Company_Originator__c);

        if(l.areas_of_need__c != l.account_Area_of_Interest_s__c){  
            l.account_Area_of_Interest_s__c = l.areas_of_need__c;
        }

        if(l.contact_Legacy_Company_Originator__c != l.Legacy_Company_Originator__c){  
            l.contact_Legacy_Company_Originator__c = l.Legacy_Company_Originator__c;
          
        }
        if(l.areas_of_need__c != l.opportunity_Area_of_Interest__c){  
            l.opportunity_Area_of_Interest__c = l.areas_of_need__c;
        }

        if(l.opportunity_Legacy_Company_Originator__c != l.Legacy_Company_Originator__c){  
            l.opportunity_Legacy_Company_Originator__c = l.Legacy_Company_Originator__c;
          
        }
        
        if(l.Primary_Partner__c != null && l.Partner_Campaign_Clone__c != null)
        {
        //CampaignCloneIDs.add(l.Partner_Campaign_Clone__c);
        l.Partner_Campaign__c = l.Partner_Campaign_Clone__r.Campaign__c;
        }
      }
    if(Trigger.isBefore){
      for(Lead l : Trigger.New){
          l.Submitter__c = UserInfo.getUserId();
      }
  }  
 /* ccLst = [Select ID,Campaign__c from Campaign_Clone__c where ID in: CampaignCloneIDs];
  
  if(!ccLst.isEmpty())
  {
  for(Campaign_Clone__c cl : ccLst)
  {
  cclnmap.put(cl.id,cl.Campaign__c);  
  }
  }
  
for(Lead l : Trigger.New)
   {
   system.debug('Lead === '+l);
   if(l.Primary_Partner__c != null && l.Partner_Campaign_Clone__c != null)
        {
       l.Partner_Campaign__c = cclnmap.get(l.Partner_Campaign_Clone__c);
        }
  }*/
}