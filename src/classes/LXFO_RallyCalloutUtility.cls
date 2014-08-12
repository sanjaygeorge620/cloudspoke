/* Class Name   : LXFO_RallyCalloutUtility 
* Description   : This class makes webservice callouts
* Created By   : Sanjay George
* Created Date : 03-23-2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay George          03-26-2013                1000                 Initial Version

*/

public class LXFO_RallyCalloutUtility { 

	static HTTP httpStub;  
    static HTTPRequest req; 
    static HTTPResponse res;
    // Variable being passed for User Story List
    public static LXFO_RallyUserStoryJSONStubClass userstry;
    //variable for User List from Rally
    public static LXFO_RallyUsersJSONStubClass UserList; 
    static string JSONMsg;
    final static string  FetchEndpoint = Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').Fetch_Endpoint__c:'https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement.js?workspace=https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682&fetch=true&start=1&pagesize=20';
    final static string UpsertEndpoint = Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').Upsert_Endpoint__c:'https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/';
    final static string UserCreds = Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').User_Credentials__c:'sanjaygeorge620@gmail.com:deloitte.1';
    final static string UserEndpoint = Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').Users_EndPoint__c:'https://rally1.rallydev.com/slm/webservice/1.41/user.js?query=&fetch=true&start=1&pagesize=20';
    final static string Workspace = Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').Workspace__c:'https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682';
    
    /*
    Method - getEntireUS
    Fetches User Story through a Callout from Rally and parses to a User Story Object
    */
    public void getEntireUS (){
        string endpoint = FetchEndpoint;
        httpStub = new HTTP();
        req = new HTTPRequest();
        res = new HTTPResponse();
         req.setHeader('Content-Type','application/x-www-form-urlencoded');
         req.setMethod('GET');
          
        Rally_Integration_Callout_Settings__c LastUpdateSettings = Rally_Integration_Callout_Settings__c.getvalues('Rally');
        String LastUpdateDate = LastUpdateSettings!=null?LastUpdateSettings.LastUpdate__c:'';
        if(LastUpdateDate!=null){ 
            LastUpdateDate = LastUpdateDate.replace(' ', 'T');
            endpoint+='&query=(LastUpdateDate%20>%20"'+LastUpdateDate+'")';
        }
        system.debug('Endpoint:'+endpoint);
        if(!Test.isRunningTest())
            JSONMsg=connect_WebService(endpoint);
        else
            JSONMsg='{\"QueryResult\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"Errors\": [], \"Warnings\": [], \"TotalResultCount\": 9, \"StartIndex\": 1, \"PageSize\": 20, \"Results\": [{\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416336.js\", \"_objectVersion\": \"4\", \"_refObjectName\": \"Browse safaris\", \"CreationDate\": \"2013-03-12T12:45:03.569Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416336, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As a web site visitor, I want to browse through the inventory of available safaris so that I can pick one that fits my time, budget and interest.\", \"Discussion\": [], \"FormattedID\": \"US1\", \"LastUpdateDate\": \"2013-03-18T12:34:28.816Z\", \"Name\": \"Browse safaris\", \"Owner\": null, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416337.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [{\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/11005650640.js\", \"_refObjectName\": \"Task 1\", \"_type\": \"HierarchicalRequirement\"}], \"DefectStatus\": null, \"Defects\": [], \"DirectChildrenCount\": 1, \"HasParent\": false, \"InProgressDate\": null, \"Iteration\": null, \"Parent\": null, \"PlanEstimate\": 2.0, \"Rank\": 499999997952.000, \"Recycled\": false, \"ScheduleState\": \"Defined\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": null, \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416342.js\", \"_objectVersion\": \"9\", \"_refObjectName\": \"Show availability of safaris\", \"CreationDate\": \"2013-03-12T12:45:03.588Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416342, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As a web site visitor, I want to view upcoming safari availability so that I can choose an available date.\", \"Discussion\": [], \"FormattedID\": \"US4\", \"LastUpdateDate\": \"2013-03-12T12:55:11.015Z\", \"Name\": \"Show availability of safaris\", \"Owner\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/user/10921341676.js\", \"_refObjectName\": \"sanjaygeorge620\", \"_type\": \"User\"}, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416343.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": \"2013-03-12T12:55:11.005Z\", \"Iteration\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/iteration/10921416327.js\", \"_refObjectName\": \"Iteration 1 - Browse and Book\", \"_type\": \"Iteration\"}, \"Parent\": null, \"PlanEstimate\": 4.0, \"Rank\": 499999997248.000, \"Recycled\": false, \"ScheduleState\": \"In-Progress\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416348.js\", \"_objectVersion\": \"3\", \"_refObjectName\": \"Register for Frequent Adventurer card\", \"CreationDate\": \"2013-03-12T12:45:03.588Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416348, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As a safari-taker, I want to sign-up for a Frequent Adventurer Card so I can earn rewards.\", \"Discussion\": [], \"FormattedID\": \"US3\", \"LastUpdateDate\": \"2013-03-12T12:54:22.573Z\", \"Name\": \"Register for Frequent Adventurer card\", \"Owner\": null, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416349.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": \"2013-03-12T12:54:22.538Z\", \"Iteration\": null, \"Parent\": null, \"PlanEstimate\": 4.0, \"Rank\": 499999998464.000, \"Recycled\": false, \"ScheduleState\": \"In-Progress\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416354.js\", \"_objectVersion\": \"3\", \"_refObjectName\": \"Complete the \\\"You may get eaten\\\" waiver\", \"CreationDate\": \"2013-03-12T12:45:03.588Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416354, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As the owner of Simba\'s Safaris, I want the customers to complete a waiver so that our company has no liability if a lion eats them.\", \"Discussion\": [], \"FormattedID\": \"US2\", \"LastUpdateDate\": \"2013-03-12T12:48:06.440Z\", \"Name\": \"Complete the \\\"You may get eaten\\\" waiver\", \"Owner\": null, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416355.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": null, \"Iteration\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/iteration/10921416330.js\", \"_refObjectName\": \"Iteration 2 - Streamline Operations\", \"_type\": \"Iteration\"}, \"Parent\": null, \"PlanEstimate\": 2.0, \"Rank\": 499999997824.000, \"Recycled\": false, \"ScheduleState\": \"Defined\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416360.js\", \"_objectVersion\": \"5\", \"_refObjectName\": \"View jungle miles account\", \"CreationDate\": \"2013-03-12T12:45:03.589Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416360, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As a frequent adventurer, I want to view the number of jungle miles in my account so I can see if I\'m eligible for a reward.\", \"Discussion\": [], \"FormattedID\": \"US5\", \"LastUpdateDate\": \"2013-03-12T12:55:21.351Z\", \"Name\": \"View jungle miles account\", \"Owner\": null, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416361.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": \"2013-03-12T12:55:21.339Z\", \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": \"2013-03-12T12:55:21.339Z\", \"Iteration\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/iteration/10921416327.js\", \"_refObjectName\": \"Iteration 1 - Browse and Book\", \"_type\": \"Iteration\"}, \"Parent\": null, \"PlanEstimate\": 4.0, \"Rank\": 499999997568.000, \"Recycled\": false, \"ScheduleState\": \"Accepted\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416366.js\", \"_objectVersion\": \"7\", \"_refObjectName\": \"Choose dietary plan\", \"CreationDate\": \"2013-03-12T12:45:03.589Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416366, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As a web site visitor, I want to view the available dietary selections (e.g., vegetarian, gluten-free, standard) and make a selection so that I know that any special food needs will be met.\", \"Discussion\": [], \"FormattedID\": \"US6\", \"LastUpdateDate\": \"2013-03-12T12:48:28.018Z\", \"Name\": \"Choose dietary plan\", \"Owner\": null, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416367.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": null, \"Iteration\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/iteration/10921416327.js\", \"_refObjectName\": \"Iteration 1 - Browse and Book\", \"_type\": \"Iteration\"}, \"Parent\": null, \"PlanEstimate\": 2.0, \"Rank\": 499999996928.000, \"Recycled\": false, \"ScheduleState\": \"Defined\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416372.js\", \"_objectVersion\": \"5\", \"_refObjectName\": \"Manage special offers\", \"CreationDate\": \"2013-03-12T12:45:03.590Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416372, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As a safari scheduler, I want to publish special offers so that I can balance demand and availability.\", \"Discussion\": [], \"FormattedID\": \"US7\", \"LastUpdateDate\": \"2013-03-12T12:48:30.800Z\", \"Name\": \"Manage special offers\", \"Owner\": null, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416373.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": null, \"Iteration\": null, \"Parent\": null, \"PlanEstimate\": 8.0, \"Rank\": 499999999104.000, \"Recycled\": false, \"ScheduleState\": \"Defined\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416378.js\", \"_objectVersion\": \"1\", \"_refObjectName\": \"Order picture package\", \"CreationDate\": \"2013-03-12T12:45:03.590Z\", \"_CreatedAt\": \"Mar 12\", \"ObjectID\": 10921416378, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"As a safari-taker, I want to view any pictures taken and be able to order reprints so that I can remember my trip.\", \"Discussion\": [], \"FormattedID\": \"US8\", \"LastUpdateDate\": \"2013-03-12T12:45:03.672Z\", \"Name\": \"Order picture package\", \"Owner\": null, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921416379.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": false, \"InProgressDate\": null, \"Iteration\": null, \"Parent\": null, \"PlanEstimate\": 8.0, \"Rank\": 499999999744.000, \"Recycled\": false, \"ScheduleState\": \"Defined\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}, {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/11005650640.js\", \"_objectVersion\": \"1\", \"_refObjectName\": \"Task 1\", \"CreationDate\": \"2013-03-18T12:34:28.714Z\", \"_CreatedAt\": \"yesterday at 6:34 am\", \"ObjectID\": 11005650640, \"Subscription\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js\", \"_refObjectName\": \"Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com\", \"_type\": \"Subscription\"}, \"Workspace\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/workspace/10921341682.js\", \"_refObjectName\": \"Workspace 1\", \"_type\": \"Workspace\"}, \"Changesets\": [], \"Description\": \"\", \"Discussion\": [], \"FormattedID\": \"US9\", \"LastUpdateDate\": \"2013-03-18T12:34:28.815Z\", \"Name\": \"Task 1\", \"Owner\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/user/10921341676.js\", \"_refObjectName\": \"sanjaygeorge620\", \"_type\": \"User\"}, \"Project\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/project/10921341772.js\", \"_refObjectName\": \"Sample Project\", \"_type\": \"Project\"}, \"Ready\": false, \"RevisionHistory\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/11005650641.js\", \"_type\": \"RevisionHistory\"}, \"Tags\": [], \"Attachments\": [], \"Package\": null, \"AcceptedDate\": null, \"Blocked\": false, \"BlockedReason\": null, \"Blocker\": null, \"Children\": [], \"DefectStatus\": \"NONE\", \"Defects\": [], \"DirectChildrenCount\": 0, \"HasParent\": true, \"InProgressDate\": null, \"Iteration\": null, \"Parent\": {\"_rallyAPIMajor\": \"1\", \"_rallyAPIMinor\": \"41\", \"_ref\": \"https://rally1.rallydev.com/slm/webservice/1.41/hierarchicalrequirement/10921416336.js\", \"_refObjectName\": \"Browse safaris\", \"_type\": \"HierarchicalRequirement\"}, \"PlanEstimate\": 2.0, \"Rank\": 499999998208.000, \"Recycled\": false, \"ScheduleState\": \"Defined\", \"TaskActualTotal\": 0.0, \"TaskEstimateTotal\": 0.0, \"TaskRemainingTotal\": 0.0, \"TaskStatus\": \"NONE\", \"Tasks\": [], \"_type\": \"HierarchicalRequirement\"}]}}';
        userstry = LXFO_RallyUserStoryJSONStubClass.parse(JSONMsg);
        if(LastUpdateSettings!=null){
            LastUpdateSettings.LastUpdate__c=string.valueof(datetime.now());
            update LastUpdateSettings;
        }
        
    }
    /*
    Method - upsertUS
    Param - insertStatus -> Boolean condition to know if insertion(false) or Updation(true)
    		ObjectID --> Object ID of the User Story in Rally if it's a Updation
   	Creates/Updates User Story in Rally
    */
    public static List<string> upsertUS (string JsonData, string ObjID )
    {
        httpStub = new HTTP();
        req = new HTTPRequest();
        res = new HTTPResponse();
        req.setHeader('Content-Type','json');
        req.setMethod('POST');
      	// Json Parsing   
      	// Expected format   :   string val ='{"HierarchicalRequirement": {"Name":"Sample Trial 2","Description":"Sample Trial 2"}}';
        req.setBody(JsonData);
        if(ObjID!=null){
            if(!Test.isRunningTest())
                JSONMsg=connect_WebService(UpsertEndpoint+ObjID+'.js');
            else
                JSONMsg='{"HierarchicalRequirement": {"Name":"Sample Trial 2","Description":"Sample Trial 2"}}';
        }
        else{
            if(!Test.isRunningTest())
                JSONMsg=connect_WebService(UpsertEndpoint+'create.js');
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
    
    
    @future(callout=true)
    public static void deleteUS (string ObjectID){
        httpStub = new HTTP();
        req = new HTTPRequest();
        res = new HTTPResponse();
        req.setHeader('Content-Type','json');
        req.setMethod('DELETE');
        if(!Test.isRunningTest())
            JSONMsg=connect_WebService(UpsertEndpoint+ObjectID+'.js');
        
        
    }
    
    
    public static string connect_WebService(string endpoint){	
        req.setEndpoint(endpoint);
        req.setHeader('Authorization',' Basic ' + EncodingUtil.base64Encode(Blob.ValueOf(UserCreds)));
        req.setHeader('oauth signature method','PLAINTEXT');
        if(!Test.isRunningTest()){
            res = httpStub.send(req);
            if(res.getStatus()=='OK')
            	return res.getbody();
            else{
            	mailAdmin();
            	return null;
            }
        }   return null;
    }
    


    public static void mailAdmin(){
    	
    	Messaging.reserveSingleEmailCapacity(10);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        list<String> toAddresses = new list<string>();
        toAddresses.add(Rally_Integration_Callout_Settings__c.getvalues('Rally')!=null?(Rally_Integration_Callout_Settings__c.getvalues('Rally').Admin_Email__c!=null?Rally_Integration_Callout_Settings__c.getvalues('Rally').Admin_Email__c:'sangeorge@deloitte.com'):'sangeorge@deloitte.com');
        
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('Sales@Salesforce.com');
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('NOTICE! Rally Integration Failed ' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('Rally Integration error occured. Please look into the Log.');
        mail.setHtmlBody('<b>Rally Integration error occured. Please look into the Log.</b>');
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    
    public static void getqueriesUsers (){
        
        string endpoint = UserEndpoint+'&workspace='+ Workspace; 
        httpStub = new HTTP();
        req = new HTTPRequest();
        res = new HTTPResponse();
         req.setHeader('Content-Type','application/x-www-form-urlencoded');
         req.setMethod('GET');
          
        Rally_Integration_Callout_Settings__c LastUpdateSettings = Rally_Integration_Callout_Settings__c.getvalues('Rally');
        if(!Test.isRunningTest())
            JSONMsg=connect_WebService(endpoint);
        else
        
            JSONMsg='{"QueryResult": {"_rallyAPIMajor": "1", "_rallyAPIMinor": "41", "Errors": [], "Warnings": [], "TotalResultCount": 1, "StartIndex": 1, "PageSize": 20, "Results": [{"_rallyAPIMajor": "1", "_rallyAPIMinor": "41", "_ref": "https://rally1.rallydev.com/slm/webservice/1.41/user/10921341676.js", "_objectVersion": "20", "_refObjectName": "sanjaygeorge620", "CreationDate": "2013-03-12T12:44:51.372Z", "_CreatedAt": "Mar 12", "ObjectID": 10921341676, "Subscription": {"_rallyAPIMajor": "1", "_rallyAPIMinor": "41", "_ref": "https://rally1.rallydev.com/slm/webservice/1.41/subscription/10921341529.js", "_refObjectName": "Community (HS_1) Edition - Deloitte Consulting - sanjaygeorge620@gmail.com", "_type": "Subscription"}, "CostCenter": "None", "Department": "None", "Disabled": false, "DisplayName": null, "EmailAddress": "sanjaygeorge620@gmail.com", "FirstName": null, "LandingPage": "/dashboard", "LastName": null, "LastPasswordUpdateDate": "2013-03-18T12:24:46.496Z", "MiddleName": null, "NetworkID": null, "OfficeLocation": "None", "OnpremLdapUsername": null, "Phone": null, "RevisionHistory": {"_rallyAPIMajor": "1", "_rallyAPIMinor": "41", "_ref": "https://rally1.rallydev.com/slm/webservice/1.41/revisionhistory/10921341677.js", "_type": "RevisionHistory"}, "Role": "None", "ShortDisplayName": null, "SubscriptionAdmin": true, "TeamMemberships": [], "UserName": "sanjaygeorge620@gmail.com", "UserPermissions": [], "UserProfile": {"_rallyAPIMajor": "1", "_rallyAPIMinor": "41", "_ref": "https://rally1.rallydev.com/slm/webservice/1.41/userprofile/10921341678.js", "_type": "UserProfile"}, "_type": "User"}]}}';
        system.debug('@@@'+JSONMsg);
        UserList = LXFO_RallyUsersJSONStubClass.parse(JSONMsg);
        system.debug(UserList.QueryResult.Results);
        
        
    }
    




}