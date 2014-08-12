global class LX_BatchContactBirthday implements Database.Batchable<sObject>{

  /* Class Name   : LX_BatchContactBirthday
    * Description   : This is a class written to send Birthday reminders to Sales Rep. This will send a mail if any Contact's Birthday
                      falls within next 10 days from current date. 
    * Created By   : Madhu
    * Created Date : 22-07-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Madhu                 22-07-2013               1000                  Initial Version    
    */

  global Date varDate=date.today();
  global Date datVar=varDate.addDays(10);
  global String todayDate=String.valueOf(datVar.day())+String.valueOf(datVar.month()) ;
  String myDate=' ';
  String lastDate=' ';
  global String query= 'Select Id,Birthdate,LX_Birthday__c,Owner.Email,Owner.Name,Name,LX_Last_Activity_Date__c from Contact where LX_Birthday__c=\''+todayDate+'\'';
  global String[] toAddresses = new String[]{}; 
  global Database.querylocator start(Database.BatchableContext BC){
            return Database.getQueryLocator(query);}

   global void execute(Database.BatchableContext BC, List<Contact> scope){
   /*  Description : It accepts collection of Contact records and send mail to its Rep.
    *  Param - scope: Collection of Contact records 
    *  Returns :  VOID
    */   
   
   
     for(Contact s : scope){  
     if(s.Birthdate!=null){
     myDate =  String.valueOf(s.Birthdate.month())+'/'+String.valueOf(s.Birthdate.day())+'/'+String.valueOf(s.Birthdate.year());
     }
     if(s.LX_Last_Activity_Date__c!=null){
     lastDate =String.valueOf(s.LX_Last_Activity_Date__c.month())+'/'+String.valueOf(s.LX_Last_Activity_Date__c.day())+'/'+String.valueOf(s.LX_Last_Activity_Date__c.year())+' '+String.valueOf(s.LX_Last_Activity_Date__c.hour())+':'+String.valueOf(s.LX_Last_Activity_Date__c.minute());
     }
     String[] toAddresses = new String[] {s.Owner.Email}; 
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     mail.setToAddresses(toAddresses);
     mail.setReplyTo('support@lexmark.com');
     mail.setSenderDisplayName('Lexmark Support');
     mail.setSubject('Birthday Reminder');
     if(s.LX_Last_Activity_Date__c!=null){
     mail.setHtmlBody('Hi '+s.Owner.Name+',<br/><br/>This is an automated message to inform you that '+s.Name+' birthday is in 10 days ['+myDate+']. '+lastDate+' was the last time an activity was logged for '+s.Name+'.<br/><br/>Regards,<br/>Lexmark Support');
     }
     else{
     mail.setHtmlBody('Hi '+s.Owner.Name+',<br/><br/>This is an automated message to inform you that '+s.Name+' birthday is in 10 days ['+myDate+']. No activity is logged for '+s.Name+'.<br/><br/>Regards,<br/>Lexmark Support');
     }
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }  
 }
 global void finish(Database.BatchableContext BC){
   /*  Description : Finish method
    *  Param - No Inputs
    *  Returns :  VOID
    */
 
 }
}