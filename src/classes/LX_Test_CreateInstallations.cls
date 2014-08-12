/**
This Test class is used to cover the following Class: CreateInstallations
*/

@isTest(SeeAllData = true)
private class LX_Test_CreateInstallations {

/*

    public static testmethod void testMethod1_CreateInstallations(){
        LX_Data_Opportunity.testData();
        
        
        CreateInstallations createInstallationsClsVar = new CreateInstallations(LX_Data_Opportunity.optyRec.Id);
        
        CreateInstallations.runInstallations();
        
        // Insert Opportunity Line Items
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        String standardPriceBookId = pb2Standard.Id;
        
        // Create new Product Model record
        Product_Model__c prodModel = new Product_Model__c(Name='Sample Model',Asset_Required__c=true);
        insert prodModel;
        // set up product2 and Verify that the results are as expected.
        
        Product2 p1 = new Product2(Name='Test Product1',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live');
        insert p1;
                
        // set up product2 and Verify that the results are as expected.
        Product2 p2 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live',SMSA_Product__c=p1.Id);
        insert p2;
        
        // set up product2 and Verify that the results are as expected.
        Product2 p3 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live',SMSA_Product__c=p2.Id);
        insert p3;
                      
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;
        
                
        // set up OpportunityLineItem and Verify that the results are as expected.
        OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=LX_Data_Opportunity.optyRec.Id, Quantity=1, TotalPrice=99);
        insert oli;
        
        
        Agreement__c ag = new Agreement__c();
        ag.account__c = LX_Data_Opportunity.optyRec.AccountId;
        ag.Opportunity__c=LX_Data_Opportunity.optyRec.Id;
        ag.Start_Date__c = System.Today();
        ag.name='Sample Model';
        ag.Status__c = 'Inactive';
        insert ag;
        
        Server__c sr = new Server__c ();
        sr.Account__c = LX_Data_Opportunity.optyRec.AccountId;
        sr.Name= 'Server Test';
        sr.Server_Name__c = 'test Server';
        sr.Server_Type__c='Test';
        insert sr;
        Server__c sr1 = new Server__c ();
        sr1.Account__c = LX_Data_Opportunity.optyRec.AccountId;
        sr1.Name= 'Server Test';
        sr1.Server_Name__c = 'test Server';
        sr1.Server_Type__c='Live';
        insert sr1;
        
        Product_Sub_Item__c ps = new Product_Sub_Item__c();
        ps.Product__c = p3.id;
        ps.Parent_product__c = p2.id;
        ps.active__c= true;
        insert ps;
   
        createInstallationsClsVar.process();
    
    }

    public static testmethod void testMethod1_CreateInstallations2(){
        LX_Data_Opportunity.testData();
        //Rahul adding for removing 101 SOQL error
        test.startTest();
        
        
        CreateInstallations createInstallationsClsVar = new CreateInstallations(LX_Data_Opportunity.optyRec.Id);
        
        CreateInstallations.runInstallations();
        
        // Insert Opportunity Line Items
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        String standardPriceBookId = pb2Standard.Id;
        
        // Create new Product Model record
        Product_Model__c prodModel = new Product_Model__c(Name='Sample Model',Asset_Required__c=true);
        insert prodModel;
        // set up product2 and Verify that the results are as expected.
        
        Product2 p1 = new Product2(Name='Test Product1',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live');
        insert p1;

                
        // set up product2 and Verify that the results are as expected.
        Product2 p2 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = False,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live',SMSA_Product__c=p1.Id);
        insert p2;
        
        // set up product2 and Verify that the results are as expected.
        Product2 p3 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = True,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live',SMSA_Product__c=p1.Id);
        insert p3;
        
        List<PricebookEntry > lstPbetoInsert = new List<PricebookEntry >();        
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        
                
                // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=p3.Id, UnitPrice=99, isActive=true);
        lstPbetoInsert.add(pbe);
        lstPbetoInsert.add(pbe1);
        insert lstPbetoInsert;
        
        // set up OpportunityLineItem and Verify that the results are as expected.
        OpportunityLineItem oli1 = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=LX_Data_Opportunity.optyRec.Id, Quantity=1, TotalPrice=99);
        OpportunityLineItem oli2 = new OpportunityLineItem(PriceBookEntryId=pbe1.Id, OpportunityId=LX_Data_Opportunity.optyRec.Id, Quantity=1, TotalPrice=99);
        
        List<OpportunityLineItem> lstOlitoInsert = new List<OpportunityLineItem>();
        lstOlitoInsert.add(oli1);
        lstOlitoInsert.add(oli2);
        
        insert lstOlitoInsert;
        test.stopTest();
        createInstallationsClsVar.process();

        
    }

    public static testmethod void testMethod1_CreateInstallations1(){
        LX_Data_Opportunity.testData();
        
        
        CreateInstallations createInstallationsClsVar = new CreateInstallations(LX_Data_Opportunity.optyRec.Id);
        
        CreateInstallations.runInstallations();
        
        // Insert Opportunity Line Items
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        String standardPriceBookId = pb2Standard.Id;
        
        // Create new Product Model record
        Product_Model__c prodModel = new Product_Model__c(Name='Sample Model',Asset_Required__c=true);
        insert prodModel;
        // set up product2 and Verify that the results are as expected.
        
        Product2 p1 = new Product2(Name='Test Product1',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live',Test_Licenses_Allowed__c=30);
        insert p1;
                
        // set up product2 and Verify that the results are as expected.
        Product2 p2 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = False,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Live',SMSA_Product__c=p1.Id,Test_Licenses_Allowed__c=30);
        insert p2;
        
                
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;
        
        // set up OpportunityLineItem and Verify that the results are as expected.
        OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=LX_Data_Opportunity.optyRec.Id, Quantity=1, TotalPrice=99);
        insert oli;
        
        
        createInstallationsClsVar.process();
    
    }
    
     public static testmethod void testMethod1_CreateInstallations4(){
        LX_Data_Opportunity.testData();
        
        //Rahul adding for removing 101 SOQL error
        test.startTest();
        
        CreateInstallations createInstallationsClsVar = new CreateInstallations(LX_Data_Opportunity.optyRec.Id);
        
        CreateInstallations.runInstallations();
        
        // Insert Opportunity Line Items
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        String standardPriceBookId = pb2Standard.Id;
        
        // Create new Product Model record
        Product_Model__c prodModel = new Product_Model__c(Name='Sample Model',Asset_Required__c=true);
        insert prodModel;
        // set up product2 and Verify that the results are as expected.
        
        Product2 p1 = new Product2(Name='Test Product1',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Failover',Test_Licenses_Allowed__c=15,Test_Environments_Needed__c=5);
        insert p1;
                
        // set up product2 and Verify that the results are as expected.
        Product2 p2 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = False,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Failover',SMSA_Product__c=p1.Id,Test_Licenses_Allowed__c=15,Test_Environments_Needed__c=5);
        insert p2;
        
                
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;
        
        // set up OpportunityLineItem and Verify that the results are as expected.
        OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=LX_Data_Opportunity.optyRec.Id, Quantity=1, TotalPrice=99);
        insert oli;
        
        test.stopTest();        
        createInstallationsClsVar.process();
    
    }
    
    public static testmethod void testMethod1_CreateInstallations5(){
        LX_Data_Opportunity.testData();
        
        //Rahul adding for removing 101 SOQL error
        test.startTest();
        
        CreateInstallations createInstallationsClsVar = new CreateInstallations(LX_Data_Opportunity.optyRec.Id);
        
        CreateInstallations.runInstallations();
        
        // Insert Opportunity Line Items
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        String standardPriceBookId = pb2Standard.Id;
        
        // Create new Product Model record
        Product_Model__c prodModel = new Product_Model__c(Name='Sample Model',Asset_Required__c=true);
        insert prodModel;
        // set up product2 and Verify that the results are as expected.
        
        Product2 p1 = new Product2(Name='Test Product1',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Test',Test_Licenses_Allowed__c=30,Test_Environments_Needed__c=5,Exclude_from_Test_Clone__c=false);
        insert p1;
                
        // set up product2 and Verify that the results are as expected.
        Product2 p2 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = False,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Test',SMSA_Product__c=p1.Id,Test_Licenses_Allowed__c=20,Test_Environments_Needed__c=5,Exclude_from_Test_Clone__c=false);
        insert p2;
        
                
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;
        
        // set up OpportunityLineItem and Verify that the results are as expected.
        OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=LX_Data_Opportunity.optyRec.Id, Quantity=1, TotalPrice=99);
        insert oli;
        test.stopTest();        
        
        createInstallationsClsVar.process();
    }
    
      public static testmethod void testMethod1_CreateInstallations6(){
        LX_Data_Opportunity.testData();
        
        
        CreateInstallations createInstallationsClsVar = new CreateInstallations(LX_Data_Opportunity.optyRec.Id);
        
        CreateInstallations.runInstallations();
        
        // Insert Opportunity Line Items
        //Rahul adding for removing 101 SOQL error
        test.startTest();
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        String standardPriceBookId = pb2Standard.Id;
        
        // Create new Product Model record
        Product_Model__c prodModel = new Product_Model__c(Name='Sample Model',Asset_Required__c=true);
        insert prodModel;
        // set up product2 and Verify that the results are as expected.
        
        Product2 p1 = new Product2(Name='Test Product1',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = TRUE,Product_Model__c = prodModel.Id,
                                   Environment__c = 'FailOver',Test_Licenses_Allowed__c=30,Failover_Environments_Allowed__c=5);
        insert p1;
                
        // set up product2 and Verify that the results are as expected.
        Product2 p2 = new Product2(Name='Test Product2',isActive=true,Replicate_Full_Environment__c = TRUE,Core_Product__c = False,Product_Model__c = prodModel.Id,
                                   Environment__c = 'Failover',SMSA_Product__c=p1.Id,Test_Licenses_Allowed__c=20,Failover_Environments_Allowed__c=5);
        insert p2;
        
                
        // set up PricebookEntry and Verify that the results are as expected.
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=standardPriceBookId, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;
        
        // set up OpportunityLineItem and Verify that the results are as expected.
        OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId=pbe.Id, OpportunityId=LX_Data_Opportunity.optyRec.Id, Quantity=1, TotalPrice=99);
        insert oli;
        test.stopTest();
        

        createInstallationsClsVar.process();

    
    }
    */
}