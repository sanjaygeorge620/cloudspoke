@isTest(seeAlldata=true)
private class ProcessCaseNewEmail_Test {
    static testmethod void m1(){
        Account acc = Data_Account.createAccount();
        Contact con = data_Contact.createContacts(acc.id,1)[0];
        //RecordType rec = [Select id, name from recordtype where sobjecttYpe='Case' and name='AM Support'];
        Case c = data_case.createCase(acc,con,'AM Support',1)[0];       
        
        Task obj = new Task();
        obj.whatId = c.Id;
        obj.subject='hi';
        obj.status='Not Started';
        obj.Activity_Subject__c= 'Auto Processed - null';
        insert obj;
         
        EmailMessage em = new EmailMessage();
        em.ToAddress='c@k.com';
        em.Subject='Hi';
        em.TextBody='HI body';
        em.ParentId = c.Id;
        em.activityId = obj.Id;
        em.Incoming = true;
        em.CcAddress='k@c.com';
        insert em;
        
        List<EmailMessage> lstEmails = new List<EmailMessage>{em};
        ProcessCaseNewEmail.CaseNewEmail(lstEmails);
    } 
    
     static testmethod void m2(){
        Account acc = Data_Account.createAccount();
        Contact con = data_Contact.createContacts(acc.id,1)[0];
        //RecordType rec = [Select id, name from recordtype where sobjecttYpe='Case' and name='AM Support'];
        Case c = data_case.createCase(acc,con,'AM Support',1)[0];       
        
        Task obj = new Task();
        obj.whatId = c.Id;
        obj.subject='hi';
        obj.status='Not Started';
        obj.Activity_Subject__c= 'Auto Processed - null';
        insert obj;
         
        EmailMessage em = new EmailMessage();
        em.ToAddress='c@k.com';
        em.Subject='Hi';
        em.htmlbody='<b>Testing<b>';
        em.ParentId = c.Id;
        em.activityId = obj.Id;
        em.Incoming = true;
        em.CcAddress='k@c.com';
        insert em;
        
        List<EmailMessage> lstEmails = new List<EmailMessage>{em};
        ProcessCaseNewEmail.CaseNewEmail(lstEmails);
    } 
}