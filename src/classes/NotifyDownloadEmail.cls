public with sharing class NotifyDownloadEmail 
{
    public static void NotifyDownloadEmail(List<ID> contactIdSet, Order__c OrderRec)
    {
       // EmailTemplate template = ([select Id from EmailTemplate where Name = 'SUPPORT: Notify Download Available' limit 1]);
        //URL_Parameter__c param = [select URL_Value__c from  URL_Parameter__c where name = 'Portal Host' limit 1];
        
        String prefix = '';
        
        if(URL_Parameter__c.getall().containskey('Portal Host'))
        {
        prefix = URL_Parameter__c.getall().get('Portal Host').URL_Value__c;
        }
        
        for (Integer i =0;i<contactIdset.size();i++)
        { 
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setTargetObjectId(contactIdSet[i]);             //use for production - sends email to Contact email address
        //   mail.setTargetObjectId('0037000000XOCC8');         //use this for testing - send to Jennifer Dauernheim Contact email address
           system.debug('sendtocontact: ' + contactIdset[i]);
 //          mail.setTemplateId(template.Id);
          
           mail.setReplyTo('license@perceptivesoftware.com');
           mail.setSenderDisplayName('license@perceptivesoftware.com');
           
           mail.setSenderDisplayName('Perceptive Software');                 // Specify the name used as the display name.   
           mail.setSubject('Product Order Confirmation');
           mail.setHtmlBody('Thank you for choosing Perceptive Software.  Your order has been completed and the license(s) for the product(s) you purchased can be found in the Account Profile area of the Perceptive Software Customer Portal.<p>'+
                '<br>' +
                '<a href='+ prefix + 'apex/orderdetails?id='+OrderRec.Id+'>Click here to view your recent order </a><p>' + 
                '<br>' +
                'Questions?<p>' +
                '<br>' +
                'Please contact Product Support should you need further assistance.<br>'+
                '<a href=tel: 800 941 7460>800 941 7460 </a> option 2 <br>' + 
                '<a href=support@perceptivesoftware.com> support@perceptivesoftware.com</a> <br>' + 
                '<a href=https://perceptivesoftware.secure.force.com/casewebsubmit> Web</a> <br>' + 
                '<br>' +
                'If your licenses are not currently on the portal, please check back within 24 hours before contacting customer support.<br>' +
                '<br>' +
                'Regards,<br>' +
                '<br>' +
                'Perceptive Software<br>'
                );
           
           system.debug('mail.setHtmlBody' + mail);
              
           List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          // List<Messaging.SendEmailResult> results ;    
                                    
           //check email results    
           System.debug('Email result ' + results[0].IsSuccess());
        }
    }
    
    public static void NotifyDownloadEmail(ID ContactID, List<ID> oppset)
    {
     String prefix = '';
        
        if(URL_Parameter__c.getall().containskey('Portal Host'))
        {
        prefix = URL_Parameter__c.getall().get('Portal Host').URL_Value__c;
        }
    
       // EmailTemplate template = ([select Id from EmailTemplate where Name = 'SUPPORT: Notify Download Available' limit 1]);
        //URL_Parameter__c param = [select URL_Value__c from  URL_Parameter__c where name = 'Portal Host' limit 1];//Commented by Charan as we can use  URL.getSalesforceBaseUrl().toExternalForm()
        for (Integer i =0;i<oppset.size();i++)
        {    
          
          
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setTargetObjectId(contactId);             //use for production - sends email to Contact email address
      //   mail.setTargetObjectId('0037000000XOCC8');         //use this for testing - send to Jennifer Dauernheim Contact email address
        //   system.debug('sendtocontact: ' + contactIdset[i]);
 //          mail.setTemplateId(template.Id);
          
           mail.setReplyTo('license@perceptivesoftware.com');
           mail.setSenderDisplayName('license@perceptivesoftware.com');
           
           mail.setSenderDisplayName('Perceptive Software');                 // Specify the name used as the display name.   
           mail.setSubject('Product Order Confirmation');
           mail.setHtmlBody('Thank you for choosing Perceptive Software.  Your order has been completed and the license(s) for the product(s) you purchased can be found in the Account Profile area of the Perceptive Software Customer Portal.<p>'+
                '<br>' +
                //'<a href='+ param.URL_Value__c + '/apex/orderdetails?id='+oppset[i]+'>Click here to view your recent order </a><p>' +
                //Commented by Charan
                '<a href='+ prefix + 'apex/orderdetails?id='+oppset[i]+'>Click here to view your recent order </a><p>' + 
                '<br>' +
                'Questions?<p>' +
                '<br>' +
                'Please contact Product Support should you need further assistance.<br>'+
                '<a href=tel: 800 941 7460>800 941 7460 </a> option 2 <br>' + 
                '<a href=support@perceptivesoftware.com> support@perceptivesoftware.com</a> <br>' + 
                '<a href=https://perceptivesoftware.secure.force.com/casewebsubmit> Web</a> <br>' + 
                '<br>' +
                'If your licenses are not currently on the portal, please check back within 24 hours before contacting customer support.<br>' +
                '<br>' +
                'Regards,<br>' +
                '<br>' +
                'Perceptive Software<br>'
                );
           
           system.debug('mail.setHtmlBody' + mail);
              
           List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   //  List<Messaging.SendEmailResult> results ;
                                    
           //check email results    
           System.debug('Email result ' + results[0].IsSuccess());
        }
    }
    

}