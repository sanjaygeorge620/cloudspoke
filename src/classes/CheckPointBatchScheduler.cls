//Schedule Job
public class CheckPointBatchScheduler implements Schedulable{
  public  void execute(SchedulableContext SC) {
       CheckPointBatch b = new CheckPointBatch(); 
       database.executebatch(b, 1);
  } 
}



/*
*****Execute Anonymous

CheckPointBatch b = new CheckPointBatch(); 
database.executebatch(b, 1);

*****EXECUTE SCHEDULE
CheckPointBatchScheduler  m = new CheckPointBatchScheduler ();
     String sch = '0 0 23 * * ?';
     system.schedule('Checkpoint Server Update (Nightly @11pm)', sch, m);



*/