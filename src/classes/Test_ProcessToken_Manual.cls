@isTest
private class Test_ProcessToken_Manual {

    static testMethod void Test_ProcessToken_Manual() {

        //String [] stageList = new List<String>();
       // stageList.add('Negotiation');
        
       // List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
        Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 
       
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Negotiation',CloseDate=System.today()); 
        insert Opp;
 List<Opportunity> test_opportunities = new  List<Opportunity>{opp};
        test.startTest();
        ProcessToken_Manual.ProcessToken_Manual(test_opportunities[0].id,'Training');
        Test.stopTest(); 
    }
    
    static testMethod void Test_ProcessToken() {
        
        test.startTest();
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList); 
                
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        String [] stageList = new List<String>();
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        stageList.add('Negotiation');
        Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 
       
        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Negotiation',CloseDate=System.today()); 
        insert Opp;
 List<Opportunity> test_opportunities = new  List<Opportunity>{opp};
        //List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');
        CategoryList.add('');
        CategoryList.add('');
        //User us1 = new USer(Email='Testing@ex.com',username='Testing@ex.com',alias='test',CommunityNickname='test1');
        //insert us1;
       // LX_Profile_Exclusion__c prof_EX = new LX_Profile_Exclusion__c(Bypass__c=true,LX_Bypass_for_Deployment_Manager__c=true,LX_Opt__c=true,SetupOwnerId=us1.id);
        List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );                 
        
        ProcessToken_Manual.ProcessToken_Manual(test_opportunities[0].id,'Training');
        Test.stopTest(); 
    }
}