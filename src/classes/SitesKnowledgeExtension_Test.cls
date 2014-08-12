//Modified By Perceptive IS -07/18

@isTest(Seealldata = True)
private class SitesKnowledgeExtension_Test
{
//-------------------------------------------------------------------------------
// TEST SitesKnowledgeExtension - Completed
//-------------------------------------------------------------------------------
        public static testgenData createData(testdataform tf)
        { 
        testgenData td = new testgenData();
        RecordType rtype =[Select id from RecordType where name='Location Customer'];   
        Profile portalProfile = [select id from profile where name = 'Perceptive Customer Portal Admin' limit 1];
        UserRole ur =[Select id from UserRole where name='Admin User'];
        integer u = 0;      
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        list<User> testUser = [select id from user where ProfileId =: p.Id and IsActive = true limit 1];
        if(tf.Act)
        {
         Account acc = new Account();
         acc.recordTypeId = rtype.id;
         acc.name='Test Account';
         //acc.ownerID = u[0].id;
         acc.LX_Sales_Team_Assigned__c='Banking';
         acc.Industry_Subtype__c='Banking';
         acc.Physical_Country__c = 'USA';
         acc.BillingCountry = 'USA';
         insert acc;
         td.Act = acc;
       if(tf.Act)
       {  
         Contact con = new Contact(lastName='TestCon',accountId = acc.Id,email='a@b.com',Lx_Lexmark_Vertical__c='Banking');
         insert con; 
         td.Con = con;
       
       if(tf.cus_user)
       { 
       System.runas(testUser [0]){ 
         userRole objUserROle = [select id,name from userrole where name='Admin User' limit 1];
         User portalUser = new User(alias = 'standt', email='cstandarduser@testorg1.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = portalProfile.Id,contactId = con.Id, 
         timezonesidkey='America/Los_Angeles',username='stsdadndarduser@testorg1.com',
         LX_Region__C='NE');
         
         insert portalUser;
                 
         td.cus_user = portalUser;  
         }
       } 
       if(tf.serv)
       { 
         Server__c s= new Server__c(Name = acc.Name,Status__c='Active',Server_Name__c='T2',Account__c=acc.Id);
         insert s; 
         td.serv = s;
       }
       } 
    }
    return td;           
    }

    public static testgenData createData_Partner(testdataform tf)
    { 
    testgenData td = new testgenData();
    RecordType rtype =[Select id from RecordType where name='Location Partner'];   
    Profile portalProfile = [select id from profile where name = 'Perceptive Channel Portal Admin' limit 1];
     
    list<User> u = [select id from user where UserRoleID != null and UserType != 'PowerPartner' limit 1];
    if(tf.Act)
    {
         Account acc = new Account();
         acc.recordTypeId = rtype.id;
         acc.name='Test Account';
         acc.ownerID = u[0].id;
         acc.LX_Sales_Team_Assigned__c='Banking';
         acc.Industry_Subtype__c='Banking';  
         acc.Physical_Country__c = 'USA';
               acc.Physical_Country__c = 'USA';
                            acc.BillingCountry = 'USA';
     
         insert acc;
         td.Act = acc;
       if(tf.Act)
       {  
         Contact con = new Contact(lastName='TestCon',accountId = acc.Id,email='a@b.com',Lx_Lexmark_Vertical__c='Banking');
         insert con; 
         td.Con = con;
       
       if(tf.cus_user)
       {  
         User portalUser = new User(alias = 'stapa', email='cstandarduser@testorg1.com', 
         emailencodingkey='UTF-8', lastname='Testingpartner', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = portalProfile.Id,contactId = con.Id, 
         timezonesidkey='America/Los_Angeles',username='stsdadndarduserpartner@testorg1.com',
         LX_Region__C='NE');
         
         insert portalUser;         
         td.cus_user = portalUser;  
       } 
       if(tf.serv)
       { 
         Server__c s= new Server__c(Name = acc.Name,Status__c='Active',Server_Name__c='T2',Account__c=acc.Id);
         insert s; 
         td.serv = s;
       }
       } 
        }
        return td;           
        }
        
       

         public static testmethod void testTestData() 
         {
             testgenData td = new testgenData();
             testdataform tf = new testdataform();
             tf.serv = True;
             
             td = createData(tf);
             testgenData td2 = createData_Partner(tf); 
         }
               
     
       
       
       
       
        static testMethod void testSitesKnowledgeExtension() 
        {
         Profile portalProfile = [select id from profile where name = 'Perceptive Customer Portal Admin' limit 1];
         
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
         
         RecordType rtype =[Select id from RecordType where name='Location Customer'];   
         
         User sysAdmin = new User(alias = 'test21', email='test123@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Tes2ting', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, Legacy_Company__c='Lexmark', 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test2231@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',UserPermissionsKnowledgeUser = True);
         
         Database.Insert(sysAdmin);
         
         system.runas(sysAdmin)
         {
         
         
  //ProductHelp__kav----------------------------------------------------------------------------------
         
         ProductHelp__kav phka = new ProductHelp__kav(ArticleID__c = 'Test546',Internal_Note__c = 'testing', Summary = 'fefefe',title = 'sfegeg',UrlName = 'gregr1234',language = 'en_US',IsVisibleInCsp = True);
         insert phka;
         
         ProductHelp__kav phpu =[Select ID,knowledgearticleId From ProductHelp__kav where id =: phka.id limit 1];
         String articleId1 = string.valueof(phpu.knowledgearticleId);
         KbManagement.PublishingService.publishArticle(articleId1, true);

  //Support_Articles__kav----------------------------------------------------------------------------------
         Support_Articles__kav saka = new Support_Articles__kav(ArticleID__c = 'Test546',Internal_Note__c = 'testing', title = 'sfegeg',UrlName = 'gregr12232334',Advanced__c = 'gjergbrbgj', language = 'en_US',IsVisibleInCsp = True);
         insert saka;
         
         Support_Articles__kav sapu =[Select ID,knowledgearticleId From Support_Articles__kav where id =: saka.id limit 1];
         String articleId3 = string.valueof(sapu.knowledgearticleId);
         KbManagement.PublishingService.publishArticle(articleId3, true); 

  //Technical_Overview__kav----------------------------------------------------------------------------------
         Technical_Overview__kav toka = new Technical_Overview__kav(section1__c = 'Test546',title = 'gdfgdf',UrlName = 'tor12232334', language = 'en_US',IsVisibleInCsp = True);
         insert toka;
         
         Technical_Overview__kav topu =[Select ID,knowledgearticleId From Technical_Overview__kav where id =: toka.id limit 1];
         String articleId4 = string.valueof(topu.knowledgearticleId);
         KbManagement.PublishingService.publishArticle(articleId4, true); 
                  

        // test_Data_Wrapper t = new test_Data_Wrapper();
         testdataform tf = new testdataform();
         testgenData tg = createData(tf);
         
         User portalUser = tg.cus_user;
         
         system.runas(portalUser )
         {
         SitesKnowledgeExtension controller;
         ApexPages.StandardController  kc;
         
            test.starttest();  
               /* Type */
               ProductHelp__kav ph =[Select p.knowledgearticleId From ProductHelp__kav p where publishstatus='online' and language='en_US' limit 1];
               ApexPages.currentPage().getParameters().put('id', ph.knowledgearticleId);
               controller = new SitesKnowledgeExtension(New ApexPages.StandardController(ph));
               controller.getProductHelp();
               controller.getProductDoc();   
               
               /* Type */
               Support_Articles__kav sa =[Select p.knowledgearticleId From Support_Articles__kav p where publishstatus='online' and language='en_US' limit 1];
               ApexPages.currentPage().getParameters().put('id', sa.knowledgearticleId);
               controller = new SitesKnowledgeExtension(New ApexPages.StandardController(sa));
               controller.getSupportArticle();
               
               /* Type */
               Technical_Overview__kav to =[Select p.knowledgearticleId From Technical_Overview__kav p where publishstatus='online' and language='en_US' limit 1];
               ApexPages.currentPage().getParameters().put('id', to.knowledgearticleId);
               controller = new SitesKnowledgeExtension(New ApexPages.StandardController(to));
               controller.getSupportArticle();
               controller.getTechnicalOverview();
               
               controller.SubmitFeedback();
               
               /* Type 
               Video__kav st =[Select p.knowledgearticleId From Video__kav p where publishstatus='online' and language='en_US' limit 1];
               ApexPages.currentPage().getParameters().put('id', st.knowledgearticleId);
               controller = new SitesKnowledgeExtension(New ApexPages.StandardController(st));
               controller.getVideo();*/
               
               system.debug('TOTAL SOQL' +limits.getQueries());
         test.stoptest();    
        
       }   
        
           
       }
}
}