public  class TechnicalDocumentController {
    private String                          soql                    {get;set;}
    public list<cUS>                        lstUS                   {get;set;}
    private list<Requirements__c>           lstFullUS               {get;set;}
    public list<Requirements__c>            selectedUS              {get;set;}
    private set<Requirements__c>            selectedSetUS           {get;set;}
    
    public Requirements__c                  initUS                  {get;set;}
    
    public list<id>                         lstSprint               {get;set;}
    public list<SelectOption>               optionsAllocatedSprint  {get;set;}
    list<string>                            DevelopmentStage        {get;set;}
    
    public list<cUS>                        userStoriesList         {get;set;}
    public map<string,Id> MapSelOps = new Map<string,Id>();
    public map<Design__c,list<Requirements__c>> designQuery         {get;set;} 
   
   // Map added to show Functional Document . 
    public map<string,list<Requirements__c>> Func_UserStory         {get;set;} 
    
    public string AuthorRole                                        {get;set;}
    public string Author                                            {get;set;}
    public string ReviewAuthorRole1                                 {get;set;}
    public string ReviewAuthor1                                     {get;set;}
    public string ReviewAuthorRole2                                 {get;set;}
    public string ReviewAuthor2                                     {get;set;}
    public string ReviewAuthorRole3                                 {get;set;}
    public string ReviewAuthor3                                     {get;set;}
    public string ReviewAuthorRole4                                 {get;set;}
    public string ReviewAuthor4                                     {get;set;}
    public string ReviewAuthorRole5                                 {get;set;}
    public string ReviewAuthor5                                     {get;set;}
    
    public string Project_Name {get;set;}  // added by Ankit khandelwal Dec-06-2012
    public string Deliverable_Id {get;set;}  // added by Ankit khandelwal Dec-06-2012
    public string Version{get;set;}  // added by Ankit khandelwal Dec-06-2012 
    public string Change_Desp{get;set;} // added by Ankit khandelwal Dec-06-2012
    public boolean SelectAll {get;set;} // added by Ankit khandelwal Dec-11-2012
    public string Organization {get; set;}
    public List<SelectOption> ProjNameList = new List<SelectOption>();
    public boolean DefinitionsExist {get;set;} // added by Vasudha to render definitions table or not
    public boolean ReferencesExist {get;set;} // added by Fatou to render refrences table or not
    
    public List<SelectOption> getProjNameList(){
        List<SelectOption> TempSelOpt = new List<SelectOption>();
        TempSelOpt.add(new SelectOption('--None--', '--None--'));
        for(Project__c proj : [select id,Name from Project__c]){
        TempSelOpt.add(new SelectOption(proj.Name, proj.Name));
        MapSelOps.put(proj.Name,proj.Id);
        }
        return TempSelOpt;
    }  
    
    public list<cUS> getUserStories() {
      /*  if(userStoriesList == null) {
            userStoriesList = new list<cUS>();
            
            if(lstFullUS == null) {
                lstFullUS = new list<Requirements__c>();
                lstFullUS = Database.query(soql);
            }
        } */
        userStoriesList = new list<cUS>();
        if (lstFullUS != null){
            for(Requirements__c s: lstFullUS) {
                userStoriesList.add(new cUS(s,SelectAll));
            }
       }    
        return userStoriesList;
    }
    
    public TechnicalDocumentController() {
    
        
        soql = 'SELECT Name, User_Type__c, Story_Points_Dummy__c, User_Story__c,User__r.Name,Supporting_BA__r.name,Developer_Name__c,Functional_Area__c,Story_Points_Dummy__c, So_that__c, Development_Stage__c, Allocated_Sprint__c FROM Requirements__c';
        initUS = new Requirements__c();
        selectedUS = new list<Requirements__c>();
        selectedsetUS = new set<Requirements__c>();
        optionsAllocatedSprint = new list<selectOption>();
        initAllocatedSprint();
        selectAll = false;
        lstFullUS = Null;
        userStoriesList = Null;
    }
    
   private void initAllocatedSprint() {
        lstSprint = new list<id>();     
        
        for(Sprint__c s: [SELECT Name FROM Sprint__c]) {
            optionsAllocatedSprint.add(new SelectOption(s.Id,s.Name));  
        }
    } 
    
    public void createQuerySOQL() {
        // Set up SOQL
        System.Debug('lstSprint list: ' + lstSprint);
        soql = 'SELECT Name, Story_Points_Dummy__c, User_Type__c, User_Story__c, So_that__c, Development_Stage__c, Allocated_Sprint__c FROM Requirements__c ';
        
        if(lstSprint.size() > 0) {
            soql = soql + ' WHERE Allocated_Sprint__c IN :lstSprint ';
        }
        
        
        if (initUS.Development_Stage__c != null){
           
             if(lstSprint.size() > 0) {
                soql = soql +  ' AND Development_Stage__c = \'' + initUS.Development_Stage__c + '\' ';
            }
            else {
                soql = soql +  ' WHERE Development_Stage__c = \'' + initUS.Development_Stage__c + '\' ';
            }   
        }
        
        if(initUS.Functional_Area__c != null) {
            if(lstSprint.size() > 0 || initUS.Development_Stage__c != null) {
                soql = soql +  ' AND Functional_Area__c = \'' + initUS.Functional_Area__c + '\' ';
            }
            else {
                soql = soql +  ' WHERE Functional_Area__c = \'' + initUS.Functional_Area__c + '\' ';
            }   
        }
        
        if(initUS.Sub_Process__c != null) {
            soql = soql + ' AND Sub_Process__c = \'' + initUS.Sub_Process__c + '\' ';
        }
        
        if(sortField != null) {
            soql = soql + sortField;
        }
        
        System.Debug('SOQL value: ' +  soql);
        System.Debug('initUS: ' + initUS);
        createQuery();
    }
    
    private void createQuery() {
        try {
            lstFullUS = new list<Requirements__c>();
            lstFullUS = Database.Query(soql);
            if (lstFullUS.size()==0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'NO Records found'));      
        } 
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Oooooooooops. Seems like the SOQL Query was wrongly created.'));
        }
    }
    
    public String sortDir {
        get {
            if (sortDir == null) {
                sortDir = 'ASC';
            }
            return sortDir;
        }
        set;
    }
    
    public String sortField {
        get {
            if(sortField == null) {
                sortField = 'Name';
            }
            return ' ORDER BY ' + sortField + ' ' + sortDir;
        }
        set;
    }
    
    public void toggleSort() {
        sortDir = sortDir.equals('ASC') ? 'DESC' : 'ASC';
        createQuery();
    }
    
    public PageReference processSelected() {        
        // Iterate through the list of US and see if they are selected, if so add them to the newly created list
        
        for(cUS cUserStory: userStoriesList) {
            if(cUserStory.selected == true) {
                // See if item is not yet in the table
                selectedSetUS.add(cUserStory.reqUS);
            }
        }
        selectedUS = new list<Requirements__c>();
        selectedUS.addAll(selectedSetUS);
        
        System.Debug('Selected List of US: ' + selectedUS);
        selectAll = false;
        return null;
    }
    
    public class cUS {
        public Requirements__c reqUS {get; set;}
        public Boolean selected {get; set;}
        
        public cUS(Requirements__c r) {
            reqUS = r;
            selected = false;
        }
        
        public cUS(Requirements__c r,boolean b) {
            reqUS = r;
            selected = b;
        }
    }
    
 
    
    Public List<Definitions__c> Definitions {get;set;}
    Public List<References__c> References {get;set;} 
    public pagereference TempPage(){
        Version = '1.0';
        Organization='Lexmark';
        Project_Name = ApexPages.currentPage().getParameters().get('Project');
        Requirements__c c = [select id from Requirements__c where id = :ApexPages.currentPage().getParameters().get('Ids')];
        selectedUS.add(c);
        createDocument();
        PageReference p = Page.TechnicalDesignDocumentPDF;
                       //  p.setRedirect(true);
                        return p;
    }
    
    
    public Pagereference createDocument() {
        Definitions = new List<Definitions__c>();
        References = new List<References__c>();  
        designQuery = new map<Design__c,list<Requirements__c>>();
        list<id> idUS = new list<id>();
        Set <Id> US_With_Design = new Set<Id> ();
        List <string> US_NOT_DONE = new list <string> ();
        String Str = '';
        
      if (Version != '' && Organization !='' && selectedUS.size()>0 && Project_Name != '--None--') {
         
        for(Requirements__c s: selectedUS) {
             idUS.add(s.id);
            }
            
        for(UserStory2Design__c u: [SELECT User_Story__c,User_Story__r.name,User_Story__r.Allocated_Sprint__r.Name,User_Story__r.Rally_ID__c,User_Story__r.Planned_Sprint_del__r.Name,User_Story__r.Functional_Area__c,User_Story__r.Sub_Process__c,Id, Design__c,Design__r.name, Design__r.Overview__c, Design__r.Data_Model__c, Design__r.Objects__c, Design__r.Fields__c, Design__r.Page_Layouts__c,Design__r.Design_Details__c,Design__r.Design_Summary__c,
                                            Design__r.Apex_Classes__c, Design__r.Visualforce_Pages__c, Design__r.Apex_Trigger__c, Design__r.Other_Components__c
                                            FROM UserStory2Design__c WHERE User_Story__c IN :idUS Order By User_Story__r.name,User_Story__r.Planned_Sprint_del__r.Name, User_Story__r.Allocated_Sprint__r.Name,User_Story__r.Functional_Area__c,User_Story__r.Sub_Process__c ]) {
                    if(designQuery.containsKey(u.Design__r)) {
                        designQuery.get(u.Design__r).add(u.User_Story__r);
                        // US_With_Design.Add(u.User_Story__r);
                    }
                    else {
                        list<Requirements__c> newList = new list<Requirements__c>();
                        newList.add(u.User_Story__r);
                        designQuery.put(u.Design__r, newList);
                       // US_With_Design.AddAll(newList);
                    }
                }
                
                for (Design__c D: designQuery.keyset()){
                        for (Requirements__c R : designQuery.get(D)){
                          US_With_Design.add(R.Id);
                        }
                  }
                
                system.debug('Design Query ' +designQuery);
                system.debug('US with design ....' + US_With_Design);
                for (Requirements__c US:selectedUS){
                   if (!US_With_Design.contains(US.Id)){
                       US_NOT_DONE.add(US.id);
                       str = str + US.Name + ' ,';
                      }
                     }
                 
                 system.debug('US NOT DONE ' + US_NOT_DONE);   
                 if(US_NOT_DONE.size()>0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please only select user stories which have a Design related to it.<br/> Below US do not have a design:' + str));
                    return null;
                    }  
                else {
                        if(Project_Name <> null && Project_Name != '--None--'){
                                Definitions = [select id,Name,Project__c,Term_Acronym__c,Project__r.Name from Definitions__c where Project__c =: MapSelOps.get(Project_Name)];
                                if(Definitions.size()>0){
                                    DefinitionsExist = true;
                                }
                                References  = [select id,Name,Document_ID__c,Project__c,Project__r.Name from References__c where Project__c =: MapSelOps.get(Project_Name)];
                                if(References.size()>0){
                                    ReferencesExist =true;
                                }
                        }  
                       PageReference p = Page.TechnicalDesignDocumentPDF;
                       //  p.setRedirect(true);
                        return p;
                    }  
        }
            
            else {
            
                if(selectedUS.size()==0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least one user story'));
                }
                if(Version == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Version'));
                }
                if(Organization == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter an Organization'));
                }
                if(Project_Name == '--None--'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Project Name'));
                }
                return null;
            
            }
        
    }
    
    
    public pagereference CreateFunctionalDocument () {
        Definitions = new List<Definitions__c>();
        References = new List<References__c>();  
        Func_UserStory = new map<string,list<Requirements__c>> (); 
        set<id> idUS = new set<id>();
        if (Version != '' && Organization !='' && selectedUS.size()>0 && Project_Name != '--None--')
        {
            for(Requirements__c s: selectedUS) {
                idUS.add(s.id);
            }
           system.debug('---IdUS---'+ idUS);
           for(Requirements__c R: [SELECT Id, Story_Points_Dummy__c, User_Type__c,So_that__c,User_Story__c,Name,Planned_Sprint_del__r.Name,Allocated_Sprint__r.Name,Functional_Area__c,
                                          Sub_Process__c,Acceptance_Criteria__c,Compliance_Criteria__c   
                                          FROM Requirements__c 
                                          WHERE Id IN :idUS Order By Name,Planned_Sprint_del__r.Name,Allocated_Sprint__r.Name,Functional_Area__c,Sub_Process__c]) {
                                          
                     if (!Func_UserStory.containsKey(R.Functional_Area__c))
                                        Func_UserStory.put(R.Functional_Area__c,new list<Requirements__c>());
                                    system.debug('+++++++++++++++' + R.User_Type__c );
                                    If (R.User_Type__c != Null){
                                          string temp = string.valueof(R.User_Type__c);
                                          R.User_Type__c = temp.replace(';',',');
                                    system.debug('+++++++++++++++' + R.User_Type__c );       
                                   } 
                                    Func_UserStory.get(R.Functional_Area__c).add(R);          
                    }
           
            
           if(Project_Name <> null && Project_Name != '--None--'){
                Definitions = [select id,Name,Project__c,Term_Acronym__c,Project__r.Name from Definitions__c where Project__c =: MapSelOps.get(Project_Name)];
                    if(Definitions.size()>0){
                        DefinitionsExist = true;
                    }
                References  = [select id,Name,Document_ID__c,Project__c,Project__r.Name from References__c where Project__c =: MapSelOps.get(Project_Name)];
                    if(References.size()>0){
                        ReferencesExist =true;
                    }
            }  
            
           Pagereference P = Page.FunctionalDocumentPDF;
           // p.setRedirect(true);
           return p;
         }
        else {
                if(selectedUS.size()==0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least one user story'));
                }
                if(Version == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Version'));
                }
                if(Organization == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter an Organization'));
                }
                if(Project_Name == '--None--'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Project Name'));
                }
               return null;
            }
        
    }
    
    public pagereference generateQAcards(){
    
    PageReference np = new PageReference('/apex/GenerateCard');
    np.setRedirect(false);
    
    return np;
    }
    
     public string domainName {
        get{
            if(domainName ==null){
             try{
             Site siteObj= [select id,subdomain from site where name=:'QRScan'];
             domainName = siteObj.subdomain; 
             return 'https://'+domainName+'.secure.force.com';
             }catch (exception e){
                 return null;
             }
            }
            else
             return null;            
        }
        private set{
        }
    }
    
    
}