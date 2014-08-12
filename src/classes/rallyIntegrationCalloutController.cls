public with sharing class rallyIntegrationCalloutController {
    
    
    public string pSandboxEndpoint {get;set;}
    public string jsonResponseBody {get;set;}
    public boolean calloutSuccess {get;set;}
    public string responseStatus {get;set;}
    
    public string searchParam {get;set;}
    //public string userCredentials {get;set;}
    
       
    static Http h;
    static HttpRequest req;
    static HttpResponse res;
    
    //public static LXFO_RallyUserStoryJSONStubClass userStory;
    public static rallyUserStoryJSONClass userStory;
    public static rallyAuthorizeJSONClass authorizeSecurityToken;
    
    public rallyUserStoryJSONClass pageUserStory {get;set;}
    
    //static string JSONMsg;
    public string JSONMsg {get;set;}
    
    
    final static string userCredentials = 'nick.johnson@perceptivesoftware.com:Nissan300';
    final static string fetchEndpoint = 'https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement.js?workspace=https://sandbox.rallydev.com/slm/webservice/v2.0/workspace/10921341682&fetch=true&start=1&pagesize=20';
    final static string upsertEndpoint = 'https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/';
    final static string authorizeEndpoint = 'https://sandbox.rallydev.com/slm/webservice/v2.0/security/authorize';
    
    public rallyIntegrationCalloutController() {
        searchParam = '';
        //1.41 --> v2.0
        //
        //sandboxEndpoint = 'https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement.js?workspace=https://sandbox.rallydev.com/slm/webservice/v2.0/workspace/10921341682&fetch=true&start=1&pagesize=20';
        calloutSuccess = false;
        pSandboxEndpoint = '';
        jsonResponseBody = '';
        //userCredentials = 'nick.johnson@perceptivesoftware.com:Nissan300';

        String LastUpdateDate = string.valueof(datetime.now());
        system.debug('Bazinga... datetime.now(): ' + LastUpdateDate);
        LastUpdateDate = LastUpdateDate.replace(' ', 'T');
        system.debug('Bazinga... formatted: ' + LastUpdateDate);
    }
    
    public PageReference performCallout() {
        
        rallyCalloutUtility rs = new rallyCalloutUtility();
        rs.getEntireUS('FormattedID','US3928', '=');
         
        JSONMsg = rallyCalloutUtility.JSONMsg;
        
        return null;
    }
    /*
    public PageReference setupBatchUploadsSchdl() {
        
        string CRON_EXP = '0 0 * * * ?';
        rallyUploadBatch_Schdl b = new rallyUploadBatch_Schdl();
        system.schedule('Hourly Rally US Upload', CRON_EXP, b);
        
        return null;
    }
    
    public PageReference setupBatchPullUpdatesSchdl() {
        
        string CRON_EXP = '0 0 * * * ?';
        rallyPull_Schdl b = new rallyPull_Schdl();
        system.schedule('Hourly Rally US Pull', CRON_EXP, b);
        
        return null;
    }
    
    
    public PageReference performSync() {
        
        rallyUploadBatch j = new rallyUploadBatch();
                Id jId = Database.executeBatch(j, 1);
        
        return null;
    }
    */
    public PageReference performSyncFromRally() {
        
        rallyPullBatch j = new rallyPullBatch();
        Id jId = Database.executeBatch(j, 1);
        
        return null;
    }
    
 }