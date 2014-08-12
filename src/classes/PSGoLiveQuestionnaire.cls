public with sharing class PSGoLiveQuestionnaire {

	public Project_Go_Live_Questionnaire__c goLiveQ {get;set;}
	public Boolean showIfNotDetails {get;set;}

	public PSGoLiveQuestionnaire() {


		setupPage();
	}

	public void setupPage() {

		goLiveQ = new Project_Go_Live_Questionnaire__c();

		showIfNotDetails = false;
	}

	public PageReference performSave() {

		return null;
	}

	public PageReference toggleShowIfNotDetails() {

		if(showIfNotDetails) {

			showIfNotDetails = false;
		}
		else {

			showIfNotDetails = true;
		}

		return null;
	}
}