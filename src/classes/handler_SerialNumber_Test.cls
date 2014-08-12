@isTest
private class handler_SerialNumber_Test {
 
    static Account testAccount {get;set;}
    static Opportunity testOpportunity {get;set;}
    static List<Product_Model__c> pmLists {get;set;}
    static List<Product2> products {get;set;}
    static SAP_Contract__c testSapContract {get;set;}
    static SAP_Sales_Order__c testSAPSalesOrder {get;set;}
    static Serial_Number__c testSerialNumber {get;set;}

    static testMethod void myUnitTest() {
        
        init();

        testSerialNumber.Part_Number__c = products[1].Part_Number__c;
        update testSerialNumber;
    }

    static void init() { 

        TestFactory_CustomSettings.createRecordTypeSettings();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('Location Partner').getRecordTypeId();
        
        testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.Physical_Country__c = 'USA';
        testAccount.BillingCountry  = 'USA';
        testAccount.RecordTypeID = recordTypeId;
        insert testAccount;
        
        testOpportunity = new Opportunity();
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.Name = 'Test Opportunity';
        testOpportunity.CloseDate = system.today().addDays(3);
        testOpportunity.StageName = 'Qualifying';
        insert testOpportunity;

        pmLists = new List<Product_Model__c>();
        pmLists = Data_ProductModels.createProductModels(3);
        
        products = new List<Product2>();
        products = Data_Product.createProduct(pmLists);

        products[0].SMSA_Product__c = products[1].Id;
        products[1].SMSA_Product__c = products[2].Id;
        update products;

        testSapContract = new SAP_Contract__c();
        insert testSapContract;

        testSAPSalesOrder = new SAP_Sales_Order__c();
        insert testSAPSalesOrder;

        testSerialNumber = new Serial_Number__c();
        testSerialNumber.Serial_Number__c = 'test';
        testSerialNumber.Opportunity__c = testOpportunity.Id;
        testSerialNumber.SAP_Contract_Number__c = testSapContract.Id;
        testSerialNumber.SAP_Sales_Order__c = testSAPSalesOrder.Id;
        testSerialNumber.Part_Number__c = products[0].Part_Number__c;
        insert testSerialNumber;
    }
}