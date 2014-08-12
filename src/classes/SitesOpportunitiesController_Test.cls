@isTest
private class SitesOpportunitiesController_Test {

        static testMethod void TestSitesOpportunitiesController () {
        try{
            Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
            Account acc = Data_Account.createAccount4();
            List<Contact> contacts = Data_Contact.queryContacts(acc.Id);
            List<ID>contactIDs = new List<ID>();
            for(Contact contactRec: contacts){
                contactIDs.add(contactRec.id);
            }    
            List<User> userList = Data_User_PartnerPortal.createUser_PartnerPortal(1, contactIds);  
            
            system.debug('UserLIst' + UserList);
                             String [] stageList = new List<String>();
                stageList.add('Negotiation');
                
                List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
                List<Product2> product = Data_Product.createProduct(pmList);  
                Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
                PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
             
                List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity2(stageList,1,Acc,contacts,pmlist,
                product,pricebook2,pbe);                    
                Opportunity opp = test_opportunities[0];
                system.debug('userList[0].contact.AccountId:' + userList[0].contact.AccountId);
               
                opp.Primary_Partner__c = contacts[0].AccountID;
                update opp;
                 
                system.debug('Opportunity - sitesOpportunities'+ [select Primary_Partner__c, ID from Opportunity where ID = :opp.id]);
                String [] CategoryList = new List<String>();
                CategoryList.add('Training');
                
               
               List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(opp.id, pbe.id, categoryList );
                system.debug('OpportunityLineItem:' + oppLineItem);
                 System.runAs(userList[0]) {
                Test.setCurrentPageReference(new PageReference('Page.opportunitydetails')); 
                ApexPages.currentPage().getParameters().put('id',opp.id );
                ApexPages.currentPage().getParameters().put('retURL','' );
                SitesOpportunityController controller = new SitesOpportunityController();
                
                system.assertequals(controller.getOpportunityDetails().id,opp.id);
                                        
                integer num = [Select  count()
                              From OpportunityLineItem o  
                              where  o.OpportunityId=:opp.id ];
                          
                           
                system.assertequals(controller.getOpportunityLineItems().size(),num); 
                
            }
            }catch(Exception e)
              {
                  System.debug( e.getMessage());
              }        
        }   
}