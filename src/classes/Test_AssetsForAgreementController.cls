@isTest(SeeAllData=true)
private class Test_AssetsForAgreementController {
    @isTest
    static void testAssetsForAgreementController (){
        Account acc = new Account(Name = 'test',Physical_Country__c = 'USA', BillingCountry = 'USA');
        insert acc;
        system.assertNotEquals(acc.id , null);
        
        Agreement__c agree = new Agreement__c(account__c = acc.id);
        insert agree;
        system.assertNotEquals(agree.id , null);
        
        Server__c serv = new Server__c(Agreement__c = agree.id , Server_Type__c = 'Live' , account__c = acc.id);
        insert serv;
        system.assertNotEquals(serv.id , null);
        
        Asset ass = new Asset(Name = 'test',Server__c = serv.id,AccountID = acc.id);
        insert ass;
        system.assertNotEquals(ass.id , null);
        
        Asset_Item__c assItem = new Asset_Item__c(asset__c = ass.id );
        insert assItem;
        system.assertNotEquals(assItem.id , null);
        
        ApexPages.StandardController std = new ApexPages.StandardController(agree);
        AssetsForAgreementController assCont = new AssetsForAgreementController (std);
        
    }

}