public class Data_PSE_Practice {
     public static pse__Practice__c createPractice(){       
        pse__Practice__c pse_practice = new pse__Practice__c(Name = 'test practice');
        pse_practice.CurrencyIsoCode = 'USD';
    pse__Practice__c parentPractice = [Select id from pse__Practice__c where pse__Parent_Practice__c = null or Name like '%Corporate Practice%' limit 1];
       //4.17.2013
       pse_practice.pse__Parent_Practice__c = parentPractice.Id;       
       // pse_practice.pse__Parent_Practice__c = 'a2F70000000PAsI';//parentPractice.Id;
        
        insert pse_practice;
        return pse_Practice;  
     }
     

      static testMethod void testTestData() {
         pse__Practice__c practice = Data_PSE_Practice.createPractice();       
         System.assert(practice.id != null);
      }   
}