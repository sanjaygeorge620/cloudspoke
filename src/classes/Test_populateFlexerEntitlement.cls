/**
 * Name: Test_populateFlexeraEntitlement
 *
 * Description: to provide code coverage for populateFlexeraEntitlement Trigger on SAP Sales Order object
 *
 * Created Date: 3/22/2012
 * Created By: Manoj Kolli
 */
@isTest(SeeallData = true)
public class Test_populateFlexerEntitlement{
static testMethod void Test_populateFlexeraEntitlement2() 
    {
      Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
      UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
      User sysAdmin = new User(alias = 'test1', email='test1@lexmark.com', 
      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
      localesidkey='en_US', profileid = adminProfile.Id, 
      timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test1@testorg1.com',
      LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',
                        Legacy_Company__c = 'Lexmark');
      Database.Insert(sysAdmin);
    
     system.runas(sysAdmin){
     /*
     RecordType rec = [Select id from RecordType where Name='Location Customer' and sobjectType='Account'];
     Account acc = new Account(recordTypeId = rec.Id, Name='TestAccount', Legacy_Company_Originator__c='Perceptive Software');
     
     acc.MDM_Sold_To_Number__c = '6676765';
     insert acc;
     */
     
     //acc.MDM_Sold_To_Number__c = '35366377';
     //update acc;
     
     String [] stageList = new List<String>();
            stageList.add('Negotiation');


            stageList.add('Negotiation');
            stageList.add('Negotiation');
       //List<Contact> contacts = Data_Contact.createContacts(acc.Id,1);
        //                     Contact cont = contacts[0];
  List<Opportunity> test_opportunities3 = Data_Opportunity.createOpportunity(stageList,1);
  //List<Opportunity> test_opportunities3 = Data_Opportunity.createOpportunity3(stageList,1,acc,null); 
  
  Opportunity opp = test_opportunities3[0];
  
  //Invoice_Logo__c il = [SELECT Id FROM Invoice_Logo__c where Name = 'Perceptive' limit 1]; 
  Invoice_Logo__c  il = new Invoice_Logo__c ();
  insert il;
  
  opp.Invoice_Logo__c = il.ID;
  
  update opp;
     
  
     SAP_Contract__c sc = new SAP_Contract__c();
     sc.Account__c = opp.account.ID;
     sc.Opportunity__c = opp.ID;
     insert sc;
     
     SAP_Contract_Item__c sci = new SAP_Contract_Item__c();
     sci.SAP_Contract__c = sc.id;
     sci.Line_Number__c = '667676';
     sci.Part_Number__c = 'PER0194';
     
     sci.quantity__c = 5;
     
     insert sci;
     
     SAP_Sales_Order__c sso = new SAP_Sales_Order__c();
     sso.SAP_Contract__c = sc.ID;
     sso.SAP_Sales_Order_Number__c = '3465776';
     sso.SAP_Contract_Number__c = '878778';
     sso.Account_Name__c = opp.account.name;
    //1380
   //  sso.Account_ID__c = '87878783';
     sso.Close_Date__c = date.newInstance(2012,12,17);
  //   sso.Opportunity_Number__c = '2343526';

     try
     {
     insert sso;
        Set<ID> setIds = new Set<ID>();
        setIds.add(sso.Id);
        Test.startTest();   
        CreateEntitlementItems obj = new CreateEntitlementItems();
        CreateEntitlementItems.createItems(setIds);
     }
     catch(DMLexception e)
     { 
     system.debug('****ERROR****' +e.getMessage());    
     } 
          
     sso.Account_Name__c = 'Test';
       try
     {
     update sso;
      Flexera_Entitlement_Items__c fe = [SELECT id,Flexera_Entitlement_ID__r.Order_ID__c FROM Flexera_Entitlement_Items__c LIMIT 1];
      fe.Flexera_Entitlement_ID__r.Order_ID__c = sso.SAP_Sales_Order_Number__c;
      update fe;
     delete sso;
     }
     catch(DMLexception e)
     {
     
     } 

     List<Product_Model__c> productModels = Data_ProductModels.createProductModels(4);
        Product2 product1 = new Product2();       
        product1.Name = 'testAccount';
        product1.family='Licenses';
        product1.Tier_Pricing__c = false;
        product1.BigMachines_Category__c ='Training';
        product1.Part_Type__c='Licensed Software';
        product1.Status__c = 'General Availability';
        product1.Part_Number__c = '5432@';
        product1.Product_Model__c= productModels[0].id;
        product1.Environment__c = 'Test';
        product1.core_Product__c = true;
        product1.Replicate_Full_Environment__c = true;
        product1.Exclude_from_Test_Clone__c = true;
        product1.Exclude_from_Failover_Clone__c = true;
        product1.Test_Environments_Needed__c = 2;
        product1.Failover_Environments_Needed__c = 2;
        insert product1;
     
        Product2 product3 = new Product2();       
        product3.Name = 'testAccount';
        product3.family='Licenses';
        product3.Tier_Pricing__c = false;
        product3.BigMachines_Category__c ='Training';
        product3.Status__c = 'General Availability';
        product3.Part_Number__c = '65432@';
        product3.Product_Model__c= productModels[0].id;
        product3.Environment__c = 'Test';
        product3.core_Product__c = true;
        product3.Replicate_Full_Environment__c = true;
        product3.Exclude_from_Test_Clone__c = true;
        product3.Exclude_from_Failover_Clone__c = true;
        product3.Test_Environments_Needed__c = 2;
        product3.Failover_Environments_Needed__c = 2;
        product3.part_type__c = 'Licensed Software';
        insert product3;
      
    Product_Sub_Item__c parPro= new Product_Sub_Item__c(Parent_Product__c = product3.Id , Product__c = product1.id,active__c = true);
    insert parPro;
     
     product2 p2 = new product2();
     product2 p3 = new product2();
     p2 = CreateEntitlementItems.genProdfromSubParent(parPro);
     p3 = CreateEntitlementItems.genProdfromSub(parPro); 
     set<id> prodids = new set<id>(); 
     prodids.add(p2.id);
     prodids.add(p3.id);
     
     
     set<id> parProSet= new set<id>();
     parProSet.add(parPro.id);
     

     Map<Id, List<Product_Sub_Item__c>> prodMap = new Map<Id, List<Product_Sub_Item__c>>();
     prodMap = CreateEntitlementItems.loadProductSubItems(prodids);  
     Map<SAP_Contract_Item__c, Set<Product2>> mapProd = CreateEntitlementItems.createProductRecsfromSubItems(parPro ,sci);
      
      Test.stopTest(); 
      }     
    }
    
    static testMethod void Test_populateFlexeraEntitlement() 
    {
        Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                 
         User sysAdmin = new User(alias = 'test1', email='test1@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test1@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',
                        Legacy_Company__c = 'Lexmark');
         Database.Insert(sysAdmin);
        
        system.runas(sysAdmin){
      
      Test.startTest();
      
     Account acc = Data_Account.createAccount3();
     SAP_Contract__c sc = new SAP_Contract__c();
     sc.Account__c = acc.ID;
     insert sc;
     
     SAP_Sales_Order__c sso = new SAP_Sales_Order__c();
     sso.SAP_Contract__c = sc.ID;
     sso.SAP_Sales_Order_Number__c = '3465776';
     sso.SAP_Contract_Number__c = '878778';
     sso.Account_Name__c = acc.name;
     
     try
     {
     insert sso;
     }
     catch(DMLexception e)
     {
     
     }
     
      
      Test.stopTest(); 
     }      
    }
    
     static testMethod void Test_populateFlexeraEntitlement1() 
{
    
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1];
         
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                 
         User sysAdmin = new User(alias = 'test1', email='test1@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', UserRoleId = portalRole.Id,username='test1@testorg1.com',
         LX_Region__C='NE',LX_Ability_to_Create_Accounts__c='Yes',
                        Legacy_Company__c = 'Lexmark');
         Database.Insert(sysAdmin);
        
        system.runas(sysAdmin){
    
    //create Opportunity
        String [] stageList = new List<String>();
        Date mydate = Date.today();
        stageList.add('Negotiation');       
        
        //Create OppLine Items
         Account acct = Data_Account.createAccount();  
         List<Contact> contacts = new List<Contact>();
        //Contact cont = contacts[0];
        List<Product_Model__c> pmList = Data_ProductModels.createProductModels(1);
        List<Product2> product = Data_Product.createProduct(pmList);  
        Pricebook2 pricebook2 = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        PricebookEntry pbe = Data_PriceBookEntry.createPriceBookEntry(pricebook2.id, product[0].id);
        String [] CategoryList = new List<String>();
        CategoryList.add('Training');      
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity2(stageList, 1,acct,contacts,pmList,product,pricebook2,pbe);   
        
    
    SAP_Contract__c sc = new SAP_Contract__c();
    sc.Account__c = acct.ID;
    sc.Opportunity__c = test_opportunities[0].Id;
    insert sc;
    
     SAP_Contract_Item__c sci = new SAP_Contract_Item__c();
     sci.SAP_Contract__c = sc.id;
     sci.Line_Number__c = '667676';
     sci.Part_Number__c = 'PER0194';
     
     sci.quantity__c = 5;
     
     insert sci;
     

    SAP_Sales_Order__c sso = new SAP_Sales_Order__c();
    sso.SAP_Contract__c = sc.ID;
    sso.SAP_Sales_Order_Number__c = '3465776';
    sso.SAP_Contract_Number__c = '878778';
    sso.Account_Name__c = acct.name;
    
    List<Product_Model__c> productModels = Data_ProductModels.createProductModels(4);
        //List<Agreement__c> agreements = createAgreements(acct.id,test_opportunities[0].id,productModels );

        List<Server__c> ListServer = new List<Server__c>(); 
        List<Case> ListCases = new List<Case>();    
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get('License - External').getRecordTypeId();
        system.debug('license-External recordtype: ' + recordTypeId);
 
        //List<Product2> products = Test_ProcessInstallations_NonCore.createProducts(productModels); 
        //List<Product2> products =  Data_Product.createProduct(productModels);
        Product2 product1 = new Product2();       
                product1.Name = 'testAccount';
                product1.family='Licenses';
                product1.Tier_Pricing__c = false;
                product1.BigMachines_Category__c ='Training';
                
                product1.Status__c = 'General Availability';
                product1.Part_Number__c = '5432@';
                product1.Product_Model__c= productModels[0].id;
                product1.Environment__c = 'Test';
                product1.core_Product__c = true;
                product1.Replicate_Full_Environment__c = true;
                product1.Exclude_from_Test_Clone__c = true;
                product1.Exclude_from_Failover_Clone__c = true;
                product1.Test_Environments_Needed__c = 2;
                product1.Failover_Environments_Needed__c = 2;
                insert product1;
        Product2 product3 = new Product2();       
        product3.Name = 'testAccount';
        product3.family='Licenses';
        product3.Tier_Pricing__c = false;
        product3.BigMachines_Category__c ='Training';
        
        product3.Status__c = 'General Availability';
        product3.Part_Number__c = '65432@';
        product3.Product_Model__c= productModels[0].id;
        product3.Environment__c = 'Test';
        product3.core_Product__c = true;
        product3.Replicate_Full_Environment__c = true;
        product3.Exclude_from_Test_Clone__c = true;
        product3.Exclude_from_Failover_Clone__c = true;
        product3.Test_Environments_Needed__c = 2;
        product3.Failover_Environments_Needed__c = 2;
        insert product3;
      List<Product2> products =  new List<Product2>();  
      products.add(product1);
      products.add(product3);
    Product_Sub_Item__c objpsi = new Product_Sub_Item__c(Parent_Product__c = product3.Id , Product__c = product1.id,active__c = true);
    insert objpsi;
    Map<Id, List<Product_Sub_Item__c>> mpItems = CreateEntitlementItems.loadProductSubItems(new Set<Id>{product3.Id});
     //Product_Sub_Item__c objpsi1 = new Product_Sub_Item__c(Parent_Product__c = product3.Id , Product__c = product1.id);
    //insert objpsi1;
    Perceptive_Config_Group__c pswgrp = new Perceptive_Config_Group__c (Name='Test Data', Key__c='Test Flexera Entitlement');
         insert pswgrp ;
         Perceptive_Config_Option__c pswopt = new Perceptive_Config_Option__c (Name= 'Sample', Description__c='Sample', Perceptive_Config_Group__c =pswgrp.id);
         insert pswopt ;
         Perceptive_Config_Value__c psw_value= new Perceptive_Config_Value__c (Name='X', Value__c ='Acuo', Perceptive_Config_Option__c = pswopt.id);
         insert psw_value;    
    Test.startTest();        
    try
    {
        insert sso;
        Set<ID> setIds = new Set<ID>();
        setIds.add(sso.Id);
        CreateEntitlementItems obj = new CreateEntitlementItems();
        CreateEntitlementItems.createItems(setIds);
        CreateEntitlementItems.genProdfromSubParent(objpsi);
        CreateEntitlementItems.createProductRecsfromLineItems(sci,product3);        
    }
    catch(DMLexception e)
    {

    }


    Test.stopTest(); 
    }
       
}
    
}