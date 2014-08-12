/*****************************************************************************
  Handles all logic on insert, update, or delete of Scheduled_Job__c objects
*****************************************************************************/

public with sharing class ScheduledJobTriggerHandler {
	private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    String sch = '';
    String DaysOfWeek = '';
    String CronId = ''; 
    
    //constructor
    public ScheduledJobTriggerHandler(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
        BatchSize = size;        
    }
    
    public void OnBeforeInsert(Scheduled_Job__c[] newJobs){
        for (Scheduled_Job__c j : newJobs){
            //check for dupe name
            List<Scheduled_Job__c> dupe = [SELECT Id, Name FROM Scheduled_Job__c WHERE Name = :j.Name];
        	if(!dupe.isEmpty()){
           		 j.Name.addError('Another Job already has this name. Please choose a unique name.');
       		}
            
            //only create new CronTrigger if the job is marked as active
            else if(checkRequiredFields(j) && j.Active__c == true){                               
                    createCronTrigger(j);                
    		}         
		}   
    }
    
    public void OnBeforeUpdate(Scheduled_Job__c[] updatedJobs, Map<ID, Scheduled_Job__c> oldJobMap){
        for (Scheduled_Job__c j : updatedJobs){
            if(checkRequiredFields(j)){
            
                //if active has gone from true -> false, abort the Job.
                if(j.Active__c == false && oldJobMap.get(j.Id).Active__c == true){
                    removeJob(j);
                    j.CronTriggerId__c = '';
                }
                //if active has gone from false -> true, then create the CronTrigger for the job.
                else if(j.Active__c == true && oldJobMap.get(j.Id).Active__c == false){
                    createCronTrigger(j);
                }
                //can not make changes to job while the job is active and running. Must unactivate and then make the update to the job and reactivate.
                //should probably just check to see if job status is executing
                else if(j.Active__c == true && oldJobMap.get(j.Id).Active__c == true){               
                    if(j != oldJobMap.get(j.Id)){ //check to see if record has been modified
                        j.Active__c.addError('Can not make changes to job while job is active. De-activate job first, update the job and re-activate.');
                    }
                }  
            }     
       }   
    }//end onBeforeUpdate
    
    public void OnBeforeDelete(Scheduled_Job__c[] JobsToDelete){
        for(Scheduled_Job__c j : JobsToDelete){
            removeJob(j);
        }
    }
     
    public boolean checkRequiredFields(Scheduled_Job__c j){
        
        boolean verified = false;
        
        // check fields that are required based on what the run unit is  
        if (j.Run_Units__c != 'Days' && j.Run_Frequency__c == null){
            j.Run_Frequency__c.adderror('This field is required to schedule the Job.');
        } 
        else if (j.Run_Units__c != 'Months' && j.MultiSelect_Days__c == null){
            j.MultiSelect_Days__c.adderror('This field is required to schedule the Job.');     
        }
        else if (j.Run_Units__c != 'Hours' && (j.Start_Time__c == null || j.Start_Time__c == '')){
            j.Start_Time__c.adderror('This field is required to schedule the Job.');            
        }
        else if (j.Run_Units__c == 'Months' && (j.NoMultiSelect_Days__c == null || j.NoMultiSelect_Days__c == '')){
            j.NoMultiSelect_Days__c.adderror('This field is required to schedule the Job.');  
        }  // done checking fields
        else {
            verified = true;
        }
        
        return verified;
    }   
    
    public void removeJob(Scheduled_Job__c j){
        If(j.CronTriggerId__c != null){
            String CronId = j.CronTriggerId__c + 'AAA';
            List<CronTrigger> CronTrig = [SELECT Id, State FROM CronTrigger WHERE Id = :j.CronTriggerId__c LIMIT 1];
            if(CronTrig.size() > 0){  
                //check to see if job is currently executing
                if (CronTrig[0].State == 'EXECUTING'){
                    j.Active__c.addError('Job can not be unactivated or deleted while job is executing.');
                } 
                else {
                    // if CronTrigger is not currently executing, try to abort CronTrigger job
                    try{
                		System.abortJob(CronTrig[0].id);                
                    } catch(exception e){
                        j.Active__c.addError('CronTrigger not aborted! ERROR: ' + e);
                    }
           		 }            
       		 }
        }
    }//end removeJob    
        
    public void createCronTrigger(Scheduled_Job__c j){        
        //if run unit is NOT 'Months', create the DaysofWeek string for the CronExpression in the format of 'MON,TUE,WED'
        if(j.Run_Units__c != 'Months'){                      
        	DaysOfWeek = '';
            if(j.MultiSelect_Days__c != null){               
            	String [] days = j.MultiSelect_Days__c.split(';');
                for (String s : days){
                	if (DaysOfWeek ==  ''){
                    	DaysOfWeek = s.substring(0, 3).toUpperCase();
                    }
                    else{
                    	DaysOfWeek = DaysOfWeek + ',' + s.substring(0, 3).toUpperCase();
                    }
                }                
            }
        }
        
        // Salesforce does not allow you to schedule by minutes. You can specify the minute start time, but can not have the job scheduled to run more than once an hour. 
        //maybe there is some other way to get jobs to run every minute?
        //if (j.Run_Units__c.equals('Minutes')){    
        //                           
        
        //create the CronExpression         
        if (j.Run_Units__c.equals('Hours')){                
             sch = '0 0 0/' + j.Run_Frequency__c + ' ? * ' + DaysOfWeek + ' *';              	 
        }
            
        else if (j.Run_Units__c.equals('Days')){               
            sch = '0 0 ' + j.Start_Time__c + ' ? * ' + DaysOfWeek + ' *';              	
        }
            
        else if (j.Run_Units__c.equals('Months')){        		
            sch = '0 0 ' + j.Start_Time__c + ' ? 1/' + j.Run_Frequency__c + ' ' +j.NoMultiSelect_Days__c.substring(0, 3).toUpperCase() + j.Weekday_Number__c + ' *';
        } //done creating CronExpression
        
        Schedulable s; 
            
        Try{
            // Get the Type 'token' for the Class
            System.Type t = System.Type.forName(j.Apex_Class__c);
            
            // Cast this class in to the schedulable interface
            // if the cast fails, we'll get an error
           s = (Schedulable) JSON.deserialize('{}',t);           
            
        }Catch(exception e){
            j.Name.addError('This class does not implement the Schedulable Interface.');
        }    
        //if the cast is successful, create the CronTrigger
        if (s != null){
            
            // Schedule our Schedulable using the stored CRON schedule                              
            CronId = System.schedule(j.Name, sch, s);
            
            //set the CronTriggerId field on the Scheduled Job 
            j.CronTriggerId__c = CronId;
        }
                          
    }//end createCronTrigger
    
}//end ScheduledJobTriggerHandler