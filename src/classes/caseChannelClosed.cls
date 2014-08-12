public with sharing class caseChannelClosed {
    public static void caseChannelClosed(Case caseRec, Contact ContactRec){
        URL_Parameter__c param = [select URL_Value__c from  URL_Parameter__c where name = 'Org Host' limit 1];
    //      String param = 'https://c.cs3.visual.force.com'
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           system.debug('caseRec' + caseRec);
           system.debug('ContactRec' + ContactRec);
           mail.setTargetObjectId(ContactRec.ID);             //use for production - sends email to Contact email address
           
           ///thread ID
           String OrgID = UserInfo.getOrganizationId();
            String caseID = CaseRec.ID;
            string threadID = generateThreadID.generateThreadID(orgID,caseID);
    
          
           mail.setReplyTo('support@perceptivesoftware.com');
           mail.setSenderDisplayName('support@perceptivesoftware.com');
           
           mail.setSenderDisplayName('Perceptive Software');                 // Specify the name used as the display name.   
           mail.setSubject('Case #' + caseRec.CaseNumber + ': ' + caseRec.Subject + ' has been closed');
           mail.setHtmlBody(
                'Hello ' + ContactRec.Name + '<p>' +
                '<br>' +
                'This is to notify you that Case #' + caseRec.CaseNumber +': ' + caseRec.Subject + ' has been closed.  If you have further questions that did not get resolved regarding this case, please contact the Case owner for this case. You can reference the case owner using the link below:<p>'+
                '<br>' +
                '<a href='+ param.URL_Value__c + '/apex/casedetails_channel?id='+caseRec.Id+'>Click here to access case </a><p>' +
     //             '<a href=https://c.cs3.visual.force.com'+ '/apex/casedetails?id= '+caseRec.Id+'>Details </a><p>' +
                '<br>' +
                'Thank you!' + 
                '<br>' +
                '[ref:' + threadID + ':ref]'
                );
           
           system.debug('mail.setHtmlBody' + mail);
           //Added by Charan on 20-09-2013 for overcoming MASS EMAIL error in times of Deployment
           if(!test.isrunningTest()){   
               List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
                                        
               //check email results    
               System.debug('Email result ' + results[0].IsSuccess());
           }

    }
        

}