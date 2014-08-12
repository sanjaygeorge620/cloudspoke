public with sharing class SitesPartnerAccountController extends SitesPartnerController {
    
//-------------------------------------------------------------------------------
// Account Detail
//-------------------------------------------------------------------------------    

 private string ControllerID; 
  private string AccountID ; 
    public SitesPartnerAccountController () {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
            AccountID = secureString(ApexPages.currentPage().getParameters().get('accountId'));
            System.debug('ControllerID' +ControllerID);
            System.debug('AccountID' +AccountID);
            
      }


    //-------------------------------------------------------------------------------
// Account Details
//-------------------------------------------------------------------------------
    public Account getAccountDetails(){
        Account acctDetails;
        try{
            acctDetails= [select 
                                  Reseller_ID__c
                                 , id
                                 , Name

                           from Account
                           where 
                               id=:ControllerID and
                               Reseller_ID__c=:SITE_ACCOUNT.ID and
                               Reseller_ID__c!='' 
                           ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return acctDetails;
        }
        
  


    
//-------------------------------------------------------------------------------
// Account
//-------------------------------------------------------------------------------    
    
    public list<Account> getAccount(){
        list<Account> account = [Select  
                                         Reseller_ID__c
                                         , id
                                         , Name
                                         , LXK_Region__c
                                         , BillingCountry
                                         , Customer_Sign_Date__c
                                         
                                    From Account
                                    where Reseller_ID__c=:SITE_ACCOUNT.ID and
                               Reseller_ID__c!='' and Type =: 'Customer' 
                               order by name];

        return account ;
    }
    
    
//-------------------------------------------------------------------------------
// Partner Account
//-------------------------------------------------------------------------------    
    

    
     public Account getPartnerAccount(){
        Account partnerAcctDetails;
        try{
            partnerAcctDetails= [select 
                                  Reseller_ID__c
                                         , id
                                         , Name
                                         , CSA__c
                                         , owner.name
                               From Account
                                    where id=:accountID  
                                          ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return partnerAcctDetails;
        }
    
   
//-------------------------------------------------------------------------------
// Products - Licenses
//-------------------------------------------------------------------------------
     
     public List<Asset_Clone__c> getLiveProducts(){
        return getProducts('Live');
     }
     public List<Asset_Clone__c> getFailoverProducts(){
        return getProducts('Failover');
     }
     public List<Asset_Clone__c> getTestProducts(){
        return getProducts('Test');
     }
     
     
     public List<Asset_Clone__c> getProducts(string ServerType){
            List<Asset_Clone__c> Products = [Select 
                                            a.Quantity__c, 
                                            a.Name, 
                                            a.Server__r.Machine_Name__c, 
                                            a.Server__r.Server_Type__c, 
                                            a.CreatedDate,
                                            (Select Name From License_Keys_Clones__r) 
                                    From Asset_Clone__c a 
                                    where a.Account__c =:AccountID  and
                                          a.Environment__c=:ServerType   
                                    order by a.createddate desc limit 1000
                                    ];
     
     return Products;
     
    }
    
    public asset_Clone__c AssetDetail{get;set;}
    public List<license_key_Clone__c> getLicenses(){
            list<license_key_Clone__c> Licenses;
            try{
                    Licenses = [Select 
                                        l.Environment_type__c,
                                        l.Quantity__c, 
                                        l.Asset_Clone__r.name,
                                        l.Asset_Item_Clone__r.Name,
                                        l.Asset_Clone__r.Account__c,
                                        l.createddate, 
                                            (Select Id, Name, contentType, LastModifiedDate From Attachments) 
                                  From License_Key_Clone__c l 
                                  where l.Asset_Clone__r.Account__c=:AccountID 
                                        and l.Asset_Clone__r.id =:ControllerID
                                  order by 
                                      createddate 
                                   desc limit 1000];
        
            AssetDetail = [Select 
                                a.Quantity__c, 
                                a.Name, 
                                a.Account__c,
                                a.Account__r.Name,
                                a.Server__r.Machine_Name__c, 
                                a.Server__r.Server_Type__c, 
                                a.Server__r.id,
                                a.CreatedDate,
                                (Select Name From License_Keys_Clones__r) 
                          From Asset_Clone__c a 
                          where a.Account__c =:AccountID  and
                              a.id=:ControllerID];
            
            } catch(QueryException e){
                throw new NoDataFoundException();
              }  
        
        
        
        
        
        
        return Licenses;
    }
    
    
//-------------------------------------------------------------------------------
// Submit License Request
//-------------------------------------------------------------------------------    
    
    
    public case LicenseCase{
          get {
              if (LicenseCase == null)
                LicenseCase = new case();
              return LicenseCase;
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
    
    public string RequestType{get; set;}           
    public PageReference submitLicenseRequest() {
            
       /*     Savepoint CaseSP = Database.setSavepoint();
            
            LicenseCase.Account = SITE_ACCOUNT;
            LicenseCase.contact = SITE_CONTACT;
            
            //add request type to subject
            if (RequestType!=null){
                LicenseCase.Subject=RequestType+' License Request - '+SITE_ACCOUNT.Name;
            } else{
                LicenseCase.Subject='License Request - '+SITE_ACCOUNT.Name;
            }    
            LicenseCase.Reason='License'; 
            LicenseCase.recordtypeid = getRecordtypeID('case','product_support');
            
            //insert case
            try {
              insert LicenseCase;
            } catch (DMLException e) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error submitting license request'));
                  ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesAccountController.submitLicenseRequest','High','DML');
                  
                  //Rollback
                  Database.rollback(CaseSP);
                          
                  return null;
            }
   */         
            /* 
  //             Insert Attachment if attachment exists?
            */
    /*            if (attachment.name!='' && attachment.name!=null && attachment.body!=null){
                    attachment.OwnerId = UserInfo.getUserId();
                    attachment.ParentId = LicenseCase.ID; // the record the file is attached to
                    try {
                          insert attachment;
                        } catch (DMLException e) {
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error attaching file. ' +e.getMessage()));
                              ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesAccountController.submitLicenseRequest - AttachFile','High','DML');
                              
                              //Rollback
                              Database.rollback(CaseSP);
                          return null;
                        }
                 }
       */  
            // redirect instead - ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'License request submitted successfully!'));
            //Redirect to license case details
            PageReference Pg;
            Pg = page.casedetails;
      //      Pg.getParameters().put('id', LicenseCase.Id);
            Pg.setRedirect(true);
          return Pg;
          
          }
    
    
//-------------------------------------------------------------------------------
// Servers
//-------------------------------------------------------------------------------

    public List<Server__c> getLiveServers(){
        return getServers('Live');
    }
    
    public List<Server__c> getFailoverServers(){
        return getServers('Failover');
    }
    
    public List<Server__c> getTestServers(){
        return getServers('Test');
    }
    private List<Server__c> getServers(string ServerType) {
          List<Server__c> Servers = [select s.ID, 
                                         s.Machine_Name__c, 
                                         s.Platform__c, 
                                         s.Platform_Version__c, 
                                         s.Release__r.name, 
                                         s.Database__c, 
                                         s.Database_Version__c, 
                                         s.Server_Type__c,
                                         s.Verified_by_Customer__r.name,
                                         s.Date_Verified_by_Customer__c 
                                  from Server__c s 
                                  where 
                                      s.Account__c=:AccountID  and 
                                      s.Server_Type__c=:ServerType
                                  order by 
                                      s.server_type__c
                                  limit 1000];
         return Servers;                     
        }

//-------------------------------------------------------------------------------
// Contacts
//-------------------------------------------------------------------------------  
    //active  non portal
    public List<Contact> getActiveContacts(){
        List<Contact> Contacts = [Select 
                                        id, 
                                        status__c, 
                                        name, 
                                        firstname,
                                        lastname,
                                        email, 
                                        phone, 
                                        AccountID,
                                        title 
                                   from Contact 
                                   where accountid=:AccountID  and 
                                         status__c='Active' and 
                                         ID not in (select 
                                                     contactid 
                                                from USER 
                                                where isactive=true
                                                )  
                                   order by LastName
                                   limit 1000];
          return Contacts;
        } 
        
    //inactive or null non portal   
    public List<Contact> getInactiveContacts(){
        List<Contact> Contacts = [Select 
                                        id, 
                                        status__c, 
                                        name, 
                                        firstname,
                                        lastname,
                                        email, 
                                        phone, 
                                        AccountID,
                                        title 
                                   from Contact 
                                   where accountid=:AccountID  and 
                                         (status__c='inactive' or status__c='') 
                                         and 
                                         ID not in (select 
                                                     contactid 
                                                from USER 
                                                where isactive=true
                                                )  
                                   order by LastName
                                   limit 1000];
          return Contacts;
        }         
    //portal    
    public List<user> getPortalContacts(){
        List<user> Contacts = [Select 
                                     u.Profile.Name, 
                                     u.Contact.Status__c, 
                                     u.username, 
                                     u.Contact.Phone, 
                                     u.Contact.Name, 
                                     u.Contact.FirstName, 
                                     u.Contact.LastName, 
                                     u.Contact.AccountId, 
                                     u.Contact.Id
                                From User u 
                                where contactid!=null and
                                      u.AccountID=:AccountID   and
                                      isactive=true
                                      order by Contact.LastName
                                limit 1000
                                ];
          return Contacts;
        } 

//-------------------------------------------------------------------------------
// Submit New Contact
//-------------------------------------------------------------------------------  
    public contact NewContact{
          get {
              if (NewContact == null)
                NewContact = new contact();
              return NewContact;
            }
          set;
          }
    
    public String selectedProfileId {get;set;}     
    public PageReference createContact() {
               NewContact.AccountID = AccountID;
            try {
              insert NewContact;
             
            } catch (DMLException e) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating contact.'));
                  ErrorLogUtility.createErrorRecord(e.getMessage(),'SitesAccountController.submitNewContact','High','DML');
                  return null;
            } 
              //Success...Go to Contact*/
               PageReference Pg;
               Pg = Page.contactdetails;
               Pg.getParameters().put('id', NewContact.ID);
               Pg.setRedirect(true);
              return Pg;
          }
          
//-------------------------------------------------------------------------------
// Orders
//-------------------------------------------------------------------------------

     //all Orders
    public list<Order__c> getOrders(){
        list<Order__c> orders= [Select name
                                        , AEX__c
                                        , AEX_Email__c
                                        , ISR__c
                                        , ISR_Email__c
                                        , Close_Date__c
                                        , Amount__c
                                        , Bill_To__c
                                        , Ship_To__c
                                        , Project_Contact__c 
                                        , opportunity__c
                                        , status__c
                                        , Account__c
                                        , PO_Number__c
                                    From Order__c
                                    where Account__c=:AccountID  and
                                          Account__c!='' and
                                          status__c = true
                                          ];
        
        return orders;
    }
    
     //-------------------------------------------------------------------------------
// Order Details
//-------------------------------------------------------------------------------
    string OrderDetailsOpportunityID;
    Order__c orderDetails;
     string OrderDetailsID;
    public Order__c getOrderDetails(){
        
        try{
            orderDetails= [select name
                                , AEX__c
                                , AEX_Email__c
                                , ISR__c
                                , ISR_Email__c
                                , Close_Date__c
                                , Amount__c
                                , Bill_To__c
                                , Ship_To__c
                                , Project_Contact__c 
                                , opportunity__c
                                , status__c
                                , Account__c
                                , Account__r.Name
                                , Opportunity_ID__c
                                , ID
                           from Order__c
                           where 
                               id=:ControllerID and
                               Account__c=:AccountID and
                               Account__c!='' 
                           ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           OrderDetailsOpportunityID = orderDetails.opportunity__c;
           OrderDetailsID = orderDetails.id;
           return orderDetails;
        }
        
  public list<Order_Detail__c> getOpportunityLineItems(){
        list<Order_Detail__c>  opptyLineItems;
        try{
            opptyLineItems = [Select  o.id, 
                                      o.Name,
                                      o.Quantity__c,
                                      o.createddate
                              From Order_Detail__c o  
                              where   
                               o.Order__c=:ControllerID
                           ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return opptyLineItems;
        }
     
 

}