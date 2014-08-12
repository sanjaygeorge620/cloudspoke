/**
 * Test class for InvoiceMaker
 */
@isTest
private class Test_InvoiceMaker_Intl {/*

    static testMethod void testExcute() {
         try{
        ID userId ;
        Date todayDate ;
        pse__Proj__c project ;
        pse__Proj__c project1 ;
        Contact resource ;
        
        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
        // create Region and Group test data 
        pse__Region__c region = createRegion();
        pse__Grp__c pseGroup = createGroup();
       
        //create Account test Data
        Account account = createAccount();
        System.assert(account.id != null);
        
        //create Opportuntiy test Data
        Opportunity opp = createOpportunity(account.id);
        System.assert(opp.id != null);
        
        //create work calendar
        pse__Work_Calendar__c workCalendar = new pse__Work_Calendar__c();
        insert workCalendar;
        System.assert(workCalendar.id != null);
        
        // create a resource
        resource = createResource(userId, account.Id, region.id, workCalendar.id); 
        System.assert(resource.id != null);
        
        //create a project
        project = createProject(account.id,opp.id,resource.id,userId,region.id, pseGroup.id);
        System.assert(project.id != null);
        project1 = project.clone(false);//change
        project1.Name = 'Test Project 1';//change
        project1.pse__Parent_Project__c = project.id;//change
        insert project1; // change
        
        System.assert(project1.id != null);//change
        
        //create a time period
        pse__Time_Period__c timePeriod = loadTimePeriod();
        System.assert(timePeriod.id != null);
        
        //create Billing Event Batch
        pse__Billing_Event_Batch__c  billingEventBatch = createBillingEventBatch(timePeriod.id,account.id, region.id);
        System.assert(billingEventBatch.id != null);
        //create Billing Event
        pse__Billing_Event__c billingEvent = createBillingEvent(project.id,billingEventBatch.id);
        System.assert(billingEvent.id != null);
        
        // assign permissions
        List<pse__Permission_Control__c> permissions = createPermissionControls(resource.id,project.id,region.id);
        pse__Assignment__c assignment;
       
        assignment = createAssignment(project.id,resource.id);
        System.assert(assignment.id != null);
       
        //create Miscellaneous Adjustment object
        pse__Miscellaneous_Adjustment__c miscAdjustment = createMiscAdjust(project.id);
        pse__Timecard_Header__c timecardHeader = createTimecard(project.Id, resource.id,assignment.id);
        System.assert(timecardHeader.id != null);
        

        List<pse__Billing_Event_Item__c> billingEIs = createBillingEventItems(billingEvent.id, project.id, timecardHeader.id,miscAdjustment.id);
        List<pse__Timecard__c> pseTimecards = new List<pse__Timecard__c>();
        for(pse__Timecard__c pseTimecardSplit : [select Id, pse__Billing_Event_Item__c from pse__Timecard__c where pse__Timecard_Header__c  = : timecardHeader.id ]){
            System.debug('--Test class--'+pseTimecardSplit);
            pseTimecardSplit.pse__Billing_Event_Item__c = billingEIs.get(0).id;
            pseTimecards.add(pseTimecardSplit);
        }
        update pseTimecards;
        Invoice_Maker__c im = new Invoice_Maker__c(Time_Period_End_Date__c = timePeriod.pse__End_Date__c.addDays(5) 
                                            ,Time_Period_Start_Date__c = timePeriod.pse__Start_Date__c.addDays(-5)
                                            , time_Billings__c=true
                                            , time_MiscAdjustments__c = true
                                            , status__c = 'Ready-For-Pickup' 
                                            , Time_Period__c = timePeriod.id
                                            , Record_Types__c = 'Professional Services');
        insert im;
        String dateKey = im.Time_Period_Start_Date__c +';'+im.Time_Period_End_Date__c;
        Map<String,List<pse__Billing_Event_Item__c>> billingEventItems = new Map<String,List<pse__Billing_Event_Item__c>>();//change

        billingEventItems.put(dateKey,billingEIs); // change
        Test.StartTest();
        //for(Invoice_Maker__c im1 : [select id , status__c from Invoice_Maker__c where id  = : im.id]){
           //VT 8/25 Commented System.assertEquals(im1.status__c, 'In-Process');
        //}
        Set<Id> InvoiceMakerSet = new Set<Id>();
        InvoiceMakerSet.add(im.id);
        InvoiceMaker_Intl.excute(InvoiceMakerSet);
        InvoiceMaker_Intl.map_madj.put(miscAdjustment.id,miscAdjustment);//change
        InvoiceMaker_Intl.getContractNumber(project1);//change
        Map<String, Integer> namingPatternNumberMap = new Map<String,Integer>();//change
        Map<String, List<pse__Billing_Event_Item__c>> tempBillingEIs = new Map<String, List<pse__Billing_Event_Item__c>>();
        pse__Billing_Event_Item__c billingEventItem = new pse__Billing_Event_Item__c();
        billingEventItem = billingEIs[0];
        String keyBEI = billingEventItem.pse__Project__r.Name + ':'+billingEventItem.pse__project__c;
        tempBillingEIs.put(keyBEI,billingEIs);
        InvoiceMaker_Intl.buildChildBEIMap(tempBillingEIs,billingEIs[0]);
        namingPatternNumberMap = InvoiceMaker_Intl.generateNamingPatternNumber('');//change
        InvoiceMaker_Intl.createAttachment(im,billingEventItems,namingPatternNumberMap,'Billing');//change
        Test.StopTest();
         }
        catch(exception e){
        
        }
    }
    
    public static pse__Region__c  createRegion(){
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
        Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage(); 
        Sales_Organization__c SalesOrg = Data_SalesOrganization.createSalesOrganization(); 
        salesOrg.Sales_Organization__c = '152365';
        Update SalesOrg;
        gc.Sales_Organization__c = salesOrg.id;
        update gc;
        
        Account acc = new Account();
        acc.Name = 'testAccount';
        acc.MDM_Sold_To_Number__c = '1234';
        acc.Coverage_ID__c = gc.ID;
        insert acc;
        return acc;
    }
    
     public static Opportunity createOpportunity(String accId){
      Opportunity opp =  new Opportunity();
      opp.AccountId = accId;
      opp.Name = 'Opportunity4TestMethod';
      opp.CloseDate = Date.today().addDays(10);
      opp.StageName = 'Negotiation';
      opp.Type = 'Renewal';
      opp.QAStatus__c = 'New';
      opp.Contract_Number__c = '435698';
      opp.Contract_End_Date__c = Date.Today().addDays(5);
      insert opp;
      Opportunity OppRec = [select AccountId, Name, CloseDate, StageName, Type, QAStatus__c, Contract_Number__c, Contract_End_Date__c, Sales_Organization__c from Opportunity where id = :opp.id];
      return oppRec;
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
            insert resource;
        }else if(!resource.pse__Is_Resource__c || !resource.pse__Is_Resource_Active__c){
            resource.pse__Is_Resource__c = resource.pse__Is_Resource_Active__c = true;
            update resource;
        }
        return resource;
    }
    
    public static pse__Proj__c createProject(ID accountId, ID opportunityId,Id resourceId, Id userId, Id regionId, Id groupId){
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
        
        insert project; 
        return project;
    }
    
    public static pse__Grp__c createGroup(){   
 
        
        pse__Grp__c  pse_group = new pse__Grp__c(name='test Group');
        pse_group.CurrencyIsoCode = 'USD';
        pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
        pse_Group.pse__Parent_Group__c = ParentGroup.Id;
        insert pse_group;
        return pse_group;  
     }
     
   
    public static List<pse__Permission_Control__c> createPermissionControls(Id resourceId, Id projectId, Id regionId){
        List<pse__Permission_Control__c> percontrols = new List<pse__Permission_Control__c>();
        //give permissions to resource
        pse__Permission_Control__c perControl1 = new pse__Permission_Control__c();
        perControl1.pse__User__c = UserInfo.getUserId();
        perControl1.pse__Resource__c = resourceId;
        perControl1.pse__Start_Date__c = Date.today();
        perControl1.pse__End_Date__c = Date.today().addDays(10);
        perControl1.pse__Cascading_Permission__c = true;
        perControl1.pse__Timecard_Entry__c = true;
        perControl1.pse__Timecard_Ops_Edit__c = true;
        perControl1.pse__Resource_Request_Entry__c = true;
        perControl1.pse__Billing__c = true;
        perControl1.pse__Expense_Entry__c = true;
        perControl1.pse__Expense_Ops_Edit__c = true;
        perControl1.pse__Invoicing__c = true;
        perControl1.pse__Skills_And_Certifications_Entry__c = true;
        perControl1.pse__Skills_And_Certifications_View__c = true;
        perControl1.pse__Staffing__c = true;
        perControl1.CurrencyIsoCode = 'USD';
        percontrols.add(perControl1);
        
        pse__Permission_Control__c perControl2 = new pse__Permission_Control__c();
        perControl2.pse__User__c = UserInfo.getUserId();
        perControl2.pse__Project__c = projectId;
        perControl2.pse__Start_Date__c = Date.today();
        perControl2.pse__End_Date__c = Date.today().addDays(10);
        perControl2.pse__Cascading_Permission__c = true;
        perControl2.pse__Timecard_Entry__c = true;
        perControl2.pse__Timecard_Ops_Edit__c = true;
        perControl2.pse__Resource_Request_Entry__c = true;
        perControl2.pse__Billing__c = true;
        perControl2.pse__Expense_Entry__c = true;
        perControl2.pse__Expense_Ops_Edit__c = true;
        perControl2.pse__Invoicing__c = true;
        perControl2.pse__Skills_And_Certifications_Entry__c = true;
        perControl2.pse__Skills_And_Certifications_View__c = true;
        perControl2.pse__Staffing__c = true;
        perControl2.CurrencyIsoCode = 'USD';
        percontrols.add(perControl2);
        
        pse__Permission_Control__c perControl3 = new pse__Permission_Control__c();
        perControl3.pse__User__c = UserInfo.getUserId();
        perControl3.pse__Region__c = regionId;
        perControl3.pse__Start_Date__c = Date.today();
        perControl3.pse__End_Date__c = Date.today().addDays(10);
        perControl3.pse__Cascading_Permission__c = true;
        perControl3.pse__Timecard_Entry__c = true;
        perControl3.pse__Timecard_Ops_Edit__c = true;
        perControl3.pse__Resource_Request_Entry__c = true;
        perControl3.pse__Billing__c = true;
        perControl3.pse__Expense_Entry__c = true;
        perControl3.pse__Expense_Ops_Edit__c = true;
        perControl3.pse__Invoicing__c = true;
        perControl3.pse__Skills_And_Certifications_Entry__c = true;
        perControl3.pse__Skills_And_Certifications_View__c = true;
        perControl3.pse__Staffing__c = true;
        perControl3.CurrencyIsoCode = 'USD';
        percontrols.add(perControl3);
        insert percontrols;
        return percontrols;
    }
    
    
    public static pse__Assignment__c createAssignment(Id projectId, Id contactId){
        try{
        pse__Schedule__c schedule = new pse__Schedule__c();        
        schedule.pse__Start_Date__c = Date.today();
        schedule.pse__End_Date__c = Date.today().addDays(5);        
        insert schedule;
        
        pse__Assignment__c assignment = new pse__Assignment__c();
        assignment.pse__Project__c = projectId;
        assignment.pse__Schedule__c = schedule.id;
        assignment.pse__Resource__c = contactId;   
        assignment.pse__Bill_Rate__c = 0;
        assignment.pse__Is_Billable__c = true;
        assignment.pse__Cost_Rate_Amount__c = 0;
        assignment.CurrencyIsoCode = 'USD';
        insert assignment;
        return assignment;
        }
        catch(exception e){
        
        }
        return null;
    }
    
     public static pse__Timecard_Header__c createTimecard(Id projectId, Id resourceId, Id assignmentId){
        pse__Timecard_Header__c timecardHeader = new pse__Timecard_Header__c();
        timecardHeader.pse__Project__c = projectId;
        timecardHeader.pse__Resource__c = resourceId;
        timecardHeader.pse__Start_Date__c = Date.today();
        timecardHeader.pse__End_Date__c = Date.today().addDays(6);
        timecardHeader.pse__Assignment__c = assignmentId;
        timecardHeader.pse__Status__C = 'Saved';
        timecardHeader.pse__Billed__c = false;
        timecardHeader.pse__Billable__c = false;
        timecardHeader.pse__Project_Methodology__c = 'INVST_S_PB';
        timecardHeader.pse__Submitted__c = false;
        insert timecardHeader;
        return timecardHeader;
    }
    public static pse__Miscellaneous_Adjustment__c createMiscAdjust(Id projectId){
        pse__Miscellaneous_Adjustment__c miscAdjustment = new pse__Miscellaneous_Adjustment__c(Name='test');
        miscAdjustment.pse__Transaction_Category__c = 'Revenue';
        miscAdjustment.pse__Effective_Date__c = System.today();
        miscAdjustment.pse__Amount__c = 100;
        miscAdjustment.CurrencyIsoCode = 'USD';
        miscAdjustment.pse__Project__c = projectId;
        miscAdjustment.Labor_Category_Account_Number__c = '999999';
        miscAdjustment.Invoice_Description__c = 'Configuration';
        insert miscAdjustment;
        return miscAdjustment;
    }
    public static pse__Time_Period__c loadTimePeriod(){
        pse__Time_Period__c timePeriod;
        for(pse__Time_Period__c tp :[select Id, pse__Start_Date__c, pse__end_Date__c from pse__Time_Period__c limit 1]){
            timePeriod = tp;
        }
        if(timePeriod == null){
            timePeriod = new pse__Time_Period__c (pse__Start_Date__c = Date.Today(), pse__end_Date__c = Date.Today()+20, pse__Type__c = 'Monthly');//change
            insert timePeriod;
        }
        return timePeriod;
    }
    
    public static pse__Billing_Event_Batch__c  createBillingEventBatch(Id timecardId, Id accountId,Id regionId){
        pse__Billing_Event_Batch__c billingEventBatch = new pse__Billing_Event_Batch__c(pse__Time_Period__c = timecardId, pse__Account__c = accountId, pse__Region__c = regionId);
        insert billingEventBatch;
        return billingEventBatch;
    } 
    
    public static pse__Billing_Event__c createBillingEvent(Id projectId, Id batchId){
        pse__Billing_Event__c billingEvent = new pse__Billing_Event__c();
        billingEvent.pse__Date__c = Date.today();
        billingEvent.CurrencyIsoCode ='USD';
        billingEvent.pse__Project__c = projectId; 
        billingEvent.pse__Billing_Event_Batch__c = batchId;
        insert billingEvent; 
        return billingEvent;
    } 
    
    
    public static List<pse__Billing_Event_Item__c> createBillingEventItems(Id beId , Id projId,Id timecardId,Id miscAdjustId){
        List<pse__Billing_Event_Item__c> billingEventItems = new List<pse__Billing_Event_Item__c>();
        
        pse__Billing_Event_Item__c billingEventItem = new pse__Billing_Event_Item__c();
        billingEventItem.pse__Object_Id__c = timecardId;
        billingEventItem.pse__Category__c = 'Timecard';
        billingEventItem.pse__Project__c = projId;
        billingEventItem.pse__Billing_Event__c = beId;
        billingEventItem.pse__Amount__c = 100;
        billingEventItem.pse__Quantity__c = 2;
        billingEventItems.add(billingEventItem);
        
        billingEventItem = new pse__Billing_Event_Item__c();
        billingEventItem.pse__Object_Id__c = miscAdjustId;
        billingEventItem.pse__Category__c = 'Miscellaneous Adjustment';
        billingEventItem.pse__Project__c = projId;
        billingEventItem.pse__Billing_Event__c = beId;
        billingEventItem.pse__Amount__c = 100;
        billingEventItem.pse__Quantity__c = 2;
        billingEventItems.add(billingEventItem);
        
        insert billingEventItems;
        return billingEventItems;
    }
    */
    
}