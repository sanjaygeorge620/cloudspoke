public class ProjectReference_Communications{
    ApexPages.StandardController standardController;
      private PSE_Project_Reference__c currentProject;
    public ProjectReference_Communications(ApexPages.StandardController pcfController){
        standardController = pcfController;
        this.currentProject = (PSE_Project_Reference__c)pcfController.getRecord();

    }
    
        public PSE_Project_Reference__c pse_project {
          // TODO: Provide getter/setter.  Getter should return the position using a SOQL statement that references the id.
          get{
            pse_project = [select id_External__c from PSE_Project_Reference__c where id =:ApexPages.currentPage().getParameters().get('id')];
            return pse_project;
          }set;
        }
        //pulling in data for the project for activity history
         public pse__proj__c Project {
            get {
                if (Project == null) {
                    Project = [SELECT id, 
                       (SELECT ID,
                               Subject, 
                               Activity_Subject__c,
                               whoId,
                               Who.Name,
                               whatID,
                               isClosed,
                               ActivityDate,
                               ownerid,
                               owner.name,
                               lastModifiedDate
                               FROM Tasks WHERE (WhatId = :pse_project.Id_External__c and (isClosed = True)) ORDER BY ActivityDate DESC)
                        FROM pse__Proj__c
                        WHERE id = :pse_project.Id_External__c]; 
                }
                return Project;     
            }
            set;
         }
      
    public List<Event> Events {
        get {
            if (Events == null) {
                Events = [SELECT ID, Subject, Activity_Subject__c, WhoID, Who.Name, whatId, isRecurrence, ActivityDate, ownerid, Owner.name, lastModifiedDate, EndDateTime FROM Event 
                Where (whatID = :pse_project.Id_External__c)  ORDER BY ActivityDate DESC];
            }
            return Events;
        }
        set;
    }
     
        
         /* This accessor provides the page with the ordered collection of history (apex) objects for display in the page. 
       it also processes the truncation of case comments as specified by the fullComments property value.*/
    public projHistory[] getProjHistories() {
        projHistory[] projHistories = new projhistory[]{};
        
        
        /* Task object */
        for (Task t:Project.tasks) { 
            
                addHistory(projHistories, new projhistory(t.id, t.Subject, t.Activity_Subject__c, t.WhoId,  t.Who.Name, t.whatID, t.isClosed, t.ActivityDate, t.ownerid, t.owner.name, t.lastModifiedDate)); 
         
        }
        
        /* Email Message object */
        for (Event m : Events) {
           
          addHistory(projHistories, new projhistory(m.id, m.Subject, m.Activity_Subject__c, m.WhoId,  m.Who.Name, m.whatID, m.isRecurrence, m.ActivityDate, m.ownerid, m.owner.name, m.lastModifiedDate));
          
      }
      
        return projHistories;
        }
    
    /* This method adds the newHistory object to the given projHistories collection in the appropriate order. 
       The order provided here places the oldest records at the front of the list, i.e. by date ascending. */
    private void addHistory(projHistory[] projHistories, projHistory newHistory) {
        Integer position = projHistories.size();
        for (Integer i = 0; i < projHistories.size(); i++) {
            if (newHistory.duedt > projHistories[i].duedt) {
                position = i;
                break;
            }
        }
        
        if (position == projHistories.size()) {
            projHistories.add(newHistory);
        } else {
            projHistories.add(position, newHistory);
        }
    }
     

/*commented out code
////used for open Activities


     public List<Task> openTasks {
            get {
                if (openTasks == null) {
                    openTasks = [SELECT ID,
                               Subject, 
                               Activity_Subject__c,
                               whoId,
                               Who.Name,
                               whatID,
                               isClosed,
                               ActivityDate,
                               ownerid,
                               owner.name,
                               Status__c,
                               lastModifiedDate
                               FROM Task WHERE (WhatId = :pse_project.Id_External__c and (isClosed = False)) ORDER BY LastModifiedDate ASC];
                        
                }
                return openTasks;   
            }
            set;
         }  
      public List<Event> openEvents {
        get {
            if (openEvents == null) {
                openEvents = [SELECT ID, 
                              Subject, 
                              Activity_Subject__c, 
                              WhoID, 
                              Who.Name, 
                              whatId, 
                              isRecurrence, 
                              ActivityDate, 
                              ownerid, 
                              Owner.name, 
                              lastModifiedDate, 
                              EndDateTime, 
                              status__c
                FROM Event 
                Where (whatID = :pse_project.Id_External__c and EndDateTime >= :system.Today())  ORDER BY lastModifieddate ASC];
            }
            return openEvents;
        }
        set;
    }  
*/    
    
            /* This accessor provides the page with the ordered collection of history (apex) objects for display in the page. 
       it also processes the truncation of case comments as specified by the fullComments property value.*/
/* commented out code       
    public openActivity[] getOpenActivities() {
        openActivity[] OpenActivities = new openActivity[]{};
        projHistory[] projHistories = new projhistory[]{};
*/       
        /* Task object */
/*commented out code
        for (Task ot: openTasks) { 
            
                addActivities(OpenActivities, new openActivity(ot.id, 
                                                               ot.Subject, 
                                                               ot.Activity_Subject__c, 
                                                               ot.WhoId,  
                                                               ot.Who.Name, 
                                                               ot.whatID, 
                                                               ot.isClosed, 
                                                               ot.ActivityDate, 
                                                               ot.ownerid, 
                                                               ot.owner.name, 
                                                               ot.lastModifiedDate,
                                                               ot.Status__c )); 
   
        }
        
        /* Email Message object ******
        for (Event om : openEvents) {
           
           addActivities(OpenActivities, new openActivity(om.id, 
                                                          om.Subject, 
                                                          om.Activity_Subject__c, 
                                                          om.WhoId,  
                                                          om.Who.Name, 
                                                          om.whatID, 
                                                          False, 
                                                          om.ActivityDate, 
                                                          om.ownerid, 
                                                          om.owner.name, 
                                                          om.lastModifiedDate,
                                                          om.Status__c));
                              
      
      }
      
        return OpenActivities;
        }
*/    
    /* This method adds the newHistory object to the given projHistories collection in the appropriate order. 
       The order provided here places the oldest records at the front of the list, i.e. by date ascending. */
/*commented out code      
    private void addActivities(openActivity[] OpenActivities, openActivity newActivity) {
        Integer Oposition = OpenActivities.size();
        for (Integer io = 0; io < OpenActivities.size(); io++) {
            if (newActivity.oLastModifieddt < OpenActivities[io].oLastModifieddt) {
                Oposition = io;
                break;
            }
        }
        
        if (Oposition == OpenActivities.size()) {
            OpenActivities.add(newActivity);
        } else {
            OpenActivities.add(Oposition, newActivity);
        }
    }
    
public class openActivity {
*/
    /* Properties of the class */
/*commented out code
    public String oSubject { get; private set; }
    public ID oTaskID { get; private set; }
    public String oCommunicationSubject   { get; private set; }
    public id oName   { get; private set; }
    public string oNameContact {get;private set;}
    public id oRelatedTo   { get; private set; }
    public Boolean oTask {get; public set; }
    public Date oDuedate { get; private set; }
    public Id oAssignedTo        { get; private set; }
    public String oAssignedToName        { get; private set; }  
    public Datetime oLastModifieddt         { get; private set; }
    public string oStatus         { get; private set; } 
*/    
    /* Class constructor */
/*commented out code
    public openActivity(id io,string so, string cso, ID no, string nco, ID rto, boolean to,date od, ID ao, string ano, datetime lmo, string sto  ) {
        oTaskID                 = io;
        oSubject                = so;
        oCommunicationSubject   = cso;
        oName                   = no;
        oNameContact            = (nco == null) ?null:nco;
        oRelatedTo              = rto;
        oTask                   =  (to == null) ?null:to;
        oDuedate                = od;
        oDuedt                  = (od == null)?null:od.format();
        oAssignedTo             = ao;
        oAssignedToName         = ano;
        oLastModifieddate       =lmo.format();
        oLastModifieddt         =lmo;
       oStatus                  =sto;
    }
    
    
    
    public string oLastModifieddate { get; set; }
    public string oDuedt {get;set;}
    public string lmmonthyr   { get { return oLastModifieddt.format('MMMMM yyyy'); } }
    public string lmtime      { get { return oLastModifieddt.format('h:mm a');} }
    public string lmdayfmt    { get { return oLastModifieddt.format('d - EEEE'); } }
    public integer lmmonth    { get { return oLastModifieddt.month();} }
    public integer lmyear     { get { return oLastModifieddt.year();} }
    public integer lmday      { get { return oLastModifieddt.day();} }
    
} 
 */    
     
}