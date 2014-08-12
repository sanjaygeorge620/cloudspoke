/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public with sharing class SitesTraining_attachmentController Extends SitesController{
   

    private string ControllerID; 
    private string ClassID;
    private string chapterID ;
    public SitesTraining_attachmentController() 
    {
       //generic way to pull in the id for all methods (courses, classes, registrations, etc)
            ControllerID = secureString(ApexPages.currentPage().getParameters().get('id'));
            ChapterID = secureString(ApexPages.currentPage().getParameters().get('chapter'));
            
            
      }


   
        //Course Attachments
        public list<Attachment> getCourseAttachments() {
        
                list<Attachment> CourseAttachments= [Select a.Name, 
                                                        a.Description, 
                                                        a.ContentType,
                                                        a.LastModifiedDate 
                                                 From Attachment a 
                                                 where parentid=:chapterID
                                                 order by name asc];
            return CourseAttachments;
        }

    public Class__c getClassDetails(){
           Class__c classinfo=[Select
                                       ID,
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
                                       trainer__c,
                                       (Select 
                                               Name, 
                                               Class__c, 
                                               Chapter_Number__c, 
                                               Chapter_URL__c, 
                                               Course__c, 
                                               length__c, 
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
                                        id=:ChapterID
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


}