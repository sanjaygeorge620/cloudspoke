@isTest
private class Test_OrderProducts {

    static testMethod void myUnitTest() {
    try{
        Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
            Account acc = Data_Account.createAccount();
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
            
            Set<ID>contactIDs = new Set<ID>();
            List<string>contactemails = new List<string>();
            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);
                contactemails.add(contactrec.email);
            }   
            system.debug('contactemails:' + contactemails); 
            List<ID> ProfileIds = new List<ID>();
              
            CreateActivePortalUser.CreateActivePortalUser(contactIDs); 
            
            List<User> UserList = new List<User>([select id from User where contactid = :Contacts[0].ID ]);
            system.debug('userList'+userList);
                String [] stageList = new List<String>();
                stageList.add('Negotiation');
                List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList,1,acc,contacts);    
                Opportunity opp = test_opportunities[0];
               
               Test.StartTest();
                
                List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
                for (Product_Model__c pmRec : pmList){
                    pmRec.Asset_Required__c = true;
                }
                update pmList;
                
                List<Product2> product = Data_Product.createProduct(pmList);  
                Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
                PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
                
                String [] CategoryList = new List<String>();
                CategoryList.add('Training');
                
                
                 
                List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );
                
                //set data on opportunity so orders are created.
                opp.SAP_Status__c = 'SUBMITTED';
                opp.AccountID = acc.id;
                update opp;
               system.debug('oppLineItem:'+ oppLineItem);  
                system.debug('Opportunity - orders'+ [select id, Account__c, Opportunity__c from Order__c where Opportunity__c = :opp.id]);
              //  system.debug('Order')
                Order__c orderRec = [select id from Order__c where opportunity__c = :opp.id];
              
              Test.StopTest();
                
              System.runAs(userList[0]) {
                Test.setCurrentPageReference(new PageReference('Page.orders')); 
                ApexPages.currentPage().getParameters().put('id',orderRec.id );
                ApexPages.currentPage().getParameters().put('retURL','' );
                SitesOrderController controller = new SitesOrderController();
                
                system.assertequals(controller.getOrderDetails().id,orderRec.id);
                                        
                integer num = [Select  count()
                              From Order_Detail__c   
                              where  Order__c=:orderRec.id ];
                          
                           
                system.assertequals(controller.getOpportunityLineItems().size(),num); 
              }
              }
              catch(Exception e)
              {
                  System.debug( e.getMessage());
              }
    }
}