@isTest
private class Test_NotifyDownloadEmail {

    static testMethod void Test_NotifyDownloadEmail() {
        
        Profile prof = [select id, name from Profile where name = 'System Administrator'];
            Map<String,ID> roles = new Map<String,ID>();
     
            List<UserRole> ur = [Select id, name from UserRole];
   
              for(UserRole r : ur){
                 roles.put(r.name, r.id);
              }     
                 
            User Objuser = new User(alias = 'standt', email='standarduser@lexmark.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US',profileId = prof.Id,UserroleId=roles.get('CEO'),Legacy_Company__c = 'Lexmark',                        
                        timezonesidkey='America/Los_Angeles', username='testuser@lexmark.com',
                        LX_Region__c = 'NE');
        
            insert Objuser; 
            
        System.runas(Objuser){
            Account acc = Data_Account.createAccount();
            List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);     
            
            List<ID> ContactEmailList = new List<ID>();
            
            contactEmailList.add(contacts[0].id);
            
                     String [] stageList = new List<String>();
                    stageList.add('Negotiation');
                    List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);    
                    Opportunity opp = test_opportunities[0];
                   
                    
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
                     
                       test.starttest();
                     
                    List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );
                    
                    Contact con = new Contact(Id=contacts[0].Id);
                    con.Email='c@k.com';
                    con.License_Contact__c = true;
                    update con;
                    
                    //set data on opportunity so orders are created.
                    opp.SAP_Status__c = 'SUBMITTED';
                    opp.AccountID = acc.id;
                    opp.Bill_to__c=con.Id;
                    opp.Ship_to__c=con.Id;
                    update opp;
                   system.debug('oppLineItem:'+ oppLineItem);  
                    system.debug('Opportunity - orders'+ [select id, Account__c, Opportunity__c from Order__c where Opportunity__c = :opp.id]);
                  //  system.debug('Order')
                    
                    //Rahul commented to get the values back.
                    //Order__c orderRec = [select id, account__c from Order__c where opportunity__c = :opp.id];
            
            Order__c orderRec = new Order__c(account__c = acc.id, Opportunity__c =opp.id);
            insert orderRec;
          
            list<id> oppList = new list<id>();
            oppList.add(opp.id);
            NotifyDownloadEmail.NotifyDownloadEmail(contactEmailList, OrderRec);
            NotifyDownloadEmailPrimaryPartner.NotifyDownloadEmailPrimaryPartner(contactEmailList, OrderRec);
            NotifyDownloadEmail.NotifyDownloadEmail(contacts[0].id, oppList);
            
            test.stoptest();
        }

    }
}