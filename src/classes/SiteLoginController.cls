/*
Salesforce Sites Login Controller
Last Updated: April 2011
Created by: Michael Fitzgerald
*/

global class SiteLoginController Extends SitesController{
    global String username {get; set;}
    global String password {get; set;}
    
    global SiteLoginController () {
        //Defaulting the UserName Field
       // username ='E-mail Address';   //10/22  Praveen
        username ='';
        
        //Display Error Message Requesting User to Login
        String startUrl= System.currentPageReference().getParameters().get('startUrl');
        if (startUrl!=null && userinfo.getUserType()=='Guest'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Provide valid Login and Password'));
            }
        }
    
    
    global PageReference login() {/* Login Method*/
        String startUrl = System.currentPageReference().getParameters().get('startURL'); 
        system.debug('SiteURL' +startUrl);
        return Site.login(username, password, startUrl);
        }
    
    global static testMethod void testSiteLoginController () {/* Test Method */
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        System.assertEquals(controller.login(),null);
         }    
}