trigger LX_DeleteAccountCompetitor on LX_Opportunity_Competitor__c  (before delete) 
{
/*
 * ©Lexmark Front Office 2013, all rights reserved
 * Created Date : 24/May/2013
 * Author : Arun thakur(arunsingh6@deloitte.com)
 * Description : Delete related “Competitor Influencer and Partner”  reocrds
 */
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code

Set<Id> LX_CompetitorInfluencerPartnerIds=new Set<Id>();
        
    
        for(LX_Opportunity_Competitor__c  ObjInfluencer :trigger.Old)
        {
            if(ObjInfluencer.LX_Competitor_Relationship__c!=null)
            LX_CompetitorInfluencerPartnerIds.Add(ObjInfluencer.LX_Competitor_Relationship__c);
            
        }
         if(!LX_CompetitorInfluencerPartnerIds.IsEmpty())
         {
            delete [select id from LX_Account_Competitor__c where id in :LX_CompetitorInfluencerPartnerIds];
         }
 }