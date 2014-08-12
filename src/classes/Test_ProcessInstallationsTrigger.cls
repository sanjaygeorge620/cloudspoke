/**
 
 */
@isTest
private class Test_ProcessInstallationsTrigger {
   
    
    static testMethod void TestProcessInstallations() {
         Account acc= new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp= new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
        insert Opp;

            opp.SAP_Status__c = 'SUBMITTED';
            update opp;
    }
    
    static testMethod void TestOpportunityLineItemGrouping() {
        //Account acc = createAccount();
          Account acc= new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA');
        insert acc;
      
        Opportunity opp= new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today());
        insert Opp;
        
        Sales_Organization__c salesOrg = new Sales_Organization__c();
        salesOrg.LX_Country_Code__c = 'US';
        salesOrg.Sales_Organization__c='5097';
        salesOrg.Name='United States';
        salesOrg.Include_in_VSOE__c = true;          
        insert salesOrg;
        //Opportunity opp = createOpportunity(acc.id);        
        
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);  
        
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
      
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');
        CategoryList.add('');
        CategoryList.add('');
        
        List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp.id, pbe.id, categoryList );        
        test.startTest();
        opp.SAP_Status__c = 'SUBMITTED';
        opp.Sales_organization__c = salesOrg.id;
        update opp;
        test.stopTest();
    }
   
   
}