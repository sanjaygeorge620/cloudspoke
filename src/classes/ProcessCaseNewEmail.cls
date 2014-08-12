public class ProcessCaseNewEmail {

    

    public static void CaseNewEmail(List<EmailMessage> newEmails) 
    {

  System.debug('=======================================CaseNewEmail====================================================================');
 
     Set<ID> ActivityidSet = new Set<ID>();      //new set for activity ids
        //for each new email message - get the activity id(the task ID)
        for (EmailMessage emailRec : newEmails){                  //set to hold email record activity ids.
            ActivityidSet.add(emailRec.Activityid);
     //       system.debug('emailRec.activityID:' + emailRec.activityID);
        }
        
        //use the activity ID to create a map of the Task ID, task Description
        Map<ID, Task> idToTaskMap = new Map<ID, Task>([select id, Description,Subject, Activity_Subject__c from Task where id in :ActivityidSet]);
                
     //   system.debug('Size of Map' + idToTaskMap.size());   //what is the size of the map
        
        //process email message  
        
        for(EmailMessage emailRec : newEmails)
        { 
           system.debug('checking if has attachment'); 
            if (emailRec.HasAttachment != True) 
            {                            //only process if email does not have attachments
            
                Task taskObject = idToTaskMap.get(emailRec.activityID);         //put map into taskObject Variable(TaskObject is the shell of the Task)
                system.debug('did I retrieve anything:' + taskObject);
                  
                if (taskObject != Null)
                {
                    if (TaskObject.Description == Null && EmailRec.Incoming == True || TaskObject.Subject == 'Auto Processed - null')
                    {           //only process if no description, incoming email
                    
                    System.debug('Inside taskObject!=null ');
                        //get attachments if any
                    
                        //add info to task object   

                        taskObject.Description = 'Additional To: ' + emailrec.ToAddress;
                   //     system.debug('toAddress:' + emailRec.ToAddress);
                        taskObject.Description = taskObject.Description + '\n'+ 'CC: ' ;                //show BCC label even if nothing there.
                        if (emailRec.CcAddress != Null){
                                taskObject.Description = taskObject.Description + emailrec.CCAddress ;
                        }
             //           taskObject.Description = taskObject.Description + '\n'+ 'BCC: ' ;           //show BCC label even if nothing there.
             //           if (emailrec.BccAddress != Null){
             //                taskObject.Description = taskObject.Description+ emailrec.BCCAddress ; 
             //           }
    
                        taskObject.Description = taskObject.Description+ '\n' + '\n'+ 'Subject: ' + emailRec.Subject; 
                        //system.debug('textbody' + emailRec.textbody);
                        taskObject.Activity_Subject__c= 'Auto Processed';
                        
                        string emailRecBody = emailRec.textbody;
                        string taskDescription;
                     System.debug('==================taskObject='+taskObject);   
                        if (emailRecBody != Null) 
                        {

                            taskDescription = taskObject.Description+ '\n'+ 'Body: ' + emailRec.textbody;
                        }
                        else{
                            Map<ID, EmailMessage> EmailMessageMap = new Map<ID, EmailMessage>([select id, textBody from EmailMessage where id = :emailRec.id]);
                            EmailMessage EmailObject = EmailMessageMap.get(emailRec.ID); 
                        //    system.debug('email object');

                                string html = emailRec.htmlbody;
                                 //first replace all <BR> tags with \n to support new lines
                                string result = html.replaceAll('<br/>', '\n');
                                result = result.replaceAll('<br />', '\n');
                                
                                //regular expression to match all HTML/XML tags
                                string HTML_TAG_PATTERN = '<.*?>';
                                
                                // compile the pattern     
                                pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
                                
                                // get your matcher instance
                                matcher myMatcher = myPattern.matcher(result);
                                
                                //remove the tags     
                                result = myMatcher.replaceAll('');
                                
                        //        system.debug('result' + result);

                             taskDescription = taskObject.Description+ '\n'+ 'Body: ' + result; 
                        } 
                            if (taskDescription.Length() > 32000) 
                            {
                                taskObject.Description = taskDescription.substring(0,32000);
                            }
                            else
                            {
                                taskObject.Description = taskDescription;
                            }
                        update TaskObject;
            
                    }
                }
            }
        }    
    }
}