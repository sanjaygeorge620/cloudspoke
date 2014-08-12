/*********************************************************************************
Name : OpportunityLineItemGrouping 
Created By : Bharti Mehta(Appirio Offshore)
Created Date : 21 Dec 2010
Usages : Testclass for Trigger OpportunityLineItemGrouping
*********************************************************************************/ 
@isTest
private class Test_OpportunityLineItemGrouping {

    static testmethod void unittest(){
        //Id accId = createAccount();
        Account acc = Data_Account.createAccount();
        id accid = acc.id;
        //create opportunity and relavant records for test
        List<Opportunity> opportunities = createOpportunities(accId,2);
        
        createLineItemsForOpportunity(opportunities.get(0).Id);
        
        opportunities.get(0).QAStatus__c = 'Complete';
        opportunities.get(1).QAStatus__c = 'Complete';
        
        //test starts
        Test.startTest();
        update opportunities;
        //test ends
        Test.stopTest();    
        
        List<Opportunity> Opportunities1 = [SELECT Contract_Indicator__c FROM Opportunity WHERE Id = :opportunities.get(0).Id OR Id = :opportunities.get(1).Id ];
        //system.assertEquals('VSE', Opportunities1.get(0).Contract_Indicator__c);//vse
        //system.assertEquals('NVE', Opportunities1.get(1).Contract_Indicator__c);  //nve
    }   
    
 /*   static Id createAccount(){
        //create account
        Account acc = new Account(name='TestAccount21122010');
        acc.Address_Edit_States__c = 'Rajasthan';
        insert acc;
        return acc.Id;
    }
*/        
    static List<Opportunity> createOpportunities(Id accId,Integer size){
        
        List<Contact> contacts = new List<Contact>(); 
        /*contacts.add(new Contact(LastName = 'Test',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_contact__c=true));
        contacts.add(new Contact(LastName = 'Test1',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_contact__c=true));
        insert contacts;*/
        contacts = Data_Contact.createContacts(accId,2);
        
        //create opportunities for test
        List<Opportunity> opportunities = new List<Opportunity> ();
        
        for(Integer i = 0 ; i < size ; i++){
            Opportunity opp =  new Opportunity();
            opp.AccountId = accId;
            opp.Name = 'newOpp';
            opp.CloseDate = Date.today().addDays(10);
            opp.StageName = 'Negotiation';
            opp.Technology__c = true;
            opp.LX_Sales_Type__c = 'Add On';
            opp.QAStatus__c = 'New';
            opp.Ship_To__c  = contacts.get(0).Id;
            opp.Bill_To__c  = contacts.get(0).Id;
            opportunities.add(opp);
        }        
        insert opportunities;
        return opportunities;
    }

    static void createLineItemsForOpportunity(Id oppId){
        List<Product_Model__c> productModels = new List<Product_Model__c>();
        for(Integer i =0; i< 4;i++){
            productModels.add(new Product_Model__c(Name = 'Test Model '+i,Line__c = 'Solutions Software',Series__c = 'Application Maint. & Dev',Family__c = 'Support'));            
        }
        insert productModels;
        
        //create products 
        List<Product2> products = new List<Product2>();
        for(Integer i = 0 ; i < 4; i++){
            Product2 prod = new Product2(Name = 'TestProduct' + i);
            prod.core_Product__c = true;
            prod.Replicate_Full_Environment__c = true;
            prod.Exclude_from_Test_Clone__c = true;
            prod.Exclude_from_Failover_Clone__c = true;
            prod.Test_Environments_Needed__c = 2;
            prod.Failover_Environments_Needed__c = 2;    
            prod.Product_Model__c = productModels.get(i).Id;    
            products.add(prod);
        }
        insert products;

        //set SMSA_Product__c field for prodocts and update
        for(Integer i = 0 ; i < 4; i += 2){
            products.get(i).SMSA_Product__c = products.get(i+1).Id;
        }
        update products;

        Id priceBookId;
        for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
            priceBookId = priceBook.id;
        }
        
        //create price book entries for product inserted above
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        for(Integer i = 0 ; i < 4; i++){
            priceBookEntries.add(new PricebookEntry(Product2Id =products.get(i).Id ,Isactive=true ,UnitPrice=100,priceBook2Id = priceBookId));
        }
        insert priceBookEntries;

        //create line items
        List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        for(Integer i = 0 ; i < 4; i++){
            lineItems.add(new OpportunityLineItem(OpportunityId = oppid, Quantity = 1, totalPrice = 1000000, priceBookEntryId = priceBookEntries.get(i).Id ));
        }
        insert lineItems;
    }
}