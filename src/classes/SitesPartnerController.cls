/*
    Perceptive Sites
    Dynamically setting Site Variables based on profile
    Created by mfitzgerald
    April 2011
*/
    
Public abstract class SitesPartnerController{
//-------------------------------------------------------------------------------
// Default Variables
//-------------------------------------------------------------------------------
          /*URL Navigation - See Related Site class below*/
          private static string DEFAULT_WEBSITE = 'https://www.perceptivesoftware.com';
          
          /*Max number of rows SOQL returns based on API Limits*/
          public integer MAX_SOQL_ROWS = 2000;  
          
//-------------------------------------------------------------------------------
// Object Variables
//-------------------------------------------------------------------------------
          public Account SITE_ACCOUNT {get {return UserAccount;} set; }
          public Contact SITE_CONTACT {get {return UserContact;} set; }
    
//-------------------------------------------------------------------------------
// Site Variables
//-------------------------------------------------------------------------------               
        /*All static variable are used for IdeaController*/
          
          
          /*Core*/  
          public string SITE_TEMPLATE_PRIMARY {get {return siteSetup.Primary_Template__c;} set; }
          /*Ideas variable to display in template*/ 
          public static string SITE_TEMPLATE_PRIMARY {get {return siteSetup.Primary_Template__c;} set; }
          public string SITE_TEMPLATE_SECONDARY {get {return siteSetup.Secondary_Template__c;} set; }
          
          public string SITE_NICKNAME {get {return siteSetup.nickname__c;} set; }
          public string SITE_CDN {get {return siteSetup.CDN__c;} set; } /*Used mostly for testing when building*/
          public string SITE_PROD_DOC_URL {get {return siteSetup.Product_Documentation_URL__c;} set; }
          public string SITE_HOME {get {return siteSetup.Home_Page__c;} set; }
          public string SITE_LOGIN {get {return siteSetup.Login_Page__c;} set; }
          public string SITE_TITLE {get {return siteSetup.site_title__c;} set; }        
          public double SITE_CACHE_MAX_AGE {get {return siteSetup.Cache_Max_Age__c;} set; }
          public boolean SITE_CACHED {get {return siteSetup.Cached__c;} set; }
          public string SITE_META_KEYWORD {get {return siteSetup.Meta_Keyword__c;} set; }
          public string SITE_META_DESCRIPTION {get {return siteSetup.Meta_Description__c;} set; }
          public string SITE_REGISTER_TEXT {get {return siteSetup.Register_as_New_User__c;} set; }
          public string SITE_ANALYTICS {get {return siteSetup.Analytics_Code__c;} set; }
          
          public boolean SITE_FEEDBACK {get {return siteSetup.Feedback__c;} set; }
          public string SITE_FEEDBACK_OPTIONS {get {return siteSetup.Feedback_Options__c;} set; }
            
          public boolean SITE_ALERT_ACTIVE {get {return siteSetup.Alert_Active__c;} set; }
          public string SITE_ALERT_TITLE {get {return siteSetup.Alert_Title__c;} set; }
          public string SITE_ALERT_FULL {get {return siteSetup.Alert_Full__c;} set; }
          
          /*Outage*/
          public boolean SITE_OUTAGE {get {return siteSetup.Outage_Notification__c;} set; }
          public string SITE_OUTAGE_HTML {get {return siteSetup.Outage_HTML__c;} set; }
        
          public string SITE_CASE_RECORDTYPE {get {return siteSetup.Case_RecordType__c;} set; }
          public static string  SITE_IDEAS_ID {get {return siteSetup.Ideas_Site_Setup__c;} set; }
          public string SITE_IDEAS_FEATURED {get {return siteSetup.Feature_Idea__c;} set; }
        
          /*tabs and security*/
          public boolean SITE_TOOLBAR {get {return siteSetup.Toolbar__c;} set; }
          public boolean SITE_TAB_HOME {get {return siteSetup.Tab_Home__c;} set; }
          public boolean SITE_TAB_ACCOUNT {get {return siteSetup.Tab_Account__c;} set; }
          Public boolean SITE_TAB_PARTNER_ACCOUNT {get {return siteSetup.Tab_Partner_Account__c;} set; }
          public boolean SITE_TAB_OPPORTUNITIES {get {return siteSetup.Tab_Opportunities__c;} set; }
          public boolean SITE_TAB_ORDERS {get {return siteSetup.Tab_Orders__c;} set; }
          public boolean SITE_TAB_LEADS {get {return siteSetup.Tab_Leads__c;} set; }
          public boolean SITE_TAB_ANSWERS {get {return siteSetup.Tab_Answers__c;} set; }
          public boolean SITE_TAB_CASES {get {return siteSetup.Tab_Cases__c;} set; }
          public boolean SITE_TAB_CASES_CHANNEL {get {return siteSetup.Tab_Cases_Channel__c;} set; }
          public boolean SITE_TAB_CONTACT {get {return siteSetup.Tab_Contact__c;} set; }
          public boolean SITE_TAB_DOWNLOADS {get {return siteSetup.Tab_Downloads__c;} set; }
          public boolean SITE_TAB_IDEAS {get {return siteSetup.Tab_Ideas__c;} set; }
          public boolean SITE_TAB_KNOWLEDGE {get {return siteSetup.Tab_Knowledgebase__c;} set; }
          public boolean SITE_TAB_DOCUMENTATION {get {return siteSetup.Tab_Product_Documentation__c;} set; }
          public boolean SITE_TAB_TRAINING {get {return siteSetup.Tab_Training__c;} set; }
          public boolean SITE_TAB_UPGRADE {get {return siteSetup.Tab_Upgrade_Center__c;} set; }
          public boolean SITE_ACTIVATE_CUSTOMER_PORTAL_TAB {get {return siteSetup.Activate_Customer_Portal_Tab__c;} set; }
        
          public string SITE_NAME {get {return siteSetup.Site_Name__c;} set; }
          public static string SITE_NAME {get {return siteSetup.Site_Name__c;} set; }
        
          //FUTURE
          //public string  SITE_LANGUAGE {get {return siteSetup.Language__c;} set; }
          //public string  SITE_URL {get {return siteSetup.URL__c;} set; }
        
        
//-------------------------------------------------------------------------------
// Site Variables and Content
//-------------------------------------------------------------------------------
          
        /*Site Settings from Custom Object*/
        public static Perceptive_Site__c siteSetup {
            get {
                if (siteSetup == null) {
                    try {
                        SiteSetup=[select 
                                         Site_Name__c,
                                         Language__c,
                                         site_title__c, 
                                         nickname__c, 
                                         Meta_Keyword__c, 
                                         Meta_Description__c, 
                                         Alert_Active__c, 
                                         Alert_Title__c, 
                                         Alert_Full__c, 
                                         Home_Page__c, 
                                         Login_Page__c,
                                         URL__C, 
                                         Primary_Template__c, 
                                         Secondary_Template__c,
                                         Cached__c,
                                         Cache_Max_Age__c,
                                         Analytics_Code__c,
                                         Feature_Idea__c,
                                         Ideas_Site_Setup__c,
                                         Case_RecordType__c,
                                         Feedback__c,
                                         Feedback_Options__c,
                                         Product_Documentation_URL__c,
                                         CDN__c,
                                         Register_as_New_User__c,
                                         
                                      //tabs
                                         Activate_Customer_Portal_Tab__c,
                                         Toolbar__c,
                                         Tab_Account__c,
                                         Tab_Answers__c,
                                         Tab_Cases__c,
                                         Tab_Contact__c,
                                         Tab_Downloads__c,
                                         Tab_Home__c,
                                         Tab_Ideas__c,
                                         Tab_Knowledgebase__c,
                                         Tab_Product_Documentation__c,
                                         Tab_Training__c,
                                         Tab_Upgrade_Center__c,
                                         Tab_Opportunities__c,
                                         Tab_Orders__c,
                                         Tab_Leads__c,
                                         Tab_Cases_Channel__c,
                                         Tab_Partner_Account__c,
                                      
                                      //Outage
                                         Outage_Notification__c,
                                         Outage_HTML__c
                                         
                                     from Perceptive_Site__c 
                                     where Site_Name__c =:getSiteName()
                                      ];
                        
                       
                    } catch (QueryException  e) {
                        //siteSetup = new Perceptive_Site__c();
                        throw new SitesException('Invalid Site Setup. ' + e.getMessage());
                    }
                }
                return siteSetup;
            }
            set;
            }
        
        /*Query and Display Generic List of Site Content*/
        public list<Perceptive_Site_Content__c> sitesContent(string ContentType, string Record_Type){
               list<Perceptive_Site_Content__c> siteContent = [Select 
                                                                    Name, 
                                                                    Description_Text__c,
                                                                    Description_WYSIWYG__c,
                                                                    Development_Area__c,
                                                                    Featured__c,
                                                                    Image__c,
                                                                    Image_Link__c,
                                                                    Track__c,
                                                                    Presenter__c,
                                                                    Difficulty__c,
                                                                    URL__c,
                                                                    Presentation__c 
                                                               From Perceptive_Site_Content__c 
                                                               where 
                                                                   Public_Viewing__c = true and
                                                                   Type__c=:ContentType and
                                                                   Perceptive_Site__r.Site_Name__c=:SITE_NAME and
                                                                   RecordType.Name=:Record_Type
                                                               order by Sort_Number__c, name 
                                                               ];
            return siteContent;
        }
            
        /*Query and Display Featured of Content - Limit 1*/
        public list<Perceptive_Site_Content__c> sitesFeaturedContent(string ContentType, string Record_Type){
                list<Perceptive_Site_Content__c>  siteContent=[Select 
                                                                    Name, 
                                                                    Description_Text__c,
                                                                    Description_WYSIWYG__c,
                                                                    Development_Area__c,
                                                                    Featured__c,
                                                                    Image__c,
                                                                    Image_Link__c,
                                                                    Track__c,
                                                                    Presenter__c,
                                                                    Difficulty__c,
                                                                    URL__c,
                                                                    Presentation__c 
                                                               From Perceptive_Site_Content__c 
                                                               where 
                                                                   Featured__c = true and
                                                                   Public_Viewing__c = true and
                                                                   Type__c=:ContentType and
                                                                   Perceptive_Site__r.Site_Name__c=:SITE_NAME and 
                                                                   RecordType.Name=:Record_Type
                                                               order by Sort_Number__c, name 
                                                               limit 1
                                                               ];
                        
            return siteContent;
            }
      
      
       /*Query and Display List of Content for Widgets*/
       public list<Perceptive_Site_Content__c> getWidget(string WidgetName){
               list<Perceptive_Site_Content__c> siteContent=[Select 
                                                                    Name, 
                                                                    Description_Text__c
                                                               From Perceptive_Site_Content__c 
                                                               where 
                                                                   Public_Viewing__c = true and
                                                                   Type__c='Widget' and
                                                                   Perceptive_Site__r.Site_Name__c=:SITE_NAME and
                                                                   RecordType.Name='Widget' and
                                                                   Name=:WidgetName
                                                               order by Track__c, name 
                                                               limit 1
                                                               ];
            
                return siteContent;
            }

            
//-------------------------------------------------------------------------------
// Custom Site Methods
//-------------------------------------------------------------------------------            

        /*Custom Exception Class*/  
        public class SitesException extends Exception{}
          
            /*Guest User?*/
        public Boolean getIsLoggedIn() {
                return UserInfo.getUserType() != 'Guest';
            }
        
        /*Global Account Information used throughout the site*/
        public static account UserAccount {
            get {
             if (UserAccount == null) {
                  user u = [select name, AccountID from user where id=:UserInfo.getUserId() limit 1];
                  system.debug('user u: ' + u);
                  system.debug('u.AccountID:' + u.AccountID);
                  if (u.AccountID!=null){
                      /*Add fields to SOQL, but please don't remove fields! */
                      UserAccount = [select id, Type, name, ownerId, owner.name, sma_status__c, csa__c, isr__r.Name, website from Account where id=:u.AccountID];
                  }
                  else{
                        UserAccount = new Account(name='Invalid Account');
                        //cannot throw exception due to all pages checking the account info
                        //throw new SitesException('Invalid Account.');
                  }
              } 
               system.debug('UserAccount:'+UserAccount);
               return UserAccount;}
           set;}
                   
             
        /*Global Contact Information used throughout the site*/
        public static contact UserContact{
            get{  
              if (UserContact == null) {
                system.debug('userInfo:' + userInfo.getuserID());
                  user u = [select name, contactID, accountID from user where id=:UserInfo.getUserId() limit 1];
                  system.debug('u.contactID: ' + u.contactID);
                  system.debug('u.accountID: ' + u.accountID);
                  system.debug('siteAccount' + UserAccount);
                  system.debug('Contacts:' + [select id, name from Contact where accountID = :UserAccount.id]);
                  system.debug('contacts at all:' + [select id, name from Contact limit 10]);
                  if (u.contactID!=null){
                      /*Add fields to SOQL, but please don't remove fields! */
                      UserContact = [select id, name, owner.name, Contact_Role__c from Contact where id=:u.contactID];
                  }
                  else{
                       UserContact = new Contact(FirstName='Invalid', LastName='Contact');
                       //cannot throw exception due to all pages checking the contact info
                       //throw new SitesException('Invalid Contact.');
                  }
               }  
               system.debug('UserContact:'+UserContact); 
               return UserContact;}
           set;}
         
        
        /*Grab the correct recordtypeid*/
        public id getRecordtypeID(string sObjectType,string DeveloperName){
             recordtype r =[Select 
                                r.SobjectType, 
                                r.DeveloperName 
                             From RecordType r 
                             where r.SobjectType=:sObjectType and 
                             r.DeveloperName =:DeveloperName];
            return r.id;
        }
        
        /* Set the Site Name */
        public static String getSiteName() {   
            string SiteID = null;
            if (userinfo.getUserType()=='Guest'){
                //use site name when a guest
                SiteID = site.getName();
                }
            else{
                 //get custom site by profile
                 profile p = [select p.name from profile p where p.id=:UserInfo.getProfileId()];
                 Perceptive_Site__c ps = [Select ps.Site_Name__c From Perceptive_Site__c ps WHERE ps.Profiles__c includes(:p.name) limit 1];
                 if (ps!=null){
                    SiteID = ps.Site_Name__c;
                 } else {
                    throw new SitesException('Invalid Site Setup: Please add the current profile to a site.');
                 }   
                }   
            return SiteID;
         }
     
                     
        /*Related Sites Navigation handling french, spanish, dutch, etc sites navigation*/
        public string relatedSite{
            get {
                if (relatedSite == null) {
                        string web_param= ApexPages.currentPage().getParameters().get('nav');
                        string web_cookie= getCookie('psi_menu');
                        if (web_param!=null) {
                                setCookie('psi_menu', web_param, site.getprefix(),-1, false);
                                RelatedSite = PerceptiveUtility.getSingleConfigValue('Perceptive_Site_Settings', 'Websites', web_param);} 
                        else if (web_cookie!=null) { 
                               RelatedSite = PerceptiveUtility.getSingleConfigValue('Perceptive_Site_Settings', 'Websites', getCookie('psi_menu'));}
                         
                        /* Can't find a param value? Set to default */
                        if (RelatedSite==null || RelatedSite ==''){RelatedSite = DEFAULT_WEBSITE;}

                }
                if (!relatedSite.endsWith('/')){relatedSite+='/';}
                return relatedSite;
            }
            set;
            }

        /*function to secure strings (especially for parameters) */
        public string secureString(string sValue)
        {
            if (sValue!='' && sValue!=null){
               return string.escapesinglequotes(sValue);
            } else{
                return '';
            }
    
        }       
//-------------------------------------------------------------------------------
// Custom Cookies
//-------------------------------------------------------------------------------    
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
              public String getCurrentUerProfileName()
             {
               profile p = [select p.name from profile p where p.id=:UserInfo.getProfileId()];
               return p.Name;
               
             
             }           
}