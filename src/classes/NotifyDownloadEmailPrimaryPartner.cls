public with sharing class NotifyDownloadEmailPrimaryPartner 
{
    public static void NotifyDownloadEmail(ID ContactID, List<ID> oppset)
    {
        String prefix = '';
        
        String PartnerLogin = URL_Parameter__c.getall().get('PartnerPortal Login').URL_Value__c;
        
        List<Order__c> ordLst = [Select ID,Opportunity_Account_Name__c from Order__c where id in: oppset];
        
        if(URL_Parameter__c.getall().containskey('Portal Host'))
        {
        prefix = URL_Parameter__c.getall().get('Portal Host').URL_Value__c;
        }
    
       // EmailTemplate template = ([select Id from EmailTemplate where Name = 'SUPPORT: Notify Download Available' limit 1]);
       // URL_Parameter__c param = [select URL_Value__c from  URL_Parameter__c where name = 'Portal Host' limit 1];//Commented by Charan as we can use  URL.getSalesforceBaseUrl().toExternalForm()
        for (Integer i =0;i<ordLst.size();i++)
        {    
          
          
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setTargetObjectId(contactId);                               //use for production - sends email to Contact email address
           mail.setReplyTo('license@perceptivesoftware.com');
           mail.setSenderDisplayName('license@perceptivesoftware.com');           
           mail.setSenderDisplayName('Perceptive Software');                 // Specify the name used as the display name.   
           mail.setSubject('Product Order Confirmation');
           mail.setHtmlBody('Thank you for choosing Perceptive Software.  Your order for ' +ordLst[i].Opportunity_Account_Name__c+ ' has been completed and the license(s) for the product(s) you purchased can be found in the Account Profile area of the Perceptive Software Partner Portal.<p>'+
                '<br>' +
                '<a href='+PartnerLogin+'>Click here for partner portal</a><p>' + 
                '<br>' +
                'After logging into the Partner Portal, click the View Channel Partner Portal button to view the Account Profile area. ' +
                '<br>' +
                'Questions?<p>' +
                '<br>' +
                'Please contact Product Support should you need further assistance.<br>'+
                '<a href=tel: 800 941 7460>800 941 7460 </a> option 2 <br>' + 
                '<a href=support@perceptivesoftware.com> support@perceptivesoftware.com</a> <br>' + 
                '<a href=https://perceptivesoftware.secure.force.com/casewebsubmit> Web</a> <br>' + 
                '<br>' +
                'if you do not have a Partner Portal Login you will recieve a notification of that access in the next five business days.<br>' +
                '<br>' +
                'Regards,<br>' +
                '<br>' +
                'Perceptive Software<br>'
                );
           
            system.debug('mail.setHtmlBody' + mail);
              
           List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                    
           //check email results    
           System.debug('Email result ' + results[0].IsSuccess());
        }
    }

}