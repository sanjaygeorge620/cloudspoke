public with sharing class handler_RallyUserStory {

	public static void setIPRStatus(List<Rally_User_Story__c> rallyUserStories) {

		set<Id> iprIds = new set<Id>();

		for(Rally_User_Story__c rus : rallyUserStories) {

			iprIds.add(rus.Internal_Project_Request__c);
		}

		Map<Id, LIST<Rally_User_Story__c>> iprIdUsMap = new Map<Id, LIST<Rally_User_Story__c>>();

		for(Rally_User_Story__c rus : [SELECT Id, State__c, Internal_Project_Request__c
				   					   FROM Rally_User_Story__c
				   					   WHERE Internal_Project_Request__c IN :iprIds]) {

			if(iprIdUsMap.containsKey(rus.Internal_Project_Request__c)) {

				iprIdUsMap.get(rus.Internal_Project_Request__c).add(rus);
			}
			else {

				iprIdUsMap.put(rus.Internal_Project_Request__c, new List<Rally_User_Story__c>{rus});
			}
		}

		set<Id> updateIPRIds = new set<Id>();

		for(Id iprId : iprIds) {

			Boolean updateComplete = true;

			for(Rally_User_Story__c rus : iprIdUsMap.get(iprId)) {

				if(rus.State__c != 'Accepted') {

					updateComplete = false;
				}
			}

			if(updateComplete) {

				updateIPRIds.add(iprId);
			}
		}

		List<SFDC_Projects__c> updateIPRs = new List<SFDC_Projects__c>();

		if(updateIPRIds.size() > 0) {
			
			for(SFDC_Projects__c ipr : [SELECT Id, IPR_Status__c
									    FROM SFDC_Projects__c
									    WHERE Id = :updateIPRs]) {

				ipr.IPR_Status__c = 'Complete';
				updateIPRs.add(ipr);
			}

			update updateIPRs;
		}
	}

	public static void createIPRUSMR(List<Rally_User_Story__c> rallyUserStories) {

		List<IPR_US_MR__c> insertIPRUSMR = new List<IPR_US_MR__c>();

		for(Rally_User_Story__c rus : rallyUserStories) {

			IPR_US_MR__c newIPRUSMR = new IPR_US_MR__c();
			newIPRUSMR.Internal_Project_Request__c = rus.Internal_Project_Request__c;
			newIPRUSMR.Rally_User_Story__c = rus.Id;

			insertIPRUSMR.add(newIPRUSMR);
		}

		insert insertIPRUSMR;
	}

	public static void syncRallyUpload(List<Rally_User_Story__c> rallyUserStories, Map<Id, Rally_User_Story__c> oldMap, Boolean isUpdate) {

		for(Rally_User_Story__c rus : rallyUserStories) {

			boolean flag = Rally_Integration_Callout_Settings__c.getvalues('RallyV2')!=null?Rally_Integration_Callout_Settings__c.getvalues('RallyV2').ScheduleRunning__c:false;
	            
	        if(flag) {

	        	try {

        			
					if(isUpdate) {

	        			if(oldmap.get(rus.Id) != null && rus.Object_Id__c == oldmap.get(rus.Id).Object_Id__c) {

							rallyCalloutMappingUtility.futureUpsertUS(null, rus.Object_Id__c, rus.Name, rus.State__c, null, rus.Release__c, null,
							     								      rus.Iteration__c, rus.Project__c, null, null, null, null,
						         								      null, null, null, null, null, null, string.valueOf(rus.Rank__c), null,
						         								      rus.IPR_Number__c);
						}
					}
					else {

						rallyCalloutMappingUtility.futureUpsertUS(null, null, rus.Name, rus.State__c, null, rus.Release__c, null,
							     							      rus.Iteration__c, rus.Project__c, null, null, null, null,
						         							      null, null, null, null, null, null, string.valueOf(rus.Rank__c), null,
						         							      rus.IPR_Number__c);
					}
	        	}
	        	catch(exception e){
	            	
	            	rus.addError('Error: Please complete...' + e);
	            }
	        }
        }
	}
}