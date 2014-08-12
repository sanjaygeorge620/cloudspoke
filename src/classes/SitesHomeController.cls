/*
***Changes***
May 2014 | MFitzgerald | Adding Checkpoint Field to getOldServers methods
*/
public class SitesHomeController extends SitesController {

    public SitesHomeController(){
        SEARCH_TEXT = Label.KB_Default_Search_Text;
    }
    
    //-------------------------------------------------------------------------------
    // Home Page
    //-------------------------------------------------------------------------------    
        //Knowledge Search  Action for the Home Page
        public string SEARCH_TEXT {get;set;}   
        public PageReference doKBSearch() {
              PageReference kbPage = Page.knowledge;
              kbPage.getParameters().put('s', SEARCH_TEXT);
              kbPage.setRedirect(true);
          return kbPage;
        }
    
    
    //-------------------------------------------------------------------------------
    // LOGIN
    //-------------------------------------------------------------------------------    
        public PageReference redirectLogin() {
            PageReference Pg;
            string startUrl = secureString(System.currentPageReference().getParameters().get('startURL')); 
            system.debug('startURL:' +startURL);
             string parameter; 
             parameter = secureString(ApexPages.currentPage().getParameters().get('getPrefix'));
             system.debug('page:' + parameter);
             string userType;
             userType = userInfo.getUserType();
             system.debug('userType: ' + userInfo.getUserType());
             if (!getIsLoggedIn()){
                 /*keep the person on the same page*/
                 return null;
             } else if(startUrl!='' && startUrl!=null){    
                 if (!startURL.startsWith('/')){
                     startURL='/'+startURL;}
                 
                 /*Redirecting Page*/
                   Pg = new PageReference(startURL);
                   Pg.setRedirect(true);
                  return Pg;
              } else {
                   if(userType == 'PowerPartner'){
                       /*Go Home*/
                       Pg = Page.Partner;
                       Pg.setRedirect(true);
                      return Pg;
                  }else{
                  /*Go Home*/
                   Pg = Page.Home;
                   Pg.setRedirect(true);
                   return Pg;
                  }
                  
              }
            } 
    
    //===============================================================================================
    // SKILLPORT SSO
    //===============================================================================================
        public PageReference logintoSkillport() {
            return SkillportServices.SinglePassUserCmd(userinfo.getuserid(),'End-User','SkillSoft');
        }
        
    // FLexera URL Encryption Start-----------------------------------------           
       public pagereference RefFlexURL() {
               
            blob SFkey = Blob.valueOf(SITE_FLEXkey);
            blob data = Blob.valueOf(SITE_USER_EMAIL);
            blob vector = EncodingUtil.base64Decode(SITE_FLEXiv);
            Datetime myDT = Datetime.now();
            Date currDate = myDT.date();
            Time currTime = myDT.time();
            //Datetime local = datetime.newinstance(currDate,currTime);
            //myDT = myDT.addhours(5);
            long timestamp = myDT.getTime();
            string timestring = String.Valueof(timestamp);
            blob TS = Blob.valueof(timestring);
            blob encryptedData = Crypto.encrypt('AES256', SFkey,vector,data);
            blob DectyptedData = Crypto.decrypt('AES256', SFkey,vector,encryptedData);
            blob encryptedTS = Crypto.encrypt('AES256', SFkey,vector,TS);
            blob DectyptedTS = Crypto.decrypt('AES256', SFkey,vector,encryptedTS);
            string ExcryptedTring = EncodingUtil.base64Encode(encryptedData);
            string DecryptedTring = EncodingUtil.base64Encode(DectyptedData);
            string DecryptedTring2 = DectyptedData.tostring();
            string EncryptedTSstring = EncodingUtil.base64Encode(encryptedTS);
            string DecryptedTSstring = EncodingUtil.base64Encode(DectyptedTS);
            string DEC_STR = DectyptedTS.ToString();
            System.debug('CHECK THIS -----------KEYBase64------'+SITE_FLEXkey);
            System.debug('CHECK THIS -----------ENCRYPT------'+ExcryptedTring);
            System.debug('CHECK THIS -----------DECRYPT------'+DecryptedTring );
            System.debug('CHECK THIS -----------DECRYPTSTRING------'+DecryptedTring2 );
            System.debug('CHECK THIS -----------TIMESTAMPSTRING------'+myDT );
            System.debug('CHECK THIS -----------TIMESTAMPSTRING LOCAL------'+timestring );
            System.debug('CHECK THIS -----------TIMESTAMPSTRING_ENC------'+EncryptedTSstring );
            System.debug('CHECK THIS -----------TIMESTAMPSTRING_DEC------'+DEC_STR ); 
            string prefix = URL_Parameter__c.getall().get('Flexera_Login').URL_Value__c;
         //   String SITE_GenFLEXurl = 'https://perceptivesoftwareuat.subscribenet.com/control/perc/login?action=authenticate&email='+ExcryptedTring+'&encToken='+EncryptedTSstring+'';
            //String SITE_GenFLEXurl = 'https://perceptivesoftware.subscribenet.com/control/perc/login?&action=authenticate&email='+ExcryptedTring+'&encToken='+EncryptedTSstring+'';
           
            
            ExcryptedTring = EncodingUtil.urlEncode(ExcryptedTring,'UTF-8');
            EncryptedTSstring = EncodingUtil.urlEncode(EncryptedTSstring,'UTF-8');
            
            String SITE_GenFLEXurl = prefix + 'action=authenticate&email='+ExcryptedTring+'&encToken='+EncryptedTSstring+'';   //Praveen Sadineni 05-12
            //SITE_GenFLEXurl =  EncodingUtil.urlEncode(SITE_GenFLEXurl,'UTF-8');
            System.debug('CHECK THIS -----------URL------   '+SITE_GenFLEXurl );
            
            pagereference pg = new pagereference(SITE_GenFLEXurl);
            pg.setredirect(true);
            system.debug('Before return');
        return pg;
    }          
            
            
     //FLexera URL Encryption End-----------------------------------------
        


    
    
    //-------------------------------------------------------------------------------
    // Widgets
    //-------------------------------------------------------------------------------
    
       //Customer Portal
           public list<Perceptive_Site_Content__c> getWidgetCommunity(){
                if (getisLoggedIn()){
                    return getWidget('Community-Internal');
                } else {
                    return getWidget('Community');
                }
           }
         public list<Perceptive_Site_Content__c> getWidgetMedia(){
            return getWidget('Perceptive-Media-Manager');
         }
    
        public list<Perceptive_Site_Content__c> getWidgetBusinessApplications()
        {
            return getWidget('Business-Applications');
            }
       
    //---------------------------Event Resources US1174
         public list<Perceptive_Site_Content__c> getWidgetEventResources()
        {
            return getWidget('Event Resources');
            }
            
            //US1787         
             public list<Perceptive_Site_Content__c> getWidgetEventResourcesPublic()  
        {
            return getWidget('Event Resources Public');
            }
       
       
    //---------------------------------------   
       
                   
           public list<Perceptive_Site_Content__c> getWidgetTraining(){
                if (getisLoggedIn()){
                    return getWidget('Training-Internal');
                } else {
                    return getWidget('Training');
                }
            } 
           
           public list<Perceptive_Site_Content__c> getWidgetSupport(){
            return getWidget('Support');} 
            
           public list<Perceptive_Site_Content__c> getWidgetDownloads(){
            return getWidget('Downloads');} 
           
           public list<Perceptive_Site_Content__c> getWidgetKnowledgeSpotlight(){
            return getWidget('KnowledgeSpotlight');}
            
           public list<Perceptive_Site_Content__c> getWidgetNavToolbarRight(){
            return getWidget('NavToolbarRight');} 
      
       //Developer Network
           public list<Perceptive_Site_Content__c> getWidgetAmazon(){
            return getWidget('Amazon');}     
           
           public list<Perceptive_Site_Content__c> getWidgetResources(){
            return getWidget('Resources');}      
        
        
    //-------------------------------------------------------------------------------
    // Products - Licenses < 30 day old
    //-------------------------------------------------------------------------------
         public List<license_key__c> getRecentLicenses(){
                //license keys last 30 days
                list<license_key__c> Licences = [Select 
                                                        l.Environment_type__c, 
                                                        l.Quantity__c, 
                                                        l.Asset__r.name, 
                                                        l.Asset__r.id,
                                                        l.createddate 
                                                  From License_Key__c l 
                                                  where 
                                                      l.Asset__r.AccountID=:SITE_ACCOUNT.id and
                                                      l.CreatedDate = LAST_N_DAYS:30
                                                  order by 
                                                      createddate desc 
                                                   limit 8];
            return Licences;
        }
    //-------------------------------------------------------------------------------
    // Servers - Verified > 90 Days ago
    //-------------------------------------------------------------------------------
         public List<server__c> getOldServers(){
                list<server__c> servers= [Select 
                                                    s.Server_Type__c, 
                                                    s.machine_name__c, 
                                                    s.Date_Verified_by_Customer__c 
                                              From server__c s 
                                              where 
                                                  s.Account__c=:SITE_ACCOUNT.ID and
                                                      (
                                                          (s.Checkpoint_ID__c!=null AND s.Date_Verified_by_Checkpoint__c < LAST_N_DAYS:90) OR
                                                          (s.Checkpoint_ID__c=null AND (s.Date_Verified_by_Customer__c < LAST_N_DAYS:90  or s.Date_Verified_by_Customer__c=null)) 
                                                      )
                                              order by 
                                                  lastmodifieddate 
                                               limit 8];
            return servers;
        }          
    //-------------------------------------------------------------------------------
    // INSPIRE
    //-------------------------------------------------------------------------------        
       //Dynamic Year
       public string PresentationYear{
           get{
               if(PresentationYear==null) 
                   PresentationYear = Label.Inspire_Year!=''?Label.Inspire_Year:string.valueof(system.today().year()); 
               return PresentationYear; 
               }
            set;} 
            
       
       //Query and Display List of Content - Not Site Specific
       public list<string> getInspireTracks(){ 
                   
                   //Grab distinct tracks              
                     set<string> InspireTracksSet = new set<string>();
                     for(Perceptive_Site_Content__c  x: getInspirePresentations()){
                         InspireTracksSet.add(x.Track__c);
                     }
            
                     //convert to list and sort
                     list<string> Tracks = new list<string>(); 
                         Tracks.addall(InspireTracksSet);
                         Tracks.sort();
               return Tracks;
        } 
       
       public list<Perceptive_Site_Content__c> getInspirePresentations(){
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
                                                                       Type__c='Inspire' and
                                                                       RecordType.Name='Inspire' 
                                                                      and Presentation_Year__c =: PresentationYear 
                                                                      and Presentation_Year__c !=null
                                                                   order by Track__c asc, name 
                                                                   ];
                               
                 
        return siteContent;
        }
}