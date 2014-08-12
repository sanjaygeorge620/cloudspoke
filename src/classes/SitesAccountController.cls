/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public class SitesAccountController Extends SitesController{

//-------------------------------------------------------------------------------
// Account
//-------------------------------------------------------------------------------
    private string ControllerID;     
    public SitesAccountController() {
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));            
      }
   
//-------------------------------------------------------------------------------
// Products - Licenses
//-------------------------------------------------------------------------------
     
     public List<Asset> getLiveProducts(){
        return getProducts('Live');
        
     }
     public List<Asset> getFailoverProducts(){
        return getProducts('Failover');        
     }
     public List<Asset> getTestProducts(){
        return getProducts('Test');        
     }
     
    /* public List<license_key__c> getLiveLicenses(){        
        //return getLicenses('Live');
        return getNewLicenses('Live');        
     }
     
     public List<license_key__c> getFailoverLicenses(){        
        return getLicenses('Failover');
     }
     public List<license_key__c> getTestLicenses(){        
        return getLicenses('Test');
     }
     */
     public List<AssetWrapper> getAllProducts(){
        return getProducts();        
     }
     
     public List<LicenseWrapper> getLiveLicenses(){
        return getNewLicenses('Live');        
     }
     
      public List<LicenseWrapper> getFailoverLicenses(){        
        return getNewLicenses('Failover');
     }
     public List<LicenseWrapper> getTestLicenses(){        
        return getNewLicenses('Test');
     }
     
     public class AssetWrapper {
         public Asset asse {get; set;}
         public String environment {get; set;}
         
         public AssetWrapper(Asset a, String env) 
         {
             asse = a;
             environment = env;
         }
     }
     
     public class LicenseWrapper 
     {
         public String name {get; set;}
         public license_key__c lk {get; set;}
         public boolean isSolution {get; set;}
         public list<Attachment> attlst {get; set;}
         public LicenseWrapper (String na, License_Key__c lik) 
         {
             name = na;
             lk = lik;
             isSolution = False;
             attlst = new list<Attachment>();
         }
     }
     
     
     public List<AssetWrapper> getProducts(){
         Map<String, AssetWrapper> assetWrapperMap = new Map<String, AssetWrapper>();
            List<Asset> Products = [Select 
                                            a.Quantity__c, 
                                            a.Name, 
                                            a.Acuo_Environment__c,
                                            a.Server__c,
                                            a.Server__r.Id, 
                                            a.Server__r.Name, 
                                            a.Server__r.Machine_Name__c, 
                                            a.Server__r.Server_Type__c, 
                                            a.CreatedDate, Product__c, Product__r.Use_Sizing_Tool__c, 
                                            (Select Name, Environment_type__c, Quantity__c, Asset__r.name, Asset_Item__r.Name, createddate From License_Keys__r) 
                                    From Asset a 
                                    where a.AccountId =:SITE_ACCOUNT.id 
                                    And a.Hide_on_Portal__c != true
                                    AND a.Server__c!=null                  //  /*Removed null servers 9.10.13*/   --Commenting out since Acuo Products are not showing up Praveen April 2014                                          
                                    order by a.createddate desc limit 1000
                                    ];

            for(Asset asse: Products) 
            {
                String tempEnv = '';
                if(asse.Server__r.Server_Type__c != null && asse.Acuo_Environment__c == null) {
                    tempEnv = asse.Server__r.Server_Type__c;
                } else {
                    tempEnv = asse.Acuo_Environment__c;
                }
                system.debug('--------------' +asse.id);
                system.debug('--------------' +tempEnv);
                AssetWrapper tempAssetWrapper = new AssetWrapper(asse, tempEnv);
                if(assetWrapperMap.get(asse.Name) != null) 
                {
                    tempAssetWrapper = assetWrapperMap.get(asse.Name);
                //    if(asse.Server__r.Server_Type__c != null && !tempAssetWrapper.environment.contains(asse.Server__r.Server_Type__c)) {
                    if(!tempAssetWrapper.environment.contains(asse.Server__r.Server_Type__c)) {
                        tempAssetWrapper.environment = tempAssetWrapper.environment + ', ' + asse.Server__r.Server_Type__c;
                    }
                    
                    if(asse.Server__c == null && asse.Acuo_Environment__c != null &&!tempAssetWrapper.environment.contains(asse.Acuo_Environment__c)) {
                        tempAssetWrapper.environment = tempAssetWrapper.environment + ', ' + asse.Acuo_Environment__c;
                    }
                }
                assetWrapperMap.put(asse.Name, tempAssetWrapper);
            }
     
     return assetWrapperMap.values();
     
    }
    
    public List<Asset> getProducts(string ServerType){
            List<Asset> Products = [Select 
                                            a.Quantity__c, 
                                            a.Name,
                                            a.Server__c,
                                            a.Server__r.Id, 
                                            a.Server__r.Name, 
                                            a.Server__r.Machine_Name__c, 
                                            a.Server__r.Server_Type__c, 
                                            a.CreatedDate, Product__c, Product__r.Use_Sizing_Tool__c, 
                                            (Select Name, Environment_type__c, Quantity__c, Asset__r.name, Asset_Item__r.Name, createddate From License_Keys__r) 
                                    From Asset a 
                                    where a.AccountId =:SITE_ACCOUNT.id and
                                          a.Environment__c=:ServerType and 
                                          a.Hide_on_Portal__c != true 
                                    order by a.createddate desc limit 1000
                                    ];
     
     return Products;
     
    }
    
    
    
    public List<license_key__c> getLicenses(string ServerType)
    {
   
    
            list<license_key__c> Licenses;
            try{
                    Licenses = [Select 
                                        l.id,
                                        //l.NumberForAcuo__c, 
                                        l.Environment_type__c, 
                                        l.Quantity__c, 
                                        //l.IsAcuoProduct__c,
                                        l.ServerName__c,
                                        l.Asset__r.name,
                                        l.Asset_Item__r.Name,
                                        l.Asset_Item__r.LastModifiedDate,
                                        l.Asset_Item__r.Product__c,
                                        //l.Asset_Item__r.IsAcuoProduct__c,
                                        l.Asset_Item__r.Product__r.Use_Sizing_Tool__c,
                                        l.Asset_Item__r.Server__r.Name,
                                        l.createddate, 
                                            (Select Id, Name, contentType, LastModifiedDate From Attachments) 
                                  From License_Key__c l 
                                  where l.Asset__r.Account.ID=:SITE_ACCOUNT.ID
                                        and l.Asset__r.Environment__c=:ServerType
                                        and l.Asset_Item__r.Hide_on_Portal__c != True
                                  order by 
                                       l.createddate
                                   desc limit 1000];
        
            
            
            }
            catch(QueryException e)
            {
                throw new NoDataFoundException();
            }
        
        return Licenses;
    }
    
    public List<LicenseWrapper> getNewLicenses(string ServerType)
    {
    
        map<ID,List<Attachment>> lkmap = new map<ID,List<Attachment>>();
    
            list<license_key__c> Licenses_SolnProd;
                    Licenses_SolnProd = [Select 
                                        l.id,
                                        //l.NumberForAcuo__c, 
                                        l.Environment_type__c, 
                                        l.Quantity__c, 
                                        //l.IsAcuoProduct__c,
                                        l.ServerName__c,
                                        l.Asset__r.name,
                                        l.Asset__c,
                                        l.Asset_Item__r.Name,
                                        l.Asset_Item__r.LastModifiedDate,
                                        l.Asset_Item__r.Product__c,
                                        //l.Asset_Item__r.IsAcuoProduct__c,
                                        l.Asset_Item__r.Product__r.Use_Sizing_Tool__c,
                                        l.Asset_Item__r.Server__r.Name,
                                        l.Asset_Item__r.Parent_Asset_Item__r.Asset__c,
                                        l.createddate, 
                                            (Select Id, Name, contentType, LastModifiedDate From Attachments) 
                                  From License_Key__c l 
                                  where l.Asset__r.Account.ID=:SITE_ACCOUNT.ID
                                        and l.Asset__r.Environment__c=:ServerType
                                        and l.Asset_Item__r.Hide_on_Portal__c = True];
                                        

             if(!Licenses_SolnProd.isEmpty())
             {
             for(license_key__c lk : Licenses_SolnProd)
             {
             system.debug('XXXXXXXXXXXXXx' +lk.Attachments.size());
             if(!lk.Attachments.isEmpty())
             {
             system.debug('XXXXXXXXXXXXXx' +lk.Asset_Item__r.Parent_Asset_Item__r.Asset__c);
             
             if(lkmap.containskey(lk.Asset_Item__r.Parent_Asset_Item__r.Asset__c))
             {
             lkmap.get(lk.Asset_Item__r.Parent_Asset_Item__r.Asset__c).addall(lk.attachments);             
             }
             else
             {
             list<Attachment> temp = new list<Attachment>();
             temp.addall(lk.attachments);
             lkmap.put(lk.Asset_Item__r.Parent_Asset_Item__r.Asset__c,temp);
             }
             }
             }
             }

    
            List<LicenseWrapper> LicensesWrapperList = new List<LicenseWrapper>();
            list<license_key__c> Licenses;
            List<license_key__c> serverLicenses;
            try
            {
                Licenses = [Select 
                                    l.id,
                                    //l.NumberForAcuo__c,
                                    l.Environment_type__c, 
                                    l.Quantity__c, 
                                    //l.IsAcuoProduct__c,
                                    l.ServerName__c,
                                    l.Asset__r.name,
                                    l.Asset__c,
                                    l.Asset_Item__r.Name,
                                    l.Asset_Item__r.LastModifiedDate,
                                    l.Asset_Item__r.createddate,
                                    l.Asset_Item__r.Product__c,
                                    //l.Asset_Item__r.IsAcuoProduct__c,
                                    l.Asset_Item__r.Product__r.Use_Sizing_Tool__c,
                                    l.Asset_Item__r.Server__r.Name,
                                    l.Asset_Item__r.Parent_Asset_Item__r.Asset__c,
                                    l.createddate, 
                                        (Select Id, Name, contentType, LastModifiedDate From Attachments) 
                              From License_Key__c l 
                              where l.Asset__r.Account.ID=:SITE_ACCOUNT.ID
                                    and l.Asset__r.Environment__c=:ServerType
                                    and l.Asset_Item__r.Hide_on_Portal__c != True
                              order by 
                                  l.createddate
                               desc limit 1000];
                for(License_Key__c lk: Licenses) 
                {
                    LicenseWrapper lw = new LicenseWrapper(lk.Asset__r.name,lk);
                    LicensesWrapperList.add(lw);    
                }
                
                if(!Licenses_SolnProd.isEmpty() && !LicensesWrapperList.isEmpty())
                {
                for(LicenseWrapper lw : LicensesWrapperList)
                {
                if(lkmap.containskey(lw.lk.Asset__c))
                {
                lw.isSolution = True;
                lw.attlst.addall(lw.lk.attachments);
                system.debug('XXXXXXXXXXXXXXXXXX' +lw.lk.Asset__c);
                system.debug('XXXXXXXXXXXXXXXXXX' +lkmap.get(lw.lk.Asset__c).size());
                system.debug('XXXXXXXXXXXXXXXXXX' +lw.attlst.size());
                for(Attachment at : lkmap.get(lw.lk.Asset__c))
                {
                lw.attlst.add(at);                
                system.debug('XXXXXXXXXXXXXXXXXX' +lw.attlst.size());
                }
                }
                }
                }
                                
                Set<Id> serverIdSet = new Set<Id>();
                for(Asset_Item__c ai: [Select Id, Name, Asset__c, (Select Id, Server__c from Server_Asset_Associations__r) from Asset_Item__c where Product__r.Use_Sizing_Tool__c =: true AND Asset__r.Account.ID=:SITE_ACCOUNT.ID]) 
                {
                    system.debug('----------------------------------ai.Server_Asset_Associations__r:'+ai.Server_Asset_Associations__r);
                    for(Server_Asset_Association__c saa: ai.Server_Asset_Associations__r) 
                    {
                        if(saa.Server__c != null)
                        {
                            serverIdSet.add(saa.Server__c);
                        }
                    }
                }
                 system.debug('----------------------------------serverIdSet:'+serverIdSet);
                if(!serverIdSet.isEmpty()) 
                {    
                    serverLicenses = [Select 
                                    l.id,
                                    //l.NumberForAcuo__c,
                                    l.Environment_type__c, 
                                    l.Quantity__c, 
                                    //l.IsAcuoProduct__c,
                                    l.ServerName__c,
                                    l.Server__c,
                                    l.Server__r.Server_Name__c,
                                    l.Server__r.Server_Type__c,
                                    l.Asset__r.name,  
                                    l.Asset__c,                                      
                                    l.Asset_Item__r.Name,
                                    l.Asset_Item__r.LastModifiedDate,
                                    l.Asset_Item__r.Product__c,
                                    l.Asset_Item__r.createddate,
                                    //l.Asset_Item__r.IsAcuoProduct__c,
                                    l.Asset_Item__r.Product__r.Use_Sizing_Tool__c,
                                    l.Asset_Item__r.Server__r.Name,
                                    l.Asset_Item__r.Parent_Asset_Item__r.Asset__c,
                                    l.createddate, 
                                        (Select Id, Name, contentType, LastModifiedDate From Attachments) 
                              From License_Key__c l 
                              where Server__c IN: serverIdSet
                                  and l.Server__r.Server_Type__c=:ServerType
                                  and l.Asset_Item__r.Hide_on_Portal__c != True
                              order by 
                                  Asset_Item__r.LastModifiedDate
                               desc limit 1000];
                    if(serverLicenses != null && serverLicenses.size() > 0)
                    {
                        Licenses.addAll(serverLicenses);
                    }
                    for(License_Key__c lk: serverLicenses) 
                    {
                        LicenseWrapper lw = new LicenseWrapper(lk.Server__r.Server_Name__c, lk);
                        LicensesWrapperList.add(lw);    
                    }
                }             
            } 
            catch(QueryException e)
            {
                throw new NoDataFoundException();
            }
        
        return LicensesWrapperList;
    }
    
    public asset AssetDetail{get;set;}
    public List<license_key__c> getLicenses(){
            list<license_key__c> Licenses;
            try{
                    Licenses = [Select 
                                        l.Environment_type__c, 
                                        l.Quantity__c, 
                                        l.Asset__r.name,
                                        l.Asset_Item__r.Name,
                                        l.createddate, 
                                            (Select Id, Name, contentType, LastModifiedDate From Attachments) 
                                  From License_Key__c l 
                                  where l.Asset__r.Account.ID=:SITE_ACCOUNT.ID
                                        and l.Asset__r.id =:ControllerID
                                  order by 
                                      createddate 
                                   desc limit 1000];
        
            AssetDetail = [Select 
                                a.Quantity__c, 
                                a.Name, 
                                a.Server__r.Machine_Name__c, 
                                a.Server__r.Server_Type__c, 
                                a.Server__r.id,
                                a.CreatedDate,
                                (Select Name From License_Keys__r) 
                          From Asset a 
                          where a.AccountId =:SITE_ACCOUNT.id and
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
            
            Savepoint CaseSP = Database.setSavepoint();
            
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
            
            /* 
               Insert Attachment if attachment exists?
            */
                if (attachment.name!='' && attachment.name!=null && attachment.body!=null){
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
         
            // redirect instead - ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'License request submitted successfully!'));
            //Redirect to license case details
            PageReference Pg;
            Pg = page.casedetails;
            Pg.getParameters().put('id', LicenseCase.Id);
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
                                      s.Account__c=:SITE_ACCOUNT.ID and 
                                      s.Server_Type__c=:ServerType
                                  order by 
                                      s.server_type__c
                                  limit 1000];
         System.debug('-----------------------------Servers:'+Servers);                         
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
                                   where accountid=:SITE_ACCOUNT.ID and 
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
                                   where accountid=:SITE_ACCOUNT.ID and 
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
    public List<user> getPortalContacts()
    {
    
        List<user> Contacts = new List<user>();
        if(SITE_NAME == 'ChannelPortalSite')
        {
                  contacts =        [Select 
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
                                      u.AccountID=:SITE_ACCOUNT.ID  and
                                      isactive=true and profile.Name like '%Perceptive Channel Portal%'
                                      order by Contact.LastName
                                limit 1000
                                ];
        }
        if(SITE_NAME == 'CustomerPortalSite')
        {
         contacts =        [Select 
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
                                      u.AccountID=:SITE_ACCOUNT.ID  and
                                      isactive=true and profile.Name like '%Perceptive Customer Portal%'
                                      order by Contact.LastName
                                limit 1000
                                ];
        
        
        }
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
               NewContact.AccountID = SITE_ACCOUNT.id;
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
                                    where Account__c=:SITE_ACCOUNT.ID and
                                          Account__c!='' and
                                          status__c = true and ((SAP_Status__c = 'Submitted') or (SAP_Status__c = 'Override'))
                                          ];
        
        return orders;
    }
    //--------------------Added for US1209 Salesforce | Add Inspire Link to Channel Portal
    
     public list<Perceptive_Site_Content__c> getWidgetEventResources()
    {
        return getWidget('Event Resources');
    }
    
    //-------------------------------------------------------------------------------------
    
          
}