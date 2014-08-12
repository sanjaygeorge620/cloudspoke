/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 5/03/2013
 *
 * Author : Rahul Raghunathan
 * 
 * Description : Update the primary and winner competitors.
 
 * 5/8/2013 Kapil Reddy Sama,Updated to make sure there is only 1 winner and 1 primary competitor on Opportunity.  
**/ 


trigger LX_Opportunity_Competitor_AI_AU on LX_Opportunity_Competitor__c (after insert, after update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
    
    if(LX_OpportunityHelper.alreadyUpdated == false){//Avoid recursion using a static variable
        list<LX_Opportunity_Competitor__c> competitorsToUpdate = new List<LX_Opportunity_Competitor__c>();//list of competitors to update.  
        set<id> newWinnerIdsSet = new set<id>();//set of newly created/updated winner competitors
        set<id> newPrimaryIdsSet = new set<id>();//set of newly created/updated primary competitors

        //Rahul Add for Opp
        Map<id,id> newWinnerOppMap = new Map<id,id>();//Map that holds the winner and the corresponding Opportunity
        Map<id,id> newPrimaryOppMap = new Map<id,id>();//Map that holds the Primary and the corresponding Opportunity

        
        
        //Insert
        if(trigger.isInsert){
            for(LX_Opportunity_Competitor__c Competitor : trigger.new){
                if(Competitor.LX_winner__c == true){//Check for winner competitors and add it to a set.                  
                    newWinnerIdsSet.add(Competitor.Id);  
                    newWinnerOppMap.put(Competitor.Id,Competitor.LX_Opportunity__c);                    
                }
                if(Competitor.LX_Primary__c == true){ //Check for priamry competitors and add it to a set.                    
                    newPrimaryIdsSet.add(Competitor.Id);                    
                    newPrimaryOppMap.put(Competitor.Id,Competitor.LX_Opportunity__c);                   
                }
            }
        }
        System.debug('newWinnerIdsSet-->'+newWinnerIdsSet);
        System.debug('newPrimaryIdsSet-->'+newPrimaryIdsSet);
        //Update
        if(trigger.isUpdate){
            for(LX_Opportunity_Competitor__c Competitor : trigger.new){
                if(Competitor.LX_winner__c == true && trigger.oldmap.get(Competitor.Id).LX_winner__c != true){//Check for winner competitors and add it to a set.                    
                    newWinnerIdsSet.add(Competitor.Id);   
                    newWinnerOppMap.put(Competitor.Id,Competitor.LX_Opportunity__c);                    
                }
                if(Competitor.LX_Primary__c == true && trigger.oldmap.get(Competitor.Id).LX_Primary__c != true){ //Check for priamry competitors and add it to a set.                   
                    newPrimaryIdsSet.add(Competitor.Id);                    
                    newPrimaryOppMap.put(Competitor.Id,Competitor.LX_Opportunity__c);                   
                    }
            }
        }    
        
        System.debug('newWinnerIdsSet-->'+newWinnerIdsSet);
        System.debug('newPrimaryIdsSet-->'+newPrimaryIdsSet);
    
        for(LX_Opportunity_Competitor__c Competitor :  [SELECT Name,LX_winner__c,LX_Primary__c FROM LX_Opportunity_Competitor__c 
                                                                                               WHERE Id NOT IN : newWinnerIdsSet and LX_winner__c = true
                                                                                               and LX_Opportunity__c IN :newWinnerOppMap.values()]){//iterate through list of winner competitors to update
            if(Competitor.LX_winner__c == true){
                Competitor.LX_winner__c = false; 
                competitorsToUpdate.add(Competitor);            
            }
        } 
        
        for(LX_Opportunity_Competitor__c Competitor :  [SELECT Name,LX_winner__c,LX_Primary__c FROM LX_Opportunity_Competitor__c 
                                                                                               WHERE Id NOT IN : newPrimaryIdsSet and LX_primary__c = true
                                                                                               and LX_Opportunity__c IN :newPrimaryOppMap.values()]){//iterate through list of primary competitors to update
            if(Competitor.LX_Primary__c == true){
                Competitor.LX_Primary__c = false; 
                competitorsToUpdate.add(Competitor);            
            }
        } 
    
        System.debug('competitorsToUpdate-->'+competitorsToUpdate);
        
        if( competitorsToUpdate.size() > 0){//update the competitors
            LX_OpportunityHelper.alreadyUpdated = true; 
            try{
            update competitorsToUpdate;
            }catch(Exception ex){            
                System.debug('Exception-->'+ex);    
                 LX_CommonUtilities.createExceptionLog(ex);//Exception log ,Veenu Trehan 6/11/13                   
            }
        }
    }
}