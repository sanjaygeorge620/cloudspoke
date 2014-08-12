/* Class Name   : LX_CreditAppLead_Utility
    * Description : This class is used to submit Lead for approval using JS for New Convert button on Lead.
    * Created By   : Sneha Kashyap
    * Created Date : 26-06-2014
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sneha Kashyap            26-06-2014               1000                Initial Version 
    * Sanjay George            30-06-2014               1001                Added classes for mailing Credit App    
    */


global class LX_CreditAppLead_Utility{

private static OrgWideEmailAddress OWD = [SELECT id,Address,DisplayName FROM OrgWideEmailAddress where displayName='Salesforce' limit 1];
private static Set<String> SetTempalteName = new Set<String>{'CreditApp_Generated_Doc','CreditApp_Request_for_information'};

WebService static void SendRecordApprovalRequest(Id recId) {
    
    /*  Description : It accepts a record Id and submits approval process for it.
    *  Param - recId: String  
    *  Returns :  VOID
    */

    // create the new approval request to submit
    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
    req.setComments('Submitted for approval. Please approve.');
    
    req.setObjectId(recId);
    // submit the approval request for processing
    Approval.ProcessResult result = Approval.process(req);

    }
    /*
    Function -SendCreditApp
    
    Mails Credit app to the users based on Geo.
    
    
    */
    WebService Static void SendCreditApp(id CaseID, id CurrentUSerID){
        List<EmailTemplate> templatesList;  
        String Geo = 'None';
            
        User ur;
        Case cs;
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<String> EmailAddressList = new List<String>();
        
        try {
            templatesList = [select id, name from EmailTemplate where developername in :SetTempalteName order by Name ];
            ur = [Select email,LX_Geo__c,Legacy_Company__c , id from User where id=:CurrentUSerID];
            cs = [Select type,accountID,contactid,LX_Sales_Organization_Number__c,contact.email, id from case where id =:CaseID ];
            Account Acc = [Select id, LX_Geo__c from account where id = :cs.AccountID limit 1];
            /*if(u.LX_Geo__c =='North America'&&cs.LX_Sales_Organization_Number__c!=null&&cs.LX_Sales_Organization_Number__c!=''){
                Geo = cs.LX_Sales_Organization_Number__c;
            }*/
            if(acc.LX_Geo__c =='North America'){
                if(ur.Legacy_Company__c == 'Lexmark')
                Geo = '5050';
                else 
                Geo='5097';
            }
            //else if(u.LX_Geo__c !='North America'){
            else if(acc.LX_Geo__c !='North America'){
                 Geo = acc.LX_Geo__c;
            }
        }
        catch (Exception e) {
                system.debug(e.getmessage());
                LX_CommonUtilities.createExceptionLog(e);
    }
        
        // Sending Email to the User for getting more Case Information
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //email.setToAddresses(new string[]{ur.email});
        email.setTargetObjectId(ur.id);
        //email.setWhatId(cs.id);
        email.setorgWideEmailAddressId(OWD.id);
        email.setTemplateId(templatesList[1].id);
        email.setSaveAsActivity(false);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
        emailList.add(email);
        
        // Sending email to the Geo ISS
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        
        
            EmailAddressList =getEmailFromID(Geo, false) ; 
        system.debug('EmailAddressList -->'+EmailAddressList );
        PageReference creditapp= Page.LX_creditApp;
        creditapp.getParameters().put('id',cs.id);
         if (Test.IsRunningTest())
           {
                efa.setBody(Blob.valueOf('UNIT.TEST'));
           }
           else 
           {
                efa.setBody(creditapp.getContent());
           }
       // efa.setBody(creditapp.getContent());
       
        List<string> TargetID = getEmailFromID(Geo, true) ; 
        String Targetidvalue  = TargetID!=null&&TargetID.size()>0?TargetID[0]:cs.Contactid;

        efa.setFileName('Lexmark_Credit_Application.doc');
        
        email = new Messaging.SingleEmailMessage();
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        email.setToAddresses(EmailAddressList );
        email.setTargetObjectId(Targetidvalue);
        email.setWhatId(cs.id);
        email.setorgWideEmailAddressId(OWD.id);
        email.setTemplateId(templatesList[0].id);
        email.setSaveAsActivity(true);     
        emailList.add(email);
        
       
        
        
        try {
            insert attachCreditApp(cs.id);
            Messaging.sendEmail(emailList);
            return;
        }
        catch (EmailException e) {
               system.debug(e.getmessage());
               LX_CommonUtilities.createExceptionLog(e);
  
    
        }
        catch(Exception e){
            system.debug(e.getmessage());
            LX_CommonUtilities.createExceptionLog(e);
        }
    }
    
    /*
    Function - getEmailFromID
    
    To find the group members of the appropriate group..
    
    */
    
    private static  List<string> getEmailFromID(String Geo, boolean isID){
        List<string> EmailList = new List<String>();
        String GeoSearch = '%'+Geo+'%';
        GeoSearch = GeoSearch.replaceall(' ', '_');
        Set<id> SetUserid = new set<id>();
        List<GroupMember> lstGroupMembers = [Select id,UserOrgroupId, group.developerName from groupMember where Group.DeveloperName like 'LX_CreditApplication%' AND Group.DeveloperName like :GeoSearch  ]; 
        
        for(GroupMember GP: lstGroupMembers ){
            SetUserid.add(GP.UserOrgroupId);
        }
        for (User u: [Select id, email from User where id in: SetUserid ]){
            if(!isID)
                EmailList.add(u.Email);
            else
                EmailList.add(u.id);
        }
        if(isID){
        List<contact> ConList =[select id from contact where pse__Salesforce_User__c in:EmailList];
        EmailList= new List<String>();
        for(Contact c: ConList ){
            EmailList.add(c.id);
        }
        }
        return EmailList;
    }
    /*
    Function to create a Credit App Application 
    */
    WebService Static void createCreditApp(id CaseID, id CurrentUSerID ,id AccountID){
         // Attaching Credit application to the Case
         Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        
        PageReference creditapp= Page.LX_creditApp;
        creditapp.getParameters().put('id',CaseID);
        
        case cs = [select id,Account.Name, LX_Sales_Organization_Number__c from Case where id=:CaseID limit 1];
        User u = [select id ,name, email,Legacy_Company__c,LX_Geo__c from user where id=:CurrentUSerID limit 1];
        Account Acc = [Select id, LX_Geo__c from account where id = : AccountID limit 1];
        String Geo = 'None';
        /*if(u.LX_Geo__c =='North America'&&cs.LX_Sales_Organization_Number__c!=null&&cs.LX_Sales_Organization_Number__c!=''){
            Geo = cs.LX_Sales_Organization_Number__c;
        }*/
        if(acc.LX_Geo__c =='North America'){
            if(u.Legacy_Company__c == 'Lexmark')
            Geo = '5050';
            else 
            Geo='5097';
        }
        //else if(u.LX_Geo__c !='North America'){
        else if(acc.LX_Geo__c !='North America'){
             Geo = acc.LX_Geo__c;
        }
        Map<string,LX_CreditApp_geo__c> MapCreditApp = LX_CreditApp_geo__c.getall();
        
        Messaging.SingleEmailMessage mail = 
              new Messaging.SingleEmailMessage();
         if (Test.IsRunningTest())
       {
            efa.setBody(Blob.valueOf('UNIT.TEST'));
       }
       else
       {
            efa.setBody(creditapp.getContent());
       }
        //efa.setBody(creditapp.getContent());
        efa.setFileName('Lexmark_Credit_Application.doc');
      mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      
      mail.setToAddresses(new List<string>{u.Email});
    
      // Step 3: Set who the email is sent from
      mail.setReplyTo(OWD.Address );
      mail.setSenderDisplayName(OWD.DisplayName );
    
      

      // Step 4. Set email contents - you can use variables!
      mail.setSubject('Lexmark Credit Application');
      String body = 'Hi ' + U.Name + ', <br><br>';
      body += 'Attached is your Credit Application for,<b>'+cs.Account.Name+'</b>. To submit this to credit, email this application along with the following information to: '+MapCreditApp.get(Geo).Email__c+' <br><br>';
        body +='The team also requires the following information as well.   <br><ul>';
       body +='<li>Income Statement (prior 2 fiscal years ended, audited)</li>';
        body +='<li>Balance Sheet (prior 2 fiscal years ended, audited)</li>';
        body +='<li>Statement of Cash Flows (prior 2 fiscal years, audited)</li></ul><br>';

        
         body +=' Regards, <br> Lexmark Support';
     
      mail.setHtmlBody(body);
    
      // Step 5. Add your email to the master list

    
  
  // Step 6: Send all emails in the master list
 
        try{
            insert attachCreditApp(CaseID);
             Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        }
        catch(Exception e){
             system.debug(e.getmessage());
               LX_CommonUtilities.createExceptionLog(e);
        }
    }
    
    // Find if the current user a Global Data Admin
    webservice Static boolean GlobalDataAdmin(string userid, string profileid){
        List<Profile> ProfList  =[select id from Profile where name like 'System Admin%' OR name like 'Tech IS'];
        for(Profile P:ProfList){
            if(P.id==profileid){
                return true;
            }

        }
        
        List<GroupMember> GrpMemberList = [Select UserOrGroupId From GroupMember where GroupId in (Select Id from Group where type='Queue' and Name='Global Data Admin') and UserOrGroupId=:userid];
        if(GrpMemberList!=null&& GrpMemberList.size()>0){
            return true;
        }
        
        return false;
    }
    
    webservice Static boolean createaccess(){
        Boolean createAccess = Schema.SObjectType.LX_RMA__C.iscreateable();
        return createAccess;
    }
    
    /*
    Function to assign Lead to Global data admin
    */
    webservice static boolean ChangetoGDA(string leadid){
        List<group> GroupList = [Select Id from Group where type='Queue' and Name='Global Data Admin'];
        Lead ldstatus = [select id , ownerid from Lead where id=:leadid limit 1];
        if(GroupList!=null&&GroupList.size()>0&&ldstatus!=null && ldstatus.ownerid!=GroupList[0].id ){
            lead ld = new lead(id=leadid, ownerid =GroupList[0].id );
            update ld;
            return true;
        }
        return false;
    }
    /*
    Function to assign Lead to Global data admin
    */
    webservice static attachment attachCreditApp(string caseid){
      PageReference creditapp= Page.LX_creditApp;
        creditapp.getParameters().put('id',caseid);
        Attachment att=new Attachment();
       if (Test.IsRunningTest())
       {
            att.Body=Blob.valueOf('UNIT.TEST');
       }
       else
       {
            att.Body=creditapp.getContent();
       }
        //att.Body=creditapp.getContent();
        att.Name='Lexmark_Credit_Application' + System.now().format('yyyy_MM_dd') + '.doc';
        att.parentId=caseid;
        return att;
    }
}