//-------------------------------------------------------------------------------
// Downloads - this is temporary before we move to flexera so I did not go back and clean up code....tested well.
//-------------------------------------------------------------------------------

public class SitesLibraryController Extends SitesController{

 private string ControllerID; 
 public ID contentID;
 public string workspaceParam;
 
 
    public SitesLibraryController () {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
            workspaceParam = secureString(ApexPages.currentPage().getParameters().get('workspace'));
            If(workspaceParam !=null && SelectedWorkspace == null){
            string SOQL;
            string MySOQL;
                SelectedWorkspace = workspaceParam;           
                SOQL = 'and c.ContentWorkspaceId  = \''+SelectedWorkspace+'\'';       
                MySOQL = 'Select c.ContentDocument.LatestPublishedVersion.ContentSize, c.ContentDocument.LatestPublishedVersion.FileType, c.ContentDocument.LatestPublishedVersion.CreatedDate, c.ContentDocument.LatestPublishedVersion.track__c,c.ContentDocument.LatestPublishedVersion.ProductRelease__c, c.ContentDocument.LatestPublishedVersion.type__C, c.ContentDocument.LatestPublishedVersion.platform__c, c.ContentDocument.LatestPublishedVersion.Database__c, c.ContentDocument.Title, c.ContentDocument.LatestPublishedVersion.Presenter__c, c.ContentDocument.Id From ContentWorkspaceDoc c where c.ContentDocument.LatestPublishedVersion.PublishStatus=\'P\' and c.ContentDocument.LatestPublishedVersion.IsLatest = true '+SOQL+' order by c.ContentDocument.LatestPublishedVersion.CreatedDate desc limit 1000';
                ContentWorkspaceDocs = database.query(MySOQL);
            }
      }
      
      
//-------------------------------------------------------------------------------
// Content Page
//-------------------------------------------------------------------------------    
    
    public ID getContentRecord(){
        ContentVersion contentRec = [Select  
                                         ID
                                         
                                    From ContentVersion
                                    where contentDocumentID=:ControllerID limit 1
                                          ];
        contentID = contentRec.id;
        system.debug('contentID: ' + contentID);
        return contentID;
    }
    



public string SelectedWorkspace;
  public string searchbox {get; set;} /*Title Search*/
  public string SelectedProduct {get; set;} /*Product*/
    public string SelectedTrack {get; set;} /*Track*/
  public string SelectedDatabase {get; set;} /*Database*/
  public string SelectedRelease {get; set;} /*Release*/
  public string SelectedType {get; set;} /*Content Type*/
  public string SelectedPlatform {get; set;} /*Platform*/
  public string getSelectedWorkspace() {
      return SelectedWorkspace;
  } /*Workspace*/
  public void setSelectedWorkspace(string workspaceParam) {
        SelectedWorkspace = workspaceParam;
        system.debug('selectedworkspace: ' + SelectedWorkspace);
  } /*Workspace*/
  
  public list<ContentWorkspaceDoc> ContentWorkspaceDocs {get; set;} /*List of Content Docs*/
  
  //for testing
  private boolean isTest = false;/*Throw an Exception*/
  public class MyException extends Exception{} /*CustomException*/   

  public list<SelectOption> getWorkspace(){
    list<ContentWorkspace> workspaces= [Select c.Name, c.Id From ContentWorkspace c order by c.Name asc];
            list<SelectOption> options = new list<SelectOption>();
                    options.add(new SelectOption('','-- All --')); /*Adding All*/
                    for (ContentWorkspace w : workspaces) {
                        options.add(new SelectOption(w.id,w.Name));
                     }
                return options;
          } 
     
      /*Track Options from the field*/
   public list<SelectOption> getTrackOptions(){
            List<SelectOption> PicklistOptions = new List<SelectOption>();
            PicklistOptions.add(new SelectOption('','-- All --'));
            
            Schema.DescribeFieldResult sObjectField= Schema.sObjectType.ContentVersion.fields.Track__c;
            for (Schema.PickListEntry RelPickVal : sObjectField.getPicklistValues()){
                PicklistOptions.add(new SelectOption(RelPickVal.getValue(),RelPickVal.getLabel()));
              }
            return PicklistOptions;
            }
   
   /*Platform Options from the field*/
   public list<SelectOption> getPlatformOptions(){
            List<SelectOption> PicklistOptions = new List<SelectOption>();
            PicklistOptions.add(new SelectOption('','-- All --'));
            
            Schema.DescribeFieldResult sObjectField= Schema.sObjectType.ContentVersion.fields.Platform__c;
            for (Schema.PickListEntry RelPickVal : sObjectField.getPicklistValues()){
                PicklistOptions.add(new SelectOption(RelPickVal.getValue(),RelPickVal.getLabel()));
              }
            return PicklistOptions;
            }
    
   /*Database Options from the field*/
   public list<SelectOption> getDatabaseOptions(){
        List<SelectOption> PicklistOptions = new List<SelectOption>();
            PicklistOptions.add(new SelectOption('','-- All --'));
            
            Schema.DescribeFieldResult sObjectField= Schema.sObjectType.ContentVersion.fields.Database__c;
            for (Schema.PickListEntry RelPickVal : sObjectField.getPicklistValues()){
                PicklistOptions.add(new SelectOption(RelPickVal.getValue(),RelPickVal.getLabel()));
              }
            return PicklistOptions;
            }
        
  /*Release Options from the Product Configurator*/   
  public list<SelectOption> getReleaseOptions() {
                list<ProductRelease__c> Releases= [select id, Release__c 
                                                   from ProductRelease__c 
                                                   where status__c ='General Availability' 
                                                    order by Release__c desc];
            list<SelectOption> options = new list<SelectOption>();
                    options.add(new SelectOption('','-- All --'));
                    for (ProductRelease__c r : Releases) {
                        options.add(new SelectOption(r.Release__c,r.Release__c));
                     }
                return options;
          } 
          
                  
  /*File Types from the Content list*/
 /* public list<SelectOption> getTypeOptions() {
            list<AggregateResult> products= [Select 
                                                c.Type__C FILETYPE 
                                              From ContentVersion c 
                                              where c.Type__C!=null
                                              Group by c.Type__C 
                                               order by c.Type__C
                                              ];
            list<SelectOption> options = new list<SelectOption>();
                    options.add(new SelectOption('','-- All --'));
                    for (AggregateResult r : products) {
                        options.add(new SelectOption((ID)r.get('FILETYPE'),(String)r.get('FILETYPE')));
                     }
                return options;
          }
          */
  /*Products from the Content list*/        
  public list<SelectOption> getMyProducts() {
                /*
                list<AggregateResult> products= [Select 
                                                    MAX(c.ProductName__r.id) PRODID, 
                                                    c.ProductName__r.name ProdName
                                                  From ContentVersion c 
                                                  where c.ProductName__r.name !=null
                                                  Group By c.ProductName__r.name 
                                                  order by 
                                                   c.ProductName__r.name
                                                  ];                                                     
                */
                //Changed to Aggregate Model
                list<AggregateResult> products= [Select 
                                                    MAX(c.ProductName__r.id) PRODID, 
                                                    c.ProductName__r.Product__r.Product_Model__r.Name ProdName
                                                  From ContentVersion c 
                                                  where c.ProductName__r.Product__r.Product_Model__r.Name !=null
                                                  Group By c.ProductName__r.Product__r.Product_Model__r.Name 
                                                  order by 
                                                   c.ProductName__r.Product__r.Product_Model__r.Name
                                                  ];    
                                                  
                    list<SelectOption> options = new list<SelectOption>();
                        options.add(new SelectOption('','-- All --'));
                        for (AggregateResult r : products) {
                            system.debug('(ID)r.get(ProdName):' + r.get('PRODID'));
                            system.debug('(String)r.get(ProdName):' + r.get('ProdName'));
                            options.add(new SelectOption((ID)r.get('PRODID'),(String)r.get('ProdName')));
                         }
                return options;
          }
            
  /*runs the actual query*/
  public void runQuery() {
    string MyDatabase;
    string MyProduct;
    string keywords;
    string SOQL = '';
    integer x = 0;
    string MySOQL='';
    
    system.debug('SelectedDatabase: '+SelectedDatabase);
    system.debug('SelectedProduct: '+SelectedProduct);      
    system.debug('SelectedRelease: '+SelectedRelease);  
    
    
    try {
        /*Custom Validation Rules*/
      //if (SelectedProduct==null || SelectedProduct==''){throw new PerceptiveUtility.CustomException('Product is Required');}
      //if (SelectedRelease!='All' && (SelectedRelease==null || SelectedRelease=='')){throw new PerceptiveUtility.CustomException('Release is Required');}
        
        if (isTest){throw new MyException('TEST ERROR HANDLER');}
      
      if (searchbox!=null){
          //Trim the Text Search
          searchbox=searchbox.trim();
          if (searchbox!=''){
           /*Title Search - Clause Builder*/
              list<string> ss = searchbox.split(' ');
                        for(String s : ss)
                        { x++;
                          System.debug('Number:' + x);
                          if (x == 1)
                              {keywords = 'c.ContentDocument.Title like \'%'+string.escapeSingleQuotes(s)+'%\'';}
                          else
                              {keywords += ' and c.ContentDocument.Title like \'%'+string.escapeSingleQuotes(s)+'%\'';}
                        }
                        System.debug('keywords :' + keywords );
                        keywords = keywords;
                        SOQL= '('+keywords + ')';
          }
       }   
      
      /*Selected Workspace - Clause Builder*/ 
             
        SOQL = buildClause(SelectedWorkspace,'c.ContentWorkspaceId  = \''+SelectedWorkspace+'\'',SOQL);       
                   
      /*Selected Release - Clause Builder*/
        SOQL = buildClause(SelectedRelease,'c.ContentDocument.LatestPublishedVersion.ProductRelease__c includes(\''+SelectedRelease+'\')',SOQL);
        
              /*Selected Track- Clause Builder*/
        SOQL = buildClause(SelectedTrack,'c.ContentDocument.LatestPublishedVersion.Track__c includes(\''+SelectedTrack+'\')',SOQL);
          
      /*Selected Database - Clause Builder*/
        SOQL = buildClause(SelectedDatabase,'c.ContentDocument.LatestPublishedVersion.Database__c includes (\''+SelectedDatabase+'\',\'\')',SOQL);
          
      /*Selected Platform - Clause Builder*/
        SOQL = buildClause(SelectedPlatform,'c.ContentDocument.LatestPublishedVersion.Platform__c includes (\''+SelectedPlatform+'\',\'\')',SOQL);  
                  
      /*Selected Type - Clause Builder*/            
        SOQL = buildClause(SelectedType,'c.ContentDocument.LatestPublishedVersion.Type__c = \''+SelectedType+'\'',SOQL);
    
      /*Selected Product - Clause Builder*/
        SOQL = buildClause(SelectedProduct,'c.ContentDocument.LatestPublishedVersion.ProductName__r.Product__r.Product_Model__r.Name  = \''+SelectedProduct+'\'',SOQL);          
      
      
      /*Adding 'and' Operator*/        
        if (SOQL!=''){SOQL = ' and '+ SOQL; }
        MySOQL = 'Select c.ContentDocument.LatestPublishedVersion.ContentSize, c.ContentDocument.LatestPublishedVersion.FileType, c.ContentDocument.LatestPublishedVersion.CreatedDate, c.ContentDocument.LatestPublishedVersion.track__c,c.ContentDocument.LatestPublishedVersion.ProductRelease__c, c.ContentDocument.LatestPublishedVersion.type__C, c.ContentDocument.LatestPublishedVersion.platform__c, c.ContentDocument.LatestPublishedVersion.Database__c, c.ContentDocument.Title,  c.ContentDocument.LatestPublishedVersion.Presenter__c, c.ContentDocument.Id From ContentWorkspaceDoc c where c.ContentDocument.LatestPublishedVersion.PublishStatus=\'P\' and c.ContentDocument.LatestPublishedVersion.IsLatest = true '+SOQL+' order by c.ContentDocument.LatestPublishedVersion.CreatedDate desc limit 1000';
      
        system.debug('Full SOQL Where: '+MySOQL);
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'SOQL Where: '+SOQL));
        system.debug('SOQL Where: '+SOQL);
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm, 'SOQL: '+MySOQL));
      
      /*Submit Query*/    
      system.debug('mySOQL:' + mySOQL);
      ContentWorkspaceDocs = database.query(MySOQL);

        
     } catch (PerceptiveUtility.CustomException e){
           /*Show Custom Errors*/
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    } catch (Exception e) {
            /*Show All Errors*/
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occured. Please refine your search and try again.'));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            /*Show Custom Errors*/
            ErrorLogUtility.createErrorRecord(e.getMessage() + ' \n\n SQL: '+MySOQL ,'ContentController.runQuery','Medium','Generic');
    }
 
  }
 /*Method to Concatenate Strings with and Operator*/
  private string buildClause(string sValue,string Clause, string SOQL){
    /*Building the SOQL Query*/
    if (sValue!=null && sValue!=''){
        if (SOQL!='')
           {SOQL +=' and '+clause;}
        else
           {SOQL = clause;}
    }
    return SOQL;}
  
 
  /*Reset Form*/ 
  public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());    
        newpage.getParameters().clear();
        newpage.setRedirect(true);
    return newpage;
  }


 //Test Code Coverage    
    static testMethod void testSitesLibraryController() {
       
        //You cannot create, update, or delete a workspace via the API - from SF Docs
        //ContentWorkspace cw = [Select id from ContentWorkspace where name like 'Conference | EMEA User forum' limit 1];
        Recordtype rt = [Select id from Recordtype where name='Conference Presentation' and sObjectType='ContentVersion' limit 1];
        
        ContentVersion cv = new ContentVersion();
        cv.versionData =  Blob.valueOf('Test Document');
        cv.title = 'TestContent6821303';
        cv.pathOnClient ='/foo.txt';
        //cv.FirstPublishLocationId = cw.id;
        cv.recordtypeid = rt.id;
        insert cv;
        
        // Insert Account
        //Account myAccount = new Account(Name='Test Company');//, Address_Edit_States__c='ks');
        Account myAccount = Data_Account.createAccount2();

       //  insert myAccount;
        
        // Insert Contact
                list<contact> cons  = Data_Contact.CreateContacts(myAccount.id,1);
                Contact myContact = cons[0];
         system.debug('Contact: ' +myContact.ID + ' First Name: ' + myContact.FirstName);
        
        // Query Profile        
        Profile p = [select id from profile where name like '%customer portal%' limit 1]; 
        
        // Insert User
        User myUser = new User(alias = 'standt', Contactid=myContact.id, email='cstandarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser@testorg.com');
         system.debug('User: ' +myUser.ID + ' Name: ' + myUser.Name);
        
        
        //System.runAs(myUser){ 
            Test.setCurrentPageReference(new PageReference('Page.Library'));
            SitesLibraryController controller01 = new SitesLibraryController();
                 controller01.searchbox=' t e s t';
                 controller01.SelectedProduct='ImageNow Client';
                 controller01.SelectedDatabase='MSSQL';
                 controller01.SelectedRelease='6.4.1';
                 controller01.SelectedType='Installer';
                 controller01.SelectedPlatform='Windows';
                  controller01.SelectedTrack='Higher Education';
                                         
                 controller01.getReleaseOptions();
                 controller01.getPlatformOptions();
        //         controller01.getTypeOptions();
                 controller01.getDatabaseOptions();
                 controller01.getMyProducts();
                 controller01.getWorkspace();
                 controller01.getTrackOptions();                 
                 controller01.RunQuery();
                 
                // controller01.isTest = true;
                 controller01.RunQuery();
                 
                  controller01.Reset();
                  
             system.debug('Controller01 Size: '+controller01.ContentWorkspaceDocs.size());
             
             ContentController controller02 = new ContentController();
                 //controller02.SelectedWorkspace = cw.id;
                 controller02.searchbox='TestContent6821303';
                 
                 controller02.RunQuery();
             
             system.debug('controller02 Size: '+controller02.ContentWorkspaceDocs.size());                
             //system.assertEquals(controller02.ContentWorkspaceDocs.size(),1);
          //}   
          
    }     
         



}