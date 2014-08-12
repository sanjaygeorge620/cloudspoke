/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/
public class SitesCaseController_Channel Extends SitesController {

//-------------------------------------------------------------------------------
// Cases Detail
//-------------------------------------------------------------------------------
    private integer MAX_RECORDS = 1000;
    public Case c;
    public string ControllerID;
    List<Account> custlst = new List<Account>();
    public SitesCaseController_Channel() {
        custlst = [Select ID from Account where Reseller_ID__c =: SITE_ACCOUNT.id limit 500]; 
        ControllerID=ApexPages.currentPage().getParameters().get('id');
        }
    public SitesCaseController_Channel(ApexPages.StandardController controller) {
        ControllerID=ApexPages.currentPage().getParameters().get('id');
        }
        
        
    //Get Case Details    
    public case getCase() {
             try{
                     c = [select 
                            CaseNumber,
                            subject ,
                            description,
                            Contact.Name,
                            Contact.Email, 
                            Contact.Phone,
                            Status,
                            createddate,
                            closeddate,
                            AccountId,
                            ownerID,
                            Type
                          
                     from Case 
                     where id=:ControllerID and
                          AccountId!=''
                     ];
              } catch(QueryException e){
                throw new NoDataFoundException();
              }                
        return c;
      }

  
        
   
        
   
    



//-------------------------------------------------------------------------------
// Cases Submit
//-------------------------------------------------------------------------------
   Public pagereference SubmitCase(){
        try{
        
             if(c!= null)
                {
                    insert c;
                }
                else
                System.debug('No Case to Insert');
        
     
                //insert c;
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting case'));
                ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseController.SubmitCase','High','DML');
                return null;
        }     
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Case Comment added successfully'));
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
        
              //Everything else is Customer Portal  
             
              list<RecordType> rt=  [Select r.id, r.name From RecordType r 
                    where r.SobjectType='case' and  
                          r.IsActive=true and 
                          (r.Name='Partner-Channel'or
                           r.Name='Customer Portal' or
                           r.Name='Managed Services' or
                           r.Name='Product Support' or
                           r.Name='Close Product Support Case')];
               return rt;
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
                             
            
             
             Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
              Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
              Id rtId;
              if(status1 == 'closed')
              {
              rtId = rtMap.get('Close Product Support Case').getRecordTypeId();     
             }
             else
             {
              rtId = rtMap.get('Product Support').getRecordTypeId();
             
             }
             
             if(!custlst.isempty())
             {
             list<case> d = [Select 
                               c.casenumber,
                               c.subject,
                               c.createddate,
                               c.closeddate,
                               c.description,
                               c.Contact.name
                           From Case c 
                           where 
                               accountid in: custlst and 
                               (Status=:Status1)  and 
                               c.RecordTypeid =: rtid and ChannelSubmitted__c = true
                            order by createddate desc limit: rowlimit]; /*Should never get this high*/  
                            
                      c.addall(d);                                                
             
                 }            
                             
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
             
             
             
             Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
              Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
             Id rtId = rtMap.get('Product Support').getRecordTypeId();              
           
            if(!custlst.isempty())
             {                 
            list<case> d = [Select 
                               c.casenumber,
                               c.subject,
                               c.createddate,
                               c.closeddate,
                               c.description,
                               c.Contact.name
                           From Case c 
                           where 
                               accountid in: custlst and 
                               (Status=:Status1 or Status=:Status2)  and 
                               c.RecordTypeid =: rtid and ChannelSubmitted__c = true
                            order by createddate desc limit: rowlimit]; /*Should never get this high*/  
                            
                      c.addall(d);                                                
                 }           
            return c;
    }
        
//-------------------------------------------------------------------------------
// Test Information
//-------------------------------------------------------------------------------
    


}