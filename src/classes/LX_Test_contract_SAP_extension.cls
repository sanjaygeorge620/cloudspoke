@isTest(seeAlldata = true)
 private class LX_Test_contract_SAP_extension{
 
 Public static List<pse__Proj__c> ps_projects = Data_Project.createProject(1);
 Public static Opportunity testOpp;
 static List<OpportunityLineItem> testOppLineList;
 Public static List<Opportunity> opplist;
 Public static Map<ID,list<OpportunityLineItem>> linemap;
 Public static Order__c testOrder;
 Public static Id testOppId;
 Public static map<ID,Order__c> testOrderMap;
 Public static Set<Id> oppset;
 static testmethod void m1(){
     test.startTest();
     ApexPages.CurrentPage().getParameters().put('id',ps_projects[0].Id);
     LX_contract_SAP_extension con_SAP_Proj = new LX_contract_SAP_extension ();
     
    //Added to test createOpportunityOrderShell
    testOppLineList = new List<OpportunityLineItem>();
    testOppLineList = [Select id,Quantity,PricebookEntry.Product2.Replicate_Full_Environment__c,PricebookEntry.Product2.Core_Product__c,
                          PricebookEntry.Product2Id,Opportunity.AccountId,OpportunityId,PricebookEntry.Product2.Product_Model__r.Asset_Required__c,
                          PricebookEntry.Product2.SMSA_Product__c,PricebookEntry.Product2.Product_Model__r.Name,Opportunity.Account.Name,
                          PricebookEntry.Product2.Parent_Product__r.Product_Model__r.Name,PricebookEntry.Product2.Environment__c,
                          PricebookEntry.Product2.Test_Environments_Needed__c,PricebookEntry.Product2.Failover_Environments_Needed__c,
                          PricebookEntry.Product2.Exclude_from_Test_Clone__c,PricebookEntry.Product2.Test_Environments_Allowed__c,
                          PricebookEntry.Product2.Failover_Environments_Allowed__c,PricebookEntry.Product2.Exclude_from_Failover_Clone__c,
                          PricebookEntry.Product2.Name
                          
                          from OpportunityLineItem
                          limit 1];
     testOpp = new Opportunity();
     testOpp = [Select id,LX_Program_Enrollment__c from opportunity where id = :testOppLineList[0].OpportunityID limit 1 ];
     opplist = new List<Opportunity>();
     oppList.add(testOpp);
     oppset = new Set<Id>();
     testOppId = testOpp.id;
     oppset.add(testOppId );
     linemap = new Map<ID,list<OpportunityLineItem>>();
     linemap.put(testOppId ,testOppLineList );
     
     testOrder = new Order__c();
     testOrder.Opportunity__c = testOppId;
     testOrder.status__c = True;
     insert testOrder;
     createOpportunityOrderShell.createOpportunityOrderShell(testOppId );
     testOrderMap = new map<ID,Order__c>();
     testOrderMap  = createOpportunityOrderShell.createOpportunityOrderShellmap(oppset,oppList,linemap); 
     test.stopTest();
 }
 
 }