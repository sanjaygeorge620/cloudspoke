//**************************************************************
//Salesforce Sites
//An apex page controller that exposes the change password functionality
//Created By: Salesforce.com: Auto generated when Sites was enabled
//Creation Date: December 2009
//Noted by: Michael Fitzgerald
//*****************************************************************

public class ChangePasswordController Extends SitesController{
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    
    public ChangePasswordController() {}
    
    public static testMethod void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);         
        
    }    
}