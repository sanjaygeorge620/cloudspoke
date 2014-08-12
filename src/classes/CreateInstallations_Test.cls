@isTest(seeAllData = True)
public class CreateInstallations_Test{
    static Account testAcc;
    static Opportunity testopp;
    static List<OpportunityLineItem> testOppLineList;
    static List<OpportunityLineItem> testOppLineListAssetReqTrue;
    static Id oppId;
    static Set<Id> oppIdSet;
    static Map<OpportunityLineItem,List<Server__c>> testOppLineServerMap;
    static Map<OpportunityLineItem,List<Server__c>> testOppLineServerMapAssetReq ;
    static Server__c testServer;
    static List<Server__c> testServerList;
    
    
    public static void createTestData(){
        
      /*  testAcc = new Account();
        testAcc = Data_Account.createAccount();
        testOppLineList = new List<OpportunityLineItem>();
        Product2 p = [Select id, Product_Model__c from Product2 where id = '01ti0000001OwirAAC' ];
        Product_Model__c pm = [Select id,Asset_Required__c from Product_Model__c where Asset_Required__c = True limit 1];
        p.Product_Model__c = pm.Id;
        system.debug('!!!!!' + pm.id);
        update p;
        Agreement__c agr = [SELECT id FROM Agreement__c LIMIT 1];
        agr.name = 'VRS 4.x Plus for USB/Firewire Production Scanning';
        agr.Account__c = '001i000000KzER0AAN';
        agr.Status__c = 'Inactive';
        update agr;
        testOppLineList = [Select id,Quantity,PricebookEntry.Product2.Replicate_Full_Environment__c,PricebookEntry.Product2.Core_Product__c,
                          PricebookEntry.Product2Id,Opportunity.AccountId,OpportunityId,PricebookEntry.Product2.Product_Model__r.Asset_Required__c,
                          PricebookEntry.Product2.SMSA_Product__c,PricebookEntry.Product2.Product_Model__r.Name,Opportunity.Account.Name,
                          PricebookEntry.Product2.Parent_Product__r.Product_Model__r.Name,PricebookEntry.Product2.Environment__c,
                          PricebookEntry.Product2.Test_Environments_Needed__c,PricebookEntry.Product2.Failover_Environments_Needed__c,
                          PricebookEntry.Product2.Exclude_from_Test_Clone__c,PricebookEntry.Product2.Test_Environments_Allowed__c,
                          PricebookEntry.Product2.Failover_Environments_Allowed__c,PricebookEntry.Product2.Exclude_from_Failover_Clone__c
                          
                          from OpportunityLineItem
                          limit 1];
        testOppLineList[0].PricebookEntry.Product2.Core_Product__c = true;
        testOppLineListAssetReqTrue = new List<OpportunityLineItem>();
        testOppLineListAssetReqTrue = [Select id,Quantity,PricebookEntry.Product2.Replicate_Full_Environment__c,PricebookEntry.Product2.Core_Product__c,
                          PricebookEntry.Product2Id,Opportunity.AccountId,OpportunityId,PricebookEntry.Product2.Product_Model__r.Asset_Required__c,
                          PricebookEntry.Product2.SMSA_Product__c,PricebookEntry.Product2.Product_Model__r.Name,Opportunity.Account.Name,
                          PricebookEntry.Product2.Parent_Product__r.Product_Model__r.Name,PricebookEntry.Product2.Environment__c,
                          PricebookEntry.Product2.Test_Environments_Needed__c,PricebookEntry.Product2.Failover_Environments_Needed__c,
                          PricebookEntry.Product2.Exclude_from_Test_Clone__c,PricebookEntry.Product2.Test_Environments_Allowed__c,
                          PricebookEntry.Product2.Failover_Environments_Allowed__c,PricebookEntry.Product2.Exclude_from_Failover_Clone__c
                          
                          from OpportunityLineItem where id = :testOppLineList[0].Id
                          limit 1];       

       // testOppLineListAssetReqTrue[0].PricebookEntry.Product2.Product_Model__c = 'a1oc00000006DuKAAU';  

        //testOppLineListAssetReqTrue[0].PricebookEntry.Product2id = p.id;
        testOppLineListAssetReqTrue[0].PricebookEntry.Product2.Environment__c = 'Test';
        Update testOppLineListAssetReqTrue;
        
       // Product2 p = [Select id, [Select id, [Select id From OpportunityLineItem__r] from PricebookEntry__r ] From Product2]              
       // Update testOppLineListAssetReqTrue;
        system.debug('@@@@ List Value: ' + testOppLineListAssetReqTrue[0]  );
        system.debug('@@@@ List Value product: ' + testOppLineListAssetReqTrue[0].PricebookEntry.Product2.Environment__c  );
        system.debug('@@@@ List Value product model: ' + testOppLineListAssetReqTrue[0].PricebookEntry.Product2.Product_Model__c   );
        testOppLineListAssetReqTrue[0].PricebookEntry.Product2.Product_Model__r.Asset_Required__c = True;
        testOppLineListAssetReqTrue[0].PricebookEntry.Product2.Exclude_from_Failover_Clone__c = True;
        Update testOppLineListAssetReqTrue;
        
        System.Debug('#$#$ List '+testOppLineList);
        System.Debug('#$#$ First '+testOppLineList);
        System.Debug('#$#$ First Opp '+testOppLineList[0].OpportunityID);
        testopp = new Opportunity();
        testopp = [Select Id from Opportunity where id = :testOppLineList[0].OpportunityID limit 1 ];
        System.Debug('#$#$ Opp '+testOppLineList);
        oppId = testopp.Id;
        System.Debug('#$#$ OppId '+oppId);
        oppIdSet = new Set<Id>();
        oppIdSet.add(oppId );
        
        testServer = new Server__c();
        testServer.name = 'TestServer';
        testServer.Server_Type__c = 'Live';
        testServer.Account__c = testAcc.Id;
        testServer.Server_Name__c = 'TestServerName';
        testServer.Status__c = 'Active';
        insert testServer;
        
        testServerList = new List<Server__c>();
        testServerList.add(testServer);
        
        testOppLineServerMap = new Map<OpportunityLineItem,List<Server__c>>();
        for(OpportunityLineItem tempOppLineItem : testOppLineList ){
                    testOppLineServerMap.put(tempOppLineItem , testServerList );
                }
        testOppLineServerMapAssetReq = new Map<OpportunityLineItem,List<Server__c>>();
        for(OpportunityLineItem tempOppLineItem : testOppLineListAssetReqTrue ){
                    testOppLineServerMapAssetReq.put(tempOppLineItem , testServerList );
                }
              
    }
    
    public static testmethod void testCreateInstallations(){
        test.startTest();
        
        createTestData();
        //if(oppId != Null && testOppLineList != Null){
        CreateInstallations testInstance = new CreateInstallations(oppId);
            CreateInstallations.runInstallations();
            testInstance.process();
            //testInstance.replicateEnvironments(testOppLineList);
            //testInstance.handleCoreProducts(testOppLineList);
            //testInstance.getAgreements(testOppLineList);
            //testInstance.handleInstallationProducts(testOppLineList);
            //CreateInstallations.callCreateInstallations(oppIdSet);
            testOppLineServerMap = new Map<OpportunityLineItem,List<Server__c>>();
            //testOppLineServerMap = testInstance.createOrFindServers(testOppLineList,True);
            //testInstance.handleAssets(testOppLineServerMap);
           // testInstance.handleAssets(testOppLineServerMapAssetReq);
        //}
        test.stoptest();*/
    }
}