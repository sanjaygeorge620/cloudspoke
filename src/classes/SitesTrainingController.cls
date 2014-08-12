/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public with sharing class SitesTrainingController Extends SitesController{
   
//-------------------------------------------------------------------------------
// PARAMETERS 
//-------------------------------------------------------------------------------
   public string  PARAM_ELEARNING = 'E-Learning';
   public string  PARAM_LIVEONLINE = 'Live Online';
   public string  PARAM_CLASSROOM = 'Classroom';
   
   public integer PARAM_TRAINING_PROGRAMS = 2;
   public integer PARAM_TRAINING_SERVICES = 3;
   public integer PARAM_TRAINING_OTHERLINKS = 4;
   
   public integer PARAM_TOP_WIDGET = 0;
   public integer PARAM_VIDEO_WIDGET = 1;
   public integer PARAM_LEFT_WIDGET = 2;
   public integer PARAM_MIDDLE_WIDGET = 3;
   public integer PARAM_RIGHT_WIDGET = 4;            
   
//-------------------------------------------------------------------------------
// Training 
//-------------------------------------------------------------------------------
    private string ControllerID; 
    public string whichPortal;  
    public SitesTrainingController() 
    {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));            
            if(SITE_NICKNAME == 'Channel Portal')
            {
                whichPortal = 'Channel_Training__c';
                }
                else
                {
                whichPortal = 'Customer_Training__c';
                }

        }


//-------------------------------------------------------------------------------
// Course Details
//-------------------------------------------------------------------------------
    public Course__c getCourseDetails(){
        Course__c  CourseDetails;
        try{                 

            CourseDetails = [select 
                                id, 
                                Name,                                
                                Language__c,
                                Tuition__c,
                                Course_Type__c,
                                Currency__c,
                                Class_Duration__c,
                                Course_Has_Materials__c,
                                Short_Description__c,
                                Course_Prerequisites__c,
                                Notes__c,
                                Description__c,
                                Topics__c,
                                Audience__c,
                                Viewing_Requirement__c,
                                Environment__c,
                                course_status__c
                           from Course__c where 
                           id=:ControllerID and
                           Active__c=true and 
                           course_status__c = 'Available' 
                           ];
                           
           } catch(QueryException e){
                        throw new NoDataFoundException();
                     }
           
            return CourseDetails;
        }
        
        //Classes by Course
        public list<Class__c> getClassesbyCourse() {
                list<Class__c> AvailableClasses= [select 
                                                    Class_Date_Str__c, 
                                                    Class_Date__c,
                                                    Open_Seats__c, 
                                                    Days_Until_Class__c,
                                                    Country__c,
                                                    Language__c,
                                                    Training_Location__r.name,
                                                    class_status__c
                                                  from Class__c
                                                  where 
                                                      (class_status__c = 'Available' OR class_status__c = 'At Capacity') and 
                                                      Course__c =:ControllerID
                                                order by 
                                                    Class_Date__c asc];
                return AvailableClasses;
            }
        
        //Course Attachments
        public list<Attachment> getCourseAttachments() {
                list<Attachment> CourseAttachments= [Select a.Name, 
                                                        a.Description, 
                                                        a.ContentType,
                                                        a.LastModifiedDate 
                                                 From Attachment a 
                                                 where parentid=:ControllerID
                                                 order by name asc];
            return CourseAttachments;
        }
//-------------------------------------------------------------------------------
// Registration Details
//-------------------------------------------------------------------------------
     public ELearning_Registration__c getRegistrationDetails(){
           ELearning_Registration__c RegistrationDetail;
           try{  
                RegistrationDetail = [Select 
                                            e.Account__r.id,
                                            e.Account__r.name, 
                                            e.Class__r.name, 
                                            e.Class__r.id,
                                            e.Total_Cost__c,  
                                            e.Registration_Status__c, 
                                            e.Purchase_Order_Number__c, 
                                            e.Payment_Method__c, 
                                            e.Number_of_Attendees__c, 
                                            e.Name_on_Credit_Card__c, 
                                            e.Name, 
                                            e.Credit_Card_Type__c, 
                                            e.Credit_Card_Number__c, 
                                            e.Credit_Card_Expiration_Date__c, 
                                            e.Course_Name__c, 
                                            e.Course_Type__c,
                                            e.Country__c, 
                                            e.Cost_Per_Attendee__c, 
                                            e.Comments__c, 
                                            e.Billing_Zip__c, 
                                            e.Billing_State__c, 
                                            e.Billing_City__c, 
                                            e.Billing_Amount__c, 
                                            e.Address_2__c, 
                                            e.Address_1__c,
                                            e.Class__r.Training_Location__r.name, 
                                            e.Class__r.Trainers__c,
                                            //e.Class__r.Trainer__c,
                                            e.Class__r.Class_Date_Str__c,
                                            e.Class__r.Hours_Text__c,
                                            e.Class__r.class_type__c,
                                            e.Class__r.Language__c,
                                            e.Class__r.Country__c                                                                                       
                                         From 
                                             ELearning_Registration__c e
                                          where id=:ControllerID and
                                                e.Account__r.id=:SITE_ACCOUNT.id
                                          limit 1
                                       ];
          
          } catch(QueryException e){
                throw new NoDataFoundException();
          }   
        
       return RegistrationDetail;
     }
  
    
    public list<Training_Attendee__c> getAttendees(){
             list<Training_Attendee__c> Attendees = [Select  
                                                     t.Name, 
                                                     t.Contact_Phone__c, 
                                                     t.Attendee_Name__c, 
                                                     t.Attendee_ImageNow_Role__c, 
                                                     t.Attendee_Email__c 
                                                From Training_Attendee__c t
                                                where t.Registration__r.id=:ControllerID
                                                order by name];
             return Attendees;}                                   

//-------------------------------------------------------------------------------
// Training Locations
//-------------------------------------------------------------------------------
    public Training_Location__c getTrainingLocation(){
            Training_Location__c TrainingLocation = [Select 
                                                           t.Name, 
                                                           t.Contact_Phone__c, 
                                                           t.Address__c 
                                                      From Training_Location__c t
                                                      where id=:ControllerID
                                                      ];
            return TrainingLocation;}                                          

//-------------------------------------------------------------------------------
// My Course Registration
//-------------------------------------------------------------------------------
    public list<ELearning_Registration__c> getMyRegistrations(){
        list<ELearning_Registration__c> MyRegistrations = [select id, 
                                                                  name, 
                                                                  Course_Name__c, 
                                                                  Class__r.id,
                                                                  Class__r.Course__r.id,
                                                                  Class__r.Class_Type__c, 
                                                                  Class__r.class_date__c,  
                                                                  Class__r.Training_Location__r.name, 
                                                                  Class__r.Open_Seats__c, 
                                                                  Class__r.Days_Until_Class__c, 
                                                                  Class__r.Class_Capacity__c,
                                                                  createddate,
                                                                  Registration_Status__c  
                                                            from ELearning_Registration__c 
                                                            where Applicant__c =: UserInfo.getUserId()
                                                            order by createddate desc];
        return MyRegistrations;}


//-------------------------------------------------------------------------------
// Classes Enrolled
//-------------------------------------------------------------------------------
       public list<Class__c> getMyeLearningClasses(){
        return getMyClasses(PARAM_ELEARNING);}
        
       public list<Class__c> getMyClassRoomClasses(){
            return getMyClasses(PARAM_CLASSROOM);}
            
       public list<Class__c> getMyLiveOnlineClasses(){
            return getMyClasses(PARAM_LIVEONLINE);} 
            
       public list<Class__c> getMyClasses(string CourseType){
           Set<Id> myClasses = new Set<Id>();
           List<Training_Attendee__c> attendees = [Select Class__r.id 
                                                    from Training_Attendee__c 
                                                    where 
                                                        Contact__c=:SITE_CONTACT.ID and 
                                                        Registration_Status__c = 'Completed' and 
                                                        class_Type__c =:CourseType and
                                                        (Status__c = 'Enrolled' or Status__c = 'Attended')
                                                   ];
            for(Training_Attendee__c attendee : attendees){
                 myClasses.add(attendee.Class__r.id);   
            }
            
            List<Class__c> availableClasses = [select id, 
                                                      name, 
                                                      Course__r.Name, 
                                                      Class_Date__c, 
                                                      Open_Seats__c, 
                                                      Class_Type__c, 
                                                      Class_Capacity__c, 
                                                      Days_Until_Class__c, 
                                                      Training_Location__c, 
                                                      Training_Location__r.id,
                                                      Training_Location__r.Name 
                                                from Class__c 
                                                where Id in : myClasses
                                                order by Course__r.Name
                                               ];
   
           return availableClasses;
   } 
//-------------------------------------------------------------------------------
// Class Chapters
//-------------------------------------------------------------------------------
    public Class__c getClassDetails(){
           Class__c classinfo=[Select
                                       name,
                                       class_Type__c,
                                       class_date__c,
                                       Training_Location__r.name,
                                       Open_Seats__c,
                                       Days_Until_Class__c,
                                       Class_Capacity__c,
                                       Course__r.Name,
                                       Course__r.id,
                                       Hours_Text__c,
                                       trainers__c,
                                       //trainer__c,
                                       (Select 
                                               Name, 
                                               Class__c, 
                                               Chapter_Number__c,
                                               Chapter_URL__c, 
                                               Course__c, 
                                               Length__c,
                                               Internal_Chapter__c, 
                                               Title__c 
                                          From Chapters__r
                                          where Internal_Chapter__c=false
                                          order by Chapter_Number__c
                                          ) 
                                   From Class__c c 
                                   where id=:ControllerID
                                    
                                ];
     return classinfo;                                
    }


//-------------------------------------------------------------------------------
// Class Chapter - View
//-------------------------------------------------------------------------------
    public Chapter__c getViewChapter(){
           system.debug('getViewChapter.id: '+ControllerID);
           Chapter__c chapterinfo=[Select
                                       Name, 
                                       Class__r.Course__r.name,
                                       Class__r.id, 
                                       Chapter_Number__c, 
                                       Chapter_URL__c, 
                                       Course__c, 
                                       length__c, 
                                       Internal_Chapter__c, 
                                       Title__c
                                  From Chapter__c
                                  where Internal_Chapter__c=false and
                                        id=:ControllerID
                                  order by Chapter_Number__c
                                    ];
           system.debug('chapterinfo: ' + chapterinfo);                         
           list<Training_Attendee__c> Attendee =[Select 
                                            Registration_Status__c 
                                        from Training_Attendee__c 
                                        where 
                                            Contact__c=:SITE_CONTACT.Id and 
                                            Class__c =:chapterinfo.Class__r.id and
                                            Registration_Status__c ='Completed'
                                        ];
           system.debug('Attendee: ' + Attendee);
           if (Attendee.size()==1){
                 return chapterinfo;           
            } else {
                throw new NoAccessException();
                return null;               
            }    
                                 
    }
        
//-------------------------------------------------------------------------------
// Courses by Type 
//-------------------------------------------------------------------------------
    //Featured
    public list<Course__c> getFeaturedCourseseLearning(){
        return getCourses(PARAM_ELEARNING, true);}
    
    //Non-Featured
    public list<Course__c> getCourseseLearning(){
        return getCourses(PARAM_ELEARNING, false);}
            
    public list<Course__c> getCourseseLiveOnline(){
        return getCourses(PARAM_LIVEONLINE, false);}
        
    public list<Course__c> getCourseseClassroom(){
        return getCourses(PARAM_CLASSROOM, false);}   
        
    //Retreive class info by Recordtype
        public list<Course__c> getCourses(string ClassType, boolean Featured) 
        {
        
         string query_fea = '';        
         string query = '';  
         string fil1 = '';
         //string fil1_fea = '';   
         string fil2 = '';
         string fil2_fea = '';   
                  
             query_fea = 'Select c.Name, '+
                            'c.Short_Description__c,'+                           
                            'c.Class_Duration__c, '+
                            'c.language__c '+                            
                             ' From Course__c c '+
                            'where c.course_status__c = \'Available\' and '+
                                 ' Featured_Course_Order__c!=null and '+
                                 ' Course_Type__c = \''+ClassType+'\' and '+
                                 ' Active__c=true and ';
                                 
             query = 'Select c.Name, '+
                            'c.Short_Description__c,'+                           
                            'c.Class_Duration__c '+
                             ' From Course__c c '+
                            'where c.course_status__c = \'Available\' and '+                                 
                                 ' Course_Type__c =  \''+ClassType+'\' and '+
                                 ' Active__c=true and ';  
              
           fil1 = ' '+whichPortal+' = True ';
                           
           fil2 = 'order by c.All_Course_Order__c asc NULLS LAST';                
           fil2_fea = 'order by Featured_Course_Order__c asc NULLS LAST';
                             
            
           
           query = query + fil1 + fil2;
           query_fea = query_fea + fil1 + fil2_fea;           

      system.debug('QUERY HERE----------------' +query); 
      system.debug('QUERY HERE----------------' +query_fea); 
        
         
     //-------------------------------------------------------------------------------------------    
            list<Course__c> Courses = new list<Course__c>();
            if (Featured==true){
                //Featured Courses
                /*   Courses= [Select c.Name, 
                                   c.Short_Description__c, 
                                   c.Class_Duration__c 
                            From Course__c c 
                            where c.course_status__c = 'Available' and 
                                  Featured_Course_Order__c!=null and
                                  Course_Type__c=:ClassType and
                                  Active__c=true
                            order by Featured_Course_Order__c asc NULLS LAST]; */
                            
                            Courses = Database.Query(query_fea);
                            
            }
            else{
                //All Courses
               /*   Courses= [Select c.Name, 
                                   c.Short_Description__c, 
                                   c.Class_Duration__c 
                            From Course__c c 
                            where c.course_status__c = 'Available' and 
                                  Active__c=true and
                                  Course_Type__c=:ClassType
                            order by c.All_Course_Order__c asc NULLS LAST]; */   
                                                      
                            Courses = Database.Query(query);
            }
            
            return Courses;
        }


//-------------------------------------------------------------------------------
// Courses by Release Field
//-------------------------------------------------------------------------------
     public list<Course__c> getCoursesCore(){
        return getCoursesbyRelease(PARAM_ELEARNING, 'Core Concept Training');}
     
     public list<Course__c> getCoursesRelease(){
        return getCoursesbyRelease(PARAM_ELEARNING, 'Release Training');}
        
     public list<Course__c> getCoursesAdvanced(){
        return getCoursesbyRelease(PARAM_ELEARNING, 'Advanced Concept Training');}
        
     public list<Course__c> getCoursesbyRelease(string ClassType, string CourseRelease) 
     {
     LIST<Course__c> courses = new List<Course__c>();
     if(SITE_NICKNAME == 'Channel Portal')
     {
                courses = [Select 
                                        c.Name, 
                                        c.Description__C, 
                                        c.release__C, 
                                        c.Short_Description__c, 
                                        c.Course_Type__c, 
                                        c.Course_Status__c, 
                                        c.Class_Duration__c 
                                    From Course__c c 
                                    where 
                                        c.course_status__c = 'Available' and 
                                        Active__c=true and
                                        Course_Type__c=:ClassType and 
                                        Channel_Training__c = True and
                                        Release__c INCLUDES (:CourseRelease) and
                                        Active__c=true
                                    order by 
                                        c.All_Course_Order__c asc NULLS LAST];
                                        
                                         system.debug('In Channel Portal Core Courses ');
                }
                if(SITE_NICKNAME == 'Customer Portal')
                {
                courses = [Select 
                                        c.Name, 
                                        c.Description__C, 
                                        c.release__C, 
                                        c.Short_Description__c, 
                                        c.Course_Type__c, 
                                        c.Course_Status__c, 
                                        c.Class_Duration__c 
                                    From Course__c c 
                                    where 
                                        c.course_status__c = 'Available' and 
                                        Active__c=true and
                                        Course_Type__c=:ClassType and 
                                        Customer_Training__c = True and 
                                        Release__c INCLUDES (:CourseRelease) and
                                        Active__c=true
                                    order by 
                                        c.All_Course_Order__c asc NULLS LAST];
                                        
                                        system.debug('In Customer Portal Core Courses ');
                }
                return courses;
            }    


    
//-------------------------------------------------------------------------------
// Training Detail Link Pages
//-------------------------------------------------------------------------------

    public Training_Info_Item__c ParentInfo {get;set;}
    public list<Training_Info_Item__c> getTrainingItems() {
        list<Training_Info_Item__c> childInfoItems;
        try{
            childInfoItems = [select 
                                    name, 
                                    description__c, 
                                    Title_URL__c, 
                                    TitleHasURL__c,
                                    Parent_Training_Info_Item__r.name,
                                    Parent_Training_Info_Item__r.Description__c
                               from Training_Info_Item__c 
                               where 
                                   Parent_Training_Info_Item__c =:ControllerID
                               order by order__c
                               ];     
         } catch(QueryException e){
                throw new NoDataFoundException();
         }   
            
            for (Training_Info_Item__c tb : childInfoItems) {
                ParentInfo =  tb;                   
                }
                    
            return childInfoItems;
       }     
    

//-------------------------------------------------------------------------------
// Training Links
//-------------------------------------------------------------------------------
    //TRAINING LINKS    
    public list<Training_Info_Item__c> getTrainingPrograms(){
        return getTrainingLinks(PARAM_TRAINING_PROGRAMS);}
        
    public list<Training_Info_Item__c> getTrainingServices(){
        return getTrainingLinks(PARAM_TRAINING_SERVICES);}   
        
    public list<Training_Info_Item__c> getOtherLinks(){
        return getTrainingLinks(PARAM_TRAINING_OTHERLINKS);}
        
    public list<Training_Info_Item__c> getTrainingLinks(integer Section){
        list<Training_Info_Item__c> TrainingLinks = [
                    Select 
                        t.Title_URL__c, 
                        t.TitleHasURL__c, 
                        t.SystemModstamp, 
                        t.Parent_Title_URL__c, 
                        t.Page_Section_Number__c, 
                        t.Order__c, 
                        t.Name, 
                        t.Long_Description__c, 
                        t.Description__c 
                    From Training_Info_Item__c t
                    where 
                        t.Parent_Training_Info_Item__c ='' and
                        t.Page_Section_Number__c =:Section
                    order by t.Order__c   
                    ];
    
        return TrainingLinks;    
    }
    
    //TRAINING WIDGETS
    public list<Training_Info_Item__c> getTopWidget(){
        return getTrainingWidget(PARAM_TOP_WIDGET,0);} 
    
    public list<Training_Info_Item__c> getVideoWidget(){
        return getTrainingWidget(PARAM_VIDEO_WIDGET,0);}  
            
    public list<Training_Info_Item__c> getLeftWidget(){
        return getTrainingWidget(PARAM_LEFT_WIDGET,0);}  
    
    public list<Training_Info_Item__c> getMiddleWidget(){
        return getTrainingWidget(PARAM_MIDDLE_WIDGET,0);}  
    
    public list<Training_Info_Item__c> getRightWidget(){
        return getTrainingWidget(PARAM_RIGHT_WIDGET,0);}          
            
    public list<Training_Info_Item__c> getTrainingWidget(integer SortNumber, integer Section){
        list<Training_Info_Item__c> TrainingLinks = [
                    Select 
                        t.Description__c 
                    From Training_Info_Item__c t
                    where 
                        t.Page_Section_Number__c =:Section and 
                        t.Order__c=:SortNumber
                    order by t.Order__c  
                    limit 1 
                    ];
    
        system.debug('*******TrainingLinks'+TrainingLinks);
        return TrainingLinks;  
          
    }
   
    
//-------------------------------------------------------------------------------
// Training Legal Text
//-------------------------------------------------------------------------------
    
    public Legal_Term__c getLegal(){
        Legal_Term__c legal;
        try{
            legal = [Select 
                             l.Agreement__c 
                       From Legal_Term__c l 
                       where  
                            l.Public__c =true and 
                            l.Type__c = 'Training Registration' 
                       order by 
                             l.Version__c desc 
                       limit 1
                       ];
        } catch(QueryException e){
            legal = new Legal_Term__c();
        }
                
     Return Legal;     
    }


}