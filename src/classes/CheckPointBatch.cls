// CheckPointBatch ==> Checkpoint Services
 // Grabbing XML Feed from third party system (ISODX) and updating related servers
 // April 2014 
 // MFitzgerald

 Global class CheckPointBatch implements Database.batchable<integer>, Database.AllowsCallouts, Database.Stateful{
    private class cpException extends Exception {} 
    Global String ErrorLog;
    Global boolean sendEmail;
    Global set<String> ServersStatusSet;
    Global CheckPointBatch(){
        ServersStatusSet = new set<String>();
        ErrorLog = '';
        sendEmail = false;
    }  
    
    Global Iterable<integer> start(Database.BatchableContext BC) {
        try{
            
            //Make Callout to service to find Total Size and Pages
            CheckpointServices.Service s = CheckpointServices.doReturnServiceMetadata();
            if(s==null) throw new cpException('Error: Service returned null header values;');
            //Create the number of times we need to make callouts
            decimal pgs = math.ceil(double.valueof(s.totalResults)/double.valueof(s.itemsPerPage));
            list<integer> i = new list<integer>();
            for(Integer a = 0; a < pgs; a++){
              i.add(a);
            }
            system.debug(i);
    
            //Return iterable number
            return i;
        }catch(exception e) {
            ErrorLog += 'START: ' + e.getmessage() + ' ('+ e.getlinenumber() + ') \n';
            system.debug('ErrorLog: ' + ErrorLog);
            return new list<integer>();
        }
    }

    Global void execute(Database.BatchableContext info, List<integer> interator) {
         system.debug('++++++++++++++EXECUTE++++++++++++++');
         Try{
               system.debug('Current Iterator: ' + interator[0]);
    
            //Make Callout and grab all servers from the feed (PAGE IS PASSED IN BASED ON ITERATOR)
                list<CheckpointServices.Server> CheckPointServers = CheckpointServices.doReturnServers(interator[0]);
                
                //Query for all SFDC Releases
                Map<string, ProductRelease__c> Releasemap = new Map<string, ProductRelease__c>();
                for(ProductRelease__c r : [select id, Release__c from ProductRelease__c where Release__c!=null]){
                    Releasemap.put(r.Release__c,r);
                }        
                system.debug('Releasemap: ' + Releasemap);
                
                //Query for all SFDC Servers
                Map<string, Server__c> Servermap = new Map<string, Server__c>();
                for(server__c s : [select id, Account__r.Company_Number__c, Checkpoint_ID__c, Server_Name__c, Machine_Name__c, Description__c from server__c where Checkpoint_ID__c!=null]){
                    Servermap.put(s.Checkpoint_ID__c,s);
                }        
                system.debug('Servermap: ' + Servermap);
                
                if(CheckPointServers.size()>0){
                    //Loop through servers and find matches and add to list to update later
                        list<server__c> ServersFound = new list<server__c>();
                        for(CheckpointServices.Server c: CheckPointServers){
                            //Verify the Checkpoint/Server ID and Company Number Match
                            if(c.qid!='' && Servermap.containskey(c.qid) && Servermap.get(c.qid).Account__r.Company_Number__c == c.companynumber){
                                //Matched record
                                server__c s = [select id, name, Date_Verified_by_Checkpoint__c, Server_Name__c, Server_Type__c, Database__c, Database_Version__c, Platform__c, Platform_Version__c, Lgid__c, Release__c from Server__c where id =: Servermap.get(c.qid).id];
                                          string shortrelease = parseRelease(c.Release);
                                          string prettydbug = System.now().format() + '\n';
                                                 prettydbug += 'Organization: ' + c.Organization + '\n';
                                                 prettydbug += 'companynumber: ' + c.companynumber + '\n';
                                                 prettydbug += 'createddate: ' + c.createddate + '\n';
                                                 prettydbug += 'databasetype: ' + c.databasetype + '\n';
                                                 prettydbug += 'databasever: ' + c.databasever + '\n';
                                                 prettydbug += 'id: ' + c.id + '\n';
                                                 prettydbug += 'index: ' + c.index + '\n';
                                                 prettydbug += 'lgid: ' + c.lgid + '\n';
                                                 prettydbug += 'modifieddatetime: ' + c.modifieddatetime + '\n';
                                                 prettydbug += 'platform: ' + c.platform + '\n';
                                                 prettydbug += 'platformver: ' + c.platformver + '\n';
                                                 prettydbug += 'release: ' + c.release + '\n';
                                                 prettydbug += 'servername: ' + c.servername + '\n';
                                                 prettydbug += 'servertype: ' + c.servertype + '\n';
                                                 prettydbug += 'release: ' + c.release + '\n';
                                                 prettydbug += 'shortrelease: ' + shortrelease + '\n';

                                          //s.Checkpoint_Debug_Log__c = System.now().format() + '/n' +string.valueof(c).replace(',','\n');  
                                          s.Checkpoint_Debug_Log__c = prettydbug;
                                          s.Server_Name__c= nz(c.servername,s.Server_Name__c);  
                                          s.Server_Type__c= nz(c.servertype,s.Server_Type__c);
                                          s.Database__c = nz(c.databasetype,s.Database__c);
                                          s.Database_Version__c = nz(c.databasever,s.Database_Version__c);
                                          s.Platform__c = nz(c.platform,s.Platform__c);
                                          s.Platform_Version__c = nz(c.platformver,s.Platform_Version__c);
                                          s.Lgid__c = nz(c.lgid, s.Lgid__c); 
                                          if(shortrelease!=null && Releasemap.containskey(shortrelease))
                                              s.Release__c = Releasemap.get(shortrelease).id;
                                          s.Date_Verified_by_Checkpoint__c = system.now();    
                                          
                                //add to list to process later
                                ServersFound.add(s);
    
                                //Add FOUND to server status for debugging and email
                                //ServersStatusSet.add('FOUND: ' + c.Organization + ' | ' + c.servername + ' | Id: ' + s.id);
                                system.debug('FOUND: ' + c.Organization + ' | ' + c.servername + ' | Id: ' + s.id);
                            } else {
                                //Add NOT FOUND to server status for debugging and email
                                ServersStatusSet.add('NOT FOUND: ' + c.Organization + ' | ' + c.servername + ' | QID: ' + c.qid);
                                sendEmail = true;
                            }
                        }
                        system.debug('ServersStatusSet: ' + ServersStatusSet.size());
                        
                        // DML: Update Servers
                        list<Database.SaveResult> srList = Database.update(ServersFound, false);
    
                        // Iterate through each returned result for logging
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                //ErrorLog += 'Successfully updated Server. Record ID: ' + sr.getId() + ' \n';
                            } else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    ErrorLog+= 'The following error has occurred. ' + err.getStatusCode() + ': ' + err.getMessage() + ' fields that affected this error: ' + err.getFields() + ' \n';
                                    sendEmail = true;
                                }
                             }
                         }        
                 }
        }catch(exception e) {
            ErrorLog += 'EXECUTE: ' + e.getmessage() + ' ('+ e.getlinenumber() + ') \n';
            system.debug('ErrorLog: ' + ErrorLog);
        }
    }
    
    //Logic to handle null values. If null keep old value
    private static string NZ(string Val_New, string Val_Old){
      if(Val_New == null || Val_New == '' || Val_New.trim().length()==0 || Val_New.tolowercase() == 'null'){
          return Val_Old;
      } else {
          return Val_New;
      }    

    }
    
    //Logic to shorten Release values. 
    private static string parseRelease(string sRelease){
      if(sRelease == null || sRelease == '' || sRelease.trim().length()<=5 || sRelease.tolowercase() == 'null'){
          return null;
      } else {
          return sRelease.substring(0,5).trim();
      }    

    }
    
    //Finish Up 
        Global void finish(Database.BatchableContext BC){   
            System.debug('Batch Process Complete');
              // Query the AsyncApexJob object to retrieve the current job's information. 
                 AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, ExtendedStatus, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
              
              
              if(sendEmail){  
              // Create a case notifying job creation with STATEFUL data
                 case c = new case();
                      c.ownerid = [select id from group where type ='Queue' and developername='SupportCSA'].id;
                      c.recordtypeid = [select id from recordtype where developername='Product_Support_CSA'].id; 
                      c.Subject = 'CheckPointBatch :  ' + a.Status + ' Processed: ' + a.JobItemsProcessed + ' out of ' + a.TotalJobItems;
                      c.description = 'The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors
                                     + ' terminal failures.\n' + 'Total Records Processed: ' + ServersStatusSet.size() + ' \n\n ' + ErrorLog + ' \n\n Thank you.';
                     if(!Test.isRunningTest())
                         insert c;

                     //Print to Email 
                     string msg = '**Salesforce Error(s)** \n';
                            msg += ErrorLog;
                            msg += '\n\n\n';
                            msg += '**Checkpoint Status Log** \n';
                            for(String x : ServersStatusSet) msg += x + '\n';
                            msg += '\n\n\n';
                     
                     //Add Log to CASE
                     Attachment att=new Attachment();
                         att.Body=Blob.valueOf(msg);
                         att.Name='Log_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
                         att.parentId=c.id;
                     //Ensure case returns an ID.
                     if(c.id!=null)
                         insert att;
                  }
          //TRY CATCH NOT ADDED TO LOG FAILS in APEX JOB LOG 
      } 
 }