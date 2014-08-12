public with sharing class Design_Controller{

  
  public  String currentStatus {get;set;}
  public  String currentSprint {get;set;}
  public  String StatusName {get;set;}
  public string SprintName {get;set;}
  public string SpName {get;set;}
  
  Boolean isSelectedDesignDetails = true ; 
  public Boolean getIsSelectedDesignDetails() { 
        return this.isSelectedDesignDetails;    
    }
   public void setIsSelectedDesignDetails(Boolean b) {       
        this.isSelectedDesignDetails = b;    
    }
  
  Boolean isSelectedDesignComponent = true ; 
  public Boolean getIsSelectedDesignComponent() { 
        return this.isSelectedDesignComponent;    
    }
   public void setIsSelectedDesignComponent(Boolean b) {       
        this.isSelectedDesignComponent = b;    
    }
  
  
  Boolean isSelectedDesignname = true ; 
  public Boolean getIsSelectedDesignname() { 
        return this.isSelectedDesignname;    
    }
   public void setIsSelectedDesignname(Boolean b) {       
        this.isSelectedDesignname = b;    
    }
    
  Boolean isSelectedAcceptance = true ; 
  public Boolean getIsSelectedAcceptance() { 
        return this.isSelectedAcceptance;    
    }
   public void setIsSelectedAcceptance(Boolean b) {       
        this.isSelectedAcceptance = b;    
    } 
  
  public List<SelectOption> getSprint(){
     list<SelectOption> options = new List<SelectOption>();
     list<Sprint__c> sprintname = [select Name from Sprint__c where (Status__c ='In Progress' or Status__c ='Complete') order by Name asc];
      for(Sprint__c sp: sprintname ){
          options.add(new SelectOption(sp.Id,sp.Name));
          }
     list<Project__c> projectname = [select Name from Project__c order by Name asc];
       for(Project__c proj: projectname){
          options.add(new SelectOption(proj.Id,proj.Name));
          }
           return options;
         }
         
   public List<SelectOption> getStatus(){
     list<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Backlog','Backlog'));
        options.add(new SelectOption('With BA','With BA'));
        options.add(new SelectOption('Ready for development','Ready for development'));
        options.add(new SelectOption('In development','In development'));
        options.add(new SelectOption('Built - Ready for internal QA','Built - Ready for internal QA'));
        options.add(new SelectOption('Built - Ready for acceptance','Built - Ready for acceptance'));
        options.add(new SelectOption('Passed (complete)','Passed (complete)'));
        options.add(new SelectOption('Closed - Invalid','Closed - Invalid'));
     
           return options;
      }
         
     public pageReference converTWord(){    
         pageReference pr;
         String sName;
         try{
         Sprint__c sp = [select name from Sprint__c where id =:currentSprint ];
         sName = sp.Name;
         }Catch(System.QueryException e){
         Project__c proj = [select name from Project__c where id =:currentSprint ];
          sName = proj.Name;
         }
         pr = new pageReference('/apex/ConvertToWord?SprintName='+ currentSprint+'&SpName='+sName+'&StName='+currentStatus );
         pr.setRedirect(false);
         return pr;
         pr.setRedirect(true);
         return pr;
         }
         
      public pageReference redirectDesign(){
         pageReference pr;
         String sName;
         try{
         Sprint__c sp = [select name from Sprint__c where id =:currentSprint ];
         sName = sp.Name;
         }Catch(System.QueryException e){
         Project__c proj = [select name from Project__c where id =:currentSprint ];
          sName = proj.Name;
         }
         pr = new pageReference('/apex/DesignDetail?SprintName='+ currentSprint+'&SpName='+sName+'&StName='+currentStatus );
         pr.setRedirect(false);
         return pr;
         }
         
       public string SprName{ get{
       return Apexpages.currentPage().getParameters().get('SpName');
          }}    
       
      public list<string> getUserStory(){
      SprintName = Apexpages.currentPage().getParameters().get('SprintName');
      StatusName = Apexpages.currentPage().getParameters().get('StName');
      list<string> uName = new list<string>();
      if(StatusName == 'All'){
        list<Requirements__c> uStory1 = [select Name from Requirements__c where 
                                         (Allocated_Sprint__c =: SprintName or Project__c =:SprintName) ];
          for(Requirements__c requ : uStory1)
            uName.add(requ.Name);
             return uName ;}
       else{
        list<Requirements__c> uStory2 = [select Name from Requirements__c where 
                                         ((Allocated_Sprint__c =: SprintName or Project__c =:SprintName) and Development_Stage__c =: StatusName)];
          for(Requirements__c requ : uStory2)
            uName.add(requ.Name);
             return uName ;
         }
                                                     
           } 
         
          public map<string,Requirements__c> getUserStoryDesign2(){
           SprintName = Apexpages.currentPage().getParameters().get('SprintName');
           StatusName = Apexpages.currentPage().getParameters().get('StName');
             map<string,Requirements__c> tempmap = new map<string,Requirements__c>();
            
             if(StatusName == 'All'){
             list<Requirements__c> uStory1 = [select Name,Acceptance_Criteria__c,User_Story__c from Requirements__c where 
                                                (Allocated_Sprint__c =: SprintName or Project__c =:SprintName) ];
              list<string> utemp = new list<string>();
               for(Requirements__c requ : uStory1)
                 tempmap.put(requ.Name,requ);
                 return tempmap;}
               else{
             list<Requirements__c> uStory2 = [select Name,Acceptance_Criteria__c,User_Story__c from Requirements__c where 
                                                ((Allocated_Sprint__c =: SprintName or Project__c =:SprintName) and Development_Stage__c =: StatusName)  ];
              list<string> utemp = new list<string>();
               for(Requirements__c requ : uStory2)
                 tempmap.put(requ.Name,requ);
                 return tempmap;
                     }                           
              
              }
           
           
        public map<string,UserStory2Design__c> getUserStoryDesign(){
          SprintName = Apexpages.currentPage().getParameters().get('SprintName');
           StatusName = Apexpages.currentPage().getParameters().get('StName');
           map<string,UserStory2Design__c> tempmap = new map<string,UserStory2Design__c>();
           
           if(StatusName == 'All'){
           list<Requirements__c> uStory1 = [select Name,User_Story__c from Requirements__c where 
                                              (Allocated_Sprint__c =: SprintName or Project__c =:SprintName) ];
           
           list<string> utemp = new list<string>();
            for(Requirements__c requ : uStory1)
            utemp.add(requ.Name);
           list<UserStory2Design__c> uDesign1;
           if(!test.isRunningTest()){
                                    uDesign1 = [select  User_Story__c,Req_Summary__c,User_Story__r.Name,
                                                     Design__r.Name,Design__r.Design_Summary__c,
                                                     Design__r.Visualforce_Pages__c,
                                                     Design__r.Apex_Classes__c,
                                                     Design__r.Other_Components__c,
                                                     Design__r.Design_Details__c 
                                                     from UserStory2Design__c where 
                                                     (User_Story__r.Allocated_Sprint__c =: SprintName or User_Story__r.Project__c =:SprintName) ];
                                                     }else{
                                    uDesign1 = [select  User_Story__c,Req_Summary__c,User_Story__r.Name,
                                                     Design__r.Name,Design__r.Design_Summary__c,
                                                     Design__r.Visualforce_Pages__c,
                                                     Design__r.Apex_Classes__c,
                                                     Design__r.Other_Components__c,
                                                     Design__r.Design_Details__c 
                                                     from UserStory2Design__c where 
                                                     (User_Story__r.Allocated_Sprint__c =: SprintName or User_Story__r.Project__c =:SprintName) limit 5 ];
                                                     }
              
             
               for(UserStory2Design__c ud : uDesign1 ){
                 for(string req: utemp){
                 if(ud.User_Story__r.Name == req){
                 tempmap.put(req,ud);
                    }
                }
                }
                 for(string req: utemp ){
                   if(!(tempmap.containsKey(req))){
                     UserStory2Design__c  objUSD =  new UserStory2Design__c ();
                      tempmap.put(req,objUSD);}}
                    return tempmap;
               }
               else{
               list<Requirements__c> uStory2 = [select Name,User_Story__c from Requirements__c where 
                                              ((Allocated_Sprint__c =: SprintName or Project__c =:SprintName) and Development_Stage__c =: StatusName) ];
           
           list<string> utemp = new list<string>();
            for(Requirements__c requ : uStory2)
            utemp.add(requ.Name);
           
           list<UserStory2Design__c> uDesign2;
            if(!test.isRunningTest()){
                                         uDesign2 = [select  User_Story__c,Req_Summary__c,User_Story__r.Name,
                                                     Design__r.Name,Design__r.Design_Summary__c,
                                                     Design__r.Visualforce_Pages__c,
                                                     Design__r.Apex_Classes__c,
                                                     Design__r.Other_Components__c,
                                                     Design__r.Design_Details__c 
                                                     from UserStory2Design__c where 
                                                     ((User_Story__r.Allocated_Sprint__c =: SprintName or User_Story__r.Project__c =:SprintName) and  User_Story__r.Development_Stage__c =: StatusName)];
                                                     }else{
                                         uDesign2 = [select  User_Story__c,Req_Summary__c,User_Story__r.Name,
                                                     Design__r.Name,Design__r.Design_Summary__c,
                                                     Design__r.Visualforce_Pages__c,
                                                     Design__r.Apex_Classes__c,
                                                     Design__r.Other_Components__c,
                                                     Design__r.Design_Details__c 
                                                     from UserStory2Design__c where 
                                                     ((User_Story__r.Allocated_Sprint__c =: SprintName or User_Story__r.Project__c =:SprintName) and  User_Story__r.Development_Stage__c =: StatusName)
                                                     LIMIT 5];
                                                     }
                                                     
                                                     
              
             
               for(UserStory2Design__c ud : uDesign2 ){
                 for(string req: utemp){
                 if(ud.User_Story__r.Name == req){
                 tempmap.put(req,ud);
                    }
                }
                }
                 for(string req: utemp ){
                   if(!(tempmap.containsKey(req))){
                     UserStory2Design__c  objUSD =  new UserStory2Design__c ();
                      tempmap.put(req,objUSD);}}
                    return tempmap;
               }
             }                                                    
         
    }