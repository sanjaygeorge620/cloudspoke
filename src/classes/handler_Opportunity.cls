public with sharing class handler_Opportunity { 
	
	public static void assignOppTerritoryMember(List<Opportunity> opps, Map<Id, Opportunity> oldOppMap, Boolean isUpdate) {

		set<Id> userIds = new set<Id>();
		
		for(Opportunity opp : opps) {

			if(isUpdate) {
				//check to see if owner changed and ensure opportunity is not closed
				if((opp.OwnerId != oldOppMap.get(opp.Id).OwnerId) && (!opp.IsClosed)) {
					
					userIds.add(opp.OwnerId);
				}
			}
			else {
				
				userIds.add(opp.OwnerId);
			}
		}
		
		if(userIds.size() > 0) {
		
			map<Id,Id> userIdTerritoryMemberIdMap = new map<Id,Id>();
			
			for(LX_Territory_Member__c tm :[SELECT Id, Name, LX_Territory_Id__c,LX_User__c 
	                                        FROM LX_Territory_Member__c
	                                        WHERE LX_User__c IN :userIds
	                                        AND LX_DefaultFlag__c = true]) {
	        	
	        	userIdTerritoryMemberIdMap.put(tm.LX_User__c, tm.id);                
	        }
	        
	        // update the territory member on opportunity
	        for(Opportunity opp : opps) {
	        	
	        	if(userIdTerritoryMemberIdMap.get(opp.OwnerId) != null) {
	        	
	        		opp.LX_Territory_Member__c = userIdTerritoryMemberIdMap.get(opp.OwnerId);
	        	}
	        }
		}
	}

	//This method defaults fields on create
	public static void setFieldsOnInsertUpdate(List<Opportunity> opps, Map<Id, Opportunity> oldOppMap, Boolean isUpdate) {

		for(Opportunity opp : opps) {

			if(isUpdate) {
			
				//Set Sold To IDF field for history tracking
				opp.Sold_To_IdF__c = opp.LX_SoldToID__c;
			}
			else {

				//This defaults the Billing Currency to the CurrencyISOCode on create
				opp.Billing_Currency__c = opp.CurrencyIsoCode;

				//Set Sold To IDF field for history tracking
				opp.Sold_To_IdF__c = opp.LX_SoldToID__c;
			}
		}
	}

	//check to see if Billing Currency and CurrencyISOCode are equal when opp goes Closed Won
	//if not equal then append the special notes field with a message for the SAP Contract
	public static void checkForCurrencyMatch(List<Opportunity> opps, Map<Id, Opportunity> oldOppMap, Boolean isUpdate) {

		for(Opportunity opp : opps) {

			String specialNotes = 'Opportunity Currency and Billing Currency do not match. Please Check what the currency should be on the SAP Contract.';

			if(isUpdate) {

				if((opp.StageName != oldOppMap.get(opp.Id).StageName) && (opp.StageName == 'Closed Won') && (opp.CurrencyIsoCode != opp.Billing_Currency__c)) {

					if(opp.Special_Notes__c != null && !opp.Special_Notes__c.contains(specialNotes)) {

						String appendedNotes = specialNotes + opp.Special_Notes__c;

						if(appendedNotes.length() > 255) {

							appendedNotes = appendedNotes.substring(0, 254);
						}

						opp.Special_Notes__c = appendedNotes;
					}
					else if(opp.Special_Notes__c == null) {

						opp.Special_Notes__c = specialNotes;
					}
				}
			}
			else {

				if((opp.StageName == 'Closed Won') && (opp.CurrencyIsoCode != opp.Billing_Currency__c)) {

					if(opp.Special_Notes__c != null && !opp.Special_Notes__c.contains(specialNotes)) {

						String appendedNotes = specialNotes + opp.Special_Notes__c;

						if(appendedNotes.length() > 255) {

							appendedNotes = appendedNotes.substring(0, 254);
						}

						opp.Special_Notes__c = appendedNotes;
					}
					else if(opp.Special_Notes__c == null) {

						opp.Special_Notes__c = specialNotes;
					}
				}
			}
		}
	}
}