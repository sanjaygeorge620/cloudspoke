@isTest
private class Test_UpdateOpportunityLineItemDates {

    static testMethod void Test_UpdateOpportunityLineItemDates() 
    {
        //create Opportunity
        String [] stageList = new List<String>();
        Date mydate = Date.today();
        stageList.add('Negotiation');       
        
        //create OppLine Items
         Account acct = Data_Account.createAccount2();  
         List<Contact> contacts = Data_Contact.QueryContacts(acct.Id);

        for(Contact con :contacts){
            con.accountID = acct.id;
            con.License_Contact__c = true;
            con.email = 'abc@abc.com';
            
        }

        update contacts;
        //Contact cont = contacts[0];
                             
                             
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);  
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');      
        
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity2(stageList, 1,acct,contacts,pmList,product,pricebook2,pbe);       
        System.assertEquals(test_opportunities.size(),1);     
        Test.StartTest();
        List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );
        
        for(OpportunityLineItem oppLineItemRec : OppLineItem){
            oppLineItemRec.Product_Family__c = 'SMSA';
            oppLineItemRec.Fair_Market_Value__c  = 10000;
            oppLineItemRec.TotalPrice = 100;
        }
        update OppLineItem;
        system.debug('OppLineItem' + OppLineItem);
        
                
        //VT 8/25:Commented system.assertEquals('Licensed Software',
            //[select Product_Family__c from OpportunityLineItem where opportunityid = :test_opportunities[0].id ].product_family__c);
            
         system.assertEquals(null,
            [select Start_Date__c from OpportunityLineItem where opportunityid = :test_opportunities[0].id ].Start_Date__c);    
         system.assertEquals(null,
            [select End_Date__c from OpportunityLineItem where opportunityid = :test_opportunities[0].id ].End_Date__c);
            
            
            
                    
        for(Opportunity OppRec : Test_Opportunities){
            //get closedate so always in the future        
            Date test_CloseDate = system.today().addDays(4);
            Date test_contract = system.today().addDays(6);
            
            OppRec.CloseDate =  test_CloseDate;  
            OppRec.QAStatus__c = 'Complete';
            OppRec.LX_Bill_To_Email_Address__c = 'proce_min@perceptivesoftware.com';
        } 

        test.stopTest();
        

        update Test_Opportunities;
        
             for(OpportunityLineItem oppLineItemRec : OppLineItem){
            oppLineItemRec.Product_Family__c = 'Professional Services';
        }
        update OppLineItem;
        system.debug('Test_Opportunities' + Test_Opportunities);        
        
        Date oneYearDate = mydate.addYears(1);
        system.debug('oneYearDate: ' + oneYearDate);
        Date oneYearMinusOneDayDate = oneYearDate.addDays(-1);
    }
}