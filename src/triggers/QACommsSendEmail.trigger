/*
October 2010
Sending out emails to QA Stakeholders
Bulkified for mass QA Updates
*/

trigger QACommsSendEmail on QA_Communication__c (after insert, after update) {
    
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    string MyAccount =''; /*Case Account Field*/
    string MyContact =''; /*Case Contact Field*/
    Set<Id> itemIds = new Set<Id>(); /*Set to put Trigger.new records*/
    
    list<String> ccAddresses = new list<String>(); /*List of 'cc' Email Addresses*/
    String strBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
    //Add  Records to a Set
    for( QA_Communication__c o : trigger.new)
       {itemIds.add(o.case__c);}
    
    //Grabbing Other Related QA Fields because I am getting related fields - LastModifiedBy.name and trigger.new only has local object fields 
    Map<id, QA_Communication__c> Comms = new Map<id,  QA_Communication__c>([Select id, Name, Description__c, LastModifiedDate, LastModifiedBy.name from  QA_Communication__c Where Id in:trigger.new]);  
    
    //Build the 'To' Email Addresses from the Cases
    List<Case> caseList = new List<Case>([Select 
                                       c.Account.name,
                                       c.Contact.name,
                                       c.subject,
                                       c.createdDate,
                                       c.casenumber,
                                       c.Secondary_Case_Owner__r.Email, 
                                       c.Leadership_Case_Owner__r.Email, 
                                       c.Owner.Email,
                                       c.RD_StakeHolder_1__r.Email,
                                       c.RD_StakeHolder_2__r.Email,
                                       c.RD_StakeHolder_3__r.Email,
                                       c.RD_StakeHolder_4__r.Email,
                                       c.RD_StakeHolder_5__r.Email
                                  From Case c
                                  where id In : itemIds ]);
    
    //Get the 'CC' Email Addresses from the Config Values
    for(Perceptive_Config_Value__c ConfigRecords : [Select p.Value__c 
                                            From Perceptive_Config_Value__c p 
                                            where p.Perceptive_Config_Option__r.Perceptive_Config_Group__r.key__c = 'Case_Settings' and
                                            p.Perceptive_Config_Option__r.Name = 'QACommunication_Stakeholders'
                                            ])
      {
        ccAddresses.Add(ConfigRecords.Value__c);
      } 
     
    //Send out the Email 
    for(QA_Communication__c qa : trigger.new)
    {
           /*List of 'to' Email Addresses*/ 
           list<String> toAddresses = new list<String>(); 
           for(Case c : caseList)
           {
                   if(c.id == qa.case__c)
                   {
                       
                        if (c.Account.name!=null && c.Account.name!=''){MyAccount= c.Account.name;}
                        if (c.Contact.Name!=null && c.Contact.Name!=''){MyContact= c.Contact.Name;}
                        if (c.Owner.Email!=null && c.Owner.Email!=''){toAddresses.add(c.Owner.Email);}
                        if (c.Leadership_Case_Owner__r.Email!=null && c.Leadership_Case_Owner__r.Email!=''){toAddresses.add(c.Leadership_Case_Owner__r.Email);}
                        if (c.Secondary_Case_Owner__r.Email!=null && c.Secondary_Case_Owner__r.Email!=''){toAddresses.add(c.Secondary_Case_Owner__r.Email);}
                        if (c.RD_StakeHolder_1__r.Email!=null && c.RD_StakeHolder_1__r.Email!=''){toAddresses.add(c.RD_StakeHolder_1__r.Email);}
                        if (c.RD_StakeHolder_2__r.Email!=null && c.RD_StakeHolder_2__r.Email!=''){toAddresses.add(c.RD_StakeHolder_2__r.Email);}
                        if (c.RD_StakeHolder_3__r.Email!=null && c.RD_StakeHolder_3__r.Email!=''){toAddresses.add(c.RD_StakeHolder_3__r.Email);}                                                
                        if (c.RD_StakeHolder_4__r.Email!=null && c.RD_StakeHolder_4__r.Email!=''){toAddresses.add(c.RD_StakeHolder_4__r.Email);}                                                
                        if (c.RD_StakeHolder_5__r.Email!=null && c.RD_StakeHolder_5__r.Email!=''){toAddresses.add(c.RD_StakeHolder_5__r.Email);}                                                
                        
                        //Email Builder
                        String EmailBody ='QA Communication Details';
                               EmailBody +='\n Title: '+qa.Name;
                               EmailBody +='\n Description: '+qa.Description__c;
                               EmailBody +='\n Comm Created by: '+Comms.get(qa.Id).LastModifiedBy.name;
                               EmailBody +='\n'; 
                               EmailBody +='\n Case Number: '+c.CaseNumber;
                               EmailBody +='\n Case Account: '+MyAccount;
                               EmailBody +='\n Case Contact: '+MyContact;
                               EmailBody +='\n Case Link: '+strBaseUrl+'/'+c.ID;
                               
                               //https://na5.salesforce.com/'+c.ID; 
                               //EmailBody +='\n Case Owner: '+c.Owner;
                               //EmailBody +='\n Comm Modified Date: '+Comms.get(qa.Id).LastModifiedDate.format();                               
                               //EmailBody +='\n Case Link: https://na5.salesforce.com/'+qa.ID;
                               //EmailBody +='Case Details';
                               //EmailBody +='\n Case Subject: '+c.subject; 
                               //EmailBody +='\n Case Created Date: '+c.CreatedDate.format();
                                            
                       try {
                           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setToAddresses(toAddresses);
                                mail.setCcAddresses(ccAddresses);
                                mail.setReplyTo('noreply@salesforce.com');
                                mail.setSenderDisplayName('CASE #'+c.CaseNumber +' QA Comm');
                                mail.setSubject('QA Communication: '+MyAccount+' | #'+c.CaseNumber+' | '+qa.Name);
                                mail.setBccSender(false);
                                mail.setUseSignature(false);
                                mail.setPlainTextBody(EmailBody);
                             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
                        }
                        catch(Exception e){
                            ErrorLogUtility.createErrorRecord(e.getMessage(),'QACommsSendEmail on QA_Communication__c ','Low','Email');
                        }
                        //Resetting Populated Variables
                            MyAccount = ''; 
                            MyContact = ''; 
                            system.debug('MytoAddresses: '+toAddresses); 
                            system.debug('MyccAddresses: '+ccAddresses);
                            //ccAddresses is the same for all emails
                   }
           }
    }
}