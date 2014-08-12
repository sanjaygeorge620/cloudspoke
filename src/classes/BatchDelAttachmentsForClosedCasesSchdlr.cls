global class BatchDelAttachmentsForClosedCasesSchdlr implements Schedulable {   
    global void execute(SchedulableContext ctx) {        

        BatchDelAttachmentsForClosedCases  batch = new BatchDelAttachmentsForClosedCases ();
                
        ID batchprocessid = Database.executeBatch(batch,200);
        
       
   } 
   
   public static testMethod void batchTest(){
       Test.startTest();
       BatchDelAttachmentsForClosedCasesSchdlr m = new BatchDelAttachmentsForClosedCasesSchdlr();
       String sch = '00 27 06 * * ?';
       system.schedule('Batch Schedule', sch, m);
       Test.stopTest();
   } 
   
}