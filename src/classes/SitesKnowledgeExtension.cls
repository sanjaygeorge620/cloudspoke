/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011

MiFitzgerald(07/25/2014): Added ViewStat to the queries
*/

Public with sharing class SitesKnowledgeExtension extends SitesController{

//-------------------------------------------------------------------------------
// Article Logic
//-------------------------------------------------------------------------------
//@Kapil(8/29/2013): Addded the try catch statements to fix the Query Exceptions.
    private final id articleid;
    private string articletitle;

    public SitesKnowledgeExtension(ApexPages.StandardController ctl) {
         articleid = ctl.getid();
         showfeedback=true;
    }
    
    //Product Help
    public ProductHelp__kav getProductHelp(){
        ProductHelp__kav ProductHelp;
        try{         
        ProductHelp = [select Title, LastModifiedDate, ArticleNumber, UrlName, HelpURL__c from ProductHelp__kav where PublishStatus='online' and language='en_US'  and (knowledgearticleid=:articleid or id=:articleid) UPDATE VIEWSTAT];
        articletitle = 'ProductHelp: '+ ProductHelp.title;
        }catch(Exception ex){
            system.debug('-->'+ex);
            return null;
        }
        return ProductHelp;
    }
    
    //Product Documents
    public ProductDocuments__kav getProductDoc(){
        ProductDocuments__kav ProductDoc;
        try{
            ProductDoc = [select Title, LastModifiedDate, ArticleNumber, UrlName, HelpURL__c from ProductDocuments__kav where PublishStatus='online' and language='en_US'  and (knowledgearticleid=:articleid or id=:articleid) UPDATE VIEWSTAT];
            articletitle = 'ProductDoc: '+ ProductDoc.title;
        }catch(Exception ex){
            system.debug('-->'+ex);
            return null;    
        }
        return ProductDoc;
    }
    
    //Support Articles
    public Support_Articles__kav getSupportArticle(){
        Support_Articles__kav SupportArticle;
        try{
            SupportArticle = [select Title, LastModifiedDate, ArticleNumber, UrlName, ArticleID__c, Article__c, Issue__c, Resolution__c from Support_Articles__kav where PublishStatus='online' and language='en_US' and (knowledgearticleid=:articleid or id=:articleid) UPDATE VIEWSTAT];
            articletitle = 'SupportArticle: '+ SupportArticle.title;
        }catch(Exception ex){
            system.debug('-->'+ex);
            return null;    
        }
        return SupportArticle;
    } 
    //Technical Overview
    public Technical_Overview__kav getTechnicalOverview(){
        Technical_Overview__kav TechnicalOverview;
        try{
            TechnicalOverview = [select LastModifiedDate,ArticleNumber,ArticleType,Show_Table_of_contents__c,InternalNotes1_Section__c,InternalNotes2_Section__c,InternalNotes3_Section__c,InternalNotes4_Section__c,InternalNotes5_Section__c,InternalNotes6_Section__c,InternalNotes7_Section__c,InternalNotes8_section__c,InternalNotes9_section__c,InternalNotes10_section__c,Section1__c,Section2__c,Section3__c,Section4__c,section5__c,Section6__c,Section7__c,Section8__c,Section9__c,Section10__c,Title,Title1_Section__c,Title2_Section__c,Title3_Section__c,Title4_Section__c,Title5_Section__c,Title6_Section__c,Title7_Section__c,Title8_section__c,Title9_Section__c,Title10_Section__c,Visibility1_Section__c,Visibility2_Section__c,Visibility3_Section__c,Visibility4_Section__c,Visibility5_Section__c,Visibility6_Section__c,Visibility7_Section__c,Visibility8_section__c,Visibility9_section__c,Visibility10_section__c FROM Technical_Overview__kav where PublishStatus='online' and language='en_US' and (knowledgearticleid=:articleid or id=:articleid) UPDATE VIEWSTAT];
            articletitle = 'TechnicalOverview: '+ TechnicalOverview.title;
        }catch(Exception ex){
            system.debug('-->'+ex);
            return null;    
        }
        return TechnicalOverview;
    } 
    
    //Support Troubleshooting
    public Support_Troubleshooting__kav getSupportTroubleshoot(){
        Support_Troubleshooting__kav SupportTroubleshoot;
        try{
            SupportTroubleshoot = [select Title, LastModifiedDate, ArticleNumber, UrlName, ArticleID__c, Issue__c, Resolution__c from Support_Troubleshooting__kav where PublishStatus='online' and language='en_US' and (knowledgearticleid=:articleid or id=:articleid) UPDATE VIEWSTAT];
            articletitle = 'SupportTroubleshoot: '+ SupportTroubleshoot.title;
        }catch(Exception ex){
            system.debug('-->'+ex);
            return null;    
        }
        return SupportTroubleshoot;
    }
    
    //Videos 
    public Video__kav getVideo(){
        Video__kav Video ;
        try{
            Video = [select Title, LastModifiedDate, ArticleNumber, UrlName, Description__c, Video__c from Video__kav where PublishStatus='online' and language='en_US' and (knowledgearticleid=:articleid or id=:articleid) UPDATE VIEWSTAT];
            articletitle = 'Video: '+ Video.title;
        }catch(Exception ex){
            system.debug('-->'+ex);
            return null;    
        }
        return Video;
    }
    
    
       
    public boolean showfeedback{
        get {
              return showfeedback;
            }
          set;
          }
          
    public portal_feedback__c Feedback{
          get {
              if (Feedback == null)
                Feedback = new portal_feedback__c();
              return Feedback;
            }
          set;
          }
          
   public pagereference SubmitFeedback(){
       try{
             Feedback.Reference_ID__c=articleid;
             Feedback.Reference_Title__c = articletitle;
             Feedback.Site__c = SITE_NICKNAME;
             Feedback.User__c = userinfo.getUserId();
             Feedback.Reference_Type__c = 'Knowledge';
             Feedback.Reference_URL__c = site.getCurrentSiteUrl();
           insert Feedback;
       } catch (DMLException e) {
              ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesKnowledgeExtension.SubmitFeedback','Medium','DML');
       } finally{
           showfeedback = false;
           Feedback = new portal_feedback__c();
       }     
       
       return null;
   }
    
}