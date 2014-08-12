public with sharing class mobileTrackerController {
  
  public string UserStroyId {get;set;}
  
  public mobileTrackerController(){
    this.UserStroyId = Apexpages.currentPage().getParameters().get('userStoryId');
  }
  
  @RemoteAction
  public static Requirements__c getUserStoryInfo(string strUserStroyId){
    Requirements__c lstRequir =[ SELECT Name,User_Story__c,Development_Stage__c FROM Requirements__c where ID =:strUserStroyId];
    return   lstRequir;    
  }
   
  @RemoteAction
  public static list<string> getNextAvailableStatus(string currentStage){
    Schema.DescribeFieldResult fieldResult = Requirements__c.Development_Stage__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    list<string> picklistvalues = new list<string>(); 
    for( Schema.PicklistEntry f : ple){
      picklistvalues.add(f.getLabel());
    }
    return   picklistvalues;    
  }
  
  @RemoteAction
  public static boolean updateDevelopment(string updatedStage,string userstoryId){
    try{
      list<Requirements__c> lstRequir =[ SELECT Name,User_Story__c,Development_Stage__c FROM Requirements__c where ID =:userstoryId];
      for(Requirements__c rq:lstRequir){
        rq.Development_Stage__c = updatedStage; 
      }
      update lstRequir;
      return   true; 
    }catch (exception e){
      return   false;   
    }
       
  }
  
  
   
}