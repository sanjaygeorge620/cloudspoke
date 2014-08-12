/**************************************************************************************
Apex Class Name     :   Sprint Planning
Version             :   1.0  
Created Date        :   18/02/2012
Function            :   Contains functionality to Drag and Drop User Stories from Proposed Sprint to 
                        Allocated Sprints
******************************************************************************/

public with sharing class sprintPlanning{
    
    public static String INPLANNING = 'In Planning'; //status of an in planning sprint
    
    //get set for current sprint drop down/picklist
    public  String currentSprint {get;set;}
    
    //get set for current project drop down/picklist
    public  String currentProject {get;set;}
    
    public Sprint__c spr {get; private set;}
    public list <Requirements__c> req {get; private set;}
    public list <Requirements__c> notAllocatedUS {get; private set;}
    public integer TotalCountAllocatedUSie{get; private set;}
    public integer TotalCountNonAllocatedUSie{get; private set;}
   
    //constructor to allow passing in selected sprint as a query string
    public sprintPlanning(){
         String sprintID = ApexPages.currentPage().getParameters().get('sprintID');
         if(sprintID != null && sprintID != ''){
            this.currentSprint = sprintID;
            getSelectedSprint();
         }
    }
    
    public Boolean getCurrentSprintInPlanning(){
        if(spr!=null)
            return spr.Status__c == INPLANNING;
        else
            return false;
    }
     
    public List<SelectOption> getProject(){
        list<SelectOption> options = new List<SelectOption>();
        Set<id> projectid = new Set<id>();
        options.add(new SelectOption('0','Select Project'));
        list<Sprint__c> sprintname = [select Name,Project__c from Sprint__c where Status__c ='In Planning' order by Name asc];
        for(Sprint__c spr : sprintname)
             projectid.add(spr.Project__c);
        list<Project__c> projectname = [select Name from Project__c where id =:projectid  order by Name asc];
        for(Project__c pro: projectname){
            options.add(new SelectOption(pro.Id,pro.Name));
        }
        return options;
    }
    
    public List<SelectOption> getSprint(){
        list<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','Select Sprint'));
        list<Sprint__c> sprintname = [select Name from Sprint__c where (Status__c ='In Planning' and Project__c =: currentProject)  order by Name asc];
         for(Sprint__c sp: sprintname ){
            options.add(new SelectOption(sp.Id,sp.Name));
        }
        return options;
    }
    
    public Sprint__c getSelectedSprint(){
       try{
            if(this.spr == null){
                 Sprint__c sprintname = [select Name,Tech1_Story_Points__c,Tech2_Story_Points__c,Tech3_Story_Points__c,Tech4_Story_Points__c,Status__c from Sprint__c where id =: currentSprint  order by Name asc];
                 this.spr = sprintname;
            }
             return this.spr;
        }Catch(System.QueryException e){
            return null;}
        }
    
    public list<Requirements__c> getAllocatedUserStory() {
        if(currentSprint != null){
            list <Requirements__c> require = [select Id,Name ,User_Story__c, 
                                                    Acceptance_Criteria__c,
                                                    Story_Points_SAP__c,
                                                    SFDC_Story_Points__c,
                                                    StoryPointsMicrostrat__c,
                                                    Story_points__c, 
                                                    Development_Stage__c,
                                                    Priority__c,
                                                    Allocated_Sprint__c ,
                                                    Story_Points_Dummy__c,
                                                    Master_Priority__c
                                                    from 
                                                    Requirements__c
                                                    //(Planned_Sprint_del__c =:currentSprint and 
                                                    where 
                                                    Allocated_Sprint__c =:currentSprint 
                                                    order by Master_Priority__c asc];
                
            this.req = require;
            this.TotalCountAllocatedUSie = require.size();
            return require;}
            else
            return null;
      }
    
    public list<Requirements__c> getNotAllocatedUserStory(){
          if(currentSprint != null){
            list <Requirements__c> req = [select Id,Name,User_Story__c,
                                                Acceptance_Criteria__c,
                                                Story_Points_SAP__c,
                                                SFDC_Story_Points__c,
                                                Development_Stage__c,
                                                StoryPointsMicrostrat__c,
                                                Story_points__c,
                                                Story_Points_Dummy__c,
                                                Allocated_Sprint__c ,
                                                Priority__c,
                                                Master_Priority__c
                                                from 
                                                Requirements__c
                                                where (Planned_Sprint_del__c = : currentSprint 
                                                and (Allocated_Sprint__c = null OR Allocated_Sprint__c = '') 
                                                and Development_Stage__c != 'Closed - Invalid' 
                                                //and Av_Market_Priority_Score__c != 0
                                                ) 
                                                order by Master_Priority__c asc ];
                                                
            this.notAllocatedUS = req;
            this.TotalCountNonAllocatedUSie =  req.size();               
            return req;
        }   else
            return null;
    }
    
    
    
   
     public integer getsfdcPlanned(){
      integer total = 0;
      if(req != null){
      for(Requirements__c r : req){
          if (r.SFDC_Story_Points__c != null && r.SFDC_Story_Points__c != '0')
         total = total + integer.valueof(r.SFDC_Story_Points__c);
         }
        return total;
        }
        else
           return total;
      }
      
     public integer getsfdcRemain(){
        if(spr!= null && (spr.Tech2_Story_Points__c != null || spr.Tech2_Story_Points__c != 0)){
          return integer.valueof(spr.Tech1_Story_Points__c) - getsfdcPlanned();
           }
        else {
          return 0- getsfdcPlanned();}
          
       }
      
       
      public integer getsapPlanned(){   
      integer total = 0;
      if(req != null){
      for(Requirements__c r : req){
          if (r.Story_Points_SAP__c != null)
         total = total + integer.valueof(r.Story_Points_SAP__c);
         }
        return total;
        }
        else
           return total;
      }
      
      public integer getsapRemain(){
      if(spr != null && spr.Tech2_Story_Points__c != null)
       return  integer.valueof(spr.Tech2_Story_Points__c) - getsapPlanned();
       else
        return 0 - getsapPlanned();
       }
      
    
      public integer getflexPlanned(){  
      integer total = 0;
      if(req != null){
      for(Requirements__c r : req){
          if (r.Story_points__c != null)
         total = total + integer.valueof(r.Story_points__c);
         }
        return total;
        }
        else
           return total;
      }
      
      public integer getflexRemain(){
      if(spr != null && spr.Tech3_Story_Points__c != null)
       return  integer.valueof(spr.Tech3_Story_Points__c) - getflexPlanned();
       else
        return 0 - getflexPlanned();
        }
       
     
      public integer getmicrostatPlanned(){   
      integer total = 0;
      if(req != null){
      for(Requirements__c r : req){
          if (r.StoryPointsMicrostrat__c != null)
         total = total + integer.valueof(r.StoryPointsMicrostrat__c);
         }
        return total;
        }
        else
           return total;
      }
      
   public integer getmicrostatRemain(){
        if(spr != null && spr.Tech4_Story_Points__c != null)
            return  integer.valueof(spr.Tech4_Story_Points__c) -  getmicrostatPlanned();
        else
            return 0 - getmicrostatPlanned();
    }          
    public PageReference syncUserStory() {
        return null;
    }
    public void autoPlan(){
      
      list<Requirements__c> allocatedlist = new list<Requirements__c>();
      integer sfdcrem = getsfdcRemain();
      integer saprem  = getsapRemain();
      integer flexrem = getflexRemain();
      integer  microstatrem = getmicrostatRemain();
      Savepoint sp = Database.setSavepoint();
      
      try{
        for (Requirements__c nonall : notAllocatedUS){
         if ((sfdcrem >= integer.valueof((nonall.SFDC_Story_Points__c)!=null? nonall.SFDC_Story_Points__c : '0')) 
                    && (saprem  >= integer.valueof((nonall.Story_Points_SAP__c)!=null? nonall.Story_Points_SAP__c :'0')) 
                    && (flexrem >= integer.valueof((nonall.Story_points__c)!=null? nonall.Story_points__c : '0')) 
                    && (microstatrem >=  integer.valueof((nonall.StoryPointsMicrostrat__c)!=null? nonall.StoryPointsMicrostrat__c: 0))){
             nonall.Allocated_Sprint__c = currentSprint;
             //nonall.Planned_Sprint_del__c = null;
             allocatedlist.add(nonall);
             sfdcrem = sfdcrem - integer.valueof((nonall.SFDC_Story_Points__c)!=null? nonall.SFDC_Story_Points__c : '0');
             saprem  = saprem - integer.valueof((nonall.Story_Points_SAP__c)!=null? nonall.Story_Points_SAP__c :'0');
             flexrem = flexrem - integer.valueof((nonall.Story_points__c)!=null? nonall.Story_points__c : '0');
             microstatrem = microstatrem - integer.valueof((nonall.StoryPointsMicrostrat__c)!=null? nonall.StoryPointsMicrostrat__c :0);
          }
        }
        update allocatedlist;
      }catch (System.Dmlexception e){
            System.debug(e);
            Database.rollback(sp);
      }
      
        
    }
    public void updateUserStoriesSprint(){
        
        Savepoint sp = Database.setSavepoint();
        try {
            String  UpdateSwing     = Apexpages.currentPage().getParameters().get('UpdateSwing');
            String  userStroyID     = Apexpages.currentPage().getParameters().get('UserStoryID');
            list <Requirements__c> listdraggedUserStory = [select Id from Requirements__c where Id =:userStroyID];  
            
            if(listdraggedUserStory.size()>0){
                if(UpdateSwing == 'AllocateUSies'){
                   listdraggedUserStory[0].Allocated_Sprint__c = currentSprint;
                    /*
                        We only want to update the Allocated Sprint and Keep the UnPlanned Sprint value as it is.  
                        listdraggedUserStory[0].Planned_Sprint_del__c = currentSprint;
                    */
                    update listdraggedUserStory;                    
                } 
               
               if(UpdateSwing == 'NonAllocateUSies'){
                    
                    listdraggedUserStory[0].Allocated_Sprint__c = null;
                    listdraggedUserStory[0].Planned_Sprint_del__c = currentSprint ;
                    update listdraggedUserStory;
                }   
            }
        }catch (System.Dmlexception e){
            System.debug(e);
            Database.rollback(sp);
        }
    }
    
    // Function to add chatter feeditem to the User Story Record.
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