public class rallCalloutUtility {
	
	static Http httpStub;  
    static HttpRequest req; 
    static HttpResponse res;
    
    // Variable being passed for User Story List
   	public static rallyUserStoryJSONClass userStory;
   	// Variable used for PUT/POST/DELETE operations to authorize session
    public static rallyAuthorizeJSONClass authorizeSecurityToken; 
    
    static string JSONMsg;
    static string sessionCookie;
    static string securityToken;
    
    //list of endpoints ..  later to be setup as custom settings
    final static string userCredentials = 'nick.johnson@perceptivesoftware.com:Nissan300';
    final static string fetchEndpoint = 'https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement.js?workspace=https://sandbox.rallydev.com/slm/webservice/v2.0/workspace/10921341682&fetch=true&start=1&pagesize=20';
    final static string upsertEndpoint = 'https://sandbox.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/';
    final static string authorizeEndpoint = 'https://sandbox.rallydev.com/slm/webservice/v2.0/security/authorize';
    
    //Fetches User Story through a Callout from Rally and parses to a User Story Object
    public void getEntireUS () {
    	
    }
    
    public static string connect_WebService(string endpoint, boolean reqAuthorize) {
    	
    	if(reqAuthorize) {
    		
    		authorizeRallyCallout();
    		req.setHeader('Cookie', sessionCookie);
    		endpoint += '?key=' + securityToken;
    	}
    	
    	req.setEndpoint(endpoint);
    	req.setHeader('Authorization', ' Basic ' + EncodingUtil.base64Encode(Blob.ValueOf(userCredentials)));
    	req.setHeader('oauth signature method', 'PLAINTEXT');
    	
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
    public static void authorizeRallyCallout() {
    	
    	httpStub = new Http();
    	req = new HttpRequest();
    	res = new HttpResponse();
    	
    	req.setEndpoint(authorizeEndpoint);
    	req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    	req.setMethod('GET');
    	req.setHeader('Authorization', ' Basic ' + EncodingUtil.base64Encode(Blob.ValueOf(userCredentials)));
    	req.setHeader('oauth signature method', 'PLAINTEXT');
    	
    	res = httpStub.send(req);
    	
    	sessionCookie = res.getHeader('Set-Cookie');
    	
    	authorizeSecurityToken = rallyAuthorizeJSONClass.parse(res.getBody());
    	
    	securityToken = authorizeSecurityToken.OperationResult.SecurityToken;
    }
    
    
    //send email method used for log and error reporting
    public static void mailAdmin() {
    	
    	
    }
    
    

}