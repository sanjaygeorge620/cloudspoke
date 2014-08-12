@istest
public with sharing class Data_Class {
    public static Class__c createClass(){ 
        RecordType classRecord = [Select Id, Name from RecordType where Name = 'Classroom' and sObjectType = 'Class__c' limit 1];      
        Class__c newClass = new Class__c();
        newClass.Class_Date__c = System.today();
        newClass.Class_Capacity__c = 10;
        if(classRecord!=null){
             newClass.RecordTypeId = classRecord.id;
        }
        insert newClass;    
        return newClass;  
     }
     

      static testMethod void testTestData() {
         Class__c newClass = Data_Class.createClass();       
         System.assert(newClass.id != null);
      }   
}