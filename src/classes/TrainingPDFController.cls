public with sharing class TrainingPDFController{
    public List<Training_Attendee__c> attendees{get;set;}
    public List<account> accounts{get;set;}
    public List<pse__Proj__c> projects{get;set;}   
    private string ClassID; 
    public TrainingPDFController (ApexPages.StandardSetController controller) {
        
        ClassID = ApexPages.currentPage().getParameters().get('id');
        
        queryPageData();
    } 
    
    public void queryPageData() {
        
        attendees = [SELECT Name,Class__r.Class_Date_Str__c,Contact__r.Name, Contact__r.FirstName, Contact__r.LastName,Attendee_Name__c, 
                            Class__r.Name, Course_Name__c, Registration__r.Account__c, Registration__r.Account__r.Name, 
                            Registration__r.Name, Class__r.Trainer__r.Name
                     FROM Training_Attendee__c                   
                     WHERE Class__c=:ClassID];           
        
        List<Id> accIDs = new List<Id>();
        
        if(attendees != null){
            for (Training_Attendee__c a : attendees){
                accIDs.add(a.Registration__r.Account__c);
            }
        }
        
        if(accIDs != null){
            accounts = [SELECT Id, Name, Local_Lang_City__c, Local_Language_Physical_State__c, CSA__c, ISR__r.Name, owner.name
                        FROM account 
                        WHERE id IN: accIDs];
        }
      
        projects = [SELECT Name, pse__Project_Manager__r.Name, pse__Project_Phase__c, pse__Account__r.id
                    FROM pse__Proj__c     
                    WHERE pse__Account__r.id IN :accIDs 
                          AND (pse__Project_Phase__c = 'Planning' 
                               OR pse__Project_Phase__c = 'Plan' 
                               OR pse__Project_Phase__c = 'Design')];        
    }
}