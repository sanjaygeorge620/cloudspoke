//Error Log Class utility
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Example Call: ErrorLogUtility.createErrorRecord(e.getMessage(),ClassName,'Severity: Low, Medium, High, Critical',Exception Type);
//Example Code
//               try{
//                   insert data;
//                   }
//                   catch (DmlException e) {
//                        // DML Exception handling code here  
//                           ErrorLogUtility.createErrorRecord(e.getMessage(),'ClassName.Method','Critical','DML');
//                   }
//                   catch(Exception e){
//                        // Generic Exception handling code here       
//                        ErrorLogUtility.createErrorRecord(e.getMessage(),'ClassName.Method','Low','Generic');
//                  }  
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

global without sharing class ErrorLogUtility {
     @future
     public static void createErrorRecord(string exceptionMessage, string ClassName, string Severity, string EType){
         Error_Log__c newErrorRecord = new Error_Log__c();
         newErrorRecord.trace__c = exceptionMessage;
         newErrorRecord.class_name__c = ClassName;
         newErrorRecord.severity__c = Severity;
         newErrorRecord.Exception_Type__c = EType;
         database.insert(newErrorRecord,false);
     }
     //TEST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    static testMethod void ErrorLogUtility() {
    ErrorLogUtility controller = new ErrorLogUtility();
        //TEsting to ensure I can write to the Error Log Object
        createErrorRecord('exception','TestClass','Critical','List');
        //No System.Assert required. Test will fail if DML error.
    }
     
     
}