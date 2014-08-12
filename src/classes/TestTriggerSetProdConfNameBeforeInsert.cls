/************************************************************************
Name      : TestTriggerSetProdConfNameBeforeInsert
Purpose   : Gives test coverage for SetProdConfNameBeforeInsert trigger.
Author    : Aashish Mathur
Date      : June 25, 2009
************************************************************************/

@isTest
private class TestTriggerSetProdConfNameBeforeInsert {
    @isTest
    static void testTriggerSetProdConfNameBeforeInsert() {
        Product2 prod = new Product2();
        prod.Name = 'prodDev';
        insert prod;
        
        Product_Configuration__c prodConf = new Product_Configuration__c();
        prodConf.Product__c = prod.id;
        insert prodConf;
        
        //System.assertEquals(prod.Name,
        //        [select Name from Product_Configuration__c where id = :prodConf.id].Name);
    }
}