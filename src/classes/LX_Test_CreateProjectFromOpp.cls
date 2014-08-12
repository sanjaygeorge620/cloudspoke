/* Class Name : LX_Test_CreateProjectFromOpp
 * Description : This test class is written to test LX_CreateProjectFromOpp CLass.
 * Created By : Akanksha Gupta
 * Created Date : 10-29-2013 
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Akanksha Gupta       10-29-2013       1000                  Initial Version
 
 */
 
 @isTest(seeAlldata=true)
private class LX_Test_CreateProjectFromOpp{
    
    static testmethod void m1(){
        test.starttest();
    //  List<Opportunity> lstOpp = Data_Opportunity.createOpportunity(new List<String>{'Qualification'},1);
   Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
insert acc; 
List<Opportunity> oppo = new List<Opportunity>();
Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
insert Opp;
Oppo.add(opp);




        pse__Proj__c proj = new pse__Proj__c();  
        proj.pse__Opportunity__c = Oppo[0].id;
        proj.pse__Account__c = Oppo[0].accountid;
        insert proj;
        ApexPages.StandardCOntroller sc = new ApexPages.StandardCOntroller(proj);
        PageReference pageRef = new PageReference('/apex/CreateProjfromOpp');
        Test.setCurrentPage(pageRef);   
        ApexPages.currentPage().getParameters().put('oppId',Oppo[0].Id);
        ApexPages.currentPage().getParameters().put('accID',Oppo[0].AccountId);
        ApexPages.currentPage().getParameters().put('recordType','Pre-Sales');
        LX_CreateProjectFromOpp obj = new LX_CreateProjectFromOpp(sc);
        test.stoptest();
    }
    static testmethod void m2(){
        test.starttest();
        List<Opportunity> lstOpp = Data_Opportunity.createOpportunity(new List<String>{'Qualification'},1);
        pse__Proj__c proj = new pse__Proj__c();
        proj.pse__Opportunity__c = lstOpp[0].id;
        proj.pse__Account__c = lstOpp[0].accountid;
        insert proj;
        ApexPages.StandardCOntroller sc = new ApexPages.StandardCOntroller(proj);
        PageReference pageRef = new PageReference('/apex/CreateProjfromOpp');
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('oppId',null);
        ApexPages.currentPage().getParameters().put('accID',null);
        ApexPages.currentPage().getParameters().put('recordType','Assessment');
        LX_CreateProjectFromOpp obj = new LX_CreateProjectFromOpp(sc);
        test.stoptest();
    }
    //Method added to cover EmailNotificationTrigger 
     static testmethod void m3(){
        
        Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 

        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
        insert Opp;


        pse__Region__c pse_region = Data_PSE_Region.createRegion(); 
        pse__Proj__c proj = new pse__Proj__c();
        proj.pse__Opportunity__c =opp.id;
        proj.pse__Account__c = Opp.accountid;
        proj.Solution_Acceptance_Date__c = System.Today();
        proj.pse__Region__c = pse_region.Id;
        
        test.starttest();
        insert proj;
        ApexPages.StandardCOntroller sc = new ApexPages.StandardCOntroller(proj);
        PageReference pageRef = new PageReference('/apex/CreateProjfromOpp');
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('oppId',null);
        ApexPages.currentPage().getParameters().put('accID',null);
        ApexPages.currentPage().getParameters().put('recordType','Assessment');
        LX_CreateProjectFromOpp obj = new LX_CreateProjectFromOpp(sc);
        test.stoptest();
    }
    
    }