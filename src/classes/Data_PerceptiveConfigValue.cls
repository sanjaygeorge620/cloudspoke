@isTest
public with sharing class Data_PerceptiveConfigValue {

     public static List<Perceptive_Config_Value__c> createPerceptiveConfigValue(Perceptive_Config_Option__c PCO, Integer NumberOfValues){ 
        
        String varAlias = string.valueof(system.currentTimeMillis());
        system.debug('varAlias' + varAlias);
        Integer aliaslength = varAlias.length(); 
        List<Perceptive_Config_Value__c>  ValueList = new List<Perceptive_Config_Value__c>();
         
        for(Integer i =0;i<NumberOfValues;i++){      
            Perceptive_Config_Value__c PCV = new Perceptive_Config_Value__c(Perceptive_Config_Option__c = PCO.id);       
            PCV.Name = 'TestingName' + varAlias.subString(aliaslength-2,aliaslength);
            PCV.Description__c = 'Testing';
            PCV.Value__c = 'TestingValue' + varAlias.subString(aliaslength-2,aliaslength);
            ValueList.add(PCV);
        }    
        insert ValueList;       
        return ValueList;  
     }
     

      static testMethod void testTestData() {
         Perceptive_Config_Group__c PCG = Data_PerceptiveConfigGroup.createPerceptiveConfigGroup();
         List<Perceptive_Config_Option__c> PCO = Data_PerceptiveConfigOption.createPerceptiveConfigOption(PCG, 2);    
         List<Perceptive_Config_Value__c> PCV = Data_PerceptiveConfigValue.createPerceptiveConfigValue(PCO[0], 2);    
         System.assert(PCV[0].id != null);
      }   

}