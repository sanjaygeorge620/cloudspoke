/*
    Created by Michael Fitzgerald
    Date: June 2014
    Description: Search for duplicates within Data.com.

*/
public without sharing class datacom_lead {
    private class DataDotComException extends Exception{}   
    public  integer PARAM_QUERY_SIZE {get{return 100;}set;}
    private integer PARAM_DEFAULT_PAGE_SIZE = 5;
    public  integer PARAM_DEFAULT_PAGE_SIZE_LEAD {get{if(PARAM_DEFAULT_PAGE_SIZE_LEAD==null)PARAM_DEFAULT_PAGE_SIZE_LEAD = PARAM_DEFAULT_PAGE_SIZE;return PARAM_DEFAULT_PAGE_SIZE_LEAD;}set;}
    public  integer PARAM_DEFAULT_PAGE_SIZE_ACCOUNT {get{if(PARAM_DEFAULT_PAGE_SIZE_ACCOUNT==null)PARAM_DEFAULT_PAGE_SIZE_ACCOUNT= PARAM_DEFAULT_PAGE_SIZE;return PARAM_DEFAULT_PAGE_SIZE_ACCOUNT;}set;}
    public  integer PARAM_DEFAULT_PAGE_SIZE_CONTACT {get{if(PARAM_DEFAULT_PAGE_SIZE_CONTACT==null)PARAM_DEFAULT_PAGE_SIZE_CONTACT= PARAM_DEFAULT_PAGE_SIZE;return PARAM_DEFAULT_PAGE_SIZE_CONTACT;}set;}
    public  integer PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCOMPANY {get{if(PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCOMPANY==null)PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCOMPANY= PARAM_DEFAULT_PAGE_SIZE;return PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCOMPANY;}set;}
    public  integer PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCONTACT {get{if(PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCONTACT==null)PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCONTACT= PARAM_DEFAULT_PAGE_SIZE;return PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCONTACT;}set;}

    public boolean runSearch{get;set;}
    public lead l{get;set;}
    
    //==========================================================================================
    // CONSTRUCTOR
    //==========================================================================================
        public datacom_lead(){
           runSearch = false;
           
           //instantiate new Lead to search against and hold values.
           //l = new lead(company='Google*', City='', State='', PostalCode='', Physical_Country__c='USA');
             l = new lead();
           
           //Preselect recordtype based on url parameters 
           string recordtype = ApexPages.currentPage().getParameters().get('RecordType');
           if(!string.isblank(recordtype)) l.RecordTypeid=RecordType;
        }

    //==========================================================================================
    // ACTION UTILITIES
    //==========================================================================================
        public void Search(){
            runSearch = true;
            
            //Simply reset to null, the next time the table is rerendered the table will be requeried
                PARAM_DEFAULT_PAGE_SIZE_LEAD = null;
                PARAM_DEFAULT_PAGE_SIZE_ACCOUNT = null;
                PARAM_DEFAULT_PAGE_SIZE_CONTACT = null;
                PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCOMPANY=null;
                PARAM_DEFAULT_PAGE_SIZE_DATACLOUDCONTACT=null;
            
            //Reset jigsaw ids
                ExistingJigsawRecords = null;

            //Requery records
                Leads = null;
                Accounts  = null;
                Contacts = null;
                DatacloudCompanies = null;
                DatacloudContacts = null;
            
        }
    
        private string encode(string v){
            system.debug('v: ' +v);
            if(v==null || v=='')
                return '';
             return (v);
        }
        
        private string condition(string v){
            v = string.escapeSingleQuotes(v);
            if(v==null || v ==''){
                return v;
            }else if(v.contains('*')){
                return v.replaceAll('\\*','\\%');
            }else {    
                return v + '%'; //Requested to have end wildcard
            }    
        }
        private string condition_bookmarks(string v){
            v = string.escapeSingleQuotes(v);
            if(v==null || v ==''){
                return v;
            }else if(v.contains('*')){
                return v.replaceAll('\\*','\\%');
            }else {    
                return '%' + v + '%'; //Requested to have end wildcard
            }    
        }
        
        private string condition_nolike(string v){
            v = string.escapeSingleQuotes(v);
            if(v==null || v ==''){
                return v;
            }else if(v.contains('*')){
                return v.replaceAll('\\*',''); //Don't replace with %
            }else {    
                return v;
            }    
        }
        
        public map<string,recordtype> LeadRecordtypes{
            get{
                if(LeadRecordtypes==null){
                    LeadRecordtypes = new map<string,recordtype>();
                    for(recordtype x: [SELECT Id, Description, DeveloperName, Name FROM RecordType WHERE SobjectType = 'lead' AND IsActive = true order by name]){
                        LeadRecordtypes.put(x.id, x);
                    }
                }
                return LeadRecordtypes;
            }
            set;
        }
        
        //prevents data.com records being presented with existing data.com ids.
        public set<string> ExistingJigsawRecords{
        get{
            if(ExistingJigsawRecords==null){
                 ExistingJigsawRecords = new set<string>();
            }
            return ExistingJigsawRecords;
        }
        set;
    }
        
    //==========================================================================================
    // PAGE REFERENCES
    //==========================================================================================    
       public string selectedCompanyid{get;set;}
       public pagereference purchaseCompany(){
           try {
               if(!DataDotComServices.purchaseRecord(selectedCompanyid, '1', 'Lead Creation Process (Buy Company)'))
               return null;     
               
               PageReference Pg = page.datacom_purchase;
                          Pg.getParameters().put('type', '1');
                          Pg.getParameters().put('rid', selectedCompanyid);
                          Pg.getParameters().put('RecordType', l.recordtypeid);
                          Pg.setRedirect(true);
                    return Pg; 
           }catch(exception e){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getmessage() + ' #' + e.getLineNumber()));
               return null; 
           }    
       }
       
       public string selectedContactid{get;set;}
       public pagereference purchaseContact(){
           try {
                   if(!DataDotComServices.purchaseRecord(selectedContactid, '0', 'Lead Creation Process (Buy Contact)'))
                   return null;
                   
                   PageReference Pg = page.datacom_purchase;
                          Pg.getParameters().put('type', '0');
                          Pg.getParameters().put('rid', selectedContactid);
                          Pg.getParameters().put('RecordType', l.recordtypeid);
                          Pg.setRedirect(true);
                    return Pg; 
           }catch(exception e){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getmessage() + ' #' + e.getLineNumber()));
               return null; 
           } 
       }
       
        //Controls which sobject is visible
         public  void viewMore(){
            //Action to show more records
         }
        
         
         private boolean AddtoAccountTeam(string accountid, string userid, string TeamMemberRole){
              system.debug(accountid+ ' ' + userid + ' ' + TeamMemberRole);
              Savepoint sp = Database.setSavepoint();
              try{
                  
                  List<AccountTeamMember> ATeam = [SELECT id FROM AccountTeamMember where AccountId =:accountid and userid=:userid];
                  //Does the user exist on the account team? Add them if they don't exist
                  if(ATeam.size()!=0){
                      return true; //already has access
                  }else{
                      //Add to team
                      AccountTeamMember atm = new AccountTeamMember();
                      atm.userid = userid;
                      atm.AccountId = accountid;
                      atm.TeamMemberRole = TeamMemberRole;
                      insert atm;
                      
                      AccountShare newShare = new AccountShare();
                          newShare.UserOrGroupId= UserId;
                          newShare.AccountId=Accountid;
                          newShare.AccountAccessLevel='Edit';
                          newShare.OpportunityAccessLevel='Edit';
                          newShare.CaseAccessLevel='Edit';
                      insert newShare;
                          
                      feeditem f = new feeditem();
                               f.parentid = Accountid;
                               f.Title = 'Account Team Addition';
                               f.body = userinfo.getFirstName() + ' ' + userinfo.getLastName() + ' has been added to the account team.';  
                          insert f;
                      return true;
                  }
              }catch(exception e){
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, e.getmessage()));
                  system.debug(e.getmessage());
                  Database.rollback(sp);
              }
              return false;
          }
                      
         public pagereference sendEmail2AccountOwner_Contact(){
            for(objContact x: Contacts){
                if(x.Accountteam){
                    if(x.Obj.Account.TR_Status__c =='Off' && AddtoAccountTeam(x.Obj.Account.id,  userinfo.getuserid(), 'Account Manager') ==true){
                        //redirect to account
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm, 'You have been added to the account team.'));
                        PageReference Pg= new ApexPages.StandardController(new account(id=x.Obj.Account.id)).view();
                        Pg.setRedirect(true);
                        return Pg;
                    } else {
                        String fullURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + x.Obj.Account.id;
                        PageReference Pg = new PageReference('/_ui/core/email/author/EmailAuthor');
                              Pg.getParameters().put('rtype', ('003'));
                              Pg.getParameters().put('p6', ('Account Team Request for ' + x.Obj.Account.Name));
                              Pg.getParameters().put('p7', ('Please add me to the ' + x.Obj.Account.Name + ' (' + fullURL +') Account Team, I have a potential lead.'));
                              Pg.getParameters().put('p24', (x.Obj.Account.Owner.email));
                              Pg.setRedirect(true);
                        return Pg; 
                     }   
                }
            }
            return null;
            
        }
         public pagereference sendEmail2AccountOwner_Account(){
            for(objAccount x: Accounts){
                if(x.Accountteam){
                    if(x.obj.TR_Status__c =='Off' && AddtoAccountTeam(x.Obj.id,  userinfo.getuserid(), 'Account Manager') ==true){
                        //redirect to account
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm, 'You have been added to the account team.'));
                        PageReference Pg= new ApexPages.StandardController(new account(id=x.Obj.id)).view();
                        Pg.setRedirect(true);
                        return Pg;
                    } else {
                        //email
                        String fullURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + x.Obj.id;
                        PageReference Pg = new PageReference('/_ui/core/email/author/EmailAuthor');
                              Pg.getParameters().put('rtype', ('003'));
                              Pg.getParameters().put('p6', ('Account Team Request for ' + x.Obj.Name));
                              Pg.getParameters().put('p7', ('Please add me to the ' + x.Obj.Name + ' (' + fullURL +') Account Team, I have a potential lead.'));
                              Pg.getParameters().put('p24', (x.Obj.Owner.email));
                              Pg.setRedirect(true);
                        return Pg; 
                    }      
                }
            }
           return null;
        }    
        
        public pagereference Skip(){
            PageReference Pg = new PageReference('/' + Lead.sObjectType.getDescribe().getKeyPrefix() + '/e');
                          Pg.getParameters().put('lea3', encode(l.company));
                          Pg.getParameters().put('name_firstlea2', encode(l.firstname));
                          Pg.getParameters().put('name_lastlea2', encode(l.lastname));
                          Pg.getParameters().put('lea11', encode(l.email));
                          Pg.getParameters().put('lea8', encode(l.phone));
                          Pg.getParameters().put('lea16street', encode(l.street));
                          Pg.getParameters().put('lea16city', encode(l.city));
                          Pg.getParameters().put('lea16state', encode(l.state));
                          Pg.getParameters().put('lea16zip', encode(l.postalcode));
                          Pg.getParameters().put('lea16country', encode(l.Physical_Country__c)); 
                          Pg.getParameters().put('00Nf0000000r0F7', '0'); //Was Data.com Used?
                          Pg.getParameters().put('retURL', (Apexpages.currentPage().getUrl()));
                          Pg.getParameters().put('RecordType', encode(l.recordtypeid));
                          Pg.getParameters().put('ent', 'Lead');
                          Pg.getParameters().put('nooverride', '1');
                          Pg.setRedirect(true);
            return Pg; 
        }
    
        public pagereference Cancel(){
            string returl = ApexPages.currentPage().getParameters().get('retURL');
                
            PageReference Pg;
            
            //Redirect back to returl or tab.
            if(returl!=null && returl!=''){
                Pg = new PageReference(retURL);
            }else{    
                Pg = new PageReference('/' + Lead.sObjectType.getDescribe().getKeyPrefix() + '/o');
            }    
            Pg.setRedirect(true);
            return Pg; 
        }
    
    
    
    
    //==========================================================================================
    // SEARCH LEADS
    //==========================================================================================    
        public list<Lead> Leads{
            get{
                if(Leads==null ){
                    boolean runQuery = false; //Boolean value determines if we have enough to query.
                   try{
                        string SOQL  = 'SELECT Name, FirstName, LastName, Email, Title, Phone, Company, Street, City, State, PostalCode, Country, Ownerid, Jigsaw FROM Lead';
                              SOQL  +=' WHERE isconverted=false ';
                              if(!string.isblank(l.FirstName)){
                                  SOQL  +=' AND FirstName LIKE \'' + condition(l.FirstName) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.LastName)){
                                  SOQL  +=' AND LastName LIKE \'' + condition(l.LastName) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Email)){
                                  SOQL  +=' AND Email = \'' + condition_nolike(l.Email) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Phone)){
                                  SOQL  +=' AND Phone LIKE \'' + condition(l.Phone) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Title)){
                                  SOQL  +=' AND Title LIKE \'' + condition(l.Title) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.Company)){
                                  SOQL  +=' AND Company LIKE \'' + condition(l.Company) + '\' ';
                                  runQuery = true;
                              }   
                              if(!string.isblank(l.Street)){    
                                  SOQL  +=' AND Street LIKE \'' + condition_bookmarks(l.Street) + '\' ';
                                  runQuery = true;
                              }  
                              if(!string.isblank(l.City)){  
                                  SOQL  +=' AND City LIKE \'' + condition(l.City) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.State)){    
                                  SOQL  +=' AND State LIKE \'' + condition(l.State) + '\' ';
                                  runQuery = true;
                              } 
                              if(!string.isblank(l.PostalCode)){   
                                  SOQL  += ' AND PostalCode LIKE \'' + condition(l.PostalCode) + '\' ';
                                  runQuery = true;
                              }
                             if(!string.isblank(l.Physical_Country__c)){   
                                  SOQL  += ' AND Country LIKE \'' + condition(l.Physical_Country__c) + '\' ';
                                  runQuery = true;
                              }  
                              if(!string.isblank(l.CompanyDunsNumber)){   
                                  SOQL  += ' AND CompanyDunsNumber LIKE \'' + condition(l.CompanyDunsNumber) + '\' ';
                                  runQuery = true;
                              }    
                              SOQL  +=' limit ' + PARAM_QUERY_SIZE;
                              system.debug(SOQL);
                        
                        Leads = new list<Lead>(); 
                        if(runQuery && runSearch){
                            for(Lead a:Database.query(SOQL)){
                                //prevent dupes when querying data.com
                                ExistingJigsawRecords.add(a.jigsaw);
                                Leads.add(a);
                            }
                        }    
                    }catch(exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
                        Leads = new list<Lead>(); 
                    }    
                }
                return Leads;
            }
            set;
        
        }
    
    //==========================================================================================
    // SEARCH CONTACTS
    //==========================================================================================
        public list<objContact> Contacts{
            get{
                if(Contacts==null){
                    boolean runQuery = false; //Boolean value determines if we have enough to query.
                   try{
                        string SOQL  = 'SELECT Name, FirstName, LastName, Email, Title, Phone, Account.id, Account.TR_Status__c, Account.Name, Account.ownerid, Account.owner.email, Account.owner.Name, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Ownerid, Jigsaw FROM Contact';
                              SOQL  +=' WHERE AccountID!=null AND recordtype.developername=\'LX_Business_Contact\' ';
                              if(!string.isblank(l.FirstName)){
                                  SOQL  +=' AND FirstName LIKE \'' + condition(l.FirstName) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.LastName)){
                                  SOQL  +=' AND LastName LIKE \'' + condition(l.LastName) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Email)){
                                  SOQL  +=' AND Email = \'' + condition_nolike(l.Email) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Phone)){
                                  SOQL  +=' AND Phone LIKE \'' + condition(l.Phone) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Title)){
                                  SOQL  +=' AND Title LIKE \'' + condition(l.Title) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.Company)){
                                  SOQL  +=' AND Account.Name LIKE \'' + condition(l.Company) + '\' ';
                                  runQuery = true;
                              }   
                              if(!string.isblank(l.Street)){    
                                  SOQL  +=' AND MailingStreet LIKE \'' + condition_bookmarks(l.Street) + '\' ';
                                  runQuery = true;
                              }  
                              if(!string.isblank(l.City)){  
                                  SOQL  +=' AND MailingCity LIKE \'' + condition(l.City) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.State)){    
                                  SOQL  +=' AND MailingState LIKE \'' + condition(l.State) + '\' ';
                                  runQuery = true;
                              } 
                              if(!string.isblank(l.PostalCode)){   
                                  SOQL  += ' AND MailingPostalCode LIKE \'' + condition(l.PostalCode) + '\' ';
                                  runQuery = true;
                              }
                             if(!string.isblank(l.Physical_Country__c)){   
                                  SOQL  += ' AND MailingCountry LIKE \'' + condition(l.Physical_Country__c) + '\' ';
                                  runQuery = true;
                              }  
                               /* NOT FILTERABLE  removing results to prevent confusion*/
                              if(!string.isblank(l.CompanyDunsNumber)){   
                                  runQuery = false;
                              }     
                              SOQL  +=' limit ' + PARAM_QUERY_SIZE;
                              system.debug(SOQL);
                        
                        Contacts = new list<objContact>(); 
                        if(runQuery && runSearch){
                            for(contact r:Database.query(SOQL)){
                                //prevent dupes when querying data.com
                                ExistingJigsawRecords.add(r.jigsaw);
                                Contacts.add(new objContact(r));
                            }
                        }    
                    }catch(exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
                        Contacts = new list<objContact>(); 
                    }    
                }
                return Contacts;
            }
            set;
        
        }
    
    //==========================================================================================
    // SEARCH ACCOUNTS
    //==========================================================================================
        public list<objAccount> Accounts{
            get{
                if(Accounts==null){
                    boolean runQuery = false; //Boolean value determines if we have enough to query.
                   try{
                        string SOQL  = 'SELECT Name, TR_Status__c, Party_Role__c, Party_Type__c, RecordType.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Ownerid, Owner.Email, Jigsaw FROM Account ';
                              if(l.recordtypeid!=null && LeadRecordtypes.containskey(l.recordtypeid) && LeadRecordtypes.get(l.recordtypeid).developername.containsignorecase('customer')){
                                 SOQL  +=' WHERE (recordtype.developername=\'Lx_Location_Customer\')';
                              }else if(l.recordtypeid!=null && LeadRecordtypes.containskey(l.recordtypeid) && LeadRecordtypes.get(l.recordtypeid).developername.containsignorecase('partner')){
                                 SOQL  +=' WHERE (recordtype.developername=\'Lx_Location_Partner\')';       
                              }else{
                                  SOQL  +=' WHERE (recordtype.developername=\'Lx_Location_Customer\' OR recordtype.developername=\'Lx_Location_Partner\')';
                              }                            
                              if(!string.isblank(l.Company)){
                                  SOQL  +=' AND Name LIKE \'' + condition(l.Company) + '\' ';
                                  runQuery = true;
                              }   
                              if(!string.isblank(l.Street)){    
                                  SOQL  +=' AND BillingStreet LIKE \'' + condition_bookmarks(l.Street) + '\' ';
                                  runQuery = true;
                              }  
                              if(!string.isblank(l.City)){  
                                  SOQL  +=' AND BillingCity LIKE \'' + condition(l.City) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.State)){    
                                  SOQL  +=' AND BillingState LIKE \'' + condition(l.State) + '\' ';
                                  runQuery = true;
                              } 
                              if(!string.isblank(l.PostalCode)){   
                                  SOQL  += ' AND BillingPostalCode LIKE \'' + condition(l.PostalCode) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.Physical_Country__c)){   
                                  SOQL  += ' AND BillingCountry LIKE \'' + condition(l.Physical_Country__c) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.CompanyDunsNumber)){   
                                  SOQL  += ' AND DunsNumber LIKE \'' + condition(l.CompanyDunsNumber) + '\' ';
                                  runQuery = true;
                              }
                              
                              SOQL  +=' limit ' + PARAM_QUERY_SIZE;
                              system.debug(SOQL);
                        
                        Accounts = new list<objAccount>(); 
                        if(runQuery && runSearch){
                            for(Account r:Database.query(SOQL)){
                                //prevent dupes when querying data.com
                                ExistingJigsawRecords.add(r.jigsaw);
                                Accounts.add(new objAccount(r));
                            }
                        }    
                    }catch(exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
                        Accounts = new list<objAccount>(); 
                    }    
                }
                return Accounts;
            }
            set;
        
        }
    
      
    
    //==========================================================================================
    // SEARCH DataCloudCompany
    //==========================================================================================
        public list<objDataCloudCompany> DataCloudCompanies{
            get{
                if(DatacloudCompanies==null){
                    boolean runQuery = false; //Boolean value determines if we have enough to query.
                   try{
                        string SOQL  = 'SELECT Id, City, CompanyId, Country, Description, DunsNumber, ExternalId, Fax, Industry, IsInactive, IsOwned, NaicsCode, NaicsDesc, Name, NumberOfEmployees, Ownership, Phone, Sic, SicDesc, Site, State, Street, TickerSymbol, TradeStyle, Website, YearStarted, Zip FROM DatacloudCompany ';
                              SOQL  +=' WHERE (IsInactive = false) ';
                              if(!string.isblank(l.Company)){
                                  SOQL  +=' AND Name like \'' + condition_nolike(l.Company) + '\' ';
                                  runQuery = true;
                              }   
                              /*
                              if(!string.isblank(l.Street)){    
                                  SOQL  +=' AND Street = \'' + condition_nolike(l.Street) + '\' ';
                                  runQuery = true;
                              } 
                              */ 
                              if(!string.isblank(l.City)){  
                                  SOQL  +=' AND City LIKE \'' + condition_nolike(l.City) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.State)){    
                                  SOQL  +=' AND State = \'' + condition_nolike(l.State) + '\' ';
                                  runQuery = true;
                              } 
                              if(!string.isblank(l.PostalCode)){   
                                  SOQL  += ' AND Zip like \'' + condition_nolike(l.PostalCode) + '\' ';
                                  runQuery = true;
                              }
                             if(!string.isblank(l.Physical_Country__c)){   
                                  SOQL  += ' AND Country = \'' + condition_nolike(l.Physical_Country__c) + '\' ';
                                  runQuery = true;
                              }  
                              if(!string.isblank(l.Location_Type__c)){   
                                  SOQL  += ' AND Site = \'' + condition_nolike(l.Location_Type__c) + '\' ';
                                  runQuery = true;
                              } 
                              /* NOT FILTERABLE  removing results to prevent confusion*/
                              if(!string.isblank(l.CompanyDunsNumber)){   
                                  runQuery = false;
                              } 
                              
                              //SOQL  +=' order by isowned asc ';
                              SOQL  +=' limit ' + PARAM_QUERY_SIZE;
                              system.debug(SOQL);
                        
                        
                        DatacloudCompanies= new list<objDatacloudCompany>(); 
                        if(runQuery && runSearch){
                            for(DatacloudCompany r:Database.query(SOQL)){
                                //do not allow duplicate jigsaw records
                                if(!ExistingJigsawRecords.contains(r.CompanyId)){
                                    DatacloudCompanies.add(new objDatacloudCompany(r));
                                }
                            }
                        }    
                    }catch(exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
                        DatacloudCompanies = new list<objDatacloudCompany>(); 
                    }    
                }
                return DatacloudCompanies;
            }
            set;
        
        }
        
    //==========================================================================================
    // SEARCH DataCloudContact
    //==========================================================================================
        public list<objDataCloudContact> DataCloudContacts{
            get{
                if(DataCloudContacts==null){
                    boolean runQuery = false; //Boolean value determines if we have enough to query.
                   try{
                        string SOQL  = 'SELECT Id, CompanyName, ContactID, email, firstname, lastname, street, city, state, zip, country, isowned FROM DataCloudContact ';
                              SOQL  +=' WHERE (IsInactive = false)';
                              if(!string.isblank(l.FirstName)){
                                  SOQL  +=' AND FirstName LIKE \'' + condition_nolike(l.FirstName) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.LastName)){
                                  SOQL  +=' AND LastName LIKE \'' + condition_nolike(l.LastName) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Email)){
                                  SOQL  +=' AND Email like \'' + condition_nolike(l.Email) + '\' ';
                                  runQuery = true;
                              }    
                              if(!string.isblank(l.Company)){
                                  SOQL  +=' AND CompanyName LIKE \'' + condition_nolike(l.Company) + '\' ';
                                  runQuery = true;
                              }   
                             /* if(!string.isblank(l.Street)){    
                                  SOQL  +=' AND Street LIKE \'' + condition(l.Street) + '\' ';
                                  runQuery = true;
                              }
                             */   
                              if(!string.isblank(l.City)){  
                                  SOQL  +=' AND City LIKE \'' + condition_nolike(l.City) + '\' ';
                                  runQuery = true;
                              }
                              if(!string.isblank(l.State)){    
                                  SOQL  +=' AND State = \'' + condition_nolike(l.State) + '\' ';
                                  runQuery = true;
                              } 
                              if(!string.isblank(l.PostalCode)){   
                                  SOQL  += ' AND Zip like \'' + condition_nolike(l.PostalCode) + '\' ';
                                  runQuery = true;
                              }
                             if(!string.isblank(l.Physical_Country__c)){   
                                  SOQL  += ' AND Country = \'' + condition_nolike(l.Physical_Country__c) + '\' ';
                                  runQuery = true;
                              }  
                              /* NOT FILTERABLE  removing results to prevent confusion*/
                              if(!string.isblank(l.CompanyDunsNumber)){   
                                  runQuery = false;
                              } 
                              //SOQL  +=' order by isowned asc ';    
                              SOQL  +=' limit ' + PARAM_QUERY_SIZE;
                              system.debug(SOQL);
                        
                        DataCloudContacts = new list<objDataCloudContact>(); 
                        if(runQuery && runSearch){
                            for(DataCloudContact r:Database.query(SOQL)){
                                //do not allow duplicate jigsaw records
                                if(!ExistingJigsawRecords.contains(r.ContactID)){
                                    DataCloudContacts.add(new objDataCloudContact(r));
                                }
                            }
                        }    
                    }catch(exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
                        DataCloudContacts = new list<objDataCloudContact>(); 
                    }    
                }
                return DataCloudContacts;
            }
            set;
        
        }
    
    //==========================================================================================
    // Wrappers
    //==========================================================================================
      
      //sObject: Account + Checkboxes
      public class objAccount{
          public boolean AccountTeam{get;set;}
          public boolean createContact{get;set;}
          public account obj{get;set;}
          public objAccount(account r){
              this.AccountTeam = false;
              this.createContact = false;
              this.obj = r;
          } 
      }
      
      //sObject: Contact + Checkboxes
      public class objContact{
          public boolean AccountTeam{get;set;}
          public contact obj{get;set;}
          public objContact(contact r){
              this.AccountTeam = false;
              this.obj = r;
          } 
      }

      //sObject: DatacloudCompany
      //Bug in Data.com API requires me to build a wrapper for all fields
      public class objDatacloudCompany{
          public boolean isSelected{get;set;}
          public DatacloudCompany obj{get;set;}
          public string name {get;set;}
          public string street {get;set;}
          public string city {get;set;}
          public string state {get;set;}
          public string zip {get;set;}
          public string country{get;set;}
          public string DunsNumber{get;set;}
          public boolean isowned{get;set;}
          public string CompanyId{get;set;}
          public objDatacloudCompany(DatacloudCompany r){
              this.isSelected = false;
              this.obj = r;
              this.name = r.name;
              this.street = r.street;                        
              this.City = r.City;
              this.State = r.state;
              this.Zip = r.zip;
              this.country = r.country;
              this.DunsNumber = r.DunsNumber;
              this.isowned = r.isowned;
              this.CompanyId = r.CompanyId;
          } 
      }

      //sObject: DatacloudContact
      //Bug in Data.com API requires me to build a wrapper for all fields
      public class objDatacloudContact{
          public boolean isSelected{get;set;}
          public DatacloudContact obj{get;set;}
          public string firstname {get;set;}
          public string lastname {get;set;}
          public string email {get;set;}
          public string street {get;set;}
          public string city {get;set;}
          public string state {get;set;}
          public string zip {get;set;}
          public string country{get;set;}
          public boolean isowned{get;set;}
          public string ContactId{get;set;}
          public objDatacloudContact(DatacloudContact r){
              this.isSelected = false;
              this.obj = r;
              this.firstname = r.firstname;
              this.lastname = r.lastname;
              this.email = r.email;
              this.street = r.street;                        
              this.City = r.City;
              this.State = r.state;
              this.Zip = r.zip;
              this.country = r.country;            
              this.isowned  = r.isowned;
              this.ContactId = r.ContactId;
          } 
      }
    
}