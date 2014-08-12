@istest
public class Data_PSE_Region {
     public static pse__Region__c createRegion(){       
        pse__Region__c pse_region = new pse__Region__c();
        pse_region.Name = 'test region';
        pse_region.CurrencyIsoCode = 'USD';
        pse__Region__c parentRegion = [Select id from pse__Region__c where pse__Parent_Region__c = null or Name like '%Corporate Region%' limit 1];
        //14.7.2013
        //id parentRegion = 'a4de0000000CaT3AAK';
        //id parentRegion = 'a2J70000000Kyjz';

        pse_region.pse__Parent_Region__c = parentRegion.Id;
        insert pse_region;
        return pse_region;  
     }
     
     
      public static pse__Region__c createRegion1(){       
        pse__Region__c pse_region = new pse__Region__c();
        pse_region.Name = 'test region';
        pse_region.CurrencyIsoCode = 'USD';       
        insert pse_region;
        return pse_region;  
     }
     

      static testMethod void testTestData() {
         pse__Region__c region = Data_PSE_Region.createRegion();       
         System.assert(region.id != null);
      }   
}