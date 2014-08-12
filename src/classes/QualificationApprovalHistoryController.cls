public class QualificationApprovalHistoryController {
    public String QualificationId {get;set;}
    public List<ProcessInstanceHistory> getApprovalSteps() {
      if (QualificationId != null) {
        Qualification__c Qualification = [Select Id, (Select TargetObjectId, SystemModstamp, StepStatus, RemindersSent, ProcessInstanceId, OriginalActorId, IsPending, IsDeleted, Id, CreatedDate, CreatedById, Comments, ActorId From ProcessSteps order by SystemModstamp desc limit 1) from Qualification__c where Id = :QualificationID];
        return Qualification.ProcessSteps;
      }
      return new List<ProcessInstanceHistory> ();
    }  
    
}