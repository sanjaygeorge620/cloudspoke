/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public class SitesCaseSubmitController Extends SitesController 
{

//-------------------------------------------------------------------------------
// Cases
//-------------------------------------------------------------------------------
public string ControllerID = ''; 
public string Release{get; set;}
public string categoryID{get; set;}
public string categoryID1{get; set;}
public string categoryID2{get; set;}
public string Brand{get; set;} 
public Product_model__c product{get; set;}
public id SelectedProduct{get; set;}
public id SelectedAccount{get; set;}

           public SitesCaseSubmitController() 
           {        
           //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('acctid'));
            categoryID = '';
            brand = '';
            release = 'N/A';
           }
             
             
    public case NewCase
    {
          get {
              if (NewCase == null)                
                NewCase = new case(Subject=Label.CaseSubmitSubject, Origin='web', Severity__c = 'Low' ,Description=Label.CaseSubmitDescription, recordtypeid = getRecordtypeID('case','product_support'));
                if(ControllerID != '')
                {                
                NewCase.Accountid = ControllerID;
                newCase.ChannelSubmitted__c = True; 
                Product = new Product_model__c();
                }
              return NewCase;
            }
          set;
          }
    public case DevCase{
          get {
              if (DevCase == null)
                DevCase= new case(recordtypeid = getRecordtypeID('case','developer_network'), Origin='web');
              return DevCase;
            }
          set;
          }      
          
    public attachment attachment{
          get {
              if (attachment == null)
                attachment = new attachment();
              return attachment;
            }
          set;
          }      
//-------------------------------------------------------------------------------
// Submit Case - Customer Portal
//-------------------------------------------------------------------------------
  
    
    public pagereference SubmitCase()
    {

             Savepoint CaseSP = Database.setSavepoint();             
             
             if(newCase.ChannelSubmitted__c != True)
             {
                NewCase.Account = SITE_ACCOUNT;             
             }
             system.debug('Site Contact  '+SITE_CONTACT);
                NewCase.contact = SITE_CONTACT;
                NewCase.product__c = SelectedProduct;
                
                if (attachment.name!='' && attachment.name!=null)
                  {
                  NewCase.HasAttachment__c = true;
                  }
               
                try {
                system.debug('Case Details-----'+NewCase);
                      insert NewCase;
                    } catch (DMLException e) {
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting case'));
                          ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseSubmitController.SubmitCase','High','DML');
                          
                          //Rollback
                          Database.rollback(CaseSP);
                      return null;
                    }
                    
                /*Does Attachment Exist?*/
                if (attachment.name!='' && attachment.name!=null)
                {
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = NewCase.ID; // the record the file is attached to
                    try {
                          insert attachment;
                        } catch (DMLException e) {
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error attaching file. ' +e.getMessage()));
                              ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseSubmitController.SubmitCase - AttachFile','High','DML');
                              
                              //Rollback
                              Database.rollback(CaseSP);
                          return null;
                        }
                 }
                    
                    //Redirect to case details
                    PageReference Pg;
                    if(newCase.ChannelSubmitted__c == True)
                    {
                    Pg = page.casedetails_Channel;
                    Pg.getParameters().put('id', NewCase.Id);
                    Pg.setRedirect(true);                    
                    }
                    else
                    {
                    
                    Pg = page.casedetails;
                    Pg.getParameters().put('id', NewCase.Id);
                    Pg.setRedirect(true);
                    }
                  return Pg;
        }
        
     public pagereference routecase()
     {
     
     PageReference Pg;
     
           if(SelectedAccount == null)  
           {       
                    Pg = page.CaseWebSubmit_Channel;                    
                    Pg.setRedirect(true);
                    }
     
     else
     {
              
                    Pg = page.casewebsubmit;  
                    Pg.getParameters().put('acctid',SelectedAccount);                  
                    Pg.setRedirect(true);
     
     
     }
     return pg;
     
     }   
        
     public pagereference SubmitFeedback(){  
          string FeedbackDescription = '';
          /*Build Description Notification*/
          FeedbackDescription = 'Case deflected from WebSubmit \n Subject: '+FormatNullValues(NewCase.Subject);
          FeedbackDescription += '\n Description: '+FormatNullValues(NewCase.Description);
          
          if (getServer()!=null)
          {    
              FeedbackDescription += '\n Server: '+FormatNullValues(getServer().Machine_Name__c)+' '+FormatNullValues(getServer().Server_Type__c);
              FeedbackDescription += '\n Release: '+FormatNullValues(getServer().Release__r.name);
              FeedbackDescription += '\n Platform: '+FormatNullValues(getServer().Platform__c)+' '+FormatNullValues(getServer().Platform_Version__c);
              FeedbackDescription += '\n Database: '+FormatNullValues(getServer().Database__c) +' '+FormatNullValues(getServer().Database_Version__c);
              FeedbackDescription += '\n Product: '+FormatNullValues(SelectedProduct);                  
          }
          
          portal_feedback__c feedback = new portal_feedback__c();
             feedback.User__c = userInfo.getUserId(); //USER ID
             feedback.Reference_Title__c = 'Found KB Article'; //Article Title
             feedback.Reference_Type__c = 'CaseWebSubmit'; //Reference Type
             feedback.Comment__c = FeedbackDescription;
             feedback.Site__c = SITE_NICKNAME; 
          try {
              insert feedback; 
          } catch (DMLException e) {
                  //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error Submitting Feedback. ' +e.getMessage()));
                  ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseSubmitController.SubmitFeedback','High','DML');
          }
           //redirect back to cases  
          PageReference Pg;
            Pg = page.cases;
            Pg.setRedirect(true);
          return Pg;
              
     
     } 
//-------------------------------------------------------------------------------
// Submit Case - Developer Network
//-------------------------------------------------------------------------------          
       public pagereference SubmitDevCase(){
             
             Savepoint CaseSP = Database.setSavepoint();
             
                DevCase.Account = SITE_ACCOUNT;
                DevCase.contact = SITE_CONTACT;
                  
                try {
                      insert DevCase;
                    } catch (DMLException e) {
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting case'));
                          ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseSubmitController.SubmitDevCase','High','DML');
                          
                          
                          //Rollback
                          Database.rollback(CaseSP);
                          return null;
                    }
                
                if (attachment.name!='' && attachment.name!=null){
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = DevCase.ID; // the record the file is attached to
                    try {
                          insert attachment;
                        } catch (DMLException e) {
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error attaching file. ' +e.getMessage()));
                              ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesCaseSubmitController.SubmitCase - AttachFile','High','DML');
                              
                              //Rollback
                                  Database.rollback(CaseSP);
                              return null;
                        }
                }    
                    //Redirect to case details
                    PageReference Pg;
                    Pg = page.casedetails;
                    Pg.getParameters().put('id', DevCase.Id);
                    Pg.setRedirect(true);
                  return Pg;
        }   
//-------------------------------------------------------------------------------
// Servers & Assets
//-------------------------------------------------------------------------------
    //Servers      
    public List<SelectOption> getServers() 
    {
    List<Server__c> Servers = new List<Server__c>();
   
   
    if(newCase.ChannelSubmitted__c = True && ControllerID != '')
    {
    Servers= [select 
                                                s.Machine_Name__C, 
                                                s.Server_Type__C 
                                          from server__c s 
                                          where s.Account__C =: ControllerID
                                          order by s.Machine_Name__C NULLS LAST 
                                                   ];
    
    
    }
    else 
    {
                 Servers= [select 
                                                s.Machine_Name__C, 
                                                s.Server_Type__C 
                                          from server__c s 
                                          where s.Account__C =: SITE_ACCOUNT.ID
                                          order by s.Machine_Name__C NULLS LAST 
                                                   ];
    }
                                                   
                List<SelectOption> options = new List<SelectOption>();
                        options.add(new SelectOption('','-- None --'));
                        for (server__c r : Servers) {
                                    options.add(new SelectOption(r.id, FormatNullValues(r.server_type__c) + ' - ' + FormatNullValues(r.Machine_Name__c)));
                                    }
                    return options;
          } 
          
    //get server details to show
    public Server__c getServer()
    {
    categoryID = '';
        server__c CurrentEnvironment = new server__c();
        List<Server__c> Servers= [select 
                                        s.Machine_Name__c, 
                                        s.Server_Type__c, 
                                        s.Release__r.name, 
                                        s.Release__r.Major__c, 
                                        s.Release__r.Minor__c,                                                                                 
                                        s.Platform__c, 
                                        s.Platform_Version__c,             
                                        s.Database__c, 
                                        s.Database_Version__c
                                  from server__c s 
                                  where id =:NewCase.Server__c];
        for (server__c s : Servers) 
        {
                CurrentEnvironment = s;
                
        }  
             
     categoryID = string.valueof(CurrentEnvironment.Release__r.Major__c)+'_'+string.valueof(CurrentEnvironment.Release__r.Minor__c); 
     
     system.debug('xxx@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +NewCase.Server__c);                      
     system.debug('xxx@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +CurrentEnvironment.Release__r.Major__c+'_'+CurrentEnvironment.Release__r.Minor__c);        
     system.debug('xxx@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +categoryID);        
            
    return CurrentEnvironment;
    }
    
    
      
    public void Getbrand()
    {  
   
    system.debug('xxx@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +selectedProduct);
    string prefix = 'Release:';
    categoryID1 = '';
    categoryID2 = '';
        if(selectedProduct != null)
        {
        Product = [Select ID,Brand__c from product_model__c where id =:selectedProduct][0];
        brand = Product.brand__c;      
        system.debug('xxx@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +brand);        
        if(ReleasePrefix__c.getall().containskey(brand))
        {
        prefix = prefix + ReleasePrefix__c.getall().get(brand).Prefix__c;
        }
        else
        {
        prefix = prefix + ReleasePrefix__c.getall().get('Perceptive').Prefix__c;        
        }             
   
        categoryID1 = prefix + categoryID;
        }
        else
        {
        prefix = prefix + ReleasePrefix__c.getall().get('Perceptive').Prefix__c;        
        categoryID1 = prefix + categoryID;  
        } 
        categoryID2 = categoryID1;
        system.debug('xxx@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' +categoryID2);                   
    }   
           
    //Assets      
    public List<SelectOption> getProducts() 
    {
    //system.debug('sssss');
    
                /*Grouping Assets together by Model Name*/
                List<AggregateResult> products= [Select max(a.Product_Model__c) ASSET_PRODUCTID,
                                                        a.Product_Model__r.name  ASSET_PRODUCT
                                                 From Asset a 
                                                 where   a.server__C =:NewCase.Server__c and 
                                                         a.Product_Model__c <> '' 
                                                 group by a.Product_Model__r.name
                                                 order by a.Product_Model__r.name  asc];
            list<SelectOption> options = new list<SelectOption>();            
                    options.add(new SelectOption('','-- None --'));
                    for (AggregateResult r : products) {
                        options.add(new SelectOption((string)r.get('ASSET_PRODUCTID'),(String)r.get('ASSET_PRODUCT')));                       
                     }
                    
                      List<AggregateResult> products1 = [select max(Asset__r.Product_Model__c) ASSET_PRODUCTID,Asset__r.Product_Model__r.name  ASSET_PRODUCT from Asset_Item__c  
                                                         where Id IN (select Asset_Item__c from Server_Asset_Association__c where server__c =:NewCase.Server__c and 
                                                         Asset_Item__r.Asset__r.Product_Model__c <> '') group by Asset__r.Product_Model__r.name order by Asset__r.Product_Model__r.name  asc];
                       for (AggregateResult r : products1) 
                       {
                        options.add(new SelectOption((string)r.get('ASSET_PRODUCTID'),(String)r.get('ASSET_PRODUCT')));
                        
                       }  
                     
                  return options;                 
          }    
          
          public List<SelectOption> getCustomers() {
                /*Grouping Assets together by Model Name*/
                system.debug('My Site_Account   '+SITE_ACCOUNT.ID);
            list<Account> custacct = [Select ID,name from Account where Reseller_ID__c =: SITE_ACCOUNT.ID order by name limit 500];    
            list<SelectOption> options = new list<SelectOption>();
                    options.add(new SelectOption('','-- None --'));
                    if(!custacct.isempty())
                    {
                    for (Account r : custacct) 
                     {
                        options.add(new SelectOption((string)r.ID,(String)r.name));
                     }
                     }
                return options;
          }      
          
          
            
          
    private string FormatNullValues(string myval){
    /*Formatting Values*/
          if (myval==null){
              myval=' ';
          }
          return myval;
          }
                
    
          

}