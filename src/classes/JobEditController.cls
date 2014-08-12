/*******************************************
  Controller for Job Edit visualforce page
********************************************/

public with sharing class JobEditController {  
    
    public Scheduled_Job__c Job{get;set;}
    
    private string JobId;   

    public boolean newJob{get;set;}   
    
    //constructor
    public JobEditController(ApexPages.StandardController controller) {        
        
        //get page parameter
        JobId = ApexPages.currentPage().getParameters().get('id');     
        
        //if Id parameter is not null, query for the Scheduled Job and fields
        if(JobID!=null){
            job = [SELECT Id, Name, Active__c, Run_Units__c, Run_Frequency__c, Apex_Class__c, MultiSelect_Days__c, 
                   	 	  Start_Time__c, Weekday_Number__c, NoMultiSelect_Days__c 
                   FROM Scheduled_Job__c 
                   WHERE Id =:JobId 
                   LIMIT 1];
            newJob = false;
        }
        //if Id parameter is null, then we are creating a new job.
        else {
            Job = new Scheduled_Job__c();
            newJob = true;
        }       
    }
    
    public PageReference saveJob() {      
        Try{
            if(newJob){
                insert Job;
            }
            else{
                update Job;
            }
           //on successful save, send the user to the Tab for Scheduled Jobs
           return new PageReference('/apex/JobsTable');
        } 
        catch(Exception e){
        	ApexPages.addMessages(e);
        }
        return null;
    }
    
    public PageReference cancel(){
        //on cancel, send the user to the Tab for Scheduled Jobs
       return new PageReference('/apex/JobsTable');
    }    
       
    //populate the options for the Start_Time__c field.    
    public List<SelectOption> getHours() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));   
            for(integer i = 0; i<24; i++) 
            {
                if(i==0){
                    options.add(new SelectOption(''+i, '12:00 am')); 
                }
                else if(i < 12){
                    options.add(new SelectOption(''+i, i + ':00 am'));
                }
                else if(i==12){
                    options.add(new SelectOption(''+i, '12:00 pm'));
                }
                else {
                    options.add(new SelectOption(''+i, (i-12)+':00 pm'));
                }
            }    
    	return options;
	}
	
    //populate the options for the Weekday Number 
    public List<SelectOption> getWeekdayNumber() {
        List<SelectOption> options = new List<SelectOption>();  
        options.add(new SelectOption('#1', 'the 1st'));
        options.add(new SelectOption('#2', 'the 2nd'));
        options.add(new SelectOption('#3', 'the 3rd'));
        options.add(new SelectOption('L', 'the last'));
        return options;
    }      
}