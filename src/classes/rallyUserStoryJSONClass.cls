public class rallyUserStoryJSONClass {
	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) { 
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class QueryResult {
		public String rallyAPIMajor {get;set;}
		public String rallyAPIMinor {get;set;}
		public List<Errors> Errors {get;set;}
		public List<String> Warnings {get;set;}
		public Integer TotalResultCount {get;set;}
		public Integer StartIndex {get;set;}
		public Integer PageSize {get;set;}
		public List<Results> Results {get;set;}
		public Set<String> formattedIds {get;set;}
		public Set<String> iprNumbers {get;set;}

		public QueryResult(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == '_rallyAPIMajor') {
							rallyAPIMajor = parser.getText();
						} else if (text == '_rallyAPIMinor') {
							rallyAPIMinor = parser.getText();
						} else if (text == 'Errors') {
							Errors = new List<Errors>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								Errors.add(new Errors(parser));
							}
						} else if (text == 'Warnings') {
							Warnings = new List<String>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								//Warnings.add(new String(parser));
								Warnings.add(parser.getText());
							}
						} else if (text == 'TotalResultCount') {
							TotalResultCount = parser.getIntegerValue();
						} else if (text == 'StartIndex') {
							StartIndex = parser.getIntegerValue();
						} else if (text == 'PageSize') {
							PageSize = parser.getIntegerValue();
						} else if (text == 'Results') {
							Results = new List<Results>();
							formattedIds = new Set<String>();
							iprNumbers = new Set<String>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								Results.add(new Results(parser));
								formattedIds.add(Results[Results.size() - 1].FormattedID);
								iprNumbers.add(Results[Results.size() - 1].SFDCProjectID);
								system.debug('Bazinga... FormattedId: ' + Results[Results.size() - 1].FormattedID);
							}
						} else {
							System.debug(LoggingLevel.WARN, 'QueryResult consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tags {
		public String rallyAPIMajor {get;set;}
		public String rallyAPIMinor {get;set;}
		public String ref {get;set;}
		public String type {get;set;}
		public List<Errors> tagsNameArray {get;set;}
		public Integer Count {get;set;}

		public Tags(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == '_rallyAPIMajor') {
							rallyAPIMajor = parser.getText();
						} else if (text == '_rallyAPIMinor') {
							rallyAPIMinor = parser.getText();
						} else if (text == '_ref') {
							ref = parser.getText();
						} else if (text == '_type') {
							type = parser.getText();
						} else if (text == '_tagsNameArray') {
							tagsNameArray = new List<Errors>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								tagsNameArray.add(new Errors(parser));
							}
						} else if (text == 'Count') {
							Count = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Tags consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Changesets {
		public String rallyAPIMajor {get;set;}
		public String rallyAPIMinor {get;set;}
		public String ref {get;set;}
		public String type {get;set;}
		public Integer Count {get;set;}

		public Changesets(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == '_rallyAPIMajor') {
							rallyAPIMajor = parser.getText();
						} else if (text == '_rallyAPIMinor') {
							rallyAPIMinor = parser.getText();
						} else if (text == '_ref') {
							ref = parser.getText();
						} else if (text == '_type') {
							type = parser.getText();
						} else if (text == 'Count') {
							Count = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Changesets consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Subscription {
		public String rallyAPIMajor {get;set;}
		public String rallyAPIMinor {get;set;}
		public String ref {get;set;}
		public String refObjectUUID {get;set;}
		public String refObjectName {get;set;}
		public String type {get;set;}

		public Subscription(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == '_rallyAPIMajor') {
							rallyAPIMajor = parser.getText();
						} else if (text == '_rallyAPIMinor') {
							rallyAPIMinor = parser.getText();
						} else if (text == '_ref') {
							ref = parser.getText();
						} else if (text == '_refObjectUUID') {
							refObjectUUID = parser.getText();
						} else if (text == '_refObjectName') {
							refObjectName = parser.getText();
						} else if (text == '_type') {
							type = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Subscription consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public QueryResult QueryResult {get;set;}

	public rallyUserStoryJSONClass(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'QueryResult') {
						QueryResult = new QueryResult(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class RevisionHistory {
		public String rallyAPIMajor {get;set;}
		public String rallyAPIMinor {get;set;}
		public String ref {get;set;}
		public String refObjectUUID {get;set;}
		public String type {get;set;}

		public RevisionHistory(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == '_rallyAPIMajor') {
							rallyAPIMajor = parser.getText();
						} else if (text == '_rallyAPIMinor') {
							rallyAPIMinor = parser.getText();
						} else if (text == '_ref') {
							ref = parser.getText();
						} else if (text == '_refObjectUUID') {
							refObjectUUID = parser.getText();
						} else if (text == '_type') {
							type = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'RevisionHistory consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Results {
		public String rallyAPIMajor {get;set;}
		public String rallyAPIMinor {get;set;}
		public String ref {get;set;}
		public String refObjectUUID {get;set;}
		public String objectVersion {get;set;}
		public String refObjectName {get;set;}
		public String CreationDate {get;set;}
		public String CreatedAt {get;set;}
		public Long ObjectID {get;set;}
		public Subscription Subscription {get;set;}
		public Subscription Workspace {get;set;}
		public Changesets Changesets {get;set;}
		public String Description {get;set;}
		public Changesets Discussion {get;set;}
		public Object DisplayColor {get;set;}
		public String FormattedID {get;set;}
		public String SFDCProjectID {get;set;}
		public String LastUpdateDate {get;set;}
		public Object LatestDiscussionAgeInMinutes {get;set;}
		public String Name {get;set;}
		public String Notes {get;set;}
		public Subscription Owner {get;set;}
		public Subscription Project {get;set;}
		public Boolean Ready {get;set;}
		public RevisionHistory RevisionHistory {get;set;}
		public Tags Tags {get;set;}
		public Changesets Attachments {get;set;}
		public Object Packages {get;set;}
		public String AcceptedDate {get;set;}
		public Boolean Blocked {get;set;}
		public Object BlockedReason {get;set;}
		public Object Blocker {get;set;}
		public Changesets Children {get;set;}
		public String DefectStatus {get;set;}
		public Changesets Defects {get;set;}
		public Integer DirectChildrenCount {get;set;}
		public Boolean HasParent {get;set;}
		public String InProgressDate {get;set;}
		public Subscription Iteration {get;set;}
		public Object Parent {get;set;}
		public Double PlanEstimate {get;set;}
		public Changesets Predecessors {get;set;}
		public Double Rank {get;set;}
		public Boolean Recycled {get;set;}
		public Subscription Release {get;set;}
		public String ScheduleState {get;set;}
		public Changesets Successors {get;set;}
		public Double TaskActualTotal {get;set;}
		public Double TaskEstimateTotal {get;set;}
		public Double TaskRemainingTotal {get;set;}
		public String TaskStatus {get;set;}
		public Changesets Tasks {get;set;}
		public String TestCaseStatus {get;set;}
		public Changesets TestCases {get;set;}
		public String AcceptanceCriteria {get;set;}
		public String Area {get;set;}
		public String Capability {get;set;}
		public String CapabilityRank {get;set;}
		public Object Feature {get;set;}
		public String FunctionalityEvaluation {get;set;}
		public String Integration {get;set;}
		public Object NotUsed {get;set;}
		public String NotUsedCapability {get;set;}
		public String NotUsedCapabilityRank {get;set;}
		public String NotUsedOldID {get;set;}
		public String NotUsedSource {get;set;}
		public String NotUsedSubCapability {get;set;}
		public String OldID {get;set;}
		public Object PortfolioItem {get;set;}
		public String Ranking {get;set;}
		public String Requester {get;set;}
		public String Source {get;set;}
		public String SubCapability {get;set;}
		public String UserGroup {get;set;}
		public String type {get;set;}

		public Results(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == '_rallyAPIMajor') {
							rallyAPIMajor = parser.getText();
						} else if (text == '_rallyAPIMinor') {
							rallyAPIMinor = parser.getText();
						} else if (text == '_ref') {
							ref = parser.getText();
						} else if (text == '_refObjectUUID') {
							refObjectUUID = parser.getText();
						} else if (text == '_objectVersion') {
							objectVersion = parser.getText();
						} else if (text == '_refObjectName') {
							refObjectName = parser.getText();
						} else if (text == 'CreationDate') {
							CreationDate = parser.getText();
						} else if (text == '_CreatedAt') {
							CreatedAt = parser.getText();
						} else if (text == 'ObjectID') {
							ObjectID = parser.getLongValue();
						} else if (text == 'Subscription') {
							Subscription = new Subscription(parser);
						} else if (text == 'Workspace') {
							Workspace = new Subscription(parser);
						} else if (text == 'Changesets') {
							Changesets = new Changesets(parser);
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'Discussion') {
							Discussion = new Changesets(parser);
						} else if (text == 'DisplayColor') {
							//DisplayColor = new Object(parser);
						} else if (text == 'FormattedID') {
							FormattedID = parser.getText();
						} else if (text == 'c_SFDCProjectID') {
							SFDCProjectID = parser.getText();
						} else if (text == 'LastUpdateDate') {
							LastUpdateDate = parser.getText();
						} else if (text == 'LatestDiscussionAgeInMinutes') {
							//LatestDiscussionAgeInMinutes = new Object(parser);
						} else if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'Notes') {
							Notes = parser.getText();
						} else if (text == 'Owner') {
							Owner = new Subscription(parser);
						} else if (text == 'Project') {
							Project = new Subscription(parser);
						} else if (text == 'Ready') {
							Ready = parser.getBooleanValue();
						} else if (text == 'RevisionHistory') {
							RevisionHistory = new RevisionHistory(parser);
						} else if (text == 'Tags') {
							Tags = new Tags(parser);
						} else if (text == 'Attachments') {
							Attachments = new Changesets(parser);
						} else if (text == 'Package') {
							//Packages = new Object(parser);
						} else if (text == 'AcceptedDate') {
							AcceptedDate = parser.getText();
						} else if (text == 'Blocked') {
							Blocked = parser.getBooleanValue();
						} else if (text == 'BlockedReason') {
							//BlockedReason = new Object(parser);
						} else if (text == 'Blocker') {
							//Blocker = new Object(parser);
						} else if (text == 'Children') {
							Children = new Changesets(parser);
						} else if (text == 'DefectStatus') {
							DefectStatus = parser.getText();
						} else if (text == 'Defects') {
							Defects = new Changesets(parser);
						} else if (text == 'DirectChildrenCount') {
							DirectChildrenCount = parser.getIntegerValue();
						} else if (text == 'HasParent') {
							HasParent = parser.getBooleanValue();
						} else if (text == 'InProgressDate') {
							InProgressDate = parser.getText();
						} else if (text == 'Iteration') {
							Iteration = new Subscription(parser);
						} else if (text == 'Parent') {
							//Parent = new Object(parser);
						} else if (text == 'PlanEstimate') {
							PlanEstimate = parser.getDoubleValue();
						} else if (text == 'Predecessors') {
							Predecessors = new Changesets(parser);
						} else if (text == 'Rank') {
							Rank = parser.getDoubleValue();
						} else if (text == 'Recycled') {
							Recycled = parser.getBooleanValue();
						} else if (text == 'Release') {
							Release = new Subscription(parser);
						} else if (text == 'ScheduleState') {
							ScheduleState = parser.getText();
						} else if (text == 'Successors') {
							Successors = new Changesets(parser);
						} else if (text == 'TaskActualTotal') {
							TaskActualTotal = parser.getDoubleValue();
						} else if (text == 'TaskEstimateTotal') {
							TaskEstimateTotal = parser.getDoubleValue();
						} else if (text == 'TaskRemainingTotal') {
							TaskRemainingTotal = parser.getDoubleValue();
						} else if (text == 'TaskStatus') {
							TaskStatus = parser.getText();
						} else if (text == 'Tasks') {
							Tasks = new Changesets(parser);
						} else if (text == 'TestCaseStatus') {
							TestCaseStatus = parser.getText();
						} else if (text == 'TestCases') {
							TestCases = new Changesets(parser);
						} else if (text == 'c_AcceptanceCriteria') {
							AcceptanceCriteria = parser.getText();
						} else if (text == 'c_Area') {
							Area = parser.getText();
						} else if (text == 'c_Capability') {
							Capability = parser.getText();
						} else if (text == 'c_CapabilityRank') {
							CapabilityRank = parser.getText();
						} else if (text == 'Feature') {
							//Feature = new Object(parser);
						} else if (text == 'c_FunctionalityEvaluation') {
							FunctionalityEvaluation = parser.getText();
						} else if (text == 'c_Integration') {
							Integration = parser.getText();
						} else if (text == 'c_NotUsed') {
							//NotUsed = new Object(parser);
						} else if (text == 'c_NotUsedCapability') {
							NotUsedCapability = parser.getText();
						} else if (text == 'c_NotUsedCapabilityRank') {
							NotUsedCapabilityRank = parser.getText();
						} else if (text == 'c_NotUsedOldID') {
							NotUsedOldID = parser.getText();
						} else if (text == 'c_NotUsedSource') {
							NotUsedSource = parser.getText();
						} else if (text == 'c_NotUsedSubCapability') {
							NotUsedSubCapability = parser.getText();
						} else if (text == 'c_OldID') {
							OldID = parser.getText();
						} else if (text == 'PortfolioItem') {
							//PortfolioItem = new Object(parser);
						} else if (text == 'c_Ranking') {
							Ranking = parser.getText();
						} else if (text == 'c_Requester') {
							Requester = parser.getText();
						} else if (text == 'c_Source') {
							Source = parser.getText();
						} else if (text == 'c_SubCapability') {
							SubCapability = parser.getText();
						} else if (text == 'c_UserGroup') {
							UserGroup = parser.getText();
						} else if (text == '_type') {
							type = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Results consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Errors {

		public Errors(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Errors consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static rallyUserStoryJSONClass parse(String json) {
		return new rallyUserStoryJSONClass(System.JSON.createParser(json));
	}
	
	/* -- Test methods must be in test classes
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{\"QueryResult\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"Errors\": [], \"Warnings\": [\"It is no longer necessary to append \\\".js\\\" to WSAPI resources.\"], \"TotalResultCount\": 1, \"StartIndex\": 1, \"PageSize\": 20, \"Results\": [{\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/14668978648\", \"_refObjectUUID\": \"ce3117f9-969b-4f17-9889-82ef927cb1cb\", \"_objectVersion\": \"23\", \"_refObjectName\": \"Salesforce | Account add Parent/Banner stores\", \"CreationDate\": \"2013-10-15T21:26:54.469Z\", \"_CreatedAt\": \"Oct 15, 2013\", \"ObjectID\": 14668978648, \"Subscription\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/subscription/2020685828\", \"_refObjectUUID\": \"73c89cb5-c15a-4f9f-a2c3-e973a7d4b67f\", \"_refObjectName\": \"Lexmark International - KY\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/workspace/11015213780\", \"_refObjectUUID\": \"540e3827-19ab-4eed-baba-e7533c1def6e\", \"_refObjectName\": \"Lexmark Business Systems\", \"_type\": \"Workspace\"}, \"Changesets\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Changesets\", \"_type\": \"Changeset\", \"Count\": 0}, \"Description\": \"<span style=\\\"font-size: 13px; font-family: arial, sans, sans-serif;\\\">Need to show Parent and Banner accounts and how they are linked. Adding a field to indicate on the <br>banner account who their parent account is and then a related list on the parent to show all banner accounts for that Parent account. (Test)<br><br><br><br>Object: Account<br><br>Add Field: Parent Store<br>Type: Lookup(account)<br>Display in the account detail section, bottom of left column. All page layouts<br><br>Add Related list: Accounts (Banner Store)<br>Pull in the following Data:<br>Account Name<br>Account Status<br>Lexmark Vertical<br>Party Group<br>Account Owner<br><br></span>\", \"Discussion\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Discussion\", \"_type\": \"ConversationPost\", \"Count\": 0}, \"DisplayColor\": null, \"FormattedID\": \"US2991\", \"LastUpdateDate\": \"2014-03-06T19:11:06.985Z\", \"LatestDiscussionAgeInMinutes\": null, \"Name\": \"Salesforce | Account add Parent/Banner stores\", \"Notes\": \"\", \"Owner\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/user/6468411234\", \"_refObjectUUID\": \"74d64385-9e1e-41e7-b3fc-5e7e3c78605c\", \"_refObjectName\": \"Josh Miesner\", \"_type\": \"User\"}, \"Project\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/project/14018163238\", \"_refObjectUUID\": \"a2667914-40db-40c3-b9bd-719246430b6c\", \"_refObjectName\": \"Chartreuse\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/revisionhistory/14668978649\", \"_refObjectUUID\": \"7796eafa-3b12-4198-8ac8-0b450323d35a\", \"_type\": \"RevisionHistory\"}, \"Tags\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Tags\", \"_type\": \"Tag\", \"_tagsNameArray\": [], \"Count\": 0}, \"Attachments\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Attachments\", \"_type\": \"Attachment\", \"Count\": 0}, \"Package\": null, \"AcceptedDate\": \"2013-10-23T14:09:37.238Z\", \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Children\", \"_type\": \"HierarchicalRequirement\", \"Count\": 0}, \"DefectStatus\": \"NONE\", \"Defects\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Defects\", \"_type\": \"Defect\", \"Count\": 0}, \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": \"2013-10-22T23:28:28.187Z\", \"Iteration\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/iteration/14578055140\", \"_refObjectUUID\": \"4bc1b466-10cd-4625-81a8-b0a83447e503\", \"_refObjectName\": \"CI Sprint 3\", \"_type\": \"Iteration\"}, \"Parent\": null, \"PlanEstimate\": 2.0, \"Predecessors\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Predecessors\", \"_type\": \"HierarchicalRequirement\", \"Count\": 0}, \"Rank\": 1.000, \"Recycled\": false, \"Release\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/release/14018163252\", \"_refObjectUUID\": \"1b057dd5-73b3-4cf4-9b4c-6f12f8b47ebc\", \"_refObjectName\": \"Release 1B Pilot\", \"_type\": \"Release\"}, \"ScheduleState\": \"Accepted\", \"Successors\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Successors\", \"_type\": \"HierarchicalRequirement\", \"Count\": 0}, \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"COMPLETED\", \"Tasks\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Tasks\", \"_type\": \"Task\", \"Count\": 4}, \"TestCaseStatus\": \"NONE\", \"TestCases\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/TestCases\", \"_type\": \"TestCase\", \"Count\": 0}, \"c_AcceptanceCriteria\": \"\", \"c_Area\": \"\", \"c_Capability\": \"\", \"c_CapabilityRank\": \"\", \"Feature\": null, \"c_FunctionalityEvaluation\": \"\", \"c_Integration\": \"\", \"c_NotUsed\": null, \"c_NotUsedCapability\": \"\", \"c_NotUsedCapabilityRank\": \"\", \"c_NotUsedOldID\": \"\", \"c_NotUsedSource\": \"\", \"c_NotUsedSubCapability\": \"\", \"c_OldID\": \"\", \"PortfolioItem\": null, \"c_Ranking\": \"\", \"c_Requester\": \"\", \"c_Source\": \"\", \"c_SubCapability\": \"\", \"c_UserGroup\": \"\", \"_type\": \"HierarchicalRequirement\"}]}}';
		rallyUserStoryJSONClass r = parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QueryResult objQueryResult = new QueryResult(System.JSON.createParser(json));
		System.assert(objQueryResult != null);
		System.assert(objQueryResult.rallyAPIMajor == null);
		System.assert(objQueryResult.rallyAPIMinor == null);
		System.assert(objQueryResult.Errors == null);
		System.assert(objQueryResult.Warnings == null);
		System.assert(objQueryResult.TotalResultCount == null);
		System.assert(objQueryResult.StartIndex == null);
		System.assert(objQueryResult.PageSize == null);
		System.assert(objQueryResult.Results == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Tags objTags = new Tags(System.JSON.createParser(json));
		System.assert(objTags != null);
		System.assert(objTags.rallyAPIMajor == null);
		System.assert(objTags.rallyAPIMinor == null);
		System.assert(objTags.ref == null);
		System.assert(objTags.type == null);
		System.assert(objTags.tagsNameArray == null);
		System.assert(objTags.Count == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Changesets objChangesets = new Changesets(System.JSON.createParser(json));
		System.assert(objChangesets != null);
		System.assert(objChangesets.rallyAPIMajor == null);
		System.assert(objChangesets.rallyAPIMinor == null);
		System.assert(objChangesets.ref == null);
		System.assert(objChangesets.type == null);
		System.assert(objChangesets.Count == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Subscription objSubscription = new Subscription(System.JSON.createParser(json));
		System.assert(objSubscription != null);
		System.assert(objSubscription.rallyAPIMajor == null);
		System.assert(objSubscription.rallyAPIMinor == null);
		System.assert(objSubscription.ref == null);
		System.assert(objSubscription.refObjectUUID == null);
		System.assert(objSubscription.refObjectName == null);
		System.assert(objSubscription.type == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		rallyUserStoryJSONClass objRoot = new rallyUserStoryJSONClass(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.QueryResult == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		RevisionHistory objRevisionHistory = new RevisionHistory(System.JSON.createParser(json));
		System.assert(objRevisionHistory != null);
		System.assert(objRevisionHistory.rallyAPIMajor == null);
		System.assert(objRevisionHistory.rallyAPIMinor == null);
		System.assert(objRevisionHistory.ref == null);
		System.assert(objRevisionHistory.refObjectUUID == null);
		System.assert(objRevisionHistory.type == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Results objResults = new Results(System.JSON.createParser(json));
		System.assert(objResults != null);
		System.assert(objResults.rallyAPIMajor == null);
		System.assert(objResults.rallyAPIMinor == null);
		System.assert(objResults.ref == null);
		System.assert(objResults.refObjectUUID == null);
		System.assert(objResults.objectVersion == null);
		System.assert(objResults.refObjectName == null);
		System.assert(objResults.CreationDate == null);
		System.assert(objResults.CreatedAt == null);
		System.assert(objResults.ObjectID == null);
		System.assert(objResults.Subscription == null);
		System.assert(objResults.Workspace == null);
		System.assert(objResults.Changesets == null);
		System.assert(objResults.Description == null);
		System.assert(objResults.Discussion == null);
		System.assert(objResults.DisplayColor == null);
		System.assert(objResults.FormattedID == null);
		System.assert(objResults.LastUpdateDate == null);
		System.assert(objResults.LatestDiscussionAgeInMinutes == null);
		System.assert(objResults.Name == null);
		System.assert(objResults.Notes == null);
		System.assert(objResults.Owner == null);
		System.assert(objResults.Project == null);
		System.assert(objResults.Ready == null);
		System.assert(objResults.RevisionHistory == null);
		System.assert(objResults.Tags == null);
		System.assert(objResults.Attachments == null);
		System.assert(objResults.Packages == null);
		System.assert(objResults.AcceptedDate == null);
		System.assert(objResults.Blocked == null);
		System.assert(objResults.BlockedReason == null);
		System.assert(objResults.Blocker == null);
		System.assert(objResults.Children == null);
		System.assert(objResults.DefectStatus == null);
		System.assert(objResults.Defects == null);
		System.assert(objResults.DirectChildrenCount == null);
		System.assert(objResults.HasParent == null);
		System.assert(objResults.InProgressDate == null);
		System.assert(objResults.Iteration == null);
		System.assert(objResults.Parent == null);
		System.assert(objResults.PlanEstimate == null);
		System.assert(objResults.Predecessors == null);
		System.assert(objResults.Rank == null);
		System.assert(objResults.Recycled == null);
		System.assert(objResults.Release == null);
		System.assert(objResults.ScheduleState == null);
		System.assert(objResults.Successors == null);
		System.assert(objResults.TaskActualTotal == null);
		System.assert(objResults.TaskEstimateTotal == null);
		System.assert(objResults.TaskRemainingTotal == null);
		System.assert(objResults.TaskStatus == null);
		System.assert(objResults.Tasks == null);
		System.assert(objResults.TestCaseStatus == null);
		System.assert(objResults.TestCases == null);
		System.assert(objResults.AcceptanceCriteria == null);
		System.assert(objResults.Area == null);
		System.assert(objResults.Capability == null);
		System.assert(objResults.CapabilityRank == null);
		System.assert(objResults.Feature == null);
		System.assert(objResults.FunctionalityEvaluation == null);
		System.assert(objResults.Integration == null);
		System.assert(objResults.NotUsed == null);
		System.assert(objResults.NotUsedCapability == null);
		System.assert(objResults.NotUsedCapabilityRank == null);
		System.assert(objResults.NotUsedOldID == null);
		System.assert(objResults.NotUsedSource == null);
		System.assert(objResults.NotUsedSubCapability == null);
		System.assert(objResults.OldID == null);
		System.assert(objResults.PortfolioItem == null);
		System.assert(objResults.Ranking == null);
		System.assert(objResults.Requester == null);
		System.assert(objResults.Source == null);
		System.assert(objResults.SubCapability == null);
		System.assert(objResults.UserGroup == null);
		System.assert(objResults.type == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Errors objErrors = new Errors(System.JSON.createParser(json));
		System.assert(objErrors != null);
	}
	*/
}