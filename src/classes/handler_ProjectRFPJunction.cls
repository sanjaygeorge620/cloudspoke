public with sharing class handler_ProjectRFPJunction {

	public static void populateAggregateFields(List<Project_RFP_Junction__c> junctions) {

		Set<Id> rfpIds = new Set<Id>();

		for(Project_RFP_Junction__c j : junctions) {

			if(j.Project_RFP_Account__c != null) {

				rfpIds.add(j.Project_RFP_Account__c);
			}
			else if(j.Project_RFP_Opportunity__c != null) {

				rfpIds.add(j.Project_RFP_Opportunity__c);
			}
		}

		Map<Id, List<Project_RFP_Junction__c>> rfpMap = new Map<Id, List<Project_RFP_Junction__c>>();

		for(Project_RFP_Junction__c j : [SELECT Id, Project_RFP_Account__c, Project_RFP_Opportunity__c, Account__c, Account_Name__c, Alias__c,
												Geo__c, Global_Account_Rating__c, Lexmark_Sub_Vertical__c, Lexmark_Vertical__c, Opportunity__c,
												Opportunity_Name__c, Opportunity_Stage__c, Opportunity_Type__c, Opportunity_Amount__c
										 FROM Project_RFP_Junction__c
										 WHERE Project_RFP_Account__c IN :rfpIds
										 OR Project_RFP_Opportunity__c IN :rfpIds]) {

			Id rfpId;

			if(j.Project_RFP_Account__c != null) {

				rfpId = j.Project_RFP_Account__c;
			}
			else if(j.Project_RFP_Opportunity__c != null) {

				rfpId = j.Project_RFP_Opportunity__c;
			}

			if(rfpMap.containsKey(rfpId)) {

				rfpMap.get(rfpId).add(j);
			}
			else {

				rfpMap.put(rfpId, new List<Project_RFP_Junction__c>{j});
			}
		}


		List<rfp_projects__c> rfps = new List<rfp_projects__c>();

		for(rfp_projects__c rfp : [SELECT Id, Account_ID__c, Account_NameQ__c, Alias__c, Geographies__c, Global_Account_Rating__c, Lexmark_Sub_Vertical__c,
										Lexmark_Vertical__c, Opportunity_Amount__c, Opportunity_IDQ__c, Opportunity_Name__c, Opportunity_Stage__c, Opportunity_TypeQ__c
								   FROM rfp_projects__c
								   WHERE Id IN :rfpMap.keyset()]) {

			rfps.add(rfp);
		}

		for(rfp_projects__c rfp : rfps) {

			string accountIds = '';
			string accountName = '';
			string accountAlias = '';
			string accountGeos = '';
			string accountRating = '';
			string accountSubVertical = '';
			string accountVertical = '';
			string oppIds = '';
			string oppNames = '';
			string oppStages = '';
			string oppTypes = '';
			decimal oppAmount = 0;

			for(Project_RFP_Junction__c j : rfpMap.get(rfp.Id)) {

				if(j.Project_RFP_Account__c != null) {

					accountIds += j.Account__c + ';';
					accountName += j.Account_Name__c + ';';
					accountAlias += j.Alias__c + ';';
					accountGeos += j.Geo__c + ';';
					accountRating += j.Global_Account_Rating__c + ';';
					accountSubVertical += j.Lexmark_Sub_Vertical__c + ';';
					accountVertical += j.Lexmark_Vertical__c + ';';
				}
				else if(j.Project_RFP_Opportunity__c != null) {

					oppIds += j.Opportunity__c + ';';
					oppNames += j.Opportunity_Name__c + ';';
					oppStages += j.Opportunity_Stage__c + ';';
					oppTypes += j.Opportunity_Type__c + ';';
					oppAmount += j.Opportunity_Amount__c;
				}
			}

			
			
			if(accountIds != '') {

				rfp.Account_ID__c = accountIds.removeEnd(';');
				rfp.Account_NameQ__c = accountName.removeEnd(';');
				rfp.Alias__c = accountAlias.removeEnd(';');
				rfp.Geographies__c = accountGeos.removeEnd(';');
				rfp.Global_Account_Rating__c = accountRating.removeEnd(';');
				rfp.Lexmark_Sub_Vertical__c = accountSubVertical.removeEnd(';');
				rfp.Lexmark_Vertical__c = accountVertical.removeEnd(';');
			}

			if(oppIds != '') {

				rfp.Opportunity_IDQ__c = oppIds.removeEnd(';');
				rfp.Opportunity_Name__c = oppNames.removeEnd(';');
				rfp.Opportunity_Stage__c = oppStages.removeEnd(';');
				rfp.Opportunity_TypeQ__c = oppTypes.removeEnd(';');
				rfp.Opportunity_Amount__c = oppAmount;
			}
			
		}

		update rfps;
	}
}