public with sharing class PrintUserStoriesController {
  
  
  transient public static String INPLANNING = 'In Planning'; //status of an in planning sprint
    transient public string SprintId; //get current sprint 
    public list <Requirements__c> UserStories {get; private set;}
    public string  sfdcBaseURL {get; private set;} 
  public PrintUserStoriesController(){
    
    // get the sprint Id of form query parameter.
    SprintId = ApexPages.currentPage().getParameters().get('sprintID');
    
    if(SprintId != null && SprintId != ''){
       this.UserStories = getUserStories(SprintId);
     }else{
       this.UserStories = null;
     }
     
     this.sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
  
  }
  
  public list<Requirements__c> getUserStories(string sprintID){
    return  [select Id,Name, 
            User_Story__c,   
            Story_Points_SAP__c,
                        SFDC_Story_Points__c,
                        StoryPointsMicrostrat__c,
                        Story_points__c, 
                        Development_Stage__c,
                        Priority__c,
                        Allocated_Sprint__c ,
                        Story_Points_Dummy__c 
                        from  Requirements__c
                        where Allocated_Sprint__c =:sprintID];
  }
}