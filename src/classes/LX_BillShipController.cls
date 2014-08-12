/*
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 07/02/2013
 *
 * Author : Sumedha K.
 * 
 * Description : This class will contain methods that will be called from Account triggers 
 * 
 * 06/12/2013 : Sumedha - Created
 * 
 */

public class LX_BillShipController{

  private string oppId = ApexPages.currentPage().getParameters().get('oppId');
  private string typeofRecord = ApexPages.currentPage().getParameters().get('type');
  public Boolean sellSection{get;set;}
  public Boolean billSection{get;set;}
  public Opportunity opp{get;set;}
  
 public LX_BillShipController(){
        opp = new Opportunity();
    
       if(typeofRecord == 'SELL'){
            sellSection = TRUE;
            billSection = FALSE;
         }else if(typeofRecord == 'BILL'){
           billSection = TRUE;
           sellSection = FALSE;
         }
 }
 
 public Pagereference createCase(){
   Case c=new Case();
   c.contactId = opp.Bill_To__c;
   c.AccountId = opp.AccountID;
   // temporarily storing whether the record is bill to or ship to on a field in case for reference
   c.Business_Card__c = typeofRecord;
   try{
    insert c;
   }catch(Exception ex){System.debug('Could not create case'+ex.getMessage());}
     
   String creatorEmail=UserInfo.getUserEmail();
   String creatorFirstname=UserInfo.getFirstName();
   String[] toAddresses = new String[] {creatorEmail}; 
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setToAddresses(toAddresses);
          mail.setReplyTo('skucherlapat@lexmark.com');
          mail.setSenderDisplayName('Lexmark Support');   
          mail.setSubject('New Bill To Case');     
     mail.setHtmlBody('Hi '+creatorFirstname+',<br/><br/>This is an automated message to inform you that your new Bill To case has been created. Your request is under process.');  
     
     //Added by Charan on 20-09-2013 for overcoming MASS EMAIL error in times of Deployment
            if(test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
   return null;
 }
}