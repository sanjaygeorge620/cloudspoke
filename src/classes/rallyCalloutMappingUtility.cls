public class rallyCalloutMappingUtility {
    
    /*
    public static list<Requirements__c> US_SFDC = new list<Requirements__c>();
    
    public static map<string, Requirements__c> Map_ObjID_UserStory = new map<string, Requirements__c>();
    */

    public static list<Rally_User_Story__c> rallyUserStories = new list<Rally_User_Story__c>();
    public static map<string, Rally_User_Story__c> Map_ObjID_UserStory = new map<string, Rally_User_Story__c>();
    public static map<string, SFDC_Projects__c> Map_IPRNumber_IPR = new map<string, SFDC_Projects__c>();
    


    public static void syncUserStoriesFromRally() {
           
        rallyCalloutUtility rs = new rallyCalloutUtility();

        
        Rally_Integration_Callout_Settings__c calloutSettings = Rally_Integration_Callout_Settings__c.getvalues('RallyV2');
        String LastUpdateDate = calloutSettings!=null?calloutSettings.LastUpdate__c:'';
        
        if(LastUpdateDate != null) { 

            LastUpdateDate = LastUpdateDate.replace(' ', 'T');
        }

        rs.getEntireUS('LastUpdateDate', LastUpdateDate, '>');


        if(calloutSettings != null){
            
            calloutSettings.LastUpdate__c = string.valueof(datetime.now());
            update calloutSettings;
        }

        system.debug('Bazinga... calloutSize: ' + rallyCalloutUtility.userstory.QueryResult.Results.size());
        
        Map_ObjID_UserStory = CreateObjIdUSMap(rallyCalloutUtility.userstory.QueryResult.formattedIds);
        Map_IPRNumber_IPR = CreateIPRNumberIPRMap(rallyCalloutUtility.userstory.QueryResult.iprNumbers);

        system.debug('Bazinga... iprNumbers: ' + rallyCalloutUtility.userstory.QueryResult.iprNumbers);
         
        system.debug('Bazinga... mapSize: ' + Map_ObjID_UserStory.size());
        system.debug('Bazinga... Map_IPRNumber_IPR map: ' + Map_IPRNumber_IPR); 
        
        Rally_User_Story__c rallyUserStory;
         
        String Descb,us_name;
        Double points ;
        for(integer i =0; i < rallyCalloutUtility.userstory.QueryResult.Results.size();i++){
            if(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID != null &&
               rallyCalloutUtility.userstory.QueryResult.Results[i].SFDCProjectID != null &&
               Map_ObjID_UserStory.get(string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID)) != null){

                system.debug('Bazinga... SFDCProjectID-' + rallyCalloutUtility.userstory.QueryResult.Results[i].SFDCProjectID);

                if(Map_ObjID_UserStory.get(string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID))==null){
                    
                    rallyUserStory = new Rally_User_Story__c();
                        
                    rallyUserStory.Rally_User_Story_Id__c = rallyCalloutUtility.userstory.QueryResult.Results[i].FormattedID;
                    rallyUserStory.Object_Id__c = string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID);
                } 
                else{

                    rallyUserStory = new Rally_User_Story__c(Id = Map_ObjID_UserStory.get(string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID)).Id);
                }

                if(rallyCalloutUtility.userstory.QueryResult.Results[i].SFDCProjectID != null) {
                    
                    rallyUserStory.Internal_Project_Request__c = Map_IPRNumber_IPR.get(string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].SFDCProjectID)).Id;
                }

                if(rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration != null) {
                    
                    rallyUserStory.Iteration__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration.refObjectName;
                }

                if(rallyCalloutUtility.userstory.QueryResult.Results[i].Project!=null) {
                    
                    rallyUserStory.Project__c = Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName).Rally_Project_Id__c:'';
                }

                if(rallyCalloutUtility.userstory.QueryResult.Results[i].Release!=null) {
                     
                    rallyUserStory.Release__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Release.refObjectName;
                }

                if(rallyCalloutUtility.userstory.QueryResult.Results[i].Rank != null) {
                    
                    rallyUserStory.Rank__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Rank;
                }

                rallyUserStory.State__c = rallyCalloutUtility.userstory.QueryResult.Results[i].ScheduleState;
                rallyUserStory.Name = rallyCalloutUtility.userstory.QueryResult.Results[i].Name;


                
                rallyUserStories.add(rallyUserStory);
            }
        }
        
        if(calloutSettings != null){
            
            calloutSettings.ScheduleRunning__c = false;
            update calloutSettings;
            
            upsert rallyUserStories;
            
            calloutSettings.ScheduleRunning__c = true;
            update calloutSettings;
        }
    }

    public static map<string, Rally_User_Story__c> CreateObjIdUSMap(Set<String> rallyIds){
        
        map<string, Rally_User_Story__c> mapObjIdUs = new map<string, Rally_User_Story__c>();
        
        for(Rally_User_Story__c rus : [SELECT Id, Internal_Project_Request__c, Iteration__c, Rally_User_Story_Id__c, Release__c, State__c, Object_Id__c, Project__c
                                       FROM Rally_User_Story__c
                                       WHERE Rally_User_Story_Id__c IN :rallyIds]) {
        
            mapObjIdUs.put(rus.Object_Id__c, rus);                          
        }
        
        return mapObjIdUs;
    }

    public static map<string, SFDC_Projects__c> CreateIPRNumberIPRMap(Set<String> iprNumbers){
        
        map<string, SFDC_Projects__c> mapIPRNumberIPR = new map<string, SFDC_Projects__c>();
        
        for(SFDC_Projects__c ipr : [SELECT Id, ProjectId__c
                                    FROM SFDC_Projects__c
                                    WHERE ProjectId__c IN :iprNumbers]) {
        
            mapIPRNumberIPR.put(ipr.ProjectId__c, ipr);                          
        }
        
        return mapIPRNumberIPR;
    }



    /*
    public static void syncUserStoriesFromRally() {
           
        rallyCalloutUtility rs = new rallyCalloutUtility();

        //rs.getEntireUS();

        system.debug('Bazinga... calloutSize: ' + rallyCalloutUtility.userstory.QueryResult.Results.size());
        
        Map_ObjID_UserStory = CreateObjIdUSMap(rallyCalloutUtility.userstory.QueryResult.formattedIds);
        
        system.debug('Bazinga... mapSize: ' + Map_ObjID_UserStory.size());
        
        Requirements__c US_Instance;
         
        String Descb,us_name;
        Double points ;
        for(integer i =0; i < rallyCalloutUtility.userstory.QueryResult.Results.size();i++){
            if(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID!=null){
                if(Map_ObjID_UserStory.get(string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID))==null){
                    US_Instance = new Requirements__c();
                        // User Story ID
                    US_Instance.Rally_ID__c=rallyCalloutUtility.userstory.QueryResult.Results[i].FormattedID;
                         // User Story ObjectID
                    US_Instance.Object_ID__c=string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID);
                } 
                else{
                    US_Instance = new Requirements__c(id=Map_ObjID_UserStory.get(string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID)).id);
                }   
                    // mapping Starts
                        // User Story Name
                         us_name=rallyCalloutUtility.userstory.QueryResult.Results[i].Name;
                        //us_name=us_name.substring(0,us_name.length()<254?us_name.length():254);
                        us_name=us_name.substring(0,us_name.length()<79?us_name.length():79);
                    //US_Instance.User_Story_Name__c=us_name;
                    US_Instance.Request_Title__c=us_name;  
                    
                    
                        // Scheduled State
                    US_Instance.State__c=   rallyCalloutUtility.userstory.QueryResult.Results[i].ScheduleState;
                        // User Story Desciption
                        Descb=rallyCalloutUtility.userstory.QueryResult.Results[i].Description;
                    //US_Instance.Detailed_User_Story__c = RemoveHTMLFields(Descb);
                        Descb=Descb.substring(0,Descb.length()<254?Descb.length():254);
                    //
                    // Updates made here.
                    //US_Instance.Description__c=Descb;
                    US_Instance.Request_Description__c=Descb;
                   
                        // User Story Owner
                    if(!Test.isRunningTest()){
                        if(rallyCalloutUtility.userstory.QueryResult.Results[i].Owner!=null){
                            system.debug('Rally id: '+US_Instance.Rally_ID__c);
                            //US_Instance.Product_Owner__c=Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Owner.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Owner.refObjectName).SFDC_ID__c:Rally_Integration_Mapping_Settings__c.getvalues('Sanjay George').SFDC_ID__c; 
                        }
                        else{
                            //US_Instance.Product_Owner__c=Rally_Integration_Mapping_Settings__c.getvalues('Sanjay George').SFDC_ID__c;
                        }
                   }
                   // Project Name
                   //if(rallyCalloutUtility.userstory.QueryResult.Results[i].Project!=null)
                        //US_Instance.Project__c= Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Project.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Project.refObjectName).sfdc_id__c:null;
                   //else
                        //US_Instance.Project__c=null;
                   // Release Name
                    //if(rallyCalloutUtility.userstory.QueryResult.Results[i].Release!=null)
                        //US_Instance.Release__c= Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Release.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Release.refObjectName).sfdc_id__c:null;
                    //else
                        //US_Instance.Release__c=null;
                    //Interation Name
                    //if(rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration!=null)
                        //US_Instance.Planned_Sprint_del__c = Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Iteration.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Iteration.refObjectName).sfdc_id__c:null;
                    //else
                        //US_Instance.Planned_Sprint_del__c=null;
                    // Workspace
                    US_Instance.Workspace__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Workspace!=null?rallyCalloutUtility.userstory.QueryResult.Results[i].Workspace.refObjectName:'';
                    //SFDC Points
                    //if(rallyCalloutUtility.userstry.QueryResult.Results[i].PlanEstimate!=null)
                         //points = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].PlanEstimate;
                        //US_Instance.SFDC_Story_Points__c = points<1?'0':(points<2?'1':(points<3?'2':(points<5?'3':(points<8?'5':(points<13?'8':(points<21?'13':(points<34?'21':(points<41?'40':'40'))))))));
                    //capability                                
                    US_Instance.Capability__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Capability;
                    //subcapability                            
                    US_Instance.Subcapability__c= rallyCalloutUtility.userstory.QueryResult.Results[i].SubCapability;
                    //usergroup                  
                    US_Instance.User_group__c = rallyCalloutUtility.userstory.QueryResult.Results[i].UserGroup;
                    //area  
                    US_Instance.Area__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Area;
                        //capabilityrank  
                    US_Instance.Capability_Rank__c= rallyCalloutUtility.userstory.QueryResult.Results[i].CapabilityRank;
                        //functionalityevaluation
                    US_Instance.Functional_Evaluation__c = rallyCalloutUtility.userstory.QueryResult.Results[i].FunctionalityEvaluation;
                        //oldid 
                    US_Instance.Old_ID__c=rallyCalloutUtility.userstory.QueryResult.Results[i].OldID;
                    //integration   
                    US_Instance.Integration__c= rallyCalloutUtility.userstory.QueryResult.Results[i].Integration;
                    //source  
                    US_Instance.Sources__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Source;
                    //acceptancecriteria
                    US_Instance.Acceptance_Criteria__c= rallyCalloutUtility.userstory.QueryResult.Results[i].AcceptanceCriteria;
                    //ranking
                    US_Instance.ranking__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Rank!=null?string.valueof(rallyCalloutUtility.userstory.QueryResult.Results[i].Rank):'';
                    //requester
                    US_Instance.requester__c = rallyCalloutUtility.userstory.QueryResult.Results[i].Requester;
                    //Attachment
                    if(rallyCalloutUtility.userstory.QueryResult.Results[i].Attachments!=null){
                        //String Attch = ' ', Attch1;
                        //for(integer j =0; i<LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Attachments.size();i++){
                            //Attch1= LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Attachments[j].ref+'/'+LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Attachments[j].refObjectName;
                            //Attch1 = Attch1.replace('webservice/1.41/','');
                            //Attch += Attch1.replace('.js','')+' , ';
                        //}
                       // US_Instance.Attachment__c = Attch;
                        
                    }
                   
                    US_SFDC.add(US_Instance);
            }
        }
        
        upsert US_SFDC;
    }
    */
    
    /*
    public static map<string, Requirements__c> CreateObjIdUSMap(Set<String> rallyIds){
        
        map<string, Requirements__c> mapObjIdUs = new map<string, Requirements__c>();
        
        //to be later replaced by custom setting marking lastupdate
        for(Requirements__c r : [SELECT Id, Object_ID__c, Rally_Id__c, LastModifiedDate, Request_Title__c, Request_Description__c,
                                    User_Story_Name__c, State__c, Product_Owner__c, Release__c, Description__c, 
                                    Planned_Sprint_del__c, Project__c, SFDC_Story_Points__c, Capability__c, 
                                    SubCapability__c, User_Group__c, Area__c, Capability_Rank__c, Functional_Evaluation__c, 
                                    Old_Id__c, Integration__c, Sources__c, ranking__c, requester__c, Developer_Name__c 
                                 FROM Requirements__c
                                 WHERE Rally_Id__c IN :rallyIds
                                 AND RecordTypeId != null 
                                 AND RecordType.Developername = 'User_Story']) {
        
            mapObjIdUs.put(r.Object_ID__c, r);                          
        }
        
        return mapObjIdUs;
    }
    */
    
    @future(callout=true)
    public static void futureUpsertUS(string us_id, string ObjectID, string UserSoryName, string ScheduledState, string owner, string Release, string Description, string Iteration, string Project, string PlanEstimate, 
                                string Capability, string SubCapability, string UserGroup, string Area, string CapabilityRank, string FunctionalEvaluation, string OldID, string integration, string Source,
                                string Rank, string requester, string sfdcProjectId){
        rallyUserStoryJSONClass US_recv;
        list<string> result; 
        
        system.debug('qqq:'+us_id+ObjectID);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('HierarchicalRequirement');
        gen.writeStartObject();
        if(UserSoryName!=null) {
            gen.writeStringField('Name', UserSoryName);
        }
        
        if(ScheduledState!=null) {
            gen.writeStringField('ScheduleState', ScheduledState);
        }
        
        if(owner!=null) {
            gen.writeStringField('Owner', (Rally_Integration_Mapping_Settings__c.getvalues(owner)!=null?Rally_Integration_Mapping_Settings__c.getvalues(owner).Rally_Field__c:''));
        }
        
        if(Release!=null) {
            gen.writeStringField('Release', (Rally_Integration_Mapping_Settings__c.getvalues(Release)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Release).Rally_Field__c:''));
        }
        
        if(Description!=null) {
            gen.writeStringField('Description', Description); 
        }
        
        if(Iteration!=null) {
            gen.writeStringField('Iteration', (Rally_Integration_Mapping_Settings__c.getvalues(Iteration)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Iteration).Rally_Field__c:''));
        }
            
        if(Project!=null) {
            gen.writeStringField('Project', (Rally_Integration_Mapping_Settings__c.getvalues(Project)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Project).Rally_Field__c:''));
        }
        
        if(PlanEstimate!=null) {
            gen.writeNumberField('PlanEstimate', double.valueof(PlanEstimate));
        }
        
        if(Capability!=null) {
            gen.writeStringField('Capability', Capability);
        }
           
        if(SubCapability!=null) {
            gen.writeStringField('SubCapability', SubCapability);
        }
        
        if(UserGroup!=null) {
            gen.writeStringField('UserGroup', UserGroup);
        }
        
        if(Area!=null) {
            gen.writeStringField('Area', Area);
        }
        
        if(CapabilityRank!=null) {
            gen.writeStringField('CapabilityRank', CapabilityRank);
        }
        
        if(FunctionalEvaluation!=null) {
            gen.writeStringField('FunctionalityEvaluation', FunctionalEvaluation);
        }
        
        if(OldID!=null) {
            gen.writeStringField('OldID', OldID);
        }
        
        if(integration!=null) {
            gen.writeStringField('Integration', integration);
        }
        
        if(Source!=null) {
            gen.writeStringField('Source', Source);
        }
        // Acceptance Criteria is a Readonly Field
        //gen.writeStringField('AcceptanceCriteria', UserStory.Acceptance_Criteria__c!=null?UserStory.Acceptance_Criteria__c:'');
        if(Rank!=null) {
            gen.writeNumberField('Rank',double.valueof(Rank));
        }
        
        if(requester!=null) {
            gen.writeStringField('Requester', requester);
        }
        
        if(sfdcProjectId!=null) {
            gen.writeStringField('c_SFDCProjectID', sfdcProjectId);
        }
        gen.writeEndObject();
        gen.writeEndObject(); 

        Map<String, String> authorizeMap = rallyCalloutUtility.authorizeRallyCallout();


        if(ObjectID!=null){
                result = rallyCalloutUtility.upsertUS(gen.getAsString(), ObjectID, authorizeMap.get('cookie'), authorizeMap.get('token'));
        }
        else{
            //system.debug('Bazinga... full JSON String: ' + gen.getAsString());
            result = rallyCalloutUtility.upsertUS(gen.getAsString(), null, authorizeMap.get('cookie'), authorizeMap.get('token'));
            //if(result[0]!=null&&result[1]!=null){
                
                //Requirements__c USInsert = new Requirements__c(id=us_id, Object_ID__c =result[0], Rally_ID__c= result[1]);
                //upsert USInsert;
                /*
                Rally_Integration_Callout_Settings__c TrgCntrlSettings = Rally_Integration_Callout_Settings__c.getvalues('Rally');
                if(TrgCntrlSettings!=null){
                    TrgCntrlSettings.ScheduleRunning__c=false;
                    update TrgCntrlSettings;
                    upsert USInsert;
                    TrgCntrlSettings.ScheduleRunning__c=true;
                    update TrgCntrlSettings;
                }
                */
            //}
        }
    }

    
    public static void upsertUS(string us_id, string ObjectID, string UserSoryName, string ScheduledState, string owner, string Release, string Description, string Iteration, string Project, string PlanEstimate, 
                                string Capability, string SubCapability, string UserGroup, string Area, string CapabilityRank, string FunctionalEvaluation, string OldID, string integration, string Source,
                                string Rank, string requester, string sessionCookie, string securityToken, string sfdcProjectId){
        rallyUserStoryJSONClass US_recv;
        list<string> result; 
        
        system.debug('qqq:'+us_id+ObjectID);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('HierarchicalRequirement');
        gen.writeStartObject();
        if(UserSoryName!=null) {
            gen.writeStringField('Name', UserSoryName);
        }
        
        if(ScheduledState!=null) {
            gen.writeStringField('ScheduleState', ScheduledState);
        }
        
        if(owner!=null) {
            gen.writeStringField('Owner', (Rally_Integration_Mapping_Settings__c.getvalues(owner)!=null?Rally_Integration_Mapping_Settings__c.getvalues(owner).Rally_Field__c:''));
        }
        
        if(Release!=null) {
            gen.writeStringField('Release', (Rally_Integration_Mapping_Settings__c.getvalues(Release)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Release).Rally_Field__c:''));
        }
        
        if(Description!=null) {
            gen.writeStringField('Description', Description); 
        }
        
        if(Iteration!=null) {
            gen.writeStringField('Iteration', (Rally_Integration_Mapping_Settings__c.getvalues(Iteration)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Iteration).Rally_Field__c:''));
        }
            
        if(Project!=null) {
            gen.writeStringField('Project', (Rally_Integration_Mapping_Settings__c.getvalues(Project)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Project).Rally_Field__c:''));
        }
        
        if(PlanEstimate!=null) {
            gen.writeNumberField('PlanEstimate', double.valueof(PlanEstimate));
        }
        
        if(Capability!=null) {
            gen.writeStringField('Capability', Capability);
        }
           
        if(SubCapability!=null) {
            gen.writeStringField('SubCapability', SubCapability);
        }
        
        if(UserGroup!=null) {
            gen.writeStringField('UserGroup', UserGroup);
        }
        
        if(Area!=null) {
            gen.writeStringField('Area', Area);
        }
        
        if(CapabilityRank!=null) {
            gen.writeStringField('CapabilityRank', CapabilityRank);
        }
        
        if(FunctionalEvaluation!=null) {
            gen.writeStringField('FunctionalityEvaluation', FunctionalEvaluation);
        }
        
        if(OldID!=null) {
            gen.writeStringField('OldID', OldID);
        }
        
        if(integration!=null) {
            gen.writeStringField('Integration', integration);
        }
        
        if(Source!=null) {
            gen.writeStringField('Source', Source);
        }
        // Acceptance Criteria is a Readonly Field
        //gen.writeStringField('AcceptanceCriteria', UserStory.Acceptance_Criteria__c!=null?UserStory.Acceptance_Criteria__c:'');
        if(Rank!=null) {
            gen.writeNumberField('Rank',double.valueof(Rank));
        }
        
        if(requester!=null) {
            gen.writeStringField('Requester', requester);
        }
        
        if(sfdcProjectId!=null) {
            gen.writeStringField('c_SFDCProjectID', sfdcProjectId);
        }
        gen.writeEndObject();
        gen.writeEndObject(); 
        if(ObjectID!=null){
                result = rallyCalloutUtility.upsertUS(gen.getAsString(), ObjectID, sessionCookie, securityToken);
        }
        else{
            //system.debug('Bazinga... full JSON String: ' + gen.getAsString());
            result = rallyCalloutUtility.upsertUS(gen.getAsString(), null, sessionCookie, securityToken);
            //if(result[0]!=null&&result[1]!=null){
                
                //Requirements__c USInsert = new Requirements__c(id=us_id, Object_ID__c =result[0], Rally_ID__c= result[1]);
                //upsert USInsert;
                /*
                Rally_Integration_Callout_Settings__c TrgCntrlSettings = Rally_Integration_Callout_Settings__c.getvalues('Rally');
                if(TrgCntrlSettings!=null){
                    TrgCntrlSettings.ScheduleRunning__c=false;
                    update TrgCntrlSettings;
                    upsert USInsert;
                    TrgCntrlSettings.ScheduleRunning__c=true;
                    update TrgCntrlSettings;
                }
                */
            //}
        }
    }
    

}