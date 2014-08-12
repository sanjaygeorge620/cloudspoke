public with sharing class handler_ProjectRFPJunctionChild {

	public static void populateAggregateFields(List<Project_RFP_Junction_Child__c> childJunctions) {

		Set<Id> rfpIds = new Set<Id>();

		for(Project_RFP_Junction_Child__c j : childJunctions) {

			if(j.Project_RFP_Account_Team_Member__c != null) {

				rfpIds.add(j.Project_RFP_Account_Team_Member__c);
			}
			else if(j.Project_RFP_Competitor__c != null) {

				rfpIds.add(j.Project_RFP_Competitor__c);
			}
		}

		Map<Id, List<Project_RFP_Junction_Child__c>> rfpMap = new Map<Id, List<Project_RFP_Junction_Child__c>>();

		for(Project_RFP_Junction_Child__c j : [SELECT Id, Project_RFP_Account_Team_Member__c, Project_RFP_Competitor__c, Account_Team_Member_Name__c, 
													Account_Team_Member_Role__c, Competitor_Account__c
									 		   FROM Project_RFP_Junction_Child__c
									 		   WHERE Project_RFP_Account_Team_Member__c IN :rfpIds
									 		   OR Project_RFP_Competitor__c IN :rfpIds]) {

			Id rfpId;

			if(j.Project_RFP_Account_Team_Member__c != null) {

				rfpId = j.Project_RFP_Account_Team_Member__c;
			}
			else if(j.Project_RFP_Competitor__c != null) {

				rfpId = j.Project_RFP_Competitor__c;
			}

			if(rfpMap.containsKey(rfpId)) {

				rfpMap.get(rfpId).add(j);
			}
			else {

				rfpMap.put(rfpId, new List<Project_RFP_Junction_Child__c>{j});
			}
		}


		List<rfp_projects__c> rfps = new List<rfp_projects__c>();

		for(rfp_projects__c rfp : [SELECT Id, Competitor_Account__c, Account_Team__c
								   FROM rfp_projects__c
								   WHERE Id IN :rfpMap.keyset()]) {

			rfps.add(rfp);
		}

		for(rfp_projects__c rfp : rfps) {

			string accountTeam = '';
			string competitorAccount = '';

			for(Project_RFP_Junction_Child__c j : rfpMap.get(rfp.Id)) {

				if(j.Project_RFP_Account_Team_Member__c != null) {


					accountTeam += j.Account_Team_Member_Name__c + '(' + j.Account_Team_Member_Role__c + ');';
				}
				else if(j.Project_RFP_Competitor__c != null) {

					competitorAccount += j.Competitor_Account__c + ';';
				}
			}

			if(accountTeam != '') {


				rfp.Account_Team__c = accountTeam.removeEnd(';');
			}

			if(competitorAccount != '') {

				rfp.Competitor_Account__c = competitorAccount.removeEnd(';');
			}
		}

		update rfps;
	}
}