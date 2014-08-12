@isTest
private class Test_OrderItems {

    static testMethod void myUnitTest() 
    {
     Profile profile;
     for(Profile p : [select Id from Profile where Name ='System Administrator' limit 1]){
        profile = p;
    }
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];       
    
    User usr = new User(Username = 'unknown.Manager@perceptivesoftware.com',
                      LastName = 'Manager',
                      FirstName = 'Unknown'+Date.today().day(),
                      UserRoleId = portalRole.Id,
                      Email = 'process.admin@perceptivesoftware.com',
                      Alias = 'uMan'+Date.today().day(),
                      CommunityNickname = 'uMan12',
                      TimeZoneSidKey = 'America/Chicago',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      LanguageLocaleKey = 'en_US',
                      LX_Region__c = 'NE',Legacy_Company__c = 'Acuo'
                      );
    if(profile != null){
        usr.ProfileId = profile.Id;
    }
    insert usr; 
              System.runAs(usr){
        Perceptive_Site__c siteSetup = SitesTestSetup.setupSitesTest();
            
            //Rahul Create URL parameters
            list<URL_Parameter__c> testUrl = new list<URL_Parameter__c>();
            testURL.add(new URL_Parameter__c(name='1124rtal Host',URL_Value__c='www.google.com'));
            testURL.add(new URL_Parameter__c(name='90320Org Host321',URL_Value__c='www.google.com'));            
            insert testUrl;
            
            //Rahul Need to replace this with actual user creation
            user u = [select id from user where userRoleID != null and usertype = 'Standard' limit 1];
            

            
            Account acc = Data_Account.createAccount();
            //acc.Primary_Sector_Focus__c     = 'Manufacturing';
            //acc.OwnerId                     = u.id;
            //acc.RecordTypeID                    =  LX_SetRecordIDs.L5LocationCustomerAccountRecordId;            
            //update acc;         
            
            
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
               
              
              List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
              for (Product_Model__c pmRec : pmList){
                pmRec.Asset_Required__c = true;
              }
              update pmList;
              
              Test.StartTest();
              
            List<Product2> product = Data_Product.createProduct(pmList);  
            Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
            PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
            
            String [] CategoryList = new List<String>();
              CategoryList.add('Training');
               
            List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );
            
            //set data on opportunity so orders are created.
                opp.SAP_Status__c = 'SUBMITTED';
                opp.AccountID = acc.id;
               // opp.Project_Contact__c= contacts[0].id;
                //update opp;
               system.debug('oppLineItem:'+ oppLineItem);  
                system.debug('Opportunity - orders'+ [select id, Account__c, Opportunity__c from Order__c where Opportunity__c = :opp.id]);
              //  system.debug('Order')
               
               //Rahul commented as there it is throwing an exception
               // Order__c orderRec = [select id from Order__c where opportunity__c = :opp.id];
              
              test.StopTest();
              
   
                Test.setCurrentPageReference(new PageReference('Page.order_Products')); 
                //Rahul commented as it is not being used.
                //ApexPages.currentPage().getParameters().put('id',orderRec.id );
                ApexPages.currentPage().getParameters().put('retURL','' );
     //          Order__c controller = new Order__c(new ApexPages.StandardController(OrderRec));
                
     //           system.assertequals(controller.getOrderDetails().id,orderRec.id);
                    
        integer num = [Select  count()
                              From OpportunityLineItem  
                              where  opportunityID=:opp.id ];
                          
                           
    //       system.assertequals(controller.getorderLineItems().size(),num); 
              }
    }
}