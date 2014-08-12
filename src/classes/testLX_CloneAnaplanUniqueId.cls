/* Class Name   : testLX_CloneAnaplanUniqueId
* Description   : This is a test class for trigger LX_CloneAnaplanUniqueId 
* Created By   : Deepti Tadala
* Created Date : 03-13-2014
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Deepti Tadala         03-13-2014               1000                 Initial Version

*/





@isTest(seealldata = true)
private class testLX_CloneAnaplanUniqueId    {

   public static testmethod void m1 () {
   
   /* Create a User Profile */
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                 
        User sysAdmin = new User(alias = 'test1', email='test1@lexmark.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = adminProfile.Id, 
        timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test1@testorg1.com',
        LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',Legacy_Company__c = 'Lexmark');
        Database.Insert(sysAdmin);
        
        system.runas(sysAdmin){
               
        Account acc = new Account(name='test Account',BillingCountry='USA',Physical_country__c='USA'); 
        insert acc; 

        Opportunity opp = new Opportunity(AccountId = acc.Id,name='test Opp',stageName='Closed Won',CloseDate=System.today()); 
        insert Opp;
        
    /* Code to create an Opportunity Line Item where the fields  Product2.Part_Number__c and OpportunityLineItem.LX_Unique_ID__c have the same value populated */
    
        List<Product_Model__c> productModels =  Data_ProductModels.createProductModels(3);    
        Product2 prod = new Product2();
        prod.Name = 'testdata';
        prod.Part_Number__c ='test';
        prod.Profit_Center__c = 'testb';
        prod.Cost__c = 10;
        prod.Price_Type__c = 'HR';
        prod.Family = 'Support Services';
        insert prod;
        List<Product2> products = new List<Product2>(); 
        products.add(prod);
        Id priceBookId;
           for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
            priceBookId = priceBook.id;
                     }
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        PricebookEntry pE1 = new PricebookEntry(Product2Id = products.get(0).Id ,Isactive=true ,UnitPrice=100);
     
            if(priceBookId != null)
            {
               pE1.priceBook2Id = priceBookId ;
               priceBookEntries.add(pE1);
               insert priceBookEntries ;
               List<OpportunityLineItem> opplis = new List<OpportunityLineItem>();
               OpportunityLineItem opp_product2 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000,LX_Unique_ID__c = 'opp_product2.id', priceBookEntryId = pE1.Id);
               opplis.add(opp_product2);
               insert opplis;
           
            }
                                 }
    }
 }