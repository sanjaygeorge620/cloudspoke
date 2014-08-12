public class KanbanBoardCntrl {

   
    public Sprint__c spr {get; set;}
    public list <Requirements__c> BacklogList{get; set;}
    public list <Requirements__c> AwaitingDev{get; set;}
    public list <Requirements__c> InDev{get; set;}
    public list <Requirements__c> AwaitingSAT{get; set;}
    public list <Requirements__c> InSAT{get; set;}
    public list <Requirements__c> Done{get; set;}
    public list <Requirements__c> BPC{get; set;} 
    
    Public List <Requirements__c> completeUSList;
    Map<String,List<Requirements__c>> AllocatedSprintUSList ;
    Public string selvalue {get;set;}
    Public string funcSelValue {get;set;}
    public string SprintName;
    public Set <String> sprintNames = new Set<String>();
    public Set <Id> sprintIds = new Set<Id>();
    public List<Sprint__c> sprintList = new List<Sprint__c>();
    
    public KanbanBoardCntrl(ApexPages.StandardController controller) {
        spr = new Sprint__c();
        spr = [select Name, id from Sprint__c where id =: apexpages.currentpage().getparameters().get('Id')];  
        sprintList = [select Name from Sprint__c where Status__c = 'In Progress'];    
        for (Sprint__c sprint : sprintList)
        {
          if (!sprintIds.contains(sprint.Id)){
            sprintNames.add(sprint.Name);
            sprintIds.add(sprint.Id);
          }
        }
        system.debug(sprintNames.size()); 
        SprintName = spr.Name;
        system.debug('####'+SprintName);
        //if (sprintNames.contains(selvalue)){
          selvalue = SprintName;
         // }
        DispUserStories(null);
    }    
    
    // Compose Sprint Dropdown
    public List<SelectOption> getsprintval(){
        List<SelectOption> tempSOPList = new List<SelectOption>();
        tempSOPList.add(new selectOption('All','All'));

        for(String str : sprintNames){
                tempSOPList.add(new SelectOption(str,str));
        }
      return tempSOPList;
    }
    
    // Compose Functional Areas Dropdown
    public List<SelectOption> getFuncval(){
        List<SelectOption> tempSOPList = new List<SelectOption>();
        tempSOPList.add(new selectOption('All','All'));
        tempSOPList.add(new selectOption('Customer Services','Customer Services'));        
        tempSOPList.add(new selectOption('Event / Medical','Event / Medical'));       
        tempSOPList.add(new selectOption('Market Access','Market Access'));        
        tempSOPList.add(new selectOption('Marketing / Multichannel','Marketing / Multichannel'));      
        tempSOPList.add(new selectOption('SFA','SFA'));     
        tempSOPList.add(new selectOption('Analytics / Insights','Analytics / Insights'));
        return tempSOPList;
    }
    
  // Display all user stories taking into account filters  
  Public void DispUserStories(string selvalx){
    if(selvalue ==null)
        selvalue ='All';
    if(funcSelValue ==null)
        funcSelValue ='All';
    
    // Find all requirements linked to the selected sprint
    List<Requirements__c> AllocatedSprintUSList  = [Select id, Name, User_Type__c, Allocated_Sprint__c , Development_Stage__c, Functional_Area__c, So_that__c,User_Story__c, Allocated_Sprint__r.Name from Requirements__c where Allocated_Sprint__c in: sprintids];
    
    List<Requirements__c> TempList = new List<Requirements__c>();
    List<Requirements__c> TempList2 = new List<Requirements__c>();
    
    // Create a subset of user stories based on filters
    if (selvalue == 'All'){
      TempList.addAll (AllocatedSprintUSList);
    }
    else{
    system.debug('########'+AllocatedSprintUSList+'selvalue selvalue selvalue '+selvalue);
      for (Requirements__c req : AllocatedSprintUSList){
        if (selvalue != null && selvalue != 'All'){
          if (req.Allocated_Sprint__r.Name == selvalue){
            TempList.add(req);
          }
        }
      }
    }
    
    if (funcSelValue == 'All'){
      TempList2 = Templist;
    }
    else{
      for (Requirements__c req : TempList){
        if (funcSelValue != null && funcSelValue != 'All'){
          if (req.Functional_Area__c == funcSelValue){
            TempList2.add(req);
          }
        }
      }
   }
    
  
    
    BacklogList = new list <Requirements__c>();
   AwaitingDev = new list <Requirements__c>();
    InDev = new list <Requirements__c>();
    AwaitingSAT = new list <Requirements__c>();
    InSAT = new list <Requirements__c>();
    Done = new list <Requirements__c>();
    BPC = new list <Requirements__c>();
    
    system.debug('######'+TempList2);
    
    // Compose a list per status
    for(Requirements__c req : TempList2){
        if(req.Development_Stage__c.contains('Backlog'))
            BacklogList.add(req);
        else if(req.Development_Stage__c.contains('Awaiting Dev'))
            AwaitingDev.add(req);
        else if(req.Development_Stage__c.contains('In Dev'))
            Indev.add(req);
        else if(req.Development_Stage__c.contains('Awaiting SAT'))
            AwaitingSAT.add(req);
        else if(req.Development_Stage__c.contains('In Test'))
            InSAT.add(req);
        else if(req.Development_Stage__c.contains('Done'))
            Done.add(req);
        else if(req.Development_Stage__c.contains('BPC'))
            BPC.add(req);
    }
    system.debug('######'+BacklogList);
  }
  
  // Method to change user story selection after changing dropdown values
  Public void filteredVal(){
    
    if(selvalue != null && selValue != 'All')
        DispUserStories(selvalue);
        
     else if(selvalue == null || selValue == 'All')
         DispUserStories(null);
    
    }  
 
 public void updateUserStoriesSprint(){
     String  UpdateSwing     = Apexpages.currentPage().getParameters().get('UpdateSwing');
     String  userStroyID     = Apexpages.currentPage().getParameters().get('UserStoryID');
     Requirements__c req = new Requirements__c(id=userStroyID);
     
     if(UpdateSwing == 'AwaitingDevUS')
         req.Development_Stage__c = '5.3 Sprint Team - Awaiting Development';
     else if(UpdateSwing == 'InDevUS')
         req.Development_Stage__c = '5.4 Sprint Team - In Development';
     else if(UpdateSwing == 'BacklogUS')
         req.Development_Stage__c = '3. Backlog - Awaiting ordering';
     else if(UpdateSwing == 'AwaitingSATUS')
         req.Development_Stage__c = '7. Sprint - Awaiting SAT';
     else if(UpdateSwing == 'InSATUS')
         req.Development_Stage__c = '8. Sprint - In Test';
     else if(UpdateSwing == 'DoneUS')
         req.Development_Stage__c = '9. Done';
          else if(UpdateSwing == 'BPC')
         req.Development_Stage__c = '5.2 Sprint Team - With BPC';
     update req;
     }
     public void addChatterComment(){
        String  chatterComment  = Apexpages.currentPage().getParameters().get('ChatterComment');
        String  userStroyID     = Apexpages.currentPage().getParameters().get('UserStoryID');
        
        if( chatterComment != '' &  userStroyID != ''){
            try{
                FeedItem post = new FeedItem();
                post.ParentId = userStroyID; //user stroy id.
                post.Body = chatterComment;  //chatter comment.
                insert post;
            }catch (System.Dmlexception e){
                System.debug(e);                
            }   
            
        }
        
    }
}