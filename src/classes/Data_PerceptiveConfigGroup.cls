@isTest
public with sharing class Data_PerceptiveConfigGroup {
     public static Perceptive_Config_Group__c createPerceptiveConfigGroup(){ 
        
        String varAlias = string.valueof(system.currentTimeMillis());
        system.debug('varAlias' + varAlias);
        Integer aliaslength = varAlias.length();   
         
              
        Perceptive_Config_Group__c PCG = new Perceptive_Config_Group__c(Key__c='TestingKey' + varAlias.subString(aliaslength-2,aliaslength));       
        PCG.Description__c = 'Testing';
        PCG.Name = 'TestingName' + varAlias.subString(aliaslength-2,aliaslength);
        insert PCG;       
        return PCG;  
     }
     

      static testMethod void testTestData() {
         Perceptive_Config_Group__c PCG = Data_PerceptiveConfigGroup.createPerceptiveConfigGroup();       
         System.assert(PCG.id != null);
      }   

}