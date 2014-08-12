@isTest(seealldata = true)
public class Test_TrainingPDFcontroller{
    
    /*static Class__c testClass {get;set;}
    static Account acc {get;set;}
    static ELearning_Registration__c reg {get;set;}
    static Training_Attendee__c ta {get;set;}*/
    static List<Training_Attendee__c> tas {get;set;}
    public static testMethod void testPDFcontroller(){
        
        init();        
        
        //perform test logic
        test.startTest();
        
        TrainingPDFcontroller controller = new TrainingPDFcontroller(new ApexPages.StandardSetController(tas));
         
        controller.queryPageData();
             
        test.stopTest();
        
    }
    
    static void init(){
        //create test data
        /*testClass = Data_Class.createClass();
        
        acc = data_Account.createAccount4();
            
        reg = new ELearning_Registration__c();
        insert reg;*/
        
        tas = [SELECT Id, Name 
               FROM Training_Attendee__c
               LIMIT 1];
        
     }
}