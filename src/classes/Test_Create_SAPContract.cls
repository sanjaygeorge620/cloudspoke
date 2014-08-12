@isTest
private class Test_Create_SAPContract {


    static testMethod void myUnitTest() {
        
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(3);
        List<Product2> product = Data_Product.createProduct(pmList);  
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        
        //create opportunity in system
        String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 3);
        //update test opportunity so that QA Status = 'Complete'
            Test.StartTest();                                     
   
        for (Opportunity oppRec : Test_Opportunities){
            oppRec.Contract_Number__c = 'Testing';   
        }
        update Test_Opportunities;
                
        system.assertEquals('Testing',
            [select id, Contract_Number__c from Opportunity where id = :Test_Opportunities[0].Id].Contract_Number__c);
        FirstRun_Create_SAPContract testFirstRun = new FirstRun_Create_SAPContract();    
             Test.StopTest();              
    }
}