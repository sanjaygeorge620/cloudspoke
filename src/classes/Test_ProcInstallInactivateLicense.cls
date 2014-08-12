@isTest(SeeAllData=true)
public class Test_ProcInstallInactivateLicense{
    static Asset testAsset;
    static Asset_Item__c testAssetItem;
    static List<Asset_Item__c> testAssetList;
    static List<OpportunityLineItem> oppLineItem;
    static List<Opportunity> testOpp;
    static Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
    static Case tempCase;
    static List<Case> testCase;
    static Account testAcc;
    static List<Contact> testContact;
    static License_Key__c testLicenseKey;
    static List<License_Key__c> testLicenseKeyList;
    static Map<ID, List<License_Key__c>> testLicenseKeyMap;
    static Server__c testServer;
    static List<Server__c> testServerList;
    static Id RecordTypeId;
    
    public static testmethod void testProcessInstallations(){
        
            test.startTest();
            
        testAssetList = new List<Asset_Item__c>();
        /*Asset_Item__c tempAsset1 = new Asset_Item__c();
        tempAsset1 = Data_Asset.createAsset();
        Asset_Item__c tempAsset2 = new Asset_Item__c();
        tempAsset2 = Data_Asset.createAsset();
        testAssetList.add(tempAsset1);
        testAssetList.add(tempAsset2);
        //insert testAssetList;
        */
        
        //Replace opp And oppLineitem with test Data 
        
        /*
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.Id, product[0].id);
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
        testOpp = new List<Opportunity>();
        testOpp = Data_Opportunity.createOpportunity(stageList, 1);
        
        String [] CategoryList = new List<String>();
            CategoryList.add('Training');
            CategoryList.add('');
            CategoryList.add('');
        
        oppLineItem = Data_OpportunityLineItem.createOppLineItem(testOpp[0].id, pbe.id, categoryList );
        */
        oppLineItem = [Select id,Opportunity.AccountId,Originating_Company__c,
                      Opportunity.Type,Opportunity.Admin_Contact__r.Name,
                      Opportunity.Admin_Contact__r.Email,Opportunity.Admin_Contact__r.Phone,
                      Opportunity.Opportunity_Number__c from OpportunityLineItem limit 1];
                      
        
        testAcc = new Account();
        testAcc = Data_Account.createAccount();
        
        testContact = new List<Contact>();
        testContact = Data_Contact.createContacts(testAcc.Id, 1);
        
        testAsset = new Asset();
        testAsset.Name        = 'Test Asset';
        testAsset.ContactId   = testContact[0].id;
        testAsset.AccountId   = testAcc.id ;
        insert testAsset;
        
        testAssetItem = new Asset_Item__c();
        testAssetItem.name = 'TestAssetItem';
        testAssetItem.Asset__c = testAsset.Id;
        insert testAssetItem;
        
        testAssetList.add(testAssetItem);
        
        String caseRecordTypeName = 'AM Support';
        RecordTypeId = '012i0000000PCqWAAW';
        
        testCase = new List<Case>();
        testCase = Data_Case.createCase(testAcc, testContact[0], caseRecordTypeName, 1);
        
        /*
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;        
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        RecordType recordType = rtMapByName.get(caseRecordTypeName).getRecordTypeId();
        tempCase = new Case();
        
        tempCase.AccountId = testAcc.Id;
        tempCase.RecordType = caseRecordTypeName;
        insert tempCase;
        testCase.add(tempCase);
        */
        
        testLicenseKey = new License_Key__c();
        testLicenseKey.name = 'TestLicenseKey';
        testLicenseKey.Asset_Item__c = testAssetList[0].Id;
        insert testLicenseKey;
        
        testLicenseKeyList = new List<License_Key__c>();
        testLicenseKeyList.add(testLicenseKey);
        
        testLicenseKeyMap = new Map<ID, List<License_Key__c>>();
        testLicenseKeyMap.put(testLicenseKey.Id, testLicenseKeyList);
        //To make LicenseKeyList.size() greater than 0 
        testLicenseKeyMap.put(testAsset.Id, testLicenseKeyList);
        
        testServer = new Server__c();
        testServer.name = 'TestServer';
        testServer.Server_Type__c = 'Live';
        testServer.Account__c = testAcc.Id;
        testServer.Server_Name__c = 'TestServerName';
        testServer.Status__c = 'Active';
        insert testServer;
        
        testServerList = new List<Server__c>();
        testServerList.add(testServer);
        
        
        List<License_Key__c> listLicenseKeyReturn = new List<License_Key__c>();
        listLicenseKeyReturn = ProcessInstallations_InactivateLicense.ProcessInstallations_InactivateLicense(testAssetList, testLicenseKeyMap, testLicenseKeyList, oppLineItem[0], testServerList, RecordTypeId, testCase);
        
            test.stopTest();
    }  
    
    
}