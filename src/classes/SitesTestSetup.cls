/*
    All Data for Sites Classes is contained within this class.
    Created April 2011
    Michael Fitzgerald 
    */
    @isTest
    public class SitesTestSetup {
                   
           public class TestSitesController extends SitesController {}
           
           
           Public static id userAccount;
           //Site Setup 
           public static testMethod Perceptive_Site__c setupSitesTest() {
                    //SETUP USER WITH CORRECT PROFILE TO TEST WITH
                    profile p = [select p.name from profile p where p.id=:UserInfo.getProfileId()];
                    System.debug('Profiles : *********'+p);
                    Integer num = [ SELECT count() FROM Perceptive_Site__c WHERE Profiles__c =:p.name ];
                   System.debug('Number of Perceptive Sites : '+num);
                    
                    /*Community c = [select id, name from community where name like '%perceptive%' limit 1];
                        idea idea = new idea();
                            idea.Communityid = c.id;
                            idea.Title = 'SitesController.idea.title';
                            idea.body='SitesController.idea.body';
                            idea.categories='SitesController.idea.category';
                        insert idea;
                  String commID = c.id;
                  IdeasSiteSetup__c ideaSiteSetup = new IdeasSiteSetup__c(Name = 'Test Site setup',CommunityId__c=commID.substring(0,15),CacheMaxAge__c = 25);
                 try{
                    insert ideaSiteSetup ;
                  }Catch(Exception ex){System.debug('Idea Site Setup insert Failed : ****'+ex.getMessage());}*/
                        
                   //Site Setup
                    Perceptive_Site__c siteSetup;
                    if (num != 0) {
                      siteSetup = [ SELECT ps.id, ps.Nickname__c, Site_Name__c, Ideas_Site_Setup__c,Home_Page__c, Login_Page__c, Primary_Template__c, Secondary_Template__c, URL__c From Perceptive_Site__c ps WHERE ps.Profiles__c includes(:p.name) limit 1];
                    } else {
                        siteSetup = new Perceptive_Site__c();
                        siteSetup.Profiles__c=p.name;
                        siteSetup.Name = 'test setup';
                        siteSetup.Site_Name__c = 'testsite';    
                        //siteSetup.Feature_Idea__c = idea.id;
                        //siteSetup.Ideas_Site_Setup__c = ideaSiteSetup.Id;
                        siteSetup.NickName__C = 'Test Nickname';
                        siteSetup.Home_Page__c = 'www.salesforce.com';
                        siteSetup.Login_Page__c =  'www.salesforce.com';
                        siteSetup.Primary_Template__c = 'Primary Template';
                        siteSetup.Secondary_Template__c = 'Secondary template';
                        siteSetup.URL__c = 'www.salesforce.com';
                        siteSetup.Language__c = 'English';
                       System.debug('SiteSetup before Insert : '+siteSetup);
                  try{
                      insert siteSetup; 
                     }catch(Exception ex){
                          System.debug('Upsert Failure : ***'+ex.getMessage());
                     } 
                    }
                    
                    //INSPIRE recordtype
                    //RecordType r_i = [Select id From RecordType r where r.SobjectType = 'Perceptive_Site_Content__c' and r.DeveloperName ='inspire'];
                    //string r_i = '01270000000M9oFAAS';
                    //string r_i = '012i0000000LlDi';
                    //04.16.2013 from 46 to 48
                    RecordType rec = [Select id From RecordType r where r.SobjectType = 'Perceptive_Site_Content__c' and r.DeveloperName ='Widget'];
                    String r_i = rec.id;

                    
                    //Site Content Setup
                    Perceptive_Site_Content__c InspireContent = new Perceptive_Site_Content__c();
                           InspireContent.Name='test'; 
                           InspireContent.Public_Viewing__c = true;
                           InspireContent.Type__c='testSitesMethods';
                           InspireContent.Perceptive_Site__c=siteSetup.id;
                           InspireContent.RecordTypeid =r_i;    //.id;
                           InspireContent.Featured__c =true;
                           InspireContent.Public_Viewing__c =true;
                    insert InspireContent;                                                         
                    
                    //WIDGET recordtype
                   // RecordType r_w = [Select id From RecordType r where r.SobjectType = 'Perceptive_Site_Content__c' and r.DeveloperName ='Widget'];
                    //String r_w = '01270000000M9oHAAS';
                    //04.16.2013 from 62 to 65
                    //String r_w = '012i0000000LlDkAAK';  
                    RecordType rec1 = [Select id From RecordType r where r.SobjectType = 'Perceptive_Site_Content__c' and r.DeveloperName ='Widget'];
                    String r_w = rec1.id;

                    //Site Content Setup
                    Perceptive_Site_Content__c WidgetContent = new Perceptive_Site_Content__c();
                           WidgetContent.Name='test_SiteContentSetup_widget'; 
                           WidgetContent.Public_Viewing__c = true;
                           WidgetContent.Type__c='Widget';
                           WidgetContent.Perceptive_Site__c=siteSetup.id;
                           WidgetContent.RecordTypeid =r_w;    ///.id;
                           WidgetContent.Featured__c =true;
                           WidgetContent.Public_Viewing__c =true;
                    insert WidgetContent;   
                    
                 return siteSetup;
                }
            
            
            //User    
            public static User u;
            public static Account acct;
            public static testMethod user testRunAs() {
            
            Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
             User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
             localesidkey='en_US', profileid = adminProfile.Id,Legacy_Company__c = 'Lexmark', 
             timezonesidkey='America/Los_Angeles', username='standarduser@tes1234edtorg1.com',LX_region__c='NE',EmployeeNumber = '12345' );
             Insert adminUser;
             
            
            
                System.runAs(adminUser) {
            
            
            
              // Setup test data
              
                 if (u==null){
                 
                 
                             //Create portal account owner
                            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
                            User portalAccountOwner1 = new User(
                                UserRoleId = portalRole.Id,
                                ProfileId = profile1.Id,
                                Username = System.now().millisecond() + 'test2@test.com',
                                Alias = 'batman',
                                Email='bruce.wayne@lexmark.com',
                                EmailEncodingKey='UTF-8',
                                Firstname='Bruce',
                                Lastname='Wayne',
                                LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US',
                                Legacy_Company__c = 'Lexmark',
                                TimeZoneSidKey='America/Chicago',
                                LX_region__c='NE',
                                EmployeeNumber = '12345'
                            );
                            Database.insert(portalAccountOwner1);
                            
                            //Create account
                            Account portalAccount1 = new Account(
                                Name = 'TestAccount',
                                Physical_Country__c='India',
                                BillingCountry='India',
                                OwnerId = portalAccountOwner1.Id
                            );
                            Database.insert(portalAccount1);
                                    
                            //Create contact
                            Contact contact1 = new Contact(
                                FirstName = 'Test',
                                    Lastname = 'McTesty',
                                AccountId = portalAccount1.Id,
                                    Email = System.now().millisecond() + 'test@test.com',
                                    Lx_Lexmark_Vertical__c = 'Manufacturing' 
                            );
                            Database.insert(contact1);
                 
                             //Account
                                 //Account acct = new Account();
                                 //        acct.name='SitesControllerTest.Account';
                                 //insert acct;
                                 acct = Data_Account.createAccount4();  
                                 string accrecType = [Select id from RecordType where name='Location Partner' and sobjectType='Account'].id;   
                                  acct .Type = 'Partner';
                                acct .RecordtypeID = AccRecType;
                                acct.ISS_Coverage_Model__c='Channel';
                                update acct ;        
                               if(acct!=null){
                                 system.debug('Account in TEST SETUP************* ' + acct);                             
                                 system.debug('Check 3 ' + Limits.getQueries());
                                 
                                 userAccount = acct.id;
                                 system.debug('Account ID in TEST SETUP************* ' + userAccount);
                                 
                                 //Contact
                               //  Contact cont = new Contact();
                               //          cont.Accountid = acct.id;
                               //          cont.firstname='SitesControllerTest';
                               //          cont.lastname='Account';
                               //  insert cont;
                                 //List<Contact> contacts = Data_Contact.QueryContacts(acct.Id);
                                  List<Contact> contacts = Data_Contact.createContacts(acct.Id,1);
                                 Contact cont = contacts[0];

                              system.debug('Check 3 ' + Limits.getQueries());
                              //UserRole portalRole5 = [Select Id From UserRole Where PortalType = 'CustomerPortal' Limit 1][0];   
                                 /*User----------------------------*/
                                 //Profile p = [select id from profile where name = 'Perceptive Partner Portal Admin']; 
                                // String pId = '00e70000000znK2AAI';
                                 //u = new User(alias = 'standt', email='SitesControllerTest@testRunAs.com', 
                                  //  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                  //  localesidkey='en_US', profileid = p.id, contactid=contact1.id,userroleid = portalRole5.Id,
                                  //  timezonesidkey='America/Los_Angeles', username='SitesControllerTest@testRunAs.com');
                                 /*----------------------------*/
                                 //Database.insert(u);
                                 
                                // System.runAs(u) {
                                   // The following code runs as user 'u' 
                                  // System.debug('Current User: ' + UserInfo.getUserName());
                                  // System.debug('Current Profile: ' + UserInfo.getProfileId());
                                 //}
                                
                                 //Agreement
                                 Agreement__c agree = new Agreement__c();
                                       agree.name ='SitesControllerTest.agreement';
                                       agree.Account__c = acct.id;
                                 insert Agree;
                                 
                                 //Server
                                 Server__c Server = new Server__c();
                                       Server.name ='SitesControllerTest.server';
                                       Server.Account__c = acct.id;
                                       Server.Agreement__c = agree.id;
                                       Server.Server_Type__c = 'Live';
                                 insert Server;
                                 //test server update trigger
                                        Server.name ='SitesControllerTest.server';
                                 update Server;
                                 
                                 //Server ---creating another server - Failover
                                 Server__c Server2 = new Server__c();
                                       Server2.name ='SitesControllerTest.server';
                                       Server2.Account__c = acct.id;
                                       Server2.Agreement__c = agree.id;
                                       Server2.Server_Type__c = 'Failover';
                                 insert Server2;
                                 
                                 system.debug('Check 3 ' + Limits.getQueries());
                                 
                                 //Asset
                                 Asset ass = new Asset();
                                       ass.name ='SitesControllerTest.asset';
                                       ass.Accountid=acct.id;
                                       ass.Agreement__c = Agree.id;
                                       ass.Server__c = Server.id;       
                                 insert ass;
                             
                                //Asset Item
                                Asset_item__c assi = new Asset_item__c();
                                           assi.name ='SitesControllerTest.asset_item__c';
                                           assi.Asset__c=ass.id;
                                           assi.Quantity__c = 0;
                                    insert assi;
                                    
                                    system.debug('Check 4' + Limits.getQueries());
                                    
                                //License Key
                                 License_Key__c lic = new License_Key__c();
                                                lic.name ='SitesControllerTest.Licensekey';
                                                lic.asset_item__c =assi.id;     
                                                lic.asset__c =ass.id;
                                                lic.server__c = server.id;
                                 insert lic;
                             //End of Account

                                     system.debug('Check 5' + Limits.getQueries());
                             
                             //Insert Opportunity & line Items
                             List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
                             
                                                              system.debug('Check 6' + Limits.getQueries());
                                                              
                                List<Product2> product = Data_Product.createProduct(pmList); 
                                
                                                                 system.debug('Check 7' + Limits.getQueries()); 
                                Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
                                PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
                                
                                                                 system.debug('Check 8' + Limits.getQueries());
                                
                                String [] stageList = new List<String>();
                                stageList.add('Negotiation');
                                system.debug('Check 9' + Limits.getQueries());
                               // List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 1);
                       
                        
                        test.startTest();                                                
                        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity2(stageList,1,acct,contacts
                        ,pmList,product,pricebook2,pbe);
                             
                        
                         String [] CategoryList = new List<String>();
                                    CategoryList.add('Training');
                                    CategoryList.add('');
                                    CategoryList.add('');
                                     
                                     system.debug('Check 10' + Limits.getQueries());
                        
                                     
                        //List<OpportunityLineItem> oppLineItem = Data_OpportunityLineItem.createOppLineItem(test_Opportunities[0].id, pbe.id, categoryList );       
                        
                        
                             //Training
                                 //Course
                                 Course__c crs = new Course__c();
                                                crs.name ='SitesControllerTest.course';
                                                crs.Active__c=true;
                                                crs.Customer_Training__c=true; 
                                 insert crs;
                                 
                                 //class
                                 Class__c cls = new Class__c();
                                                cls.class_status__c = 'Available';
                                                cls.Course__c = crs.id;
                                                cls.Class_Capacity__c = 100;    
                                 insert cls;
                                 
                                 //viewing chapter
                                 Chapter__c chpt = new Chapter__c(); 
                                                chpt.Internal_Chapter__c = false;
                                                chpt.class__c = cls.id;
                                                chpt.Chapter_Number__c = 1;
                                                
                                 insert chpt;    
                                 
                                attachment att = [Select ID,Body,BodyLength,Contenttype,Description,IsPrivate,Name,ParentID,ownerID,IsDeleted from Attachment where Isprivate=False limit 1];

                                attachment testatt = new attachment(Body = att.Body,Contenttype = att.contenttype,Description = att.Description, Isprivate = False,Name = 'Testatt876598',ParentID = chpt.ID );

                               insert testatt;
                                
                                            
                                 
                                 //registrations
                                 ELearning_Registration__c reg = new ELearning_Registration__c();
                                                           reg.Account__c = acct.id;
                                                           reg.Registration_Status__c = 'Completed';
                                                           reg.Class__c = cls.id;
                                 insert reg;                           
                                 
                                 system.debug('Check 6' + Limits.getQueries());
                                 
                                 //attendees            
                                 Training_Attendee__c attendee = new Training_Attendee__c();
                                                      attendee.Registration__c = reg.id;
                                                      attendee.Contact__c = cont.id;
                                                      attendee.Class__c = cls.id;
                                                      attendee.Status__c = 'Enrolled';
                                 insert attendee;
                                 
                                 //tokens
                                 Token__c token = new Token__c();
                                          token.Training_Attendee__c = attendee.id; 
                                          token.Account__c = Acct.id;   
                                          token.Token_Type__c = 'Training';
                                 insert token;      
                                 
                                 //legal terms
                                 Legal_Term__c legal = new Legal_Term__c();
                                          legal.version__c = 1.99;
                                          legal.Public__c = true;
                                          legal.Type__c = 'Training Registration' ;
                                          legal.Agreement__c = 'test agreement';
                                 insert legal;         
                                 
                             //End of Training  
                    }        
                 }
           
            }
            //test.stopTest();
             return adminUser;
            }   
            
            public static testMethod case createSupportCase(){
                //CASES
                TestSitesController controller = new TestSitesController();
                    case NewCase = new case();
                        NewCase.subject='This is a crazy test 11232154236584';
                        NewCase.description='This is a crazy test 11232154236584';
                        NewCase.recordtypeid=Controller.getRecordtypeID('case','product_support');
                    insert NewCase;
               return NewCase;     
            }
            
            public static testMethod contact createContact()
            {
             account accct =  Data_Account.createAccount2();
                //CASES
                TestSitesController controller = new TestSitesController();
                /*    contact newcontact = new contact();
                        newcontact.Firstname = 'new test';
                        newcontact.LastName='waffles';
                        newcontact.email='wafflehouse@waffles.com';
                        newcontact.Accountid =controller.SITE_ACCOUNT.id;
                        insert newcontact; */
                        
                    List<Contact> contacts = Data_Contact.createContacts(accct.ID,1);
                    Contact newcontact = contacts[0];
                        
               return NewContact;     
            }
    }