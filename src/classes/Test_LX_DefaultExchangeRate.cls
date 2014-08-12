@isTest(SeeallData = true)
private class Test_LX_DefaultExchangeRate {

static testMethod void DefaultExchangeRate(){
    
    Account aa = Data_Account.createAccount3();
    
    Contact cc = new Contact();
    cc.LastName = 'Test Contact';
    cc.AccountId = aa.Id;
    cc.Default_Bill_To__c = true;
    cc.Contact_Role__c = 'User';
    cc.email = 'abc@abc.com';
    cc.phone = '+1 213 456 7890';
    insert cc;
    
     test.startTest();
    
    RecordType rr1 = [select id,name from RecordType where name = 'Expansion-Add On' and sObjectType = 'Opportunity'];
    RecordType rr2 = [select id,name from RecordType where DeveloperName = 'Lx_Location_Partner' and sObjectType = 'Account'];

    
    aa.RecordTypeId = rr2.id;
    aa.TR_Status__c = '';
    update aa;
    
     Opportunity oo = new Opportunity(AccountID = aa.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='Expansion New Solution',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology');
    insert oo;
    
    Opportunity oo1 = new Opportunity(AccountID = aa.id,Name='Sold to Opportunity',CloseDate=Date.Today()+7,Type='Expansion New Solution',StageName='Closed Won',Account_Number__c='345678',Budget__c='98765',
                                            Authority__c='test',Objectives__c='test',Timeline__c='today',Next_Steps__c='2',Signed_Contract_Received__c=TRUE,Top_Loss_Reason__c='Price',
                                            Loss_Comments__c='Won',LX_Competitor_Lost_To__c=Data_Account.createAccount3().id,Department__c='Accounting',Non_Standard_Travel_Terms__c=TRUE,
                                            Purchase_Order__c='1234',QAStatus__c='Complete',Area_of_Interest_s__c='Content',Qualification_Level__c='Level 1',Reason_for_Conversion__c='Enterprice Government',
                                            Sector__c='Banking',LX_Bill_To_Email_Address__c = 'proces_min@perceptivesoftware.com',Technology__c=true,LX_Sales_Type__c='New Project',LX_product_type__c = 'Technology',
                                            Primary_Partner__c = aa.Id);
    insert oo1;  
      
    LX_Countries_In_Scope__c scope = new LX_Countries_In_Scope__c(LX_Opportunity__c = oo1.Id, CurrencyIsoCode ='USD');
    insert scope;
    
 LX_DefaultExchangeRateClass.DefaultExchangeRateMethod (scope.id);
    
     test.stopTest();
}
}