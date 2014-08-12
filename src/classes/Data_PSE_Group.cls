public class Data_PSE_Group {
     public static pse__Grp__c createGroup(){   
 
        
        pse__Grp__c  pse_group = new pse__Grp__c(name='test Group');
        pse_group.CurrencyIsoCode = 'USD';
        pse__Grp__c parentGroup = [Select id from pse__Grp__c where pse__Parent_Group__c = null or Name like '%Corporate%' limit 1];
        //4.18.2013 from 8 to 10
        pse_Group.pse__Parent_Group__c = parentGroup.Id;//ParentGroup.Id;
        //pse_Group.pse__Parent_Group__c = 'a4Ee000000000llEAA';

        insert pse_group;
        return pse_group;  
     }
     

      static testMethod void testTestData() {
         pse__Grp__c grp = Data_PSE_Group.createGroup();       
         System.assert(grp.id != null);
      }   
}