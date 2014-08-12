//**************************************************************
//Salesforce Sites
//An apex page controller that exposes the site forgot password functionality
//Created By: Salesforce.com: Auto generated when Sites was enabled
//Creation Date: December 2009
//Noted by: Michael Fitzgerald
//*****************************************************************

public class ForgotPasswordController Extends SitesController{
    public String username {get; set;}   
       
    public ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
    }
    
   public static testMethod void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}