/**
 * Test class for InvoiceMaker
 */
@isTest(seealldata = true)
private class Test_InvoiceMaker_DS_MS 
{   
    public static  Account OppAcc = createAccount();
    
    private static Account createAccountLocationCustomer(){
        Account A = new Account(name='Account4TestMethod2');        
        A.BillingState= 'AndhraPradesh';  
        A.Name = 'testAccount2';
        A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
        A.MDM_Sold_To_Number__c = '56A47657';
        A.Physical_Country__c = 'USA';
        A.BillingCity = 'NYC';
        A.LX_Country_Code__c = 'AI';
        A.BillingCountry  = 'USA';
        A.LX_Geo__c = 'EMEA';
        A.MPS_Qualification__c = 'MPS';
        A.LXK_Region__c = 'USA';
        A.TR_Status__c = 'On';
        A.ISS_Coverage_Method__c = 'Face to Face';
        A.ISS_Coverage_Model__c ='Enterprise';
        //VT 10/1 added to remove validation error
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Primary_Sector_Focus__c = 'Manufacturing';  
        A.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Customer').getRecordTypeId();
        insert A;
        return A;
     }
     
    static testMethod void testExcute_DS() 
    {  
        ID userId ;
        Date todayDate ;
        pse__Proj__c project ;
        Contact resource ;
        
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
        pse__Work_Calendar__c workCalendar = new pse__Work_Calendar__c();
        insert workCalendar;
        System.assert(workCalendar.id != null);
        
        // create Region and Group test data 
        pse__Region__c region = createRegion();
        pse__Grp__c pseGroup = createGroup();
       
        //create Account test Data
        Account account = createAccountLocationCustomer();   
        

         resource = createResource(userId, account.Id, region.id, workCalendar.id); 
        System.assert(resource.id != null);
        
        System.assert(account.id != null);
        
        //create Opportuntiy test Data
        Opportunity opp = createOpportunity(account.id);
        
        System.assert(opp.id != null);
        
        //create a project
        project = createProject_DS(account.id,opp.id,resource.id,userId,region.id, pseGroup.id);
        System.assert(project.id != null);
        
        List<OpportunityLineItem> opplst = createLineItems(project.id ,opp.id);
        
        opp.COntract_Number__c = '67676786';
        
            
          Test.StartTest();
        
        update opp;
        
        Project_Billing_Items__c pbi1 = new Project_Billing_Items__c();
        pbi1.Opportunity__c = opp.Id;
        pbi1.Project__c = Project.ID;
        insert pbi1;
        
        List<Project_Billing_Items__c> pbi = [Select ID,Bill_Item__c from Project_Billing_Items__c where Opportunity__c =: opp.ID and Project__c =: Project.ID];
        
        System.debug('******BIlling Items' +pbi);
        
        for(Project_Billing_Items__c pb : pbi)
        {
        pb.Bill_Item__c = true;
        }
    
        update pbi;
       
        pse__Time_Period__c timePeriod = loadTimePeriod();
        System.assert(timePeriod.id != null);
        
      
       
        Invoice_Maker__c im = new Invoice_Maker__c(Time_Period_End_Date__c = timePeriod.pse__End_Date__c.addDays(5) ,
        Time_Period_Start_Date__c = timePeriod.pse__Start_Date__c.addDays(-5), time_Billings__c=true,
         time_MiscAdjustments__c = true, status__c = 'Ready-For-Pickup' , Time_Period__c = timePeriod.id,
         Record_Types__c = 'Database Services');
        insert im;
        for(Invoice_Maker__c im1 : [select id , status__c from Invoice_Maker__c where id  = : im.id]){
          //VT 8/25 Commented  System.assertEquals(im1.status__c, 'In-Process');
        }
        Set<Id> InvoiceMakerSet = new Set<Id>();
        InvoiceMakerSet.add(im.id);
        InvoiceMaker_DS.excute(InvoiceMakerSet);
   //   InvoiceMaker.excute(InvoiceMakerSet);
        
        Test.StopTest();
    }
 //----------------------------------------------------------------------MSU
 
 
    static testMethod void testExcute_MS() 
    {  
        ID userId ;
        Date todayDate ;
        pse__Proj__c project ;
        Contact resource ;
        
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
        pse__Work_Calendar__c workCalendar = new pse__Work_Calendar__c();
        insert workCalendar;
        System.assert(workCalendar.id != null);
        
        // create Region and Group test data 
        pse__Region__c region = createRegion();
        pse__Grp__c pseGroup = createGroup();
       
        //create Account test Data
        Account account = createAccountLocationCustomer();
        
         resource = createResource(userId, account.Id, region.id, workCalendar.id); 
        System.assert(resource.id != null);
        
        
        
        //create Opportuntiy test Data
        Opportunity opp = createOpportunity(account.id);
        
        System.assert(opp.id != null);
        
        //create a project
        project = createProject_MSU(account.id,opp.id,resource.id,userId,region.id, pseGroup.id);
        System.assert(project.id != null);
        
        List<OpportunityLineItem> opplst = createLineItems(project.id ,opp.id);
       
        pse__Time_Period__c timePeriod = loadTimePeriod();
        System.assert(timePeriod.id != null);
        
        Test.StartTest();
       
        Invoice_Maker__c im = new Invoice_Maker__c(Time_Period_End_Date__c = timePeriod.pse__End_Date__c.addDays(5) ,
        Time_Period_Start_Date__c = timePeriod.pse__Start_Date__c.addDays(-5), time_Billings__c=true,
         time_MiscAdjustments__c = true, status__c = 'Ready-For-Pickup' , Time_Period__c = timePeriod.id,
         Record_Types__c = 'Managed Services');
        insert im;
        for(Invoice_Maker__c im1 : [select id , status__c from Invoice_Maker__c where id  = : im.id]){
          //VT 8/25 Commented  System.assertEquals(im1.status__c, 'In-Process');
        }
        Set<Id> InvoiceMakerSet = new Set<Id>();
        InvoiceMakerSet.add(im.id);
   //   InvoiceMaker.excute(InvoiceMakerSet);
        Test.StopTest();
        InvoiceMaker_DS.generateFileName(im,'Start');
        String s = InvoiceMaker_DS.escapeQuote('"hello"');
        InvoiceMaker_mS.excute(InvoiceMakerSet);
    }
 
 
 //--------------------------------------------------------------------------------   
    
    
     public static pse__Grp__c createGroup(){   
 
        
        pse__Grp__c  pse_group = new pse__Grp__c(name='test Group');
        pse_group.CurrencyIsoCode = 'USD';
        pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
        pse_Group.pse__Parent_Group__c = ParentGroup.Id;
        insert pse_group;
        return pse_group;  
     }
        
         public static pse__Region__c  createRegion()
         {
        pse__Region__c parentRegion;
        for(pse__Region__c rg : [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1]){
            parentRegion = rg;
        }
          pse__Region__c region = new pse__Region__c();
        if(parentRegion != null)
            region.pse__Parent_Region__c = parentRegion.Id;
        insert region;
        return region;
    
    
  }  
  
   public static Account createAccount(){
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.MDM_Sold_To_Number__c = '1234';  
        acc.Physical_Country__c = 'USA';
        acc.BillingCountry = 'USA';
      
        insert acc;
        return acc;
    }
    
      public static Opportunity createOpportunity(String accId){
      Opportunity opp =  new Opportunity();
      opp.AccountId = accId;     
      opp.Name = 'Opportunity4TestMethod';
      opp.CloseDate = Date.today().addDays(10);
      opp.StageName = 'Negotiation';
      opp.Type = 'MPS';
      opp.QAStatus__c = 'New';
      opp.Contract_Number__c = '12345';
      opp.Contract_End_Date__c = Date.Today().addDays(5);
      opp.MPS__c=true;
      opp.LX_Sales_Type__c='Add On';
      opp.RecordTypeId = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('MPS').getRecordTypeId();
      insert opp;
      return opp;
    }
    
    public static List<OpportunityLineItem> createLineItems(id ProjectID,ID OppID)
    {
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        
        pmList[0].Family__c = 'Database Services';
        
        update pmList;
        
        List<Product2> product = Data_Product.createProduct(pmList);  
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        pse__Time_Period__c timePeriod = loadTimePeriod();
        List<OpportunityLineItem> LineItems = new List<OpportunityLineItem>();   
         for(Integer i =0;i<5;i++)
         {        
            OpportunityLineItem oppLineItems = new OpportunityLineItem();
            oppLineItems.opportunityId       = oppID;
            oppLineItems.Project__c          = ProjectID;
            oppLineItems.pricebookentryid    = Pbe.Id;
            oppLineItems.quantity            = 1;
            oppLineItems.unitprice           = 1;
            oppLineItems.Start_Date__c = timePeriod.pse__Start_Date__c;
            oppLineItems.End_Date__c = timePeriod.pse__end_Date__c;
            oppLineItems.Product_Family__c = 'Database Services';
            
            
           
            LineItems.add(oppLineItems);  
         }
        system.debug('lineItems entered:' + lineItems);
        insert LineItems;       
    return LineItems;
    
    }
    
    
      public static pse__Proj__c createProject_DS(ID accountId, ID opportunityId,Id resourceId, Id userId, Id regionId, Id groupId)
      {
     string PrRTId = ProjectRecordType__c.getValues('Database Services').Record_Type_ID__c;
        pse__Proj__c project = new pse__Proj__c();
        project.pse__Closed_for_Time_Entry__c
        = project.pse__Closed_for_Expense_Entry__c
        = false;
        project.pse__Allow_Expenses_Without_Assignment__c
        = project.pse__Allow_Timecards_Without_Assignment__c
        = project.pse__Is_Active__c
        = true;
        project.pse__Is_Billable__c = false;
        project.pse__Opportunity__c = opportunityId;
        project.pse__Account__c = accountId;
        project.pse__Project_Status__c = 'Red';
        project.pse__Start_Date__c = Date.today().addMonths(-1);
        project.pse__End_Date__c = Date.today().addMonths(4);
        project.pse__Region__c = regionId;
        project.pse__Group__c = groupId;
        project.OwnerId = userId;
        project.CurrencyIsoCode ='USD';
        project.pse__Project_Manager__c = resourceId;
        project.pse__Billing_Type__c = 'INVST_S_PB';
        project.RecordTypeId = PrRTId;
        
        insert project; 
        return project;
    }
    
     public static pse__Proj__c createProject_MSU(ID accountId, ID opportunityId,Id resourceId, Id userId, Id regionId, Id groupId)
      {
     string PrRTId = ProjectRecordType__c.getValues('MS Upgrades').Record_Type_ID__c;
        pse__Proj__c project = new pse__Proj__c();
        project.pse__Closed_for_Time_Entry__c
        = project.pse__Closed_for_Expense_Entry__c
        = false;
        project.pse__Allow_Expenses_Without_Assignment__c
        = project.pse__Allow_Timecards_Without_Assignment__c
        = project.pse__Is_Active__c
        = true;
        project.pse__Is_Billable__c = false;
        project.pse__Opportunity__c = opportunityId;
        project.pse__Account__c = accountId;
        project.pse__Project_Status__c = 'Red';
        project.pse__Start_Date__c = Date.today().addMonths(-1);
        project.pse__End_Date__c = Date.today().addMonths(4);
        project.pse__Region__c = regionId;
        project.pse__Group__c = groupId;
        project.OwnerId = userId;
        project.CurrencyIsoCode ='USD';
        project.pse__Project_Manager__c = resourceId;
        project.pse__Billing_Type__c = 'INVST_S_PB';
        project.RecordTypeId = PrRTId;
        
        insert project; 
        return project;
    }
     public static pse__Time_Period__c loadTimePeriod(){
        pse__Time_Period__c timePeriod;
        
            timePeriod = new pse__Time_Period__c (pse__Start_Date__c = Date.newInstance(2010,5,1), pse__end_Date__c = Date.newInstance(2010,5,29), pse__Type__c = 'Monthly');
            insert timePeriod;
        
        return timePeriod;
    }
      public static Contact createResource(Id userId, Id accountId, Id regionId, Id workCalendarId){
        Contact resource;
        for(Contact con : [Select Id, pse__Is_Resource__c, pse__Is_Resource_Active__c,email from Contact where pse__Salesforce_User__c =:userId limit 1]){
            resource = con;
        }
        if (resource == null || resource.email == null){
            resource = new Contact();
            resource.LastName = 'LastName';
            resource.AccountId = accountId;
             resource.Email = 'Test@test123.com';
            resource.pse__Resource_Role__c = 'Consultant';
            resource.pse__Work_Calendar__c = workCalendarId;
            resource.pse__Is_Resource__c = resource.pse__Is_Resource_Active__c = true;
            resource.pse__Default_Cost_Rate__c = 0;
            resource.pse__Region__c = regionId;
            resource.pse__Resource_Role__c = 'Consultant';
            resource.pse__Default_Cost_Rate__c = 25.0;
            resource.pse__Salesforce_User__c = userId;
            resource.Lx_Lexmark_Vertical__c='Manufacturing';
            insert resource;
        }else if(!resource.pse__Is_Resource__c || !resource.pse__Is_Resource_Active__c){
            resource.pse__Is_Resource__c = resource.pse__Is_Resource_Active__c = true;
            update resource;
        }
        return resource;
    }
    
    public static Account createAccount2(){
        Account acc = new Account();
        acc.Name = 'testAccount2';
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
        acc.MDM_Sold_To_Number__c = '56789';
        acc.Type = 'Partner-Channel Level 1';
        acc.Physical_Country__c = 'USA';
        acc.BillingCountry = 'USA';
        
        insert acc;
        return acc;
    }
    
  }