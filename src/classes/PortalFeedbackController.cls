/*Created July 2010 to capture Customer Feedback*/
/*General Help Method added October 2010*/
/*Portal Feedback Component*/
public without sharing class PortalFeedbackController {
    
    Public String  ReferenceTitle {get; set;} //Title of Feedback
    Public String  ReferenceID {get; set;} //ID of Feedback
    Public String  ReferenceType {get; set;} //Type of Feedback
    Public String  ReferenceURL {get; set;} //URL of Feedback
    
    Public String  Comment {get; set;} //Comment
    Public Boolean ShowFeedback {get; set;} //Toggle Field to show Feedback
    Public string lookingforpicklist {get; set;} //Picklist
    Public string resultspicklist {get; set;} //Picklist
    
    
    
    public PortalFeedbackController(ApexPages.StandardController controller) {//constructor with Page controller
        System.Debug('++++++++++++++++++++Start of Page Constructor++++++++++++++++++++');
        ShowFeedback=true;
        lookingforpicklist=null;
        resultspicklist =null;
    }
    
    public PortalFeedbackController() {//constructor
        System.Debug('++++++++++++++++++++Start of Constructor++++++++++++++++++++');
        ShowFeedback=true;
        lookingforpicklist=null;
        resultspicklist =null;
    }
    
    public PageReference HideFeedback() {
        System.Debug('++++++++++++++++++++Start of HideFeedback++++++++++++++++++++');
        ShowFeedback =false;
        return null;
    }
    
    public List<SelectOption> getItems() {
        System.Debug('++++++++++++++++++++Start of Get Items++++++++++++++++++++');
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('True','Yes')); 
        options.add(new SelectOption('False','No'));
        return options; 
    }

    public PageReference save() {
         System.Debug('++++++++++++++++++++Start of SAVE++++++++++++++++++++');
         
         //Validating the strings and converting them to boolean vals
             if (lookingforpicklist==null){lookingforpicklist='N/A';}
             if (resultspicklist==null){resultspicklist='N/A';}
        
             //validation to truncate values to fit the field sizes
             if (Comment.length() > 32000) {Comment = Comment.substring(0,32000);}
             if (ReferenceTitle.length() > 255) {ReferenceTitle = ReferenceTitle.substring(0,255);}
             if (ReferenceID.length() > 255) {ReferenceID= ReferenceID.substring(0,255);}
             if (ReferenceType.length() > 255) {ReferenceType = ReferenceType.substring(0,255);}
             
             ReferenceURL='https://'+ApexPages.currentPage().getHeaders().get('Host') + ReferenceURL;
             if (ReferenceURL.length() > 255) {ReferenceURL = ReferenceURL.substring(0,255);}
             
             try {
                 //DML 
                 portal_feedback__c feedback = new portal_feedback__c();
                     feedback.User__c = userInfo.getUserId(); //USER ID
                     feedback.Comment__c = Comment; //Long Text Area 32k
                     feedback.Looking_for__c = lookingforpicklist; //Boolean
                     feedback.Resolve_Issue__c = resultspicklist; //Boolean
                     feedback.Reference_Title__c = ReferenceTitle; //Article Title
                     feedback.Reference_ID__c = ReferenceID; //Reference ID
                     feedback.Reference_Type__c = ReferenceType; //Reference Type
                     feedback.Reference_URL__c = ReferenceURL; //Reference Type
                     feedback.Site__c = getSiteNickName(); //Site
                  insert feedback; 
                  ShowFeedback=false; //hide the section in VF
                }   
              catch(Exception e){
                    // Generic Exception handling code here       
                    //Silently write to error log. No need for User to get visible warning.
                    ErrorLogUtility.createErrorRecord(e.getMessage(),'PortalFeebackController.save','Low','Generic');
                  }   
                      
       return null;  
    }

    
/*General Help Method*/    
    Public string getSiteNickName()
     {return SiteUtilController.getSiteNickName();}
    
    
    public List<SelectOption> getFeedbackOptions() {
                List<Perceptive_Config_Value__c> feedbacklist =PerceptiveUtility.getListofConfigValues(site.getName(),'FeedbackTypes');               
                List<SelectOption> options = new List<SelectOption>();
                        options.add(new SelectOption('','-- None --'));
                        for (Perceptive_Config_Value__c f : feedbacklist) {
                            options.add(new SelectOption(f.Value__c,f.Value__c));}
                    return options;
          }
          
    Public pagereference SaveGeneralFeeback(){
       string retURL = ApexPages.currentPage().getParameters().get('retURL');
        try {
           
            //Need Subject
            if (ReferenceTitle==null || ReferenceTitle=='')
                {throw new PerceptiveUtility.CustomException('Subject is Required');}
            if (ReferenceType==null || ReferenceType=='')
                {throw new PerceptiveUtility.CustomException('Type is Required');}
            if (Comment==null || Comment=='')
                {throw new PerceptiveUtility.CustomException('Comment is Required');}
            
            portal_feedback__c feedback = new portal_feedback__c();
                     feedback.User__c = userInfo.getUserId(); //USER ID
                     feedback.Comment__c = Comment; //Long Text Area 32k
                     feedback.Reference_Title__c = ReferenceTitle; //Article Title
                     feedback.Reference_Type__c = ReferenceType; //Reference Type
                     feedback.Reference_URL__c = retURL; //Reference Type
                     feedback.Site__c = getSiteNickName(); //Site
                  insert feedback; 
                  
              /*Returning to RETURL or Home Page*/
              PageReference pageRef;
              if (retURL!=null){
                  pageRef= new PageReference(ApexPages.currentPage().getParameters().get('retURL'));}
              else{
                  pageRef= new PageReference(site.getcurrentsiteurl());}         
              pageRef.setRedirect(true);
              return pageRef;    
                  
       } catch (PerceptiveUtility.CustomException e){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
      }
      catch(Exception e){
                // Generic Exception handling code here       
                //Silently write to error log. No need for User to get visible warning.
                ErrorLogUtility.createErrorRecord(e.getMessage(),'PortalFeebackController.save','Low','Generic');
           }
     return null; 
    }
    
    
    
//Test Code Coverage    +++++++++++++++++++++++++++++++++
    static testMethod void PortalFeedbackController () {
    
      Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'sqt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='testerusertesters@lexmark.com',LX_region__c='NE',Legacy_Company__c='Lexmark');
         Insert adminUser;
         
        system.runas(adminUser)
        {
     
    
    
    
        portal_feedback__c f = new portal_feedback__c(Comment__C='this is a comment', 
                                        Looking_for__c='true',
                                        user__c=userinfo.getuserid());
         insert f;
        
        // Insert Account
        Account aNew = new Account(Name='Test Company',Physical_Country__c='India',BillingCountry='India');
         insert aNew;
         system.debug('Account: ' +aNew.ID + ' Name: ' + aNew.Name);  
        
        // Insert Contact
        Contact cNew = new Contact(accountid=aNew.id, FirstName='John', LastName='Doe',Lx_Lexmark_Vertical__c = 'Manufacturing',phone='1232344');
         insert cNew;
         system.debug('Contact: ' +cNew.ID + ' Name: ' + cNew.Name);  
        
        // Query Profile        
        Profile p = [select id from profile where name like '%customer portal%' limit 1]; 
        
        //Query Role
        List<UserRole> portalRoleList = [Select PortalType, PortalRole, Name, Id, ContactAccessForAccountOwner,
                                                             CaseAccessForAccountOwner From UserRole Where PortalType = 'CustomerPortal' Limit 1];
        
      
        // Insert User
       /* User uNew = new User(alias = 'standt', Contactid=cNew.id, email='cstandarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser@lexmark.com',userroleid=portalRoleList[0].id ); */
         //insert uNew; 
         //system.debug('User: ' +uNew.ID + ' Name: ' + uNew.Name);
         
        
        
        Test.setCurrentPageReference(new PageReference('Page.Knowledge_Support_Articles'));
        ApexPages.Standardcontroller sc1 = New ApexPages.StandardController(f);
           // System.runAs(uNew) {
                System.debug('#1 Current User: ' + UserInfo.getUserName());
                System.debug('#1 Current Profile: ' + UserInfo.getProfileId()); 
                   
                PortalFeedbackController controller01 = New PortalFeedbackController(sc1); 
                PortalFeedbackController  controller03 = new PortalFeedbackController();
                 //Drop Downs
                 List<SelectOption>    test01 = controller01.getItems();       
                 
                 controller01.lookingforpicklist=null;
                 controller01.resultspicklist='False';
                 controller01.Comment ='123';
                 controller01.ReferenceTitle ='123';
                 controller01.ReferenceID ='123';
                 controller01.ReferenceType ='123';
                 controller01.ReferenceURL ='123';
                 controller01.getSiteNickName();
                 //Action Commands
                 controller01.getFeedbackOptions();
                 controller01.Save();
                 controller01.HideFeedback();
           // }
            
            
            //running as current standard user
            {
                System.debug('#1 Current User: ' + UserInfo.getUserName());
                System.debug('#1 Current Profile: ' + UserInfo.getProfileId()); 
                PortalFeedbackController controller02 = New PortalFeedbackController(sc1);
                
                //Creating >32000 Characters for fields
                string s;
                Integer count = 1;
                while (count < 32002) 
                {s=s+count+'/n'; count++;}
                
                 controller02.lookingforpicklist='False';
                 controller02.resultspicklist=null;
                 controller02.Comment =s;
                 controller02.ReferenceTitle =s;
                 controller02.ReferenceID =s;
                 controller02.ReferenceType =s;
                 controller02.ReferenceURL =s;
                    

                //Action Commands
                 controller02.getFeedbackOptions();
                 controller02.SaveGeneralFeeback();
                 controller02.HideFeedback();
                 
                    
            }
        }
        
    }                     

}