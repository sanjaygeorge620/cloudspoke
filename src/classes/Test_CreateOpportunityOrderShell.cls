@isTest
private class Test_CreateOpportunityOrderShell {

    static testMethod void myUnitTest() {
   
      
            Profile prof = [select id, name from Profile where name = 'System Administrator'];
            Map<String,ID> roles = new Map<String,ID>();
     
            List<UserRole> ur = [Select id, name from UserRole];
   
              for(UserRole r : ur){
                 roles.put(r.name, r.id);
              }     
                 
            User Objuser = new User(alias = 'standt', email='standarduser@lexmark.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US',profileId = prof.Id,UserroleId=roles.get('CEO'),Legacy_Company__c='Lexmark',                        
                        timezonesidkey='America/Los_Angeles',EmployeeNumber='emp234',LX_Ability_to_Create_Accounts__c='yes', username='testuser@lexmark.com',LX_Region__c='NE');
        
            insert Objuser; 
            
            Account acc;
            List<Contact> contacts = new List<Contact>();
            Set<ID>contactIDs = new Set<ID>();
            List<string>contactemails = new List<string>();
            Perceptive_Site__c siteSetup;
            
            System.runAs(Objuser){
                test.startTest();
                siteSetup = SitesTestSetup.setupSitesTest();
                acc = Data_Account.createAccount();
                contacts = Data_Contact.createContacts(acc.Id,1);
                contactemails = new List<string>();
                
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
                
                //  public static List<Opportunity> createOpportunity2(List<String> Stage, Integer size,Account acc,List<Contact> contacts,
//    List<Product_Model__c> productModels,List<Product2> products,Pricebook2 pb,PricebookEntry pbe)
                List<Opportunity> test_opportunities = new List<Opportunity> ();
                            System.runAs(Objuser){
                test_opportunities = Data_Opportunity.createOpportunity2(stageList,1,acc,contacts,pmlist,product,pricebook2,pbe); 
                }   
                Opportunity opp = test_opportunities[0];
                
                                test.StopTest();                 
                List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );
                
                //set data on opportunity so orders are created.
                opp.SAP_Status__c = 'SUBMITTED';
                opp.AccountID = acc.id;
                update opp;
                // test.StartTest();
                createOpportunityOrderShell.createOpportunityOrderShell(opp.id);
               system.debug('oppLineItem:'+ oppLineItem);  
                system.debug('Opportunity - orders'+ [select id, Account__c, Opportunity__c from Order__c where Opportunity__c = :opp.id]);
              //system.debug('Order')
                //Order__c orderRec = [select id from Order__c where opportunity__c = :opp.id];

            }
    }
}