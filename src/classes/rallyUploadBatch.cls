global class rallyUploadBatch implements Database.Batchable<integer>, Database.AllowsCallouts, Database.Stateful { // Schedulable,
	
	global final datetime cLastUpdateDate = system.now() - (1/24.0);
	
	//global string LastUpdateDate;
	//global DateTime cLastUpdateDate;
	
	global string query;
	global Map<String, String> authorizeMap;
	global List<Requirements__c> newSFRequirements; 
	
	//Constructor
	public rallyUploadBatch() {
		/*
		Rally_Integration_Callout_Settings__c LastUpdateSettings = Rally_Integration_Callout_Settings__c.getvalues('RallyV2');
        LastUpdateDate = LastUpdateSettings!=null?LastUpdateSettings.LastUpdate__c:'';
        
        cLastUpdateDate = datetime.valueof(LastUpdateDate);
        */
		query = 'SELECT Id, Object_ID__c, Rally_Id__c, LastModifiedDate, Request_Description__c, Request_Title__c, User_Story_Name__c, State__c, Product_Owner__c, Release__c, Description__c, Planned_Sprint_del__c, Project__c, SFDC_Story_Points__c, Capability__c, SubCapability__c, User_Group__c, Area__c, Capability_Rank__c, Functional_Evaluation__c, Old_Id__c, Integration__c, Sources__c, ranking__c, requester__c, Developer_Name__c FROM Requirements__c WHERE Rally_Id__c = null AND LastModifiedDate >= :cLastUpdateDate AND RecordTypeId != null AND RecordType.Developername = \'User_Story\'';
	} 
	
	// Start 
	global Iterable<integer> start(Database.BatchableContext bc) {
		system.debug('Bazinga... cLastUpdateDate: ' + cLastUpdateDate);
		system.debug('Bazinga... query: ' + query);
		
		authorizeMap = rallyCalloutUtility.authorizeRallyCallout(); 
		
		newSFRequirements = Database.query(query);
		
		system.debug('Bazinga... start... querySize: ' + newSFRequirements.size());
		
		list<integer> i = new list<integer>();
		
		for(Integer r = 0; r < newSFRequirements.size(); r++) {
			i.add(r);
		} 
		
		return i;
	}
	 
	
	// Execute *batch size set to 1*
	global void execute(Database.Batchablecontext BC, List<integer> scope) {
		
		system.debug('Bazinga... execute... current scope Id: ' + newSFRequirements[scope[0]].Id);
		
		rallyCalloutMappingUtility.upsertUS(newSFRequirements[scope[0]].Id, newSFRequirements[scope[0]].Object_id__c, newSFRequirements[scope[0]].User_Story_Name__c, newSFRequirements[scope[0]].State__c, newSFRequirements[scope[0]].Product_Owner__c, newSFRequirements[scope[0]].Release__c, newSFRequirements[scope[0]].Description__c,
				     							newSFRequirements[scope[0]].Planned_Sprint_del__c, newSFRequirements[scope[0]].Project__c, newSFRequirements[scope[0]].SFDC_Story_Points__c, newSFRequirements[scope[0]].Capability__c, newSFRequirements[scope[0]].SubCapability__c, newSFRequirements[scope[0]].User_Group__c, 
			         							newSFRequirements[scope[0]].Area__c, newSFRequirements[scope[0]].Capability_Rank__c, newSFRequirements[scope[0]].Functional_Evaluation__c, newSFRequirements[scope[0]].Old_ID__c, newSFRequirements[scope[0]].Integration__c, newSFRequirements[scope[0]].Sources__c, newSFRequirements[scope[0]].ranking__c, newSFRequirements[scope[0]].requester__c,
			         							authorizeMap.get('cookie'), authorizeMap.get('token'));
	}
	
	// Finish 
	global void finish(Database.Batchablecontext BC) { 
		/*
		//Query the AsyncApexJob object to retrieve the current job's information. 
 		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, ExtendedStatus, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
 						  FROM AsyncApexJob 
 						  WHERE Id = :BC.getJobId()];
 		
 		Rally_Integration_Callout_Settings__c LastUpdateSettings = Rally_Integration_Callout_Settings__c.getvalues('RallyV2');
        String LastUpdateDate = LastUpdateSettings!=null?LastUpdateSettings.LastUpdate__c:'';
 		
 		if(LastUpdateSettings != null) {
        	
        	LastUpdateSettings.LastUpdate__c = string.valueOf(datetime.now());
        	//update LastUpdateSettings;
        }
        */
	}
}