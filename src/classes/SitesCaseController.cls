/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/
public class SitesCaseController Extends SitesController {

//-------------------------------------------------------------------------------
// Cases Detail
//-------------------------------------------------------------------------------
    private integer MAX_RECORDS = 1000;
    public Case c;
    public string ControllerID;
    public SitesCaseController() {
        ControllerID=ApexPages.currentPage().getParameters().get('id');
        }
    public SitesCaseController(ApexPages.StandardController controller) {
        ControllerID=ApexPages.currentPage().getParameters().get('id');
        }
        
        
    //Get Case Details    
    public case getCase() {
             try{
                     c = [select 
                            CaseNumber,
                            subject, 
                            description,
                            Contact.Name,
                            Contact.Email, 
                            Contact.Phone,
                            Status,
                            Impact__c,
                            Final_Outcome__c,
                            server__r.release_text__c,
                            server__r.machine_name__c,
                            Reason,
                            createddate,
                            closeddate,
                            ProductName__c,
                            AccountId,
                            isclosed
                     from Case 
                     where id=:ControllerID and
                         AccountId=:SITE_ACCOUNT.ID and
                         AccountId!=''
                     ];
              } catch(QueryException e){
                throw new NoDataFoundException();
              }                
        return c;
      }

   //Get Case Comments
   public list<CaseComment> getCaseComments() {
     list<CaseComment> comments = [Select 
                                     Id, 
                                     IsPublished, 
                                     CommentBody, 
                                     CreatedBy.name, 
                                     CreatedDate 
                                   From CaseComment 
                                   where 
                                       IsPublished=true and
                                       parentid=:ControllerID
                                   order by CreatedDate desc
                                   ];
              return Comments;
      }
   
   //Case Attachments
        public list<Attachment> getCaseAttachments() {
            list<Attachment> CaseAttachments= [Select a.Name, 
                                                        a.Description, 
                                                        a.ContentType,
                                                        a.createddate 
                                                 From Attachment a 
                                                 where parentid=:ControllerID
                                                 order by a.createddate desc];

                return CaseAttachments;
        }
        
   //Case Articles
        public list<KnowledgeArticleversion> getCaseArticles() {
            Set<Id> kbIDs = new Set<Id>();
            
            //Get Case Articles
            list<CaseArticle> CaseArticles= [Select 
                                                    c.KnowledgeArticleId,
                                                    c.CaseID
                                                 From CaseArticle c 
                                                 where c.CaseId=:ControllerID
                                               ];
            //Get Article IDS
            for (CaseArticle kav: CaseArticles) {
                  kbIDs.add(kav.KnowledgeArticleId);
                }
            
            //Find Knowledge Articles                                   
            list<KnowledgeArticleversion> Articles = [Select 
                                                          k.title,
                                                          k.KnowledgeArticleId
                                                          From 
                                                          KnowledgeArticleversion k
                                                          where 
                                                              KnowledgeArticleid in: (kbIDs) and
                                                              PublishStatus = 'online'
                                                          order by createdDate desc    
                                                          ];    
          return Articles;
        }
        
   
        
   //Get Case Activity History
   public list<Task> getCaseActivityHistory() {
     //Find Related Tasks           
     list<Task> Tasks = [Select 
                                 activity_subject__c, 
                                 IsVisibleInSelfService, 
                                 Subject, 
                                 CreatedBy.name, 
                                 CreatedDate,
                                 Description 
                           From Task
                           where 
                               IsVisibleInSelfService=true and
                               whatid=:ControllerID
                           order by createdDate Desc    
                               ];
              return Tasks;
      }   
    
//-------------------------------------------------------------------------------
// TASK DETAIL
//------------------------------------------------------------------------------- 
    //Get One Task
   public Task getCaseActivity() {
          Task t;
          try{
             t = [Select 
                         activity_subject__c, 
                         IsVisibleInSelfService, 
                         Subject, 
                         CreatedBy.name, 
                         CreatedDate,
                         Description,
                         isclosed,
                         What.id
                   From Task
                   where 
                       IsVisibleInSelfService=true and
                       id=:ControllerID];
         } catch(QueryException e){
                throw new NoDataFoundException();
         } 
        return t;
      }  
   //Get Task Parent
   public case getActivityCase() {
           //set case information to display                   
              c = [select 
                        casenumber,
                        subject, 
                        createddate,
                        CreatedBy.name, 
                        contact.name,
                        closeddate,
                         AccountId
                 from Case 
                 where id=:getCaseActivity().What.Id];      
         //Throw error for Security      
            if (c.AccountId!=SITE_ACCOUNT.ID){
                throw new NoAccessException();
            }      
       return c;
   }


//-------------------------------------------------------------------------------
// Cases Submit
//-------------------------------------------------------------------------------
   Public pagereference SubmitCase(){
        try{
                insert c;
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting case'));
                ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseController.SubmitCase','High','DML');
                return null;
        }     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Case Comment added successfully'));
        return null;
   }
    
    
    //Case Comment
    Public CaseComment CaseComment{
         get {
              if (CaseComment == null)
                CaseComment = new CaseComment();
              return CaseComment ;
            }
          set;
          }
          
    public PageReference SubmitComment() {
           CaseComment.IsPublished=true;
           CaseComment.parentid=ControllerID;

          try{
              Database.DMLOptions dmo = new Database.DMLOptions();
              dmo.EmailHeader.triggerUserEmail = true;
              database.insert(CaseComment, dmo);
           } catch (DMLException e) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error adding comment'));
                  ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseController.SubmitComment','High','DML');
                  return null;
            } finally {
              CaseComment = new CaseComment(); 
            }
         
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Case Comment added successfully'));
            return null;
          }   
      
    
    public Attachment attachment {
          get {
              if (attachment == null)
                attachment = new Attachment();
              return attachment;
            }
          set;
          }
         
    public PageReference uploadAttachment() {
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = ControllerID; // the record the file is attached to
            //attachment.IsPrivate = true;
            try {
              insert attachment;
            } catch (DMLException e) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                  ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseController.upload','High','DML');
                  return null;
            } finally {
              attachment = new Attachment(); 
            }
         
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
            return null;
          }
      
//-------------------------------------------------------------------------------
// Cases Export
//-------------------------------------------------------------------------------
     /*Cases - Export*/
    Public list<Case> getCasesExport(){
       integer x =0;
       string currentstatus;
       string currentstatus2;
       string CaseType=ApexPages.currentPage().getParameters().get('CaseType');
       
       if (CaseType==null || CaseType==''){
            return null;
       } else{
           //prevent hackers
           CaseType=string.escapeSingleQuotes(CaseType); 
                //currently only handles 2 types   
                list<string> ss = CaseType.split(',');
                for(String s : ss)
                { x++;
                  System.debug('Number:' + x);
                  if (x == 1)
                      {currentstatus=s;}
                  else
                      {currentstatus2=s;}
                }
                System.debug('currentstatus:' + currentstatus);
            if (x==1){
                return getCasesbyStatus(currentstatus,MAX_RECORDS, getRecordTypes());
            } else {
                return getCasesbyStatuses(currentstatus,currentstatus2, MAX_RECORDS, getRecordTypes());
            }   
           
      }
   }
//-------------------------------------------------------------------------------
// Cases Widget
//-------------------------------------------------------------------------------
   
        
               
    /*Cases - Need Attention*/
    Public list<Case> getCasesNeedsAttention(){
           return getCasesbyStatus('Open-Needs Customer Attention',MAX_RECORDS, getRecordTypes());}
           
    /*Cases - Open*/    
    Public list<Case> getCasesOpen(){
           return getCasesbyStatuses('New','Open-Working',MAX_RECORDS, getRecordTypes());}

    /*Cases - On Hold*/    
    Public list<Case> getCasesHold(){
          return getCasesbyStatus('On Hold',MAX_RECORDS, getRecordTypes());}
          
    /*Cases - Closed*/    
    Public list<Case> getCasesClosed(){
          return getCasesbyStatus('Closed',MAX_RECORDS, getRecordTypes());}
    
    /*Call out by Recordtype*/
    private list<RecordType> getRecordTypes(){
        if (SITE_CASE_RECORDTYPE=='Developer Network'){
              //Developer Network
              list<RecordType> rt=  [Select r.id, r.name From RecordType r 
                    where r.SobjectType='case' and  
                          r.IsActive=true and 
                          (r.Name='Developer Network')];
               return rt;
        }         
        else{
              //Everything else is Customer Portal
              list<RecordType> rt=  [Select r.id, r.name From RecordType r 
                    where r.SobjectType='case' and  
                          r.IsActive=true and 
                          (r.Name='Customer Portal' or
                           r.Name='Managed Services' or
                           r.Name='Product Support' or
                           r.Name='Close Product Support Case')];
               return rt;
           }
         }

                
    //Single Status
    Private list<Case> getCasesbyStatus(string Status1, integer rowlimit, list<RecordType> rt){
            list<Case> c = [Select 
                               c.casenumber,
                               c.subject,
                               c.createddate,
                               c.closeddate,
                               c.description,
                               c.Contact.name
                           From Case c 
                           where 
                               accountid=:SITE_ACCOUNT.id and 
                               (Status=:Status1)  and 
                               c.RecordTypeid in: RT
                             order by createddate desc limit: rowlimit]; /*Should never get this high*/
            return c;
    }
    //Double Statuses
    private list<Case> getCasesbyStatuses(string Status1, string Status2, integer rowlimit, list<RecordType> rt){
            list<Case> c = [Select 
                               c.casenumber,
                               c.subject,
                               c.createddate,
                               c.closeddate,
                               c.description,
                               c.Contact.name
                           From Case c 
                           where 
                               accountid=:SITE_ACCOUNT.id and 
                               (Status=:Status1 or Status=:Status2)  and 
                               c.RecordTypeid in: RT 
                            order by createddate desc limit: rowlimit]; /*Should never get this high*/
            return c;
    }
        
//-------------------------------------------------------------------------------
// Test Information
//-------------------------------------------------------------------------------
    


}