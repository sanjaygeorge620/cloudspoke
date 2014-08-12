global class deleteArchived implements Database.Batchable<Sobject>  
{  
global final String Query;  
global deleteArchived(String q)  
{  
Query=q;  
}  
  
global Database.QueryLocator start(Database.BatchableContext BC)  
{  
return Database.getQueryLocator(query);  
}  
  
global void execute(Database.BatchableContext BC, List<SObject> scope)
{  
List<Published_Price_Book__c> pbklst= new list<Published_Price_Book__c>();  
for (SObject s : scope)  //for all objects from our query      
{  
Published_Price_Book__c a = (Published_Price_Book__c)s;
pbklst.add(a);  
}  
Delete pbklst;  
}  
  
global void finish(Database.BatchableContext BC)  
{  
//Send an email to the User after your batch completes  
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
String[] toAddresses = new String[] {'praveen.sadineni@perceptivesoftware.com '};  
mail.setToAddresses(toAddresses);  
mail.setSubject('Apex Batch Job is done');  
mail.setPlainTextBody('The batch Apex job processed ');  
//Added by Charan on 20-09-2013 for overcoming MASS EMAIL error in times of Deployment 
if(!test.isRunningTest()){
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
}
} 

static testmethod void test()
{
Test.startTest();
{
Id batchId = database.executeBatch(new deleteArchived('Select ID from Published_Price_Book__c where Status__c = \'Archived\' limit 100'), 200);
}
Test.stopTest();
}




 
}