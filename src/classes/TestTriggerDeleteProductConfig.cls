/************************************************************************
Name      : TestTriggerDeleteProductConfig
Purpose   : Gives test coverage for DeleteProductConfig trigger.
Author    : Aashish Mathur
Date      : June 25, 2009
************************************************************************/

@isTest
private class TestTriggerDeleteProductConfig {
    @isTest
    static void testTriggerDeleteProductConfig() {
        ProductRelease__c prodRel = new ProductRelease__c();
        prodRel.Major__c = 1;
        prodRel.Minor__c = 1;
        prodRel.Increment__c = '1';
        insert prodRel;
        
        Product2 prodDev = new Product2();
        prodDev.Name = 'prodDev';
        insert prodDev;
        
        Product_Configuration__c prodConf = new Product_Configuration__c();
        prodConf.ProductRelease__c = prodRel.id;
        prodConf.Product__c = prodDev.id;
        insert prodConf;
        
        prodConf = [Select ProductRelease__c from Product_Configuration__c where id = :prodConf.id];
        Test.startTest();
        delete prodRel;
        //System.assertEquals([select id from Product_Configuration__c where id = :prodConf.id].size(), 0);
        Test.stopTest();
    }
}