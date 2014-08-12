@isTest
private class Test_CreateToken_Training {

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


        String [] CategoryList = new List<String>();
        CategoryList.add('Training');
        CategoryList.add('');
        CategoryList.add('');
        
Test.startTest();     
        List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );       
        System.assert(oppLineItem[0].id != null);
                                                 
        system.assertEquals(1,
             [select id from OpportunityLineItem where opportunityid = :oppLineItem[0].opportunityId
                                                    and category__c = 'Training' 
                                                    and Processed__c <> True].size());
        for (Opportunity oppRec : Test_Opportunities){
            oppRec.QAStatus__c = 'Complete';   
        }
        Set<ID> oppIdSet = new Set<ID>();
        for (Opportunity  OppRec : test_opportunities){
            if (OppRec.QAStatus__c == 'Complete') {
                oppIdSet.add(oppRec.id);
    
             }   
        }        
        
       update Test_Opportunities;
            String [] tokenList = new List<String>();
            tokenList.add('Product Support');
            ProcessToken.ProcessToken(oppIdSet, tokenList);
        Test.stopTest();
        
             
        system.assertEquals('Complete',
            [select id, QAStatus__c from Opportunity where id = :Test_Opportunities[0].Id].QAStatus__c);
    }
}