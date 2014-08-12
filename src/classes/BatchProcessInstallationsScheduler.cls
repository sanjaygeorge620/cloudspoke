global class BatchProcessInstallationsScheduler implements Schedulable {   
    global void execute(SchedulableContext ctx) {        

        BatchProcessInstallations  batch = new BatchProcessInstallations();         
                 
        ID batchprocessid = Database.executeBatch(batch,1);
        
   }    
}