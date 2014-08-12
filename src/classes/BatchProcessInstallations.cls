global class BatchProcessInstallations implements Database.Batchable<sObject>, Database.Stateful{
    global class BatchProcessInstallationException extends Exception{}
    global string StateFul_ErrorLog; //Maintain State to create case
    global boolean CreateCase;
    global BatchProcessInstallations(){
        StateFul_ErrorLog = '';
        CreateCase = false;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, QAStatus__c, SAP_Sent__c, Contract_Number__c, SAP_Status__c FROM Opportunity WHERE SAP_Status__c IN (\'OVERRIDE\',\'SUBMITTED\') and InstallationStatus__c IN (\'Started\')';
        if(Test.isRunningTest())
        {     
               query = 'SELECT Id, Name, QAStatus__c, SAP_Sent__c, Contract_Number__c, SAP_Status__c FROM Opportunity WHERE SAP_Status__c IN (\'OVERRIDE\',\'SUBMITTED\') and InstallationStatus__c IN (\'Started\') limit 1';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> opportunities){
        
        //We are processing 1 at a time.
        if(opportunities.size()> 0){
            for(Opportunity oppty : opportunities){
                
                system.debug('BatchProcessInstallations - Started Processing Opportunity' + oppty);
                try{
                    //Update initial status
                        oppty.InstallationStatus__c = 'Processing';
                        update oppty;

                    // TO DO : call processinstallations            
                        ProcessInstallations.ProcessInstallation(new List<id>{oppty.id});

                    //Update the Status to Completed
                        oppty.InstallationStatus__c = 'Completed';
                        oppty.Installation_Error_Log__c= '';
                        update oppty;
                }catch(exception e){
                        
                      string errorlog  = oppty.id + ' ' + oppty.name + '\n'; 
                             errorlog  += 'Error: ' +e.getmessage() + '\n'; 
                             errorlog  += 'Line Number: ' + e.getlinenumber() + '\n'; 
                             errorlog  += 'Cause: ' + e.getCause() + '\n'; 
                             errorlog  += 'StackTrace: ' + e.getStackTraceString() + '\n'; 
                      CreateCase = true;
                      StateFul_ErrorLog += errorlog + '\n';
                      
                      try{
                          //Try updating the opportunity.
                          oppty.Installation_Error_log__c = errorlog;
                          oppty.InstallationStatus__c = 'Errored';
                          update oppty;
                      }catch(exception ex){
                          //do nothing
                      }    
                }
                
                system.debug('BatchProcessInstallations - Opportunity Processing Completed' + oppty);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
           System.debug('Batch Process Complete');
              // Query the AsyncApexJob object to retrieve the current job's information. 
                 AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, ExtendedStatus, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
              
              
              if(CreateCase){  
              // Create a case notifying job creation with STATEFUL data
                 case c = new case();
                      c.ownerid = [select id from group where type ='Queue' and developername='HelpDeskEnterpriseApplication'].id;
                      c.recordtypeid = [select id from recordtype where developername='HelpDesk'].id; 
                      c.Level_1__c = 'Salesforce.com';
                      c.Category__c = 'Enterprise Application';
                      c.Type = 'Problem';
                      c.Subject = 'Batch - Installation Logic:  ' + a.Status + ' Processed: ' + a.JobItemsProcessed + ' out of ' + a.TotalJobItems;
                      c.description = 'Installation job processed ' + a.TotalJobItems + ' records with '+ a.NumberOfErrors
                                     + ' terminal failures.\n' + ' \n\n ' + StateFul_ErrorLog + ' \n\n Thank you.';
                     if(!Test.isRunningTest())
                         insert c;

                     //Print to Email 
                     string msg = '**Salesforce Installation Error(s) @' + System.now().format('yyyy_MM_dd_hh_mm_ss') + ' ** \n';
                            msg += '\n\n\n';
                            msg += StateFul_ErrorLog;
                            msg += '\n\n\n';
                     
                     //Add Log to CASE
                     Attachment att=new Attachment();
                         att.Body=Blob.valueOf(msg);
                         att.Name='Log_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.log';
                         att.parentId=c.id;
                     //Ensure case returns an ID.
                     if(c.id!=null)
                         insert att;
                  }
          //TRY CATCH NOT ADDED TO LOG FAILS in APEX JOB LOG 
    }
}