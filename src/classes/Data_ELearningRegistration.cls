@isTest
public with sharing class Data_ELearningRegistration {

    public static ELearning_Registration__c createElearning(id classRecId, id AccountId){ 
        System.debug('ClassrecID :'+classRecId+' and Account id : '+AccountID);
        ELearning_Registration__c registration = new ELearning_Registration__c();
        registration.class__c = classRecId;
        registration.Account__c = AccountId;
        System.debug('');
        insert registration;  
        System.debug('Registration Inserted : '+registration);
        return registration;  
     }
     

      static testMethod void testTestData() {
        Class__c newClass = Data_Class.createClass(); 
        Account acc = Data_Account.createAccount();
         ELearning_Registration__c newRegistration = Data_ELearningRegistration.createElearning(newclass.id,acc.id );       
         System.assert(newRegistration.id != null);
      }   
}