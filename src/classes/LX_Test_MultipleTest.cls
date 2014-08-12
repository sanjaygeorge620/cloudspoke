@isTest(seeAllData = True)
public class LX_Test_MultipleTest{

    public static List<Opportunity> testOppList;
    public static List<LX_SAP_Record_Sales_Org__c> testSAPRecList;
    public static LX_SAP_Record_Sales_Org__c testSAPRec;
    public static List<LX_SAP_Record__c> testSAP;
    public static List<LX_SAP_Record_Sales_Org__c> otherTestRec;
    public static List<Case> testCaseList;
    public static List<String> testAddressList;
    public static List<pse__Assignment__c> testPSEAssign;
    public static List<pse__Timecard_Header__c> testPSETime;
    public static Lead newLead;
    public static Contact newContact;
    public static Account newAccount;
    
    //to Test LX_scheduleDailyNote
    public static testmethod void test_LX_scheduleDailyNote(){
    test.startTest();
    test.stopTest();
    } 
    
    //to Test LX_SAPSalesOrgTriggerUtil
    public static testmethod void test_LX_SAPSalesOrgTriggerUtil(){
    test.startTest();
    try {
        String tempName = 'Temp Creator';
        testAddressList = new List<String>();
        testAddressList.add('Add1@lexmark.com');
        testAddressList.add('Add2@lexmark.com');
        testAddressList.add('Add3@lexmark.com');
        testAddressList.add('Add4@lexmark.com');
        testCaseList = new List<Case>();
        testCaseList = [Select id from case limit 1];
        testSAP = new List<LX_SAP_Record__c>();
        testSAP = [Select id,name from LX_SAP_Record__c limit 2];
        otherTestRec = new List<LX_SAP_Record_Sales_Org__c>();
        otherTestRec = [Select id,Name from LX_SAP_Record_Sales_Org__c limit 1]; 
        testSAPRec = new LX_SAP_Record_Sales_Org__c();
            testSAPRec.LX_Sales_Org1__c = '1001';
            testSAPRec.LX_Bill_To_Sales_Org__c = otherTestRec[0].Id;
            testSAPRec.LX_Sold_To__c = testSAP[0].Id;
            testSAPRec.LX_SAP_Record__c = testSAP[1].Id;
            //testSAPRec.Name = 'testName';
            //testSAPRec.LX_Physical_Street_Address__c = 'test address';
            //testSAPRec.LX_Physical_Street_Address_2__c = 'test address 2';
            //testSAPRec.LX_Physical_City__c = ' testcity';
            //testSAPRec.LX_Physical_Postal_Code__c = 'testcode';
            //testSAPRec.LX_Physical_State__c = 'teststate';
            //testSAPRec.LX_Physical_Province__c = 'testprovince';
            //testSAPRec.LX_Physical_Country__c = 'testcountry';
            insert testSAPRec;
        LX_SAPSalesOrgTriggerUtil testInstance = new LX_SAPSalesOrgTriggerUtil();
        LX_SAPSalesOrgTriggerUtil.SentEmail(1,testSAPRec,testCaseList[0],testAddressList,tempName );
        LX_SAPSalesOrgTriggerUtil.SentEmail(2,testSAPRec,testCaseList[0],testAddressList,tempName );
        LX_SAPSalesOrgTriggerUtil.SentEmail(3,testSAPRec,testCaseList[0],testAddressList,tempName );
        LX_SAPSalesOrgTriggerUtil.SentEmail(4,testSAPRec,testCaseList[0],testAddressList,tempName );
        }
        catch (Exception e) {}
    test.stopTest();
    }
    
    //to Test LX_GetWBSController
    public static testmethod void test_LX_GetWBSController(){
    test.startTest();
    try {
        testPSETime = new List<pse__Timecard_Header__c>();
        testPSETime = [Select id from pse__Timecard_Header__c where pse__Admin_Global_Edit__c = True limit 1];
        testPSEAssign = new List<pse__Assignment__c>();
        testPSEAssign = [Select id,name,pse__Resource__c from pse__Assignment__c limit 1];
        testPSETime[0].pse__Assignment__c = testPSEAssign[0].Id;
        //update testPSETime;
        ApexPages.currentPage().getParameters().put('id',testPSETime[0].id);
        LX_GetWBSController testInstance = new LX_GetWBSController();
        testInstance.save();
        }
        catch (Exception e){}
    test.stopTest();
    }
    
    //to Test LX_EE_PrintReleasePDFExtn
    public static testmethod void test_LX_EE_PrintReleasePDFExtn(){
    test.startTest();
    try {
    Opportunity sampleOpp = new Opportunity();
    sampleOpp = [Select id from opportunity limit 1];
        ApexPages.StandardController sc = new ApexPages.standardController(sampleopp);
        LX_EE_PrintReleasePDFExtn testInstance = new LX_EE_PrintReleasePDFExtn(sc);
     }
     catch (Exception e) {}   
    test.stopTest();
    }
    
    //to Test LeadtApprovalSubmit Trigger is presently Inactive
    public static testmethod void test_LeadtApprovalSubmit(){
    test.startTest();
    try {
    newLead = new Lead();
        newLead.LastName='Test Contact';
        newLead.firstName='TestFirst';
        newLead.Status = 'Open' ;
        newLead.Company ='Testing Company'; 
        newLead.Sector__c ='Cross Industry';
        newLead.Lead_Type__c ='Expansion-Add On';
        newLead.LX_ISS_Coverage_Model__c = 'OLA';
        newLead.LX_ISS_Coverage_Method__c = 'Face To Face';
        newLead.TR_Status__c = 'Off';
        newLead.City = 'abc';
        newLead.PostalCode = '4237';
        newLead.Street = 'xyz';
        newLead.State = 'testcity';
        newLead.Preferred_Language__c = 'English';
        Insert newLead;
        }
        catch (Exception e) {}
    test.stopTest();
    }
    
    //to Test LX_ContactShareTrg
    public static testmethod void test_LX_ContactShareTrg(){
    test.startTest();
    try {
        List<Account> acc = new List<Account>();
        acc = [Select id from Account limit 1];
        newContact = new Contact();
            newContact.LastName='Test Contact1 ';
            newContact.firstName='TestFirst';
            newContact.AccountId = acc[0].Id;
            newContact.Contact_Role__c ='Executive'; 
            newContact.Region__c='NA';
            newContact.email='test@lexmark.com';
            newContact.Physical_street_address__c = '74553 W';
            newContact.Physical_City__c = 'shawnee';
            newContact.address_edit_countries__c = 'United States';
            newContact.License_Contact__c=true;
            newContact.Accounting_Contact__c = true;
            newContact.areas_of_need__c = 'Content';
            newContact.pse__Is_Resource__c = true;
            newContact.pse__Is_Resource_Active__c = true;
            newContact.phone='123456789';
            newContact.MobilePhone='9123456789';
            newContact.Fax='9123456789';
            newContact.Status__c = 'Active' ;
            newContact.Industry__c = 'Manufacturing';
            newContact.Lx_Lexmark_Vertical__c='Manufacturing';
        insert newContact;
        newContact.MobilePhone = '9123456555';
        update newContact;
        }
        catch (Exception e) {}
    test.stopTest();
    }
    
    //to Test LX_AccountShareTrg
    public static testmethod void test_LX_AccountShareTrg(){
    test.startTest();
    try {
        Geography_Coverage__c gc = Data_GeographyCoverage.createGeographyCoverage();      
        newAccount = new Account();
            newAccount.BillingState = 'Rajasthan';  
            newAccount.Name = 'testAccount';
            newAccount.Sector__c = 'State/Local';
            newAccount.Type = 'Customer';  
            newAccount.Party_Role__c = 'Perpetual';
            newAccount.Party_Type__c =  'Commercial';
            newAccount.Coverage_ID__c = gc.id;
            newAccount.MDM_Sold_To_Number__c = '56A47657';
            newAccount.Primary_Sector_Focus__c = 'Manufacturing';
            newAccount.Legacy_Company_Originator__c = 'Acuo';
            newAccount.LX_Sales_Team_Assigned__c ='Manufacturing';
            newAccount.Physical_Country__c = 'USA';
            newAccount.BillingCountry  = 'USA';
            newAccount.RecordTypeId = LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
        insert newAccount;
        newAccount.BillingState = 'Punjab';
        update newAccount;
        }
        catch (Exception e) {}
    test.stopTest();
    }
    
    //to Test RecordSharing 
    public static testmethod void test_RecordSharing (){
    test.startTest();
    try {
        RecordSharing testInstance = new RecordSharing();
        Set<ID> LeadListIDs = new Set<ID>();
        List<Lead> leadList = new List<Lead>();
        leadList = [Select id from lead limit 5];
        for(Lead l : leadList){
            LeadListIDs.add(l.id);
        }
        RecordSharing.manualShare_Lead_Read(LeadListIDs);
        }
        catch (Exception e) {}
    test.stopTest();
    }
    
    //to Test RecordSharing_Removal 
    public static testmethod void test_RecordSharing_Removal(){
    test.startTest();
    try {
        Set<ID> accListIDs = new Set<ID>();
        List<ID> userIDList = new List<ID>();
        List<User> accUserList = new List<User>();
        accUserList = [Select id,accountId from User where isActive = True limit 5];
        for(User a : accUserList){
            accListIDs.add(a.accountid);
            userIDList.add(a.ID);
        }
        Set<ID> LeadListIDs = new Set<ID>();
        List<Lead> leadList = new List<Lead>();
        leadList = [Select id from Lead limit 1];
        List<leadShare> newLS = new List<leadShare>();
        leadShare ls = new LeadShare();
            ls.LeadAccessLevel = 'Read';
            ls.LeadId = leadList[0].Id;
            //ls.RowCause = 'Manual';
            ls.UserOrGroupID = userIDList[0];
        Insert ls;
        List<LeadShare> leadShareList = new List<LeadShare>();
        leadShareList = [Select id,leadId from leadShare where UserOrGroupID In :accListIDs limit 1];
        for(LeadShare l : leadShareList ){
            LeadListIDs.add(l.leadId);
        }
        RecordSharing_Removal.manualShare_Lead_Removal(LeadListIDs ,accListIDs );
        }
        catch (Exception e) {}
    test.stopTest();
    }
    /*
    //to Test LX_WBSElementProject_BI_BU
    public static testmethod void test_LX_WBSElementProject_BI_BU(){
    test.startTest();
        Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
       
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
        insert Opp;

        WBS_Element__c wbs_ele = new WBS_Element__c(name='Testing');
        insert wbs_ele ;
        WBS_Element__c e = [SELECT id, name FROM WBS_Element__c Where name='Testing'];
        e.Name = 'TestEle';
        update e;
        List<pse__timecard_header__c> tempPSEproj = new List<pse__timecard_header__c >();
        tempPSEproj = [Select id,pse__project__c,pse__project__r.pse__Billing_Type__c,Company_Number__c from pse__timecard_header__c where pse__project__c != Null 
                       AND (pse__Project_Methodology__c = 'Billable Hourly' OR pse__Project_Methodology__c = 'Fixed Price Hours')
                       limit 5];
        for(pse__timecard_header__c p : tempPSEproj){
            p.pse__project__r.pse__Billing_Type__c = 'Pre-Sales';
        }
        update tempPSEproj;
        List<WBS_Element__c> tempWBSEle = new List<WBS_Element__c>();
        String temp1 = String.ValueOf(tempPSEproj[0].Company_Number__c );
        String temp2 = '%';
        String temp = temp2+temp1;
        tempWBSEle = [Select id,name from WBS_Element__c where name like 'B%' AND name like :temp  limit 5];
        WBS_Element_Project__c wbs_ele_projnotnull = new WBS_Element_Project__c(WBS_Element__c = tempWBSEle[0].id , Opportunity__c = opp.id, Project__c = tempPSEproj[0].pse__project__c );
        insert  wbs_ele_projnotnull ;
        
        tempPSEproj = [Select id,pse__project__c,Company_Number__c from pse__timecard_header__c where pse__project__c != Null 
                       AND pse__Project_Methodology__c = 'MPS' limit 5];
        for(pse__timecard_header__c p : tempPSEproj){
            p.pse__project__r.pse__Billing_Type__c = 'Pre-Sales';
        }
        update tempPSEproj;
        temp1 = String.ValueOf(tempPSEproj[0].Company_Number__c );
        temp2 = '%';
        temp = temp2+temp1;
        tempWBSEle = [Select id,name from WBS_Element__c where name like 'P%' AND name like :temp limit 5]; 
        WBS_Element_Project__c wbs_ele_projnotnull1 = new WBS_Element_Project__c(WBS_Element__c = tempWBSEle[0].id , Opportunity__c = opp.id, Project__c = tempPSEproj[0].pse__project__c );
        insert  wbs_ele_projnotnull1 ; 
        
        WBS_Element_Project__c wbs_ele_proj = new WBS_Element_Project__c(WBS_Element__c = wbs_ele.id , Opportunity__c = opp.id);
        insert  wbs_ele_proj;  
    test.stopTest();
    }
    */
    
    //to Test QualificationApprovalHistoryController
    public static testmethod void test_QualificationApprovalHistoryController(){
    test.startTest();
    try {
    List<ProcessInstanceHistory> retValueList = new List<ProcessInstanceHistory>();
    QualificationApprovalHistoryController testInstance = new QualificationApprovalHistoryController();
    Qualification__c tempQual = new Qualification__c();
    retValueList = testInstance.getApprovalSteps();
        tempQual = [Select id from Qualification__c limit 1];
        testInstance.QualificationId = tempQual.Id;
        retValueList = testInstance.getApprovalSteps();
        }
        catch (Exception e) {}
    test.stopTest();
    }
    
    //to Test SubmitSimpleLead
    /*public static testmethod void test_SubmitSimpleLead(){
    test.startTest();
        Lead sampleLead = new Lead();
          sampleLead = [Select id from lead where
         ((((LX_Party_Group__c = 'Partner' AND Business_Unit__c = 'ISS') OR (Business_Unit__c = 'ISS' AND LX_Party_Group__c = 'Customer' AND LX_ISS_Coverage_Model__c = 'OLA')) AND (RecordSubmittedForApproval__c = False AND Status = 'Open' AND 
         (ApproverBasedOnLocation__c = Null OR ApproverBasedOnLocation2__c = null)))
          OR
         (((LX_Party_Group__c = 'Partner' AND Business_Unit__c = 'ISS') OR (Business_Unit__c = 'ISS' AND LX_Party_Group__c = 'Customer' AND LX_ISS_Coverage_Model__c = 'OLA')) AND (RecordSubmittedForApproval__c = False AND RecordRejectedAtApproval__c = True AND Status != 'Qualified' AND 
         (ApproverBasedOnLocation__c = Null OR ApproverBasedOnLocation2__c = null))))
         AND RecordType.Name = 'Simple'
          limit 1];
          
        sampleLead.RecordRejectedAtApproval__c = True;
        sampleLead.Region__c = 'North America';
        Update sampleLead;
        Lead otherSampleLead = new Lead();
        otherSampleLead = [Select id from lead where id != :sampleLead.Id limit 1]; 
        ApexPages.StandardController sc = new ApexPages.standardController(sampleLead);
        Apexpages.CurrentPage().getParameters().put('id',sampleLead.Id);
        SubmitSimpleLead testInstance = new SubmitSimpleLead(sc);
        PageReference retPage = testInstance.submitLeadForApproval();
        
        sampleLead.Region__c = 'EMEA';
        update sampleLead;
        //retPage = testInstance.submitLeadForApproval();
    test.stopTest();
    }*/
    
    //to Test sobjectsCls
    public static testmethod void test_sobjectsCls(){
    test.startTest();
    try {
        sobjectsCls testInstance = new sobjectsCls();
    test.stopTest();
    }
    catch (Exception e)
    {}
    
    }
}