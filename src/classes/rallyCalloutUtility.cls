public class rallyCalloutUtility {
	
	static Http httpStub;  
    static HttpRequest req; 
    static HttpResponse res;
    
    // Variable being passed for User Story List
   	public static rallyUserStoryJSONClass userStory;
   	// Variable used for PUT/POST/DELETE operations to authorize session
    public static rallyAuthorizeJSONClass authorizeSecurityToken;  
    
    public static string JSONMsg; 
    static string sessionCookie;
    static string securityToken;
    
    //list of endpoints ..  later to be setup as custom settings
    final static string userCredentials = Rally_Integration_Callout_Settings__c.getvalues('RallyV2')!=null?Rally_Integration_Callout_Settings__c.getvalues('RallyV2').User_Credentials__c:'nick.johnson@perceptivesoftware.com:Nissan300'; 
    final static string fetchEndpoint = Rally_Integration_Callout_Settings__c.getvalues('RallyV2')!=null?Rally_Integration_Callout_Settings__c.getvalues('RallyV2').Fetch_Endpoint__c:'https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement.js?workspace=https://sandbox.rallydev.com/slm/webservice/v2.0/workspace/10921341682&fetch=true&start=1&pagesize=20';
    final static string upsertEndpoint = Rally_Integration_Callout_Settings__c.getvalues('RallyV2')!=null?Rally_Integration_Callout_Settings__c.getvalues('RallyV2').Upsert_Endpoint__c:'https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/';
    final static string authorizeEndpoint = Rally_Integration_Callout_Settings__c.getvalues('RallyV2')!=null?Rally_Integration_Callout_Settings__c.getvalues('RallyV2').Authorize_Endpoint__c:'https://sandbox.rallydev.com/slm/webservice/v2.0/security/authorize';
    
    //Fetches User Story through a Callout from Rally and parses to a User Story Object
    public void getEntireUS (string queryParam, string queryValue, string queryOperator) {
    	
    	string endpoint = fetchEndpoint;
    	httpStub = new Http();
    	req = new HttpRequest();
    	res = new HttpResponse();
    	req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    	req.setMethod('GET');
    	
    	//to be setup later with custom settings
    	//for now just query updated in the last hour
    	/*
    	Rally_Integration_Callout_Settings__c LastUpdateSettings = Rally_Integration_Callout_Settings__c.getvalues('RallyV2');
        String LastUpdateDate = LastUpdateSettings!=null?LastUpdateSettings.LastUpdate__c:'';
        
        if(LastUpdateDate!= null) { 
            LastUpdateDate = LastUpdateDate.replace(' ', 'T');
            endpoint+='&query=(LastUpdateDate%20>%20"'+LastUpdateDate+'")';
        }
        */
        
        //string LastUpdateDate = string.valueof(system.now() - (1/24.0));
        //LastUpdateDate = LastUpdateDate.replace(' ', 'T');
        //endpoint += '&query=(LastUpdateDate%20>%20"' + LastUpdateDate + '")';
        //endpoint += '&query=(c_SFDCProjectID%20=%20"PRJ001197")';
        //endpoint += '&query=(' + queryParam + '%20=%20"' + queryValue + '")';
        endpoint += '&query=(' + queryParam + '%20' + queryOperator + '%20"' + queryValue + '")';
        //projectId = 'US3770';
        //endpoint += '&query=(FormattedID%20=%20"' + projectId + '")';

        JSONMsg = connect_WebService(endpoint);
        
        if(!Test.isRunningTest()) {
        	
        	userStory = rallyUserStoryJSONClass.parse(JSONMsg);
        }
        else {
        	JSONMsg = '{\"QueryResult\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"Errors\": [], \"Warnings\": [\"It is no longer necessary to append \\\".js\\\" to WSAPI resources.\"], \"TotalResultCount\": 1, \"StartIndex\": 1, \"PageSize\": 20, \"Results\": [{\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/14668978648\", \"_refObjectUUID\": \"ce3117f9-969b-4f17-9889-82ef927cb1cb\", \"_objectVersion\": \"23\", \"_refObjectName\": \"Salesforce | Account add Parent/Banner stores\", \"CreationDate\": \"2013-10-15T21:26:54.469Z\", \"_CreatedAt\": \"Oct 15, 2013\", \"ObjectID\": 14668978648, \"Subscription\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/subscription/2020685828\", \"_refObjectUUID\": \"73c89cb5-c15a-4f9f-a2c3-e973a7d4b67f\", \"_refObjectName\": \"Lexmark International - KY\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/workspace/11015213780\", \"_refObjectUUID\": \"540e3827-19ab-4eed-baba-e7533c1def6e\", \"_refObjectName\": \"Lexmark Business Systems\", \"_type\": \"Workspace\"}, \"Changesets\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Changesets\", \"_type\": \"Changeset\", \"Count\": 0}, \"Description\": \"<span style=\\\"font-size: 13px; font-family: arial, sans, sans-serif;\\\">Need to show Parent and Banner accounts and how they are linked. Adding a field to indicate on the <br>banner account who their parent account is and then a related list on the parent to show all banner accounts for that Parent account. (Test)<br><br><br><br>Object: Account<br><br>Add Field: Parent Store<br>Type: Lookup(account)<br>Display in the account detail section, bottom of left column. All page layouts<br><br>Add Related list: Accounts (Banner Store)<br>Pull in the following Data:<br>Account Name<br>Account Status<br>Lexmark Vertical<br>Party Group<br>Account Owner<br><br></span>\", \"Discussion\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Discussion\", \"_type\": \"ConversationPost\", \"Count\": 0}, \"DisplayColor\": null, \"FormattedID\": \"US2991\", \"LastUpdateDate\": \"2014-03-06T19:11:06.985Z\", \"LatestDiscussionAgeInMinutes\": null, \"Name\": \"Salesforce | Account add Parent/Banner stores\", \"Notes\": \"\", \"Owner\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/user/6468411234\", \"_refObjectUUID\": \"74d64385-9e1e-41e7-b3fc-5e7e3c78605c\", \"_refObjectName\": \"Josh Miesner\", \"_type\": \"User\"}, \"Project\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/project/14018163238\", \"_refObjectUUID\": \"a2667914-40db-40c3-b9bd-719246430b6c\", \"_refObjectName\": \"Chartreuse\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/revisionhistory/14668978649\", \"_refObjectUUID\": \"7796eafa-3b12-4198-8ac8-0b450323d35a\", \"_type\": \"RevisionHistory\"}, \"Tags\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Tags\", \"_type\": \"Tag\", \"_tagsNameArray\": [], \"Count\": 0}, \"Attachments\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Attachments\", \"_type\": \"Attachment\", \"Count\": 0}, \"Package\": null, \"AcceptedDate\": \"2013-10-23T14:09:37.238Z\", \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Children\", \"_type\": \"HierarchicalRequirement\", \"Count\": 0}, \"DefectStatus\": \"NONE\", \"Defects\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Defects\", \"_type\": \"Defect\", \"Count\": 0}, \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": \"2013-10-22T23:28:28.187Z\", \"Iteration\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/iteration/14578055140\", \"_refObjectUUID\": \"4bc1b466-10cd-4625-81a8-b0a83447e503\", \"_refObjectName\": \"CI Sprint 3\", \"_type\": \"Iteration\"}, \"Parent\": null, \"PlanEstimate\": 2.0, \"Predecessors\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Predecessors\", \"_type\": \"HierarchicalRequirement\", \"Count\": 0}, \"Rank\": 1.000, \"Recycled\": false, \"Release\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/release/14018163252\", \"_refObjectUUID\": \"1b057dd5-73b3-4cf4-9b4c-6f12f8b47ebc\", \"_refObjectName\": \"Release 1B Pilot\", \"_type\": \"Release\"}, \"ScheduleState\": \"Accepted\", \"Successors\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Successors\", \"_type\": \"HierarchicalRequirement\", \"Count\": 0}, \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"COMPLETED\", \"Tasks\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/Tasks\", \"_type\": \"Task\", \"Count\": 4}, \"TestCaseStatus\": \"NONE\", \"TestCases\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"_ref\": \"https://sandbox.rallydev.com/slm/webservice/v2.0/HierarchicalRequirement/14668978648/TestCases\", \"_type\": \"TestCase\", \"Count\": 0}, \"c_AcceptanceCriteria\": \"\", \"c_Area\": \"\", \"c_Capability\": \"\", \"c_CapabilityRank\": \"\", \"Feature\": null, \"c_FunctionalityEvaluation\": \"\", \"c_Integration\": \"\", \"c_NotUsed\": null, \"c_NotUsedCapability\": \"\", \"c_NotUsedCapabilityRank\": \"\", \"c_NotUsedOldID\": \"\", \"c_NotUsedSource\": \"\", \"c_NotUsedSubCapability\": \"\", \"c_OldID\": \"\", \"PortfolioItem\": null, \"c_Ranking\": \"\", \"c_Requester\": \"\", \"c_Source\": \"\", \"c_SubCapability\": \"\", \"c_UserGroup\": \"\", \"_type\": \"HierarchicalRequirement\"}]}}';
        	userStory = rallyUserStoryJSONClass.parse(JSONMsg);
        }
        /*
        if(LastUpdateSettings != null) {
        	
        	LastUpdateSettings.LastUpdate__c = string.valueOf(datetime.now());
        	update LastUpdateSettings;
        }
        */
    }
    
    //Creates/Updates User Story in Rally
    public static List<string> upsertUS (string JsonData, string ObjID, string tCookie, string tToken) {
    	
    	//get security token and session Id to store
    	//authorizeRallyCallout();
    	
    	//
        httpStub = new HTTP();
        req = new HTTPRequest();
        res = new HTTPResponse();
        
        //store sessionId for sccuessive callouts
        //req.setHeader('Cookie', sessionCookie);
        req.setHeader('Cookie', tCookie);
    		
        req.setHeader('Content-Type','json');
        req.setMethod('POST');
        
        system.debug('Bazinga... request method.. ' + req.getMethod());
      	// Json Parsing   
      	// Expected format   :   string val ='{"HierarchicalRequirement": {"Name":"Sample Trial 2","Description":"Sample Trial 2"}}';
        req.setBody(JsonData);
        if(ObjID!=null){
            if(!Test.isRunningTest())
                //JSONMsg=connect_WebService(upsertEndpoint + ObjID + '.js?key=' + securityToken);
                JSONMsg=connect_WebService(upsertEndpoint + ObjID + '.js?key=' + tToken);
            else
                JSONMsg='{"HierarchicalRequirement": {"Name":"Sample Trial 2","Description":"Sample Trial 2"}}';
        }
        else{
            if(!Test.isRunningTest())
                //JSONMsg=connect_WebService(upsertEndpoint + 'create.js?key=' + securityToken);
                JSONMsg=connect_WebService(upsertEndpoint + 'create.js?key=' + tToken);
            else
                JSONMsg='{"HierarchicalRequirement":{"Name":"Sample Trial 2","ObjectID":"1234","Description":"Sample Trial 2"}}';
        }
        system.debug('pppp'+JSONMsg);
        string sample = JSONMsg.substringAfter('"ObjectID": ');
        string sample2 = JSONMsg.substringAfter('"FormattedID": ');
        sample2 = sample2.substringBefore(',');
        sample = sample.substringBefore(',');
        sample2 = sample2.substringBetween('"');
        List<string> result = new list<string>();
        result.add(sample);
        result.add(sample2);
        //userstry = UserStory.parse(JSONMsg);
        return result;
        
    }
    
    
    public static string connect_WebService(string endpoint) { //, boolean reqAuthorize
    	
    	req.setEndpoint(endpoint);
    	req.setHeader('Authorization', ' Basic ' + EncodingUtil.base64Encode(Blob.ValueOf(userCredentials)));
    	//req.setHeader('oauth signature method', 'PLAINTEXT');
        
    	if(!Test.isRunningTest()) {
    		
    		res = httpStub.send(req);
    		
    		if(res.getStatus() == 'OK') {
    			
    			return res.getBody();
    		}
    		else {
    			
    			mailAdmin();
    			return null;
    		}
    		
    		return null;
    	}
    	return null;
    }
    
    //Grabs Security Token and Session Cookie for authorizing successive POST/PUT/DELETE Rally Callouts
    public static Map<String,String> authorizeRallyCallout() {
    	
    	httpStub = new Http();
    	req = new HttpRequest();
    	res = new HttpResponse();
    	
    	req.setEndpoint(authorizeEndpoint);
    	req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    	req.setMethod('GET');
    	req.setHeader('Authorization', ' Basic ' + EncodingUtil.base64Encode(Blob.ValueOf(userCredentials)));
    	//req.setHeader('oauth signature method', 'PLAINTEXT');
    	
    	res = httpStub.send(req);
    	
    	sessionCookie = res.getHeader('Set-Cookie');
    	
    	authorizeSecurityToken = rallyAuthorizeJSONClass.parse(res.getBody());
    	
    	securityToken = authorizeSecurityToken.OperationResult.SecurityToken;
    	
    	Map<String, String> authMap = new Map<String, String>();
    	authMap.put('cookie', sessionCookie);
    	authMap.put('token', securityToken);
    	
    	return authMap;
    }

    
    
    //send email method used for log and error reporting
    public static void mailAdmin() {
    	/*
    	Messaging.reserveSingleEmailCapacity(10);
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	list<String> toAddresses = new list<String>();
    	*/
    }
    
    

}