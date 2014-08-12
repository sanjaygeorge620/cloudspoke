public class LX_SAPSalesOrgTriggerUtil{

    public static void SentEmail(integer flag, LX_SAP_Record_Sales_Org__c sapRecord, Case caseObj, string[] toAddresses, string creatorFirstname){
    
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              mail.setToAddresses(toAddresses);
              mail.setReplyTo('support@lexmark.com');
              mail.setSenderDisplayName('Lexmark Support');
       if(flag==1){
             mail.setSubject('New Bill To Case');     
             mail.setHtmlBody('Hi '+creatorFirstname+',<br/><br/>This is an automated message to inform you that your new Bill To case,'+'<a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseObj.id+'</a>'+' has been created. <br/>Description:<br/>Bill To Request - Sales Org: '+sapRecord.LX_Sales_Org1__c+'<br/>Bill To Sales Org: '+sapRecord.LX_Bill_To_Sales_Org__r.Name+'<br/>Sold To to Link To: '+sapRecord.LX_Sold_To__c+'<br/>Bill To Number: '+sapRecord.Name+'<br/>Bill To Link: <a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+sapRecord.id+'</a><br/><br/>Street/House No.: '+sapRecord.LX_Physical_Street_Address__c+'<br/>Street 2: '+sapRecord.LX_Physical_Street_Address_2__c+'<br/>City: '+sapRecord.LX_Physical_City__c+'<br/>Postal Code: '+sapRecord.LX_Physical_Postal_Code__c+'<br/>Region/State: '+sapRecord.LX_Physical_State__c+'/'+sapRecord.LX_Physical_Province__c+'<br/>Country: '+sapRecord.LX_Physical_Country__c+'<br/><br/>Regards,<br/>Lexmark Support');  
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
       else if(flag==2){
            mail.setSubject('Bill To Modification Request');     
            mail.setHtmlBody('Hi '+creatorFirstname+',<br/><br/>This is an automated message to inform you that your new Bill To case,'+'<a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseObj.id+'</a>'+' has been created. <br/>Description:<br/>Bill To Request - Sales Org: '+sapRecord.LX_Sales_Org1__c+'<br/>Bill To Sales Org: '+sapRecord.LX_Bill_To_Sales_Org__r.Name+'<br/>Sold To to Link To: '+sapRecord.LX_Sold_To__c+'<br/>Bill To Number: '+sapRecord.Name+'<br/>Bill To Link: <a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+sapRecord.id+'</a><br/><br/>Please refer to the field history tracking related list on the Bill To Record to view the recent changes.<br/><br/>Regards,<br/>Lexmark Support');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
       else if (flag==3){
            mail.setSubject('New Ship To Case'); 
            mail.setHtmlBody('Hi '+creatorFirstname+',<br/><br/>This is an automated message to inform you that your new Ship To case,'+'<a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseObj.id+'</a>'+' has been created. <br/>Description:<br/>Ship To Request - <br/><br/>Sold To to Link To: '+sapRecord.LX_Sold_To__c+'<br/><br/>Bill To Sales Org: '+sapRecord.LX_Bill_To_Sales_Org__r.Name+'<br/>Ship To Number: '+sapRecord.Name+'<br/>Ship To Link: <a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+sapRecord.id+'</a><br/><br/>Street/House No.: '+sapRecord.LX_Physical_Street_Address__c+'<br/>Street 2: '+sapRecord.LX_Physical_Street_Address_2__c+'<br/>City: '+sapRecord.LX_Physical_City__c+'<br/>Postal Code: '+sapRecord.LX_Physical_Postal_Code__c+'<br/>Region/State: '+sapRecord.LX_Physical_State__c+'/'+sapRecord.LX_Physical_Province__c+'<br/>Country:  '+sapRecord.LX_Physical_Country__c+'<br/><br/>Regards,<br/>Lexmark Support');  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
       else if (flag==4){
            mail.setSubject('Ship To Modification Request');     
            mail.setHtmlBody('Hi '+creatorFirstname+',<br/><br/>This is an automated message to inform you that your new Ship To case,'+'<a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+caseObj.id+'</a>'+' has been created. <br/>Description:<br/>Ship To Request - <br/><br/>Sold To to Link To: '+sapRecord.LX_Sold_To__c+'<br/>Bill To Sales Org: '+sapRecord.LX_Bill_To_Sales_Org__r.Name+'<br/>Ship To Number: '+sapRecord.Name+'<br/>Ship To Link: <a>'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+sapRecord.id+'</a><br/><br/>Please refer to the field history tracking related list on the Ship To Record to view the recent changes.<br/><br/>Regards,<br/>Lexmark Support');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
    
    
    }



}