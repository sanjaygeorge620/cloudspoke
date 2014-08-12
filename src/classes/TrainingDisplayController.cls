//Developed to Improve Training Registration
//Created by Michael Fitzgerald
//August 2010
//This class is retrieving lists only, No DML

Public with sharing class TrainingDisplayController{
  //Custom Variables  
   public string ClassType{ get; set; }
   public string CourseRelease{ get; set; }
        
  //Constructors
    Public TrainingDisplayController(){/*NULL*/}
    public TrainingDisplayController(ApexPages.StandardController controller) {/*NULL*/}
    //Function Methods
    
    
  //LISTS 
    //Retrieve the Recordtypes associated with the Course__C object
    Public  List<Schema.RecordTypeInfo> getCourseRecordType(){
            Schema.DescribeSObjectResult R = Course__C.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        return RT;
    }

    //Retreive class info by Recordtype
    public list<Course__c> getClassroomInfo() { 
        return [Select c.Name, 
                       c.Description__C, 
                       c.Short_Description__c, 
                       c.Course_Type__c, 
                       c.Course_Status__c, 
                       c.Class_Duration__c 
                From Course__c c 
                where c.course_status__c = 'Available' and 
                      Featured_Course_Order__c!=null and 
                      Course_Type__c=:ClassType
                order by Featured_Course_Order__c asc];
    } 
    
    //Retrieve the Fields within the picklist through the Metadata API
    public List<SelectOption> getReleaseOptions(){
        List<SelectOption> ReleaseOptions = new List<SelectOption>();
        Schema.DescribeFieldResult Finals = Schema.sObjectType.Course__C.fields.Release__c;
        for (Schema.PickListEntry RelPickVal : Finals.getPicklistValues()){
            ReleaseOptions.add(new SelectOption(RelPickVal.getValue(),RelPickVal.getLabel()));
        }
        return ReleaseOptions;
    } 
    
    //Retreive courses by the type passed through the url
    public list<Course__c> getCoursesbytype() {
        ClassType=ApexPages.currentPage().getParameters().get('type');
        return [Select c.Name, 
                       c.Release__c, 
                       c.Description__C, 
                       c.Short_Description__c, 
                       c.Course_Type__c, 
                       c.Course_Status__c, 
                       c.Class_Duration__c  
                From Course__c c
                where c.course_status__c = 'Available' and 
                      Course_Type__c=:ClassType
                order by c.All_Course_Order__c asc NULLS LAST];
    } 
    
    //Retreive classes by the Tagged Release Field
    public list<Course__c> getCoursesbyRelease() { ///pulling release
        ClassType=ApexPages.currentPage().getParameters().get('type');
        LIST<Course__c> lc = [Select c.Name, c.Description__C, c.release__C, c.Short_Description__c, c.Course_Type__c, c.Course_Status__c, c.Class_Duration__c 
                From Course__c c 
                where c.course_status__c = 'Available' and Course_Type__c=:ClassType and Release__c INCLUDES (:CourseRelease)
                order by c.All_Course_Order__c asc NULLS LAST];
        
        if (lc.size()!=0){return lc;}
        else {return null;}
    }          

    //Retrive classes by course
    public list<Class__c> getClassesbyCourse() {
        list<Class__c> C= [select id, name, Class_Date_Str__c, Class_Date__c, Course__r.name, 
                    Course__r.Course_Type__c, Open_Seats__c, Class_Capacity__c, Days_Until_Class__c, Training_Location__c, Training_Location__r.Name 
                from Class__c
                where class_status__c = 'Available' and Course__c =:ApexPages.currentPage().getParameters().get('id')
                order by name asc];
        if (c.size()!=0){return c;}
        else {return null;}
    }

    //Retrive attachment
    public list<Attachment> getCourseAttachments() {
        list<Attachment> a= [Select a.Name, 
                                    a.Id, 
                                    a.Description, 
                                    a.ContentType,
                                    a.LastModifiedDate 
                             From Attachment a 
                             where parentid=:ApexPages.currentPage().getParameters().get('id')
                             order by name asc];
        if (a.size()!=0){return a;}
        else {return null;}
    }
    
    
//TEST++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    static testMethod void TrainingDisplayController() {
    TrainingDisplayController controller = new TrainingDisplayController();
        controller.getCoursesbyRelease();
        controller.getCoursesbytype();
        controller.getReleaseOptions();
        controller.getClassroomInfo();
        controller.getCourseRecordType();
        controller.getClassesbyCourse();
        controller.getCourseAttachments();
        
    }
}