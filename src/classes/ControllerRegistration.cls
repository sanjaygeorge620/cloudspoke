public class ControllerRegistration {


    private boolean paidUser = false;
    public boolean showMyRegistrationRows;
    
    public Map<Id, ELearning_Registration__c> userCompletedRegistrations;
    public List<ELearning_Registration__c> allMyRegistrations;
    public List<Class__c> availableClasses;

    public Id selectedClassId {get;set;}
    public Id selectedChapterId {get;set;}
    
    public ControllerRegistration(){
            
        allMyRegistrations = 
            [select id, name, Course_Name__c, Class__r.Class_Type__c, Registration_Status__c,  Class__r.class_date__c  from ELearning_Registration__c where Applicant__c =: UserInfo.getUserId()
                order by Course_Name__c];
        
        /*commented by arun on 6-4-13
        User loggedInUser = [select id, contactId, IsPortalEnabled, Email from User where id =:UserInfo.getUserId()];
        Id contactId = null;
        
        //Portal User, use their Contact Id
        if(loggedInUser.IsPortalEnabled){
            contactId = loggedInUser.ContactId;
        }
        //Internal User, find the corresponding Contact based on email address
        else{
            List<Contact> internalContacts = [Select Id, email from Contact where email = :loggedInUser.email 
                    order by CreatedDate];
             
            //Found a Contact for this user.  Get the first one if there are multiple Contacts.  
            if(internalContacts.size()>0){
                Contact c = internalContacts.get(0);
                contactId = c.Id;
            }
            
        }
         
            
            userCompletedRegistrations = 
                new Map<Id, ELearning_Registration__c>(
                [select id, class__c, class__r.name, Course_Name__c, Registration_Status__c   from ELearning_Registration__c 
                    where Applicant__c =: UserInfo.getUserId() and Registration_Status__c = 'Completed'
                    order by Course_Name__c]);
            
        
        
        
        Set<Id> registeredClasses = new Set<Id>();
        //If contact is found, then get the registrations.  otherwise, empty registrations.
        if(contactId != null){    
        
            List<Training_Attendee__c> attendees = [Select Id, Class__c, Registration_Status__c from Training_Attendee__c 
                where Contact__c=:contactId and Registration_Status__c = 'Completed' and (Status__c = 'Enrolled' or Status__c = 'Attended')];
            for(Training_Attendee__c attendee : attendees){
                registeredClasses.add(attendee.Class__c);   
            }
        }
        availableClasses = [select id, name, Course__r.Name, Class_Date__c, Open_Seats__c, Class_Type__c, Class_Capacity__c, 
                                    Days_Until_Class__c, Training_Location__c, Training_Location__r.Name 
                            from Class__c where Id in : registeredClasses
                            order by Course__r.Name];
*/

    }

    public List<ELearning_Registration__c> getMyCompletedRegistrations(){
        if (userCompletedRegistrations!=null)
            return userCompletedRegistrations.values();
        else
            return null;
           
    }
    public List<Class__c> getAvailableClasses(){
        return availableClasses;
    }

    public List<ELearning_Registration__c> getAllRegistrations(){
        return allMyRegistrations;
    }
    
    public boolean getShowMyRegistrationRows(){
        return (allMyRegistrations!=null && allMyRegistrations.size()>0);   
    }
    
    public List<Chapter__c> getSelectedChapters(){
        String urlId = ApexPages.currentPage().getParameters().get('ClassId');
        if(urlId!=null && urlId.length()>0){
            selectedClassId = urlId;
        }
        List<Chapter__c> chapters = [select Name, Title__c, Chapter_Number__c, length__c, Class__c, Course__c
                                        from Chapter__c where Class__c = :selectedClassId and Internal_Chapter__c = false
                                        order by Chapter_Number__c asc];    
                                        
        return chapters;
    }
    
    public PageReference viewChapter(){
        PageReference pageRef;
        pageRef = new PageReference('/apex/RegistrationChapters');
        return pageRef;
        
    }
    
    public PageReference openChapter(){
        return null;
    }

}