@isTest(seeAlldata=true)
private class Test_NotifyDownloads { 

   static testMethod void myUnitTest() 
    {
      
        Set<ID> contactIDSet = new Set<ID>();             //set to hold the contact IDs to be processed
        List<ID> contactIDList = new List<ID>();   
        String [] stageList = new List<String>();
        integer contactNum = 0;
        stageList.add('Closed Won');        
        
       list<Account> accl = new list<Account>();
    system.debug('Check 8' + Limits.getQueries());
       Account aa = Data_Account.createAccount();
       system.debug('Check 9' + Limits.getQueries());
       Account bb = Data_Account.createAccount();
       
     
       
       aa.Type = 'Partner-Channel Level 2';
       bb.Type = 'Partner-Other';
       aa.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
       bb.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
       accl.add(aa);
       accl.add(bb);
       
       update accl;  
       
       list<Contact> testCon = Data_Contact.createContacts(aa.id, 2); 
       
       testCon[0].AccountID = accl[0].ID;
       testCon[1].AccountID = accl[1].ID;
       testCon[0].Email = 'testingxyz@perceptivesoftware.com';
       testCon[1].Email = 'testingabc@perceptivesoftware.com';
       testCon[0].License_contact__c= true;
       testCon[1].License_contact__c= true;
       testCon[0].Accounting_Contact__c = True;
       testCon[1].Accounting_Contact__c = True;
       
       update testCon;    
        
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);
       
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
         system.debug('Check 7' + Limits.getQueries());
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');   
       
       test.starttest();  
     //  List<Opportunity> test_opportunities1 = Data_Opportunity.createOpportunity2(stageList,1,aa,testcon,pmlist,product,pricebook2,pbe);
       List<Opportunity> test_opportunities1 = Data_Opportunity.createOpportunity3(stagelist,1,aa,testcon);
          
       system.debug('Check 8' + Limits.getQueries());
       
        List<OpportunityLineItem> oppLineItem1 = Data_OpportunityLineItem.createOppLineItem(test_Opportunities1[0].id, pbe.id, categoryList );
        
        system.debug('Check 9' + Limits.getQueries());
        
             test.StopTest();  
        
        test_opportunities1[0].Primary_Partner__c = accl[0].id;
        test_opportunities1[0].Bill_To__c = testCon[0].id;        
        test_opportunities1[0].Ship_To__c = testCon[0].id;
        test_opportunities1[0].Project_Contact__c = testCon[0].id;
      //test_opportunities1[0].AccountTypeUpdate__c ='Partner-Channel Level 2';
        test_opportunities1[0].SAP_Status__c = 'SUBMITTED';
        FirstRun_Check.FirstRun_Downloads = true;
        FirstRun_Check.FirstRun_OrderShellCreation = true;
        
        
        update test_opportunities1;
        
        }
        
       
        
     
 
        
    static testMethod void testInactiveCustomerPortalUser()
        {
        Profile prof = [select id, name from Profile where name = 'System Administrator'];
            Map<String,ID> roles = new Map<String,ID>();
     
            List<UserRole> ur = [Select id, name from UserRole];
   
              for(UserRole r : ur){
                 roles.put(r.name, r.id);
              }     
                 
            User Objuser = new User(alias = 'standt', email='standarduser@lexmark.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US',profileId = prof.Id,UserroleId=roles.get('CEO'),Legacy_Company__c = 'Perceptive',                        
                        timezonesidkey='America/Los_Angeles', username='testuser@lexmark.com',LX_Region__c = 'NE');
        
            insert Objuser; 
            
        System.runas(Objuser){
                
        list<string> stageList = new List<String>();   
       
        stageList.add('Closed Won');
        List<Opportunity> test_opportunities2 = Data_Opportunity.createOpportunity(stageList, 1);  
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);  
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');       
        test.starttest();
        List<OpportunityLineItem> oppLineItem2 = Data_OpportunityLineItem.createOppLineItem(test_opportunities2[0].id, pbe.id, categoryList );
        System.debug('Before User');
               
        list<Account> accl = new list<Account>();
    
       Account aa = Data_Account.createAccount();
       Account bb = Data_Account.createAccount();
       
       aa.Type = 'Partner-Channel Level 2';
       bb.Type = 'Partner-Other';
      aa.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
       bb.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
       accl.add(aa);
       accl.add(bb);
       
       update accl;
        Solution_Business_Process__c solutions = new Solution_Business_Process__c(Account__c=aa.id,Opportunity__c=test_opportunities2[0].id,Solution_Status__c='Sold',Sector__c='State/Local');
        insert solutions;
      
       list<Contact> testCon = Data_Contact.createContacts(aa.id, 2); 
       
       testCon[0].AccountID = accl[0].ID;
       testCon[1].AccountID = accl[1].ID;
       testCon[0].Email = 'testingxyz@perceptivesoftware.com';
       testCon[1].Email = 'testingabc@perceptivesoftware.com';
       
       
       update testCon;
       
       testCon[0].Accounting_Contact__c = True;
       testCon[1].Accounting_Contact__c = True;
       
       update testCon;
       
    
        
        List<Profile> ProfileId1 = [select id from Profile where Name = 'Perceptive Customer Portal Admin' limit 1];
        
         User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
         
               System.runAs(thisUser) 
                 {
       
                User newUserRec = new User (
                        Username = 'testingxyz@perceptivesoftware.com',        
                        LastName = testCon[1].LastName,
                        FirstName = testCon[1].FirstName,
                        //    UserPermissionsMarketingUser = true,
                        //Email = 'jennifer.dauernheim@perceptivesoftware.com',             //use this for testing - send to exact email address
                        Email = testCon[1].Email,                               //use this for production - sends to contact email address
                        Alias = testCon[1].FirstName.substring(0,1) + testCon[1].LastName.substring(0,2) , //check to see if better format
                        CommunityNickname = testCon[0].FirstName + '.' + testCon[1].LastName,    
                        TimeZoneSidKey = 'America/Los_Angeles',        
                        LocaleSidKey = 'en_US',    
                        EmailEncodingKey = 'UTF-8',  
                        Legacy_Company__c = 'Perceptive',      
                        LanguageLocaleKey = 'en_US',  
                              
                        ProfileId = profileID1[0].id,
                        contactid = testCon[1].id,
                        Lx_Region__c = 'NE'                        
                );
                
                insert   newUserRec;

        test_opportunities2[0].Primary_Partner__c = accl[1].id;
        test_opportunities2[0].Ship_To__c = testCon[1].id;
        test_opportunities2[0].Project_Contact__c = testCon[1].id;
       // test_opportunities2[0].AccountTypeUpdate__c ='Partner-Channel Level-OEM';
        test_opportunities2[0].SAP_Status__c = 'SUBMITTED';
        FirstRun_Check.FirstRun_Downloads = true;
        FirstRun_Check.FirstRun_OrderShellCreation = true;
       
        update test_opportunities2[0];
        
        
           test.StopTest();
           }
        }
          
        }
        
        //--------------------------------Customer Portal
          
      static testMethod void testInactivePartnerPortalUser()
        {
        
      Profile prof = [select id, name from Profile where name = 'System Administrator'];
            Map<String,ID> roles = new Map<String,ID>();
     
            List<UserRole> ur = [Select id, name from UserRole];
   
              for(UserRole r : ur){
                 roles.put(r.name, r.id);
              }     
                 
            User Objuser = new User(alias = 'standt', email='standarduser@lexmark.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US',profileId = prof.Id,UserroleId=roles.get('CEO'),Legacy_Company__c = 'Perceptive',                       
                        timezonesidkey='America/Los_Angeles', username='testuser@lexmark.com',LX_Region__c = 'NE');
        
            insert Objuser; 
            
        System.runas(Objuser){
        
        list<string> stageList = new List<String>();   
       
        stageList.add('Closed Won');
        List<Opportunity> test_opportunities2 = Data_Opportunity.createOpportunityNewSales(stageList, 1);  
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);  
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');
        test.starttest();
        List<OpportunityLineItem> oppLineItem2 = Data_OpportunityLineItem.createOppLineItem(test_opportunities2[0].id, pbe.id, categoryList );
        System.debug('Before User');
        list<Account> accl = new list<Account>();
    
       Account aa = Data_Account.createAccount();
       Account bb = Data_Account.createAccount();
       
       aa.Type = 'Partner-Channel Level 2';
       bb.Type = 'Partner-Other';
       aa.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
       bb.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
       
       accl.add(aa);
       accl.add(bb);
       
       update accl;
        Solution_Business_Process__c solutions = new Solution_Business_Process__c(Account__c=aa.id,Opportunity__c=test_opportunities2[0].id,Solution_Status__c='Sold',Sector__c='State/Local');
        insert solutions;
       
       list<Contact> testCon = Data_Contact.createContacts(aa.id, 2); 
       
       testCon[0].AccountID = accl[0].ID;
       testCon[1].AccountID = accl[1].ID;
       testCon[0].Email = 'testing'+string.valueof(Date.today()).replaceAll('-', '_').replaceAll(':','_')+'@perceptivesoftware.com';
       testCon[1].Email = 'testing'+string.valueof(Date.today()).replaceAll('-', '_').replaceAll(':','_')+'@perceptivesoftware.com';
       
       
       update testCon;
       
       testCon[0].Accounting_Contact__c = True;
       testCon[1].Accounting_Contact__c = True;
       
       update testCon;
       
       
        
        List<Profile> ProfileId2 = [select id from Profile where Name = 'Perceptive Partner Portal Admin' limit 1];
             list<User> thisUser1 = [select Id from User where ContactId in :testCon];
          User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
           
               System.runAs(thisUser) 
                 {
        test_opportunities2[0].Primary_Partner__c = accl[0].id;
        test_opportunities2[0].Ship_To__c = testCon[0].id;
        test_opportunities2[0].Project_Contact__c = testCon[0].id;
        test_opportunities2[0].SAP_Status__c = 'SUBMITTED';
        FirstRun_Check.FirstRun_Downloads = true;
        FirstRun_Check.FirstRun_OrderShellCreation = true;
       
        update test_opportunities2[0];
        
        
           test.StopTest();
           }
        }
        }
   
        
    
}