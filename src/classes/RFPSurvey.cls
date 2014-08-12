public with sharing class RFPSurvey {

	//attachments
	public List<Attachment> rfpAttachments {get;set;}

	//contact vars
	public Contact primaryCustomerContact {get;set;}
	public Contact primaryLexmarkContact {get;set;}

	//
	public rfp_projects__c newRFP {get;set;}
	public String fileName {get;set;}
	public String contentType {get;set;}
	public Blob proposalDocumentation {get;set;}

	//Search Existing variables
	public String selectedExistingRFPId {get;set;}
	public Integer searchListSize {get;set;}
	public List<rfp_projects__c> searchExistingRFPs {get;set;}
	private string rfpSoql {get;set;}
	public String sortDir {

		get{ if(sortDir == null) {sortDir = 'ASC';} return sortDir; }
		set;
	}
	public String sortField {

		get { if(sortField == null) {sortField = 'Name';} return sortField; }
		set;
	}

	//Page Parameters
	public String oppOrAccountId {get;set;}
	public String rfpId {get;set;}

	//Visibility variables
	public Boolean showRFPSection1 {get;set;}
	public Boolean showRFPSection2 {get;set;}
	public Boolean showRFPSection3 {get;set;}

	public Boolean showBothSection {get;set;}
	public Boolean showPSWSection {get;set;}
	public Boolean showISSSection {get;set;}

	
	
	//constructor
	public RFPSurvey() {

		oppOrAccountId = Apexpages.currentPage().getParameters().get('Id');

		rfpId = Apexpages.currentPage().getParameters().get('rfp');

		
		if(rfpId != null && rfpId != '') {

			showRFPSection1 = false;
			showRFPSection2 = false;
			showRFPSection3 = true;

			queryAttachments();
		}
		else {

			showRFPSection1 = true;
			showRFPSection2 = false;
			showRFPSection3 = false;
		}

		searchListSize = 0;
		rfpSoql = 'SELECT Id, Name, Contact__c, RFP_Due_Date__c FROM rfp_projects__c WHERE Name != null';
		runQuery();
	}
	

	//page queries
	public void pageSetup() {
		
		newRFP = new rfp_projects__c();

		primaryCustomerContact = new Contact();
		primaryLexmarkContact = new Contact();

		if(selectedExistingRFPId != null && selectedExistingRFPId != '') {

			newRFP = [SELECT Id, Contact__c, RFP_Due_Date__c, Date_Decision_is_Expected__c, 
						Is_Hardcopy_Required__c, Is_Lexmark_the_incumbent__c, Date_Intent_to_Bid_doc_due__c, 
						Customer_requires_ISO_Certification__c, Questions_Due_to_Customer__c, Date_Request_Was_Received__c, 
						Proposal_Reference_Number__c, Response_Requirements_Detail__c, Sales_Engineer__c, 
						Proposal_Coordinator__c, Proposal_Writer_1__c, Proposal_Writer_2__c, 
						Proposal_Writer_3__c, Proposal_Writer_4__c, Sales_Manager__c, Type_of_Request__c, 
						Pricing_to_be_Provided__c, Prior_Contact_With_Prospect_Details__c, 
						Sample_RFP_Functional_Checklist__c, Additional_Prior_Contact_Details__c, 
						Website_for_Proposal__c, Username__c, Password__c, Red_Flags_Challenges__c, 
						Strengths__c, Deployment_Target_Date__c, Deployment_Complexity__c, Are_we_partnering__c, Are_we_priming_or_is_the_partner__c, 
						List_of_Partners__c, Performance_or_Bid_Bond_Required__c, Business_Unit__c, 
						Pursuing_Opportunity__c, RFP_Pricing_Terms__c, Pricing_Details__c, Strategic_Opportunity__c, 
						Deploying_Across_5_Departments__c, Deploying_In_More_Than_10_Locations__c, 
						Large_Professional_Services_Commitment__c, Multi_phase_Deployment__c, 
						Engaging_a_System_Integrator__c, Initial_PO_Value_3M_US__c, License_Deployment_300_users__c, 
						Multiple_Partners__c, Footprint_in_New_or_Strategic_Area__c, Additional_Opportunity_Details__c, 
						Number_of_Processes_Proposed__c, Number_of_Sites__c, Processes_Proposed__c, New_PSW_Install__c, 
						Consolidating_an_Existing_System__c, Replacing_a_Single_Existing_System__c, 
						Consolidating_Replacing_Details__c, Solution_Proposed__c, Custom_Solution__c, 
						Host_Application_s__c, Hardware_Provisioning__c, Backfile_Conversion_Needed__c, 
						Backfile_Conversion_Details__c, Proposing_Object_Conversion__c, Technical_Validation_Exercise_TVE__c, 
						Project_Plan_Required__c, Simple_or_Sample_Project_Plan__c, Simple_Sample_Project_Plan_Details__c, 
						Does_Solution_Meet_Requirements__c, Deploy_on_Time_and_Budget__c, Solution_Requirements_Deployment_Details__c, 
						Traditional_Perpetual_Deployment__c, Subscription_on_Premises_Deployment__c, Hosted__c, 
						Software_as_a_Service__c, Solutions_Anticipated__c, Future_Functionality_Required__c, 
						Training_Location__c, Delivery_Method__c, Course_1__c, Partnering_Agreement_in_Place__c, 
						Teaming_Agreements_in_Place__c, ISS_Local_Priority__c, eCommerce_Capability__c, 
						Most_Important_output_need__c, Second_Most_Important_output_need__c, Most_important_outcome__c, 
						Second_most_important_outcome__c, Follow_up_date__c, Main_Title_of_Proposal__c, Subtitle_of_Proposal__c, 
						Term_of_Contract__c, Total_Quantity_of_Units__c, Estimated_Page_Volumes_Per_Month__c, 
						Current_Print_Vendor__c, Current_Copier_Vendor__c, Current_Quantity_of_Printers__c, 
						Industry_Consultant_on_Project__c, RSC_on_Project__c, ROC_on_Project__c, PSC_on_Project__c, 
						Ext_CFT_Member_1_on_Project__c, Ext_CFT_Member_2_on_Project__c, Ext_CFT_Member_3_on_Project__c, 
						Please_Select__c, RFP_Due_Date_and_Time__c, Scanners_Required__c, SE_on_Project__c, Primary_Lexmark_Contact__c,
						Estimated_revenue_for_this_project__c, Lexmark_company_name_long__c, Lexmark_company_name_short__c, 
						Geo_s_covered_by_this_project__c                                                                    
					  FROM rfp_projects__c
					  WHERE Id = :selectedExistingRFPId];


	  		queryPrimaryCustomerContact();
		} 

		queryPrimaryLexmarkContact();

		showBothSection = true;
		showPSWSection = false;
		showISSSection = false;
	}

	public void queryPrimaryCustomerContact() {
		
		
		if(newRFP.Contact__c != null) {
			
			primaryCustomerContact = [SELECT Id, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Phone, Email
									  FROM Contact
									  WHERE Id = :newRFP.Contact__c];
	  	}
	}

	public void queryPrimaryLexmarkContact() {
		
		
		if(newRFP.Primary_Lexmark_Contact__c != null) {
			
			primaryLexmarkContact = [SELECT Id, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Phone, Email
									 FROM Contact
									 WHERE Id = :newRFP.Primary_Lexmark_Contact__c];
	  	}
	  	else  {

	  		primaryLexmarkContact = [SELECT Id, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Phone, Email, pse__Salesforce_User__c
									 FROM Contact
									 WHERE pse__Salesforce_User__c = :UserInfo.getUserID()];

		 	newRFP.Primary_Lexmark_Contact__c = primaryLexmarkContact.Id;
	  	}
	}

	
	/* --------
	Form Existing Search Methods
	-------- */
	public void runQuery() {

		date d = System.Today();
		rfpSoql += ' AND RFP_Due_Date__c >= ' + string.valueof(d);

		try {

			searchExistingRFPs = Database.query(rfpSoql + ' ORDER BY ' + sortField + ' ' + sortDir + ' LIMIT 25');

			system.debug('Bazinga... ' + searchExistingRFPs);

			searchListSize = searchExistingRFPs.size();
		}
		catch(Exception e) {

			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!... ' + e));
		}
	}



	public PageReference runPrimaryCustomerContactFieldPull() {

		queryPrimaryCustomerContact();

		return null;
	}

	public PageReference runPrimaryLexmarkContactFieldPull() {

		queryPrimaryLexmarkContact();

		return null;
	}


	public PageReference runFilter() {
 
		

		string searchRFPValue = Apexpages.currentPage().getParameters().get('searchRFPValue');
		
		rfpSoql = 'SELECT Id, Name, Contact__c, RFP_Due_Date__c FROM rfp_projects__c WHERE Name != null';

		if(!searchRFPValue.equals('')) {

			rfpSoql += ' AND Name LIKE \'%'+String.escapeSingleQuotes(searchRFPValue)+'%\'';
		}

		system.debug('Bazinga...' + rfpSoql);

		runQuery();

		return null;
	}

	/* --------
	Form Save Methods
	-------- */
	public void performSave() {

		//update contact records
		if(primaryCustomerContact.Id != null) {

			update primaryCustomerContact;
		}

		if(primaryLexmarkContact.Id != null) {

			update primaryLexmarkContact;
		}

		//perform dml
		if(selectedExistingRFPId != null && selectedExistingRFPId != '') {

			update newRFP;
		}
		else {

			insert newRFP;
		}


		//check if to create new junction records
		List<Project_RFP_Junction__c> rfpJunctions = new List<Project_RFP_Junction__c>();

		set<Id> existingAccountIds = new set<Id>();
		set<Id> existingOpportunityIds = new set<Id>();

		for(Project_RFP_Junction__c prj : [SELECT Id, Account__c, Opportunity__c, Project_RFP_Account__c, Project_RFP_Opportunity__c,
												Opportunity__r.AccountId
										   FROM Project_RFP_Junction__c
										   WHERE Project_RFP_Account__c = :newRFP.Id
										   OR Project_RFP_Opportunity__c = :newRFP.Id]) {

			if(prj.Account__c != null) {
				
				existingAccountIds.add(prj.Account__c);
			}

			if(prj.Opportunity__c != null) {

				existingOpportunityIds.add(prj.Opportunity__c);
				existingAccountIds.add(prj.Opportunity__r.AccountId);
			}
		}

		//check if opp or account then create junction records

		//account
		if(oppOrAccountId.substring(0,3) == '001') {

			if(!existingAccountIds.contains(oppOrAccountId)) {

				createRelatedJunctionRecords(true, existingAccountIds);
			}
		} 
		else if(oppOrAccountId.substring(0,3) == '006') { //opp

			if(!existingOpportunityIds.contains(oppOrAccountId)) {

				createRelatedJunctionRecords(false, existingAccountIds);
			}
		}
	}

	public void createRelatedJunctionRecords(Boolean isAccount, set<Id> existingAccountIds) {


		if(isAccount) {

			Project_RFP_Junction__c newJunction = new Project_RFP_Junction__c();

			newJunction.Account__c = oppOrAccountId;
			newJunction.Project_RFP_Account__c = newRFP.Id;

			insert newJunction;

			createChildJunctionRecords(true, newJunction.Id, null);
		}
		else {

			Project_RFP_Junction__c newOpportunityJunction = new Project_RFP_Junction__c();

			newOpportunityJunction.Opportunity__c = oppOrAccountId;
			newOpportunityJunction.Project_RFP_Opportunity__c = newRFP.Id;

			insert newOpportunityJunction;

			createChildJunctionRecords(false, newOpportunityJunction.Id, null);

			//
			string tempAccountId = [SELECT AccountId FROM Opportunity WHERE Id = :oppOrAccountId LIMIT 1].AccountId;

			//check to see if a junction has already been created for the related account
			if(!existingAccountIds.contains(tempAccountId)) {

				Project_RFP_Junction__c newAccountJunction = new Project_RFP_Junction__c();
				newAccountJunction.Account__c = tempAccountId;
				newAccountJunction.Project_RFP_Account__c = newRFP.Id;

				insert newAccountJunction;

				createChildJunctionRecords(true, newAccountJunction.Id, tempAccountId);
			}
			
		}
	} 


	public void createChildJunctionRecords(Boolean isAccount, String parentJunctionRecordId, String oppAccountId) {

		if(isAccount) {
			
			//create child junction records (AccountTeam)
			Map<Id, String> accountTeamMemberUserIdsAndRoles = new Map<Id, String>();

			if(oppAccountId != null) {

				accountTeamMemberUserIdsAndRoles = queryRelatedAccountTeamMembers(oppAccountId);
			}
			else {

				accountTeamMemberUserIdsAndRoles = queryRelatedAccountTeamMembers(oppOrAccountId);	
			}
			

			if(accountTeamMemberUserIdsAndRoles.size() > 0) {

				List<Project_RFP_Junction_Child__c> insertJunctionChildRecords = new List<Project_RFP_Junction_Child__c>();

				for(Id uId : accountTeamMemberUserIdsAndRoles.keyset()) {

					Project_RFP_Junction_Child__c newJunctionChildRecord = new Project_RFP_Junction_Child__c();

					newJunctionChildRecord.Account_Team_Member__c = uId;
					newJunctionChildRecord.Account_Team_Member_Role__c = accountTeamMemberUserIdsAndRoles.get(uId);
					newJunctionChildRecord.Project_RFP_Account_Team_Member__c = newRFP.Id;
					newJunctionChildRecord.Project_RFP_Junction__c = parentJunctionRecordId;

					insertJunctionChildRecords.add(newJunctionChildRecord);
				}

				insert insertJunctionChildRecords;
			}
		}
		else {

			//create child junction records (Opportunity Competitors)
			Set<Id> opportunityCompetitorIds = new Set<Id>();

			opportunityCompetitorIds = queryRelatedOpportunityCompetitors(oppOrAccountId);

			if(opportunityCompetitorIds.size() > 0) {

				List<Project_RFP_Junction_Child__c> insertJunctionChildRecords = new List<Project_RFP_Junction_Child__c>();

				for(Id competitorId : opportunityCompetitorIds) {

					Project_RFP_Junction_Child__c newJunctionChildRecord = new Project_RFP_Junction_Child__c();

					newJunctionChildRecord.Competitor__c = competitorId;
					newJunctionChildRecord.Project_RFP_Competitor__c = newRFP.Id;
					newJunctionChildRecord.Project_RFP_Junction__c = parentJunctionRecordId;

					insertJunctionChildRecords.add(newJunctionChildRecord);
				}

				insert insertJunctionChildRecords;
			}
		}
	}

	public Set<Id> queryRelatedOpportunityCompetitors(string oppId) {

		Set<Id> opportunityCompetitorIds = new Set<Id>();

		for(LX_Opportunity_Competitor__c oc : [SELECT Id, LX_Opportunity__c
											   FROM LX_Opportunity_Competitor__c
											   WHERE LX_Opportunity__c = :oppId]) {

			opportunityCompetitorIds.add(oc.Id);
		}

		return opportunityCompetitorIds;
	}

	public Map<Id, String> queryRelatedAccountTeamMembers(string accountId) {

		Map<Id, String> accountTeamMemberIdsAndRoles = new Map<Id, String>();

		for(AccountTeamMember atm : [SELECT AccountId, UserId, TeamMemberRole
									 FROM AccountTeamMember
									 WHERE AccountId = :accountId]) {

			accountTeamMemberIdsAndRoles.put(atm.UserId, atm.TeamMemberRole);
		}

		return accountTeamMemberIdsAndRoles;
	}

	public void queryAttachments() {

		rfpAttachments = new List<Attachment>();

		rfpAttachments = [SELECT Id, Name, ParentID
					      FROM Attachment
					      WHERE ParentID = :rfpId];
	}

	public PageReference attachFile() {

		if(proposalDocumentation != null) {

			Attachment attach = new Attachment();
	       	attach.Body= proposalDocumentation;
	      	attach.Name= filename;
	      	attach.ContentType= contentType;
	      	attach.ParentID= rfpId;
		    
		    try {
	          	insert(attach);
	      	} 
	      	catch(Exception e) {
          
          		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
	          	return null;
	      	}
		}

		PageReference Pg = page.rfpsurvey;
     	Pg.getParameters().put('Id', oppOrAccountId);
     	Pg.getParameters().put('rfp', rfpId);
     	Pg.setRedirect(true);
     	return Pg;
	}
 
	public PageReference performFinalSave() {

		PageReference pr = new PageReference('/' + rfpId);
        return pr.setRedirect(true);
	}


	/* --------
	Form Navigation Methods
	-------- */
	public PageReference launchExistingSurvey() {

		pageSetup();

		showRFPSection1 = false;
		showRFPSection2 = true;

		return null;
	}

	public PageReference launchNewSurvey() {

		pageSetup();

		showRFPSection1 = false;
		showRFPSection2 = true;

		return null;
	}

	public PageReference Next() {

		if((newRFP.Business_Unit__c == 'ISS' && showISSSection) ||
		   (newRFP.Business_Unit__c == 'PSW' && showPSWSection) ||
		   (newRFP.Business_Unit__c == 'Lexmark' && showPSWSection)) {

			try {

				performSave();
			}
      		catch(Exception e) {
      
      			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
          		return null;
      		}


			PageReference Pg = page.rfpsurvey;
         	Pg.getParameters().put('Id', oppOrAccountId);
         	Pg.getParameters().put('rfp', newRFP.Id);
         	Pg.setRedirect(true);
         	return Pg; 
		}
		else {

			if(newRFP.Business_Unit__c == 'ISS') {

				showISSSection = true;
			}
			else if(newRFP.Business_Unit__c == 'PSW') {

				showPSWSection = true;
			}
			
			
			if(newRFP.Business_Unit__c == 'Lexmark' && showBothSection) {

				showISSSection = true;
			}
			else if(newRFP.Business_Unit__c == 'Lexmark' && showISSSection) {

				showPSWSection = true;
				showISSSection = false;
			}

			if(showBothSection) {

				showBothSection = false;
			}

			return null;
		}
	}

	public PageReference Back() {

		if(newRFP.Business_Unit__c == 'ISS') {

			showBothSection = true;
			showISSSection = false;
		}
		else if(newRFP.Business_Unit__c == 'PSW') {

			showBothSection = true;
			showPSWSection = false;
		}
		
		
		if(newRFP.Business_Unit__c == 'Lexmark' && showISSSection) {

			showBothSection = true;
			showISSSection = false;
		}
		else if(newRFP.Business_Unit__c == 'Lexmark' && showPSWSection) {

			showISSSection = true;
			showPSWSection = false;
		}

		return null;
	}

	public PageReference nullPR() {

		return null;
	}
}