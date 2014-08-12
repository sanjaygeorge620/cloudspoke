trigger UpdateTaskOnNewAttachment on Attachment (after insert) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 08-Aug-13] : Added Bypass code
    try{
            system.debug('#### attachment trigger - size of triiger.new '+ trigger.new.size());
            map<ID, list<Attachment>> emailattachments = new map<ID, list<Attachment>>{};
            list<attachment> emptylist = new attachment[0];                  // empty list
            String attachName = '';
            
         // loop through all the attachments and build a map that contains an entry for each parentID 
         // with a list of all its attachments
            for(Attachment a : trigger.new){
           
                if(!emailattachments.containsKey(a.parentid)){               // if parentID not in the map yet add an entry for it.
                    emailattachments.put(a.parentid, emptylist);        
                }
                list<Attachment> et = emailattachments.get(a.parentid);      // get the list of attachments for that parentID
                et.add(a);                                                   // add this attachment to the list
                emailattachments.put(a.parentid, et);                        // update the list for this parentID
        
                if (attachName == Null){
                 attachName = a.Name;
                }
                else{
                    attachName = attachname + ',' + a.Name;
                }
                
            }
            
                system.debug('#### map parentID/attachments '+ emailattachments);
                
                // now loop through the map. For each map entry retrieve the email using parentID
                // (process only if email found, this is how we know that the attachments belong to an email)
                // then for each email retrieve the related task using email.activityID
                        // inner loop for attachments
                        
                        
                // 12-28(jd)
                //  for each entry in et - get email associated
                //  for each email - get activity ID
                //  get task associated with activty id
                //  update task with data.
                            
                List<EmailMessage> emailList = new List<EmailMessage> ([Select id, activityID, ToAddress, CCAddress, BccAddress, Subject, textBody, htmlbody from EmailMessage where ID in :emailattachments.Keyset()]);
                        
                for (emailMessage emailRec : emailList) {
                    system.debug('emailID: ' + EmailRec.id);
                    system.debug('activityID: ' + EmailRec.activityID);
                    Map<ID, Task> idToTaskMap = new Map<ID, Task>([select id, Description from Task where id = :emailRec.ActivityID]);
                    
                    system.debug('Size of Map' + idToTaskMap.size());   //what is the size of the map
            
                    Task taskObject = idToTaskMap.get(emailRec.activityID);         //put map into taskObject Variable(TaskObject is the shell of the Task)
                    system.debug('did I retrieve anything:' + taskObject);
                      
                    if (taskObject != Null){
                       // if (TaskObject.Description == Null && EmailRec.Incoming == True){           //only process if no description, incoming email
                        
                            //get attachments if any
                        
                            //add info to task object   
                            taskObject.Description = 'Additional To: ' + emailrec.ToAddress;
                            system.debug('toAddress:' + emailRec.ToAddress);
                            taskObject.Description = taskObject.Description + '\n'+ 'CC: ' ;                //show BCC label even if nothing there.
                                if (emailRec.CcAddress != Null){
                                    taskObject.Description = taskObject.Description + emailrec.CCAddress ;
                            }
                  //          taskObject.Description = taskObject.Description + '\n'+ 'BCC: ' ;           //show BCC label even if nothing there.
                  ///          if (emailrec.BccAddress != Null){
                  //              taskObject.Description = taskObject.Description+ emailrec.BCCAddress ; 
                  //          }
                            
                            system.debug('attachment names: ' + attachName);
                            taskObject.Description = taskObject.Description + '\n'+ 'Attachments: ' + attachName ; 
                        
                            taskObject.Description = taskObject.Description+ '\n' + '\n'+ 'Subject: ' + emailRec.Subject; 
                            //system.debug('textbody' + emailRec.textbody);
                            taskObject.Activity_Subject__c= 'Auto Processed';
                             string taskDescription;
                                if (emailRec.textbody != Null) {
                                taskDescription = taskObject.Description+ '\n'+ 'Body: ' + emailRec.textbody;
                                }
                                else{
                                    Map<ID, EmailMessage> EmailMessageMap = new Map<ID, EmailMessage>([select id, textBody from EmailMessage where id = :emailRec.id]);
                                    EmailMessage EmailObject = EmailMessageMap.get(emailRec.ID); 
                          //          system.debug('email object');
        
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
                                        
                            //            system.debug('result' + result);
                                  
                                    taskDescription = taskObject.Description+ '\n'+ 'Body: ' + result; 
        
                                } 
                            if (taskDescription.Length() > 32000) {
                                taskObject.Description = taskDescription.substring(0,32000);
                            }
                            else{
                                taskObject.Description = taskDescription;
                            }
                            update TaskObject;
                    
                      //  }
                    }
                }
          }
          catch(Exception e){ 

            //continue processing
          } 
        

}