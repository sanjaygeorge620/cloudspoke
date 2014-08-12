/************************************************
  Controller for the JobsTable visualforce page
*************************************************/

public with sharing class JobsTableController {
	public List<Scheduled_Job__c> jobs {get;set;}	   
    public string SelectedJobId { get; set; }
    public string view {get;set;}
    private List<String> CronTriggerIds = new List<String>();
    private List<CronTrigger> CronTriggers = new List<CronTrigger>();
    public List<wrapJob> wrapJobList;
    public Map<String, CronTrigger> cronTriggerMap = new Map<String, CronTrigger>();
    
    //constructor
    public JobsTableController(){    	  
        //test
        if(wrapJobList == null) {
            wrapJobList = new List<wrapJob>();
        }
        view = 'All';
        
        LoadData();  
        createCronMap();                  
    }    
      
      private void LoadData() {

          //get active jobs
          wrapJobList = new List<wrapJob>();
          if(view == 'Active'){
             jobs = [SELECT Id, Name, Active__c, Run_Units__c, Run_Frequency__c, Apex_Class__c, CronTriggerId__c, CreatedBy.Name, CreatedDate
                   FROM Scheduled_Job__c
                   WHERE Active__c = true
                   ORDER BY CreatedDate DESC];  

          //get unactive jobs
          } else if(view == 'Not Active'){
           	jobs = [SELECT Id, Name, Active__c, Run_Units__c, Run_Frequency__c, Apex_Class__c, CronTriggerId__c, CreatedBy.Name, CreatedDate
                   FROM Scheduled_Job__c
                   WHERE Active__c = false
                   ORDER BY CreatedDate DESC];

          //get all jobs
          } else {
      			jobs = [SELECT Id, Name, Active__c, Run_Units__c, Run_Frequency__c, Apex_Class__c, CronTriggerId__c, CreatedBy.Name, CreatedDate
                       FROM Scheduled_Job__c                 
                       ORDER BY CreatedDate DESC]; 
          } 
          
          //for every job in jobs list, create a wrapper and add it to list
          for(Scheduled_Job__c j : jobs){
              wrapJobList.add(new wrapJob(j));
          }        
      }
    
    private void createCronMap(){
        for(Scheduled_Job__c j : jobs){
            CronTriggerIds.add(j.CronTriggerId__c);
        }        
        
        CronTriggers = [SELECT Id, NextFireTime, PreviousFireTime, State, CronJobDetail.Name, CronJobDetail.JobType, CronExpression
                        FROM CronTrigger
                       	WHERE Id IN : CronTriggerIds]; 
        
        for(CronTrigger ct : CronTriggers){ 
            String CronID = String.valueOf(ct.Id);
            for(Scheduled_Job__c j: jobs){
                
                if(j.CronTriggerId__c != null && CronID.Contains(j.CronTriggerId__c)){                   
                        cronTriggerMap.put(j.id, ct);                   
                }
            }                         
        }
    }
    
    public class wrapJob {
        public Scheduled_Job__c job {get; set;}
        public Boolean selected {get; set;}
 
        //contructor method.        
        public wrapJob(Scheduled_Job__c j) {
            job = j;
            selected = false;
        }
    }
    public List<WrapJob> getJobsList() { 
         loaddata();
         return wrapJobList;         
    }  
    
    public List<SelectOption> getViews() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Active','Active'));
        options.add(new SelectOption('Not Active','Not Active'));            
        return options;
    }  
    
    public Map<String, CronTrigger> getCronTriggerMap() {
        return cronTriggerMap;
    }
    
    public void DeleteJob(){
        if (SelectedJobId == null) {      
       		return;
        }
        Scheduled_Job__c tobeDeleted = null;
        for(Scheduled_Job__c j : jobs){
           if (j.Id == SelectedJobId) {
              tobeDeleted = j;
              break;
           }
    	}           
      	//if job record found delete it
     	if (tobeDeleted != null) {
      		Delete tobeDeleted;
      	}       
     	LoadData();
        CreateCronMap();
   	}
    
     public void ActivateJobs(){
        for (WrapJob w: WrapJobList){
            if(w.selected == true && w.job.Active__c == false){                
                w.job.Active__c = true;
                update w.job;                
            }
        }
        
        loadData();
        CreateCronMap();
    }
    
    public void DeactivateJobs(){
        for (WrapJob w: WrapJobList){
            if(w.selected == true && w.job.Active__c == true){               
                w.job.Active__c = false;
                update w.job;                
            }
        }
         
        loadData();
        CreateCronMap();
    }
}