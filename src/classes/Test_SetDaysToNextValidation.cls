@isTest
private class Test_SetDaysToNextValidation{
  static testMethod void compareDaystoNextValidation(){ 
  Perceptive_Config_Group__c pswgrp = new Perceptive_Config_Group__c (Name='Test Data', Key__c='TestKey');
         insert pswgrp ;
         Perceptive_Config_Option__c pswopt = new Perceptive_Config_Option__c (Name= 'Sample', Description__c='Sample', Perceptive_Config_Group__c =pswgrp.id);
         insert pswopt ;
         Perceptive_Config_Value__c psw_value= new Perceptive_Config_Value__c (Name='X', Value__c ='1', Perceptive_Config_Option__c = pswopt.id);
         insert psw_value;    
         List__c lst = Data_List.createList();
         
         Perceptive_Config_Value__c days = [SELECT Value__c, Name FROM Perceptive_Config_Value__c where Name='X' limit 1];
         integer daysCount=Integer.valueof(days.value__c);
         List<List__c> lsts = new List<List__c>();       
         lsts=[SELECT OwnerId,Days_to_Next_Validation__c from List__c where id= :lst.id];
        //VT:8/25 commented system.assertEquals(lsts[0].Days_to_Next_Validation__c,daysCount);
       }
}