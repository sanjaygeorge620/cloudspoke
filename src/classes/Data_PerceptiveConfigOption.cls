@istest
public with sharing class Data_PerceptiveConfigOption {

     public static List<Perceptive_Config_Option__c> createPerceptiveConfigOption(Perceptive_Config_Group__c PCG, Integer NumberOfOptions){ 
        
        String varAlias = string.valueof(system.currentTimeMillis());
        system.debug('varAlias' + varAlias);
        Integer aliaslength = varAlias.length(); 
        List<Perceptive_Config_Option__c>  OptionList = new List<Perceptive_Config_Option__c>();
         
        for(Integer i =0;i<NumberOfOptions;i++){      
            Perceptive_Config_Option__c PCO = new Perceptive_Config_Option__c(Perceptive_Config_Group__c = PCG.id);       
            PCO.Name = 'TestingName' + varAlias.subString(aliaslength-2,aliaslength);
            PCO.Description__c = 'Testing';
            OptionList.add(PCO);
        }    
        insert OptionList;       
        return OptionList;  
     }
     

      static testMethod void testTestData() {
         Perceptive_Config_Group__c PCG = Data_PerceptiveConfigGroup.createPerceptiveConfigGroup();
         List<Perceptive_Config_Option__c> PCO = Data_PerceptiveConfigOption.createPerceptiveConfigOption(PCG, 2);           
         System.assert(PCO[0].id != null);
      }   

}