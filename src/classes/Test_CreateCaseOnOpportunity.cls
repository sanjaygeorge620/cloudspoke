/**
    Test Class for CreateInstallations
*/    
@isTest
private class Test_CreateCaseOnOpportunity {
    
    static testmethod void testCreateCaseOnInsert(){
        // create Account test data 
        Account acc = createAccount();
        // create contact test data with email id = login user's email Id
        Contact con = createContact(acc.id);
        // create Opportunity test data with stageName = Validation
        Opportunity opp = createOportunity(acc.id, 'Validation');
    }
    
    static testmethod void testCreateCaseOnUpdate(){
        // create Account test data 
        Account acc = createAccount();
        //create contact test data with email Id = login user's email Id
        Contact con = createContact(acc.id);
        // create Opportunity test data with StageName = 'Proposal'
        Opportunity opp = createOportunity(acc.id, 'Proposal');
        // update opportunity with stageName = Validation
        opp.StageName = 'Validation';
        Solution_Business_Process__c testSolBus = new Solution_Business_Process__c(Opportunity__c = opp.id,Account__c=acc.id);
        insert testSolBus;
        update opp;
    }
    
    
    public static Account createAccount(){
       //Account A = new Account(name='Account4TestMethod');
       Account A = Data_Account.createAccount();
       Id rtId;
       for(RecordType rt : [Select SobjectType, Name, Id, DeveloperName from RecordType where Name = 'Prospect Unlocked'  and SobjectType ='Account' ]){
            rtId = rt.id; 
       } 
       if(rtId != null){
        A.recordTypeId = rtId;
       }
  //     A.Address_Edit_States__c = 'Rajasthan';
       A.Party_Role__c = 'Press';
       A.Party_Type__c = 'OEM';
  //     insert A;
       update A;
       return A;
   }
   public static Opportunity createOportunity(ID accountID, String stageName){
        //Create a new Opportunity
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = accountID;
        opp1.Name = 'Opportunity4TestMethod';
        opp1.CloseDate = Date.today();
        opp1.StageName = stageName;
        opp1.Type = 'Renewal';
        opp1.Technology__c = True;
        opp1.LX_Sales_Type__c = 'New Project';
        insert opp1;
        return opp1;
   }
   
   public static Contact createContact(Id accountId){
    String emailId;
    for(User usr : [select Id, email from User where id = : userInfo.getUserId()]){
        emailId = usr.email;
    }
    Contact con = new Contact(LastName= 'Test Contact',accountId = accountId,Lx_Lexmark_Vertical__c = 'Manufacturing');
    if(emailId != null){
        con.email = emailId;
    }
    insert con;
    return con;
   }
   
    
}