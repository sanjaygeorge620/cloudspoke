//**************************************************************
//Salesforce Sites
//An apex class that creates a portal user
//Created By: Salesforce.com: Auto generated when Sites was enabled
//Creation Date: April 2011
//Noted by: Michael Fitzgerald
//*****************************************************************
 
public class SiteRegisterController Extends SitesController{
    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    //private static Id PORTAL_ACCOUNT_ID = '001x000xxx35tPN';
    public static Id PORTAL_ACCOUNT_ID = LX_SetRecordIDs.PortalAccountID ; 
    public boolean isTestExecution = false;	
	public Id testAccountId = null;	
    public SiteRegisterController () {
    }

    public String username {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
      
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    public PageReference registerUser() {
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        User u = new User();
        u.Username = username;
        u.Email = email;
        u.CommunityNickname = communityNickname;
        
		if(isTestExecution)
			PORTAL_ACCOUNT_ID = testAccountId;
		
        String accountId = PORTAL_ACCOUNT_ID;
        system.debug('accountId === '+accountId);
		system.debug('user === '+u);
		system.debug('password === '+password);
        // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        String userId = Site.createPortalUser(u, accountId, password);
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(username, password, null);
            }
            else {
                PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }
    
    // Test method to bring this class's test coverage over the required 75%
    static testMethod void testRegistration() {
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        controller.isTestExecution = true;
        controller.testAccountId = '001x000xxx35tPN';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);
       
    }
}