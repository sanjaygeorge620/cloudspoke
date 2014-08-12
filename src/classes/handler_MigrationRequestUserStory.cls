public with sharing class handler_MigrationRequestUserStory {


	public static void updateIPRUSMR(List<Migration_Request_User_Story_Junction__c> junctions) {

		List<IPR_US_MR__c> updateIPRUSMR = new List<IPR_US_MR__c>();

		Set<String> usRallyIds = new Set<String>();
		Map<String, String> rallyIdMRIdMap = new Map<String, String>();

		for(Migration_Request_User_Story_Junction__c j : junctions) {

			usRallyIds.add(j.Rally_User_Story_Id__c);
			rallyIdMRIdMap.put(j.Rally_User_Story_Id__c, j.Migration_Request__c);
		}

		for(IPR_US_MR__c var : [SELECT Id, Migration_Request__c, Rally_User_Story_Id__c
								FROM IPR_US_MR__c
								WHERE Rally_User_Story_Id__c IN :usRallyIds]) {

			var.Migration_Request__c = rallyIdMRIdMap.get(var.Rally_User_Story_Id__c);
			updateIPRUSMR.add(var);
		}

		update updateIPRUSMR;
	}
}