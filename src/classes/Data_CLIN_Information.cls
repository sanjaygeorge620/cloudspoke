@isTest
public with sharing class Data_CLIN_Information {

 public static CLIN_Information__c createCLINInformation(Id oppId){    
     
         
         CLIN_Information__c newClin = new CLIN_Information__c();
        
        newClin.opportunity__c = oppid;

        insert newClin;
        
        
        
        return newClin;  
     }
     

      static testMethod void testTestData() {
         String [] stageList = new List<String>();
            stageList.add('Negotiation');
            stageList.add('Negotiation');
            stageList.add('Negotiation');
              List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity(stageList, 3);  
              
           for (Opportunity oppRec: test_Opportunities){
            oppRec.Sector__c = 'National Government1';
           }
           test.starttest();
            update test_Opportunities; 
            
            CLIN_Information__c newClin2 = new CLIN_Information__c();
            CLIN_Information__c newClin3 = new CLIN_Information__c();
        
            newClin2.opportunity__c = test_Opportunities[0].id;
            newClin3.opportunity__c = test_Opportunities[0].id;
            insert newClin2;
            insert newClin3;
            update newClin2;
            delete newClin3;     
           test.stoptest();       
         CLIN_Information__c newClin = Data_CLIN_Information.createCLINInformation(test_Opportunities[0].id);       
         System.assert(newClin.id != null);
      }   
       
}