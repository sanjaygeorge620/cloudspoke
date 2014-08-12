/*
SiteUtil Controller 
Created by Michael J Fitzgerald
September 2010

Functionality to make a Salesforce Site More Dynamic
1. Functionality for Future public Sites (UK, German, French, Spanish, etc)
2. Write Cookies and Get Cookies for SSO
3. Setting Site NickName for Navigation and Page Titles
4. Setting URL for Public Domain
*/

Public with sharing class SiteUtilController{
    
     /* Template Page Initialization */
   public pagereference PageTemplateInit(){ 
         /* Menu Cookie */
             string menuid= ApexPages.currentPage().getParameters().get('nav');
             if (menuid!=null) {setCookie('psi_menu', menuid, site.getprefix(),-1, false);} 
         
         /* Prefix Cookie */ 
             if (getCookie('psi_prefix')!=site.getprefix()) 
                {setCookie('psi_prefix', site.getprefix(),site.getprefix(),-1, false);}  
             
         /* Username Cookie */
             if (userinfo.getUserType()!='Guest')     
                {if (getCookie('psi_user')!=userinfo.getusername()) 
                {setCookie('psi_user', userinfo.getusername(), site.getprefix(),-1, true);}}
             else {setCookie('psi_user', '', site.getprefix(),0, true);}  
         
         
        /* Redirect with StartURL Done currently with Javascript in VF Template
        String startUrl= System.currentPageReference().getParameters().get('startUrl');
        if (startUrl!=null && userinfo.getUserType()!='Guest'){
            PageReference page= new PageReference(startUrl);
            page.setRedirect(true);
            return page;  
            }
        else {return null;}
        */
        return null;
        }
        
    /*Setting Unauthorized Page to Display (Eventually this will be dynamically set off an object) */
    public static String getActiveSiteHomePage() {
        /*Built for Handling Multiple Sites*/
        string HomePage = PerceptiveUtility.getSingleConfigValue(Site.getName(), 'Settings', 'Home');
        return HomePage;
    }
    
    /* Nickname for Navigation Text */
    public static String getSiteNickName() {
        /*Built for Handling Multiple Sites*/
        string NickName = PerceptiveUtility.getSingleConfigValue(Site.getName(), 'Settings', 'NickName');
        if (NickName==null){NickName=UserInfo.getOrganizationName();}/*Defaulting*/
        return NickName;
    }
   
    /*Setting the User's logged in Email for SSO Header*/
    public static String getUserEmail(){
           /*Built for SSO*/
           string myemail;
           try{user u = [select email from user where id=:userinfo.getuserid()];
               myemail =u.email;}
           catch(Exception e){myemail='';}      
         return myemail;}
    
               
    /*Setting the URL for the Linked Domain (Eventually this will be dynamically set off an object) */
    public static String getNavMenu(){
         /*Built for Handling Multiple International Sites*/
         string mynav = getCookie('psi_menu'); /*Read Cookie*/
         string myVal = PerceptiveUtility.getSingleConfigValue(Site.getName(), 'NavMenu', mynav); /*Look for Nav Val*/
         if (myVal!=null && myVal!='')
             {mynav=myVal;}
         else    
             {mynav=PerceptiveUtility.getSingleConfigValue(Site.getName(), 'NavMenu', 'Default');} /*Defaulting to Public Site Value*/
         return mynav;
         }
    
    /*Set Cookie Method */
    public static string setCookie(string cookiename, string cookievalue, string cookiepath,integer cookieage, boolean issecure) { 
             cookie mycookie = new Cookie(cookiename, cookievalue, cookiepath, cookieage, issecure);
             ApexPages.currentPage().setCookies(new Cookie[]{mycookie});
         return null;
         }
    
    /*Get Cookie Method */
    public static string getCookie(string cookiename) { 
          Cookie mycookie = ApexPages.currentPage().getCookies().get(cookiename);
          if(mycookie == null) {return null;}
          else {return mycookie.getValue();} 
         }
    
    //Class Test     
    public static testMethod void testSiteUtilController () {
        	List<Perceptive_Config_Option__c> MyPO = [Select p.Perceptive_Config_Group__r.key__c, p.Name 
        												From Perceptive_Config_Option__c p
                                                        where
                                                        	p.Perceptive_Config_Group__r.key__c='CustomerPortalSite' and 
                                                        	p.Name='NavMenu'
                                                        ];
        Perceptive_Config_Value__c PV;
        if (MyPO.size()==1){
        	for (Perceptive_Config_Option__c PO : MyPO) 
                             {
                             	
					        	//Add Config Value
					                PV = new Perceptive_Config_Value__c();
					                PV.Name = 'usa__test';
					                PV.Perceptive_Config_Option__c = PO.ID;
					                PV.Value__c = '321';
					                PV.Description__c='test';
					                insert PV;
					            //Add Config Value
					                PV = new Perceptive_Config_Value__c();
					                PV.Name = 'uk__test';
					                PV.Perceptive_Config_Option__c = PO.ID;
					                PV.Value__c = '123';
					                PV.Description__c='test';
					                insert PV;
                             }     
        	}
        	
        else{		
        	//Add Config Group	
                Perceptive_Config_Group__c PG = new Perceptive_Config_Group__c();
                PG.Name = 'CustomerPortalSite';
                PG.Key__c = 'CustomerPortalSite';
                PG.Description__c='test';
                insert PG;
            //Add Config Option
                Perceptive_Config_Option__c PO = new Perceptive_Config_Option__c();
                PO.Name = 'NavMenu';
                PO.Perceptive_Config_Group__c = PG.ID;
                PO.Description__c='test';
                insert PO;  
            //Add Config Value
                PV = new Perceptive_Config_Value__c();
                PV.Name = 'usa__test';
                PV.Perceptive_Config_Option__c = PO.ID;
                PV.Value__c = '321';
                PV.Description__c='test';
                insert PV;
            //Add Config Value
                PV = new Perceptive_Config_Value__c();
                PV.Name = 'uk__test';
                PV.Perceptive_Config_Option__c = PO.ID;
                PV.Value__c = '123';
                PV.Description__c='test';
                insert PV;
        }         
        
        // Instantiate a new controller with all parameters in the page
        Test.setCurrentPageReference(new PageReference('Page.changepassword'));
        //Test #1
            ApexPages.currentPage().getParameters().put('nav', 'usa__test');
            SiteUtilController controller = new SiteUtilController();
            controller.PageTemplateInit();
            system.debug(getUserEmail()); 
            system.debug(getActiveSiteHomePage());
            system.debug(getSiteNickName());
            
            system.debug(getnavmenu());
            System.assertEquals(getSiteNickName(),UserInfo.getOrganizationName());       
                                       
        }   
}