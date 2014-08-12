public with sharing class InternalProjectRequestRally_Extension {
	
	public integer listSize {get;set;}
	
	public Boolean showNewUserStory {get;set;}
	
	public string newUSNameNoti {get;set;}
	public string newUSName {get;set;}
	public string newUSDescription {get;set;}
	public string newUSSelectedState {get;set;}
	public string newUSSelectedProject {get;set;}
	
	public decimal newUSRank {get;set;}
	
	public boolean showCreateNewButton {get;set;}
	
	public List<selectOption> userStoryStates {get;set;}
	
	private ApexPages.StandardController controller {get;set;}
	
	private SFDC_Projects__c p;
	
	public SFDC_Projects__c project {get;set;}
	
	public List<rallyUserStoryWrapper> userStories {get;set;}
	
	public InternalProjectRequestRally_Extension(ApexPages.StandardController controller) {
		
		//set visibility on the create new button
		showCreateNewButton = Rally_Integration_Access__c.getInstance(userinfo.getuserid()).Create_UserStory__c;
		
		//initialize the standard controller
		this.controller = controller;
		this.p = (SFDC_Projects__c)controller.getRecord();
		
		showNewUserStory = false;
		
		queryPageRecord();
		queryRallyUserStories();
	}
	
	
	public class rallyUserStoryWrapper {
		
		public string usId {get;set;}
		public string usObjectId {get;set;}
		public string usName {get;set;}
		public string usStatus {get;set;}
		public string usIteration {get;set;}
		public string usRelease {get;set;}
		public string usProjectId {get;set;}

		public rallyUserStoryWrapper(string tmpUsId, string tmpUsObjectId, string tmpUsName, string tmpUsStatus, string tmpUsIteration, string tmpUsRelease, string tmpUsProjectId) {
			
			usId = tmpUsId;
			usObjectId = tmpUsObjectId;
			usName = tmpUsName;
			usStatus = tmpUsStatus;
			usIteration = tmpUsIteration;
			usRelease = tmpUsRelease;
			usProjectId = tmpUsProjectId;
		}
	} 
	
	public void queryPageRecord() {
		
		userStoryStates = new List<selectOption>();
		userStoryStates.add(new selectOption('Defined','Defined'));
		userStoryStates.add(new selectOption('In-Progress','In-Progress'));
		userStoryStates.add(new selectOption('Completed','Completed'));
		userStoryStates.add(new selectOption('Accepted','Accepted'));
		
		project = [SELECT Id, Name, ProjectID__c, Description__c, Business_Priority__c, Project__r.Name,
					Release__r.Name, Iteration__r.Name
				   FROM SFDC_Projects__c
				   WHERE Id = :p.Id];
	}
	
	public void queryRallyUserStories() {
		
		userStories = new List<rallyUserStoryWrapper>();
		
		rallyCalloutUtility rs = new rallyCalloutUtility();
		rs.getEntireUS('c_SFDCProjectID', project.ProjectID__c, '=');
		
		listSize = rallyCalloutUtility.userstory.QueryResult.Results.size();
		
		for(integer i =0; i < rallyCalloutUtility.userstory.QueryResult.Results.size();i++) {
			if(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID!=null){
				
				string iteration = '';
				string release = '';
				string projectId = '';
				
				if(rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration!=null) {
					iteration = rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration.refObjectName;
				}
				
				if(rallyCalloutUtility.userstory.QueryResult.Results[i].Release!=null) {
					release = rallyCalloutUtility.userstory.QueryResult.Results[i].Release.refObjectName;
				}

				if(rallyCalloutUtility.userstory.QueryResult.Results[i].Project!=null) {
					projectId = Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName).Rally_Project_Id__c:'';
				}
				
				userStories.add(new rallyUserStoryWrapper(rallyCalloutUtility.userstory.QueryResult.Results[i].FormattedID,
														  string.valueOf(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID),
														  rallyCalloutUtility.userstory.QueryResult.Results[i].Name,
														  rallyCalloutUtility.userstory.QueryResult.Results[i].ScheduleState,
														  iteration, release, projectId));
			}
		}
	}
	
	
	public PageReference performSave() {
		
		saveNewUserStory();
		
		return null;
	}
	
	public void saveNewUserStory() {
		
		
		if(newUSName == '') {
			
	 		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!... Must enter a value for Name!'));
		}
		else if(newUSDescription == '') {
			
	 		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!... Must enter a value for Description!'));
		}
		else if(project.Project__r.Name == null) {
			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!... Must enter a value for Project above in the COE Information section!'));
		}
		
		
		
		if(!ApexPages.hasMessages()) {
			
			Map<String, String> authorizeMap = rallyCalloutUtility.authorizeRallyCallout();
		
			
			rallyCalloutMappingUtility.upsertUS(null, null, newUSName, newUSSelectedState, UserInfo.getName(), project.Release__r.Name, newUSDescription,
					     							project.Iteration__r.Name, project.Project__r.Name, '1', 'testCapability', 'testSubCapability', 'testUserGroup', 
				         							'testArea', 'testCapabilityRank', 'testFunctionalEvaluation', 'testOldID', 'testIntegration', 'testSource', string.valueOf(newUSRank), UserInfo.getName(),
				         							authorizeMap.get('cookie'), authorizeMap.get('token'), project.ProjectID__c);
			
			
			newUSNameNoti = newUSName;
			queryRallyUserStories();
			newUSName = null;
			newUSDescription = null;
			showNewUserStory = false;
		}
		
	}
	
	
	public PageReference newUserStoryToggle() {
		
		if(showNewUserStory) {
			
			newUSName = null;
			newUSDescription = null;
			showNewUserStory = false;
		}
		else {
			
			newUSRank = project.Business_Priority__c;
			newUSName = project.Name;
			newUSDescription = project.Description__c;
			showNewUserStory = true;
		}
		
		return null;
	}
	
	public PageReference nullPR() {
		
		return null;
	}
	
}