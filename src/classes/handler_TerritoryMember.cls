public with sharing class handler_TerritoryMember {
	
	public static void checkDefaultTerritoryMemberToUpdateOpps(List<LX_Territory_Member__c> territoryMembers, Map<Id, LX_Territory_Member__c> oldMap, Boolean isUpdate) {
		
		map<Id, LX_Territory_Member__c> userIdTerritoryMemberMap = new map<Id, LX_Territory_Member__c>();
		
		for(LX_Territory_Member__c tm : territoryMembers) {
			
			if(isUpdate) {
				
				if(tm.LX_DefaultFlag__c && !oldMap.get(tm.Id).LX_DefaultFlag__c) {
					
					userIdTerritoryMemberMap.put(tm.LX_User__c, tm);
				}
			}
			else {
				
				if(tm.LX_DefaultFlag__c) {
					
					userIdTerritoryMemberMap.put(tm.LX_User__c, tm);
				}
			}
			
		}
		
		if(userIdTerritoryMemberMap.size() > 0) {
			
			List<Opportunity> updateOpps = new List<Opportunity>();
			
			for(Opportunity opp : [SELECT Id, LX_Territory_Member__c, OwnerId, IsClosed
								   FROM Opportunity
								   WHERE OwnerId IN :userIdTerritoryMemberMap.keyset()
								   AND IsClosed = false]) {
				
				opp.LX_Territory_Member__c = userIdTerritoryMemberMap.get(opp.OwnerId).Id;	
				updateOpps.add(opp);				   	
			}
			
			if(updateOpps.size() > 0) {
				
				//update updateOpps;
				
				
				try{
    				
    				update updateOpps;
    			}
    			catch(Exception Ex) {
    				trigger.new[0].adderror(ex.getmessage() + ' [#' + ex.getlinenumber() + ']');
    				//LX_CommonUtilities.createExceptionLog(Ex); 
    			} 
			}
		}
		
	}
}