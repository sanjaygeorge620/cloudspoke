@isTest(seealldata=true)
//MFitzgerald | 31May2014 | Added LX_SLA_Penalties_Comments__c ='something', LX_Total_Devices_in_Scope__c =1, and LX_No_of_knowledge_workers__c=1 to all dml operations for validation rule
public class LX_Test_Operations_BI_BU_AI_AD{

    private testmethod static void testmethod2(){
        
    Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
    insert acc; 

    Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
    insert Opp;
    
    LX_Operations__c operation = new LX_Operations__c();
    RecordType rec = [Select id from Recordtype where developername='Non_NA_MPS' and SobjecttYpe='LX_Operations__c'];
    operation.name = 'test';
    operation.RecordTypeId= rec.id;
    operation.Is_Primary__c = true;
    operation.LX_Opportunity__c = opp.id;
    operation.LX_SLA_Penalties_Comments__c ='something';
    operation.LX_No_of_knowledge_workers__c =1;
    operation.LX_Total_Devices_in_Scope__c =1;
    insert operation;
    
    Opportunity opp1 = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
    insert Opp1;

    LX_Operations__c operation_test = new LX_Operations__c();
    RecordType rec1 = [Select id from Recordtype where developername='Non_NA_MPS' and SobjecttYpe='LX_Operations__c'];
    operation_test.name = 'testb';
    operation_test.Is_Primary__c = false;
    operation_test.RecordTypeId= rec1.id;
    operation_test.LX_Opportunity__c = opp.id;
    operation_test.LX_SLA_Penalties_Comments__c ='something';
    operation_test.LX_No_of_knowledge_workers__c =1;
    operation_test.LX_Total_Devices_in_Scope__c =1;
    insert operation_test;
         
       operation_test.Is_Primary__c = true;
    update operation_test;
    
    delete operation_test;
    
    }

    private testmethod static void testmethod1(){
        
    Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
    insert acc; 

    Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
    insert Opp;
    
    LX_Operations__c operation = new LX_Operations__c();
    RecordType rec = [Select id from Recordtype where developername='Non_NA_MPS' and SobjecttYpe='LX_Operations__c'];
    operation.name = 'test';
    operation.RecordTypeId= rec.id;
    operation.Is_Primary__c = true;
    operation.LX_Opportunity__c = opp.id;
    operation.LX_SLA_Penalties_Comments__c ='something';
    operation.LX_No_of_knowledge_workers__c =1;
    operation.LX_Total_Devices_in_Scope__c =1;
    insert operation;
    
    Opportunity opp1 = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
    insert Opp1;

    LX_Operations__c operation_test = new LX_Operations__c();
    RecordType rec1 = [Select id from Recordtype where developername='Non_NA_MPS' and SobjecttYpe='LX_Operations__c'];
    operation_test.name = 'testb';
    operation_test.Is_Primary__c = true  ;
    operation_test.RecordTypeId= rec1.id;
    operation_test.LX_Opportunity__c = opp.id;
    operation_test.LX_SLA_Penalties_Comments__c ='something';
    operation_test.LX_No_of_knowledge_workers__c =1;
    operation_test.LX_Total_Devices_in_Scope__c =1;
    insert operation_test;
    
    operation_test.name = 'testb1';
    operation_test.Is_Primary__c = true  ;
    operation_test.LX_Opportunity__c  = opp1.id;
    update operation_test;
    
    operation_test.Is_Primary__c = false  ;
    update operation_test;
    
    delete operation_test;
    
     Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User userNew = new User();
        userNew.FirstName = 'testUser345';
        userNew.LastName = 'testUser345';
        userNew.ProfileId = profile.Id;
        userNew.Legacy_Company__c = 'Lexmark';
        userNew.Username = 'testUserName1290@lexmark.com';
        userNew.Email = 'test123@lexmark.com';
        userNew.Alias = 'test';
        userNew.CommunityNickname = 'testComName';
        userNew.TimeZoneSidKey = 'America/Chicago';
        userNew.LocaleSidKey = 'en_US';
        userNew.EmailEncodingKey = 'ISO-8859-1';
        userNew.LanguageLocaleKey = 'en_US';
        userNew.EmployeeNumber ='1234567';
        
        insert userNew;
    
    OpportunityTeamMember otm = new OpportunityTeamMember(
                                   TeamMemberRole = 'Account Manager', 
                                   OpportunityId  = opp.Id,
                                   UserId         = userNew.id);
                                   
    insert otm;
    
    otm.TeamMemberRole = 'Account Role';
    update otm;
    delete otm;
    
    }
    



}