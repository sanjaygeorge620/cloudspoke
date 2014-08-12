Global class timecardWbsSync implements Database.Batchable<sObject>
{
Global final String Query;
   Global timecardWbsSync(String S,String T)
   {
   
   }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    return Database.getQueryLocator(Query);        
    }
    
    global void execute(Database.BatchableContext BC,  List<sObject> recordList)
    {
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }
    
    

}