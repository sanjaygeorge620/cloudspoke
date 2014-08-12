/***************************************************************************************************
Name : populatePrimaryDealerOnOpportunity 
Created By : Reena Acharya(Appirio Offshore)
Created Date : 26th March , 2013
Description : Set Primary Dealer of Opportunity on insert/update/delete of related dealers
***************************************************************************************************/
trigger populatePrimaryDealerOnOpportunity on Dealer__c (after insert, after update, after delete) {
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code

   Set<Id> opportunityIDs = new Set<Id>();

   //On insert /Update /Delete create a set of new Opportunity and old opportunity Ids.
   
   if(Trigger.isInsert || Trigger.isUpdate ){
       for(Dealer__c deal : Trigger.New){                      
           if(Trigger.isInsert || (Trigger.isUpdate && (Trigger.OldMap.get(deal.Id).Primary_Dealer__c  != deal.Primary_Dealer__c || Trigger.OldMap.get(deal.Id).Opportunity_Name__c  != deal.Opportunity_Name__c))){
               if(deal.Opportunity_Name__c  != null)
                   opportunityIDs.add(deal.Opportunity_Name__c );
               if(Trigger.isUpdate && Trigger.OldMap.get(deal.Id).Opportunity_Name__c != null)
                   opportunityIDs.Add(Trigger.OldMap.get(deal.Id).Opportunity_Name__c);
           }
       }
   }
   else if (Trigger.isDelete){
       for(Dealer__c deal : Trigger.Old){ 
            if(deal.Primary_Dealer__c && deal.Opportunity_Name__c != null){
                opportunityIDs.add(deal.Opportunity_Name__c );
            }
       }
   }
   //Opportunity set contains any id then process those opportunities.
    if(opportunityIDs.size() > 0){
        //Get the opportunities with associated dealers 
        List<Opportunity> opps = new List<Opportunity>([Select id ,Primary_Dealer__c,(Select id ,Primary_Dealer__c,Name, Dealer_Name__r.name from Dealers__r where Primary_Dealer__c  = true ) from Opportunity where id in : opportunityIDs ]);
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        //Iterate opportunity data
        for(Opportunity opp : opps)
        {
            //If opp dont have any primary dealer associated with it then set primary dealer of opporutnity as blank.
            if(opp.Dealers__r.size() == 0)
            {
                opp.Primary_Dealer__c = '';
                oppsToUpdate.Add(opp);
            }
            else 
            {
                //If opp have multiple primary dealers associated then update primary dealer with comma separated dealers name.
                String dealerName = '';
                for(Dealer__c dealer : opp.Dealers__r)
                {
                    dealerName += dealer.Dealer_Name__r.name + ',';
                }
                dealerName = dealerName.substring(0,dealerName.length() -1);
                opp.Primary_Dealer__c = dealerName ;
                oppsToUpdate.Add(opp);
            }
        }
        
        //Update opportunities.
        if(oppsToUpdate.size() > 0){
            update oppsToUpdate;
        }
        
    }   
}