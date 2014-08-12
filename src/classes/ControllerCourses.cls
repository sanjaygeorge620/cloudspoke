public class ControllerCourses {
    
    private Course__c currentCourse;
    ApexPages.StandardController standardController;
    private boolean paidUser = false;
    public boolean showRows;    
    
    public List<Class__c> availablePortalClasses;
    //public List<Attachment> attachments;    
    public ControllerCourses(ApexPages.StandardController pcfController){
        standardController = pcfController;
        this.currentCourse = (Course__c)pcfController.getRecord();
        List<ELearning_Registration__c> userCompletedRegistrations = [select id  from ELearning_Registration__c 
                        where Applicant__c =: UserInfo.getUserId() and Registration_Status__c = 'Completed'];
        
        availablePortalClasses = 
                [select id, name, Class_Date_Str__c, Class_Date__c, Course__r.name, Course__r.Course_Type__c, Open_Seats__c, Class_Capacity__c, Days_Until_Class__c, Training_Location__c, Training_Location__r.Name 
                    from Class__c
                    where class_status__c = 'Available' and Course__c =:currentCourse.id
                    order by name asc];
        
        //attachments = [select Id, Name from Attachment where parentId=:currentCourse.Id];
    }
   
   //public List<Attachment> getAttachments(){
   //       return attachments;
   //}

    public List<Class__c> getAvailablePortalClasses(){
        return availablePortalClasses;
    }
    
    public boolean getShowRows(){
        return (availablePortalClasses!=null && availablePortalClasses.size()>0);   
    }
    
    
}