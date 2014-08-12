public with sharing class MigrationRequest_Extension {
    
    public integer listSize {get;set;}
    public integer searchListSize {get;set;}
    
    public boolean showCreateNewButton {get;set;}
    
    public boolean showNewUserStory {get;set;}
    
    public string searchProjectId {get;set;}
    
    public Set<String> associatedRallyIds = new Set<String>();
    
    public List<rallyUserStoryWrapper> rallyUserStories {get;set;}
    public List<rallyUserStoryWrapper> rallyUserStoriesByProjectId {get;set;}
    
    public Migration_Request__c migrationRequest {get;set;}
    
    public List<Migration_Request_User_Story_Junction__c> junctions {get;set;}
    public Map<String, Migration_Request_User_Story_Junction__c> rallyUSIdMigrationRequestJunctionMap = new Map<String, Migration_Request_User_Story_Junction__c>();
    
    private ApexPages.StandardController controller {get;set;} 
    
    private Migration_Request__c mr;
    
    public MigrationRequest_Extension(ApexPages.StandardController controller) {
        
        //set visibility on the create new button
        showCreateNewButton = Rally_Integration_Access__c.getInstance(userinfo.getuserid()).Create_UserStory__c;
        
        //initialize the standard controller
        this.controller = controller;
        this.mr = (Migration_Request__c)controller.getRecord();
        
        showNewUserStory = false;
        searchProjectId = '';
        
        queryPageRecord();
        queryJunctions();
    }
    
    public void queryPageRecord() {
        
        migrationRequest = [SELECT Id, Name
                            FROM Migration_Request__c
                            WHERE Id = :mr.Id];
    }
    
    public void queryJunctions() {
        
        junctions = new List<Migration_Request_User_Story_Junction__c>();
        
        for(Migration_Request_User_Story_Junction__c mrusj : [SELECT Id, Migration_Request__c, Rally_User_Story_Id__c
                                                              FROM Migration_Request_User_Story_Junction__c
                                                              WHERE Migration_Request__c = :mr.Id]) {
            
            junctions.add(mrusj);   
            associatedRallyIds.add(mrusj.Rally_User_Story_Id__c);
            rallyUSIdMigrationRequestJunctionMap.put(mrusj.Rally_User_Story_Id__c, mrusj);                                      
        }
        
        
        
        queryAssociatedRallyUserStories();
    }
    
    public PageReference runFilter() {
        try {
        	
        	queryRallyUserStoriesByProjectId();
        }
        catch(Exception e) {
        	
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
        }

        return null;
    }
    
    public void queryAssociatedRallyUserStories() {
        
        rallyUserStories = new List<rallyUserStoryWrapper>();
        
        for(String mrusjId : associatedRallyIds) {
        
            rallyCalloutUtility rs = new rallyCalloutUtility();
            rs.getEntireUS('FormattedID', mrusjId, '=');
            
            for(integer i =0; i < rallyCalloutUtility.userstory.QueryResult.Results.size();i++) {
                if(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID!=null){
                    
                    string iteration = '';
                    string release = '';
                    string projectId = '';
                    
                    if(rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration!=null) {
                        iteration = rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration.refObjectName;
                    }
                    
                    if(rallyCalloutUtility.userstory.QueryResult.Results[i].Release!=null) {
                        release = rallyCalloutUtility.userstory.QueryResult.Results[i].Release.refObjectName;
                    } 

                    if(rallyCalloutUtility.userstory.QueryResult.Results[i].Project!=null) {
                        projectId = Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName).Rally_Project_Id__c:'';
                    }
                    
                    rallyUserStories.add(new rallyUserStoryWrapper(true,
                                                                   rallyCalloutUtility.userstory.QueryResult.Results[i].FormattedID,
                                                                   string.valueOf(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID),
                                                                   rallyCalloutUtility.userstory.QueryResult.Results[i].Name,
                                                                   rallyCalloutUtility.userstory.QueryResult.Results[i].ScheduleState,
                                                                   iteration, release, projectId));
                }
            }
        }

        listSize = rallyUserStories.size();
    } 
    
    public void queryRallyUserStoriesByProjectId() {

        searchProjectId = Apexpages.currentPage().getParameters().get('searchProjectId');

        string searchField = 'c_SFDCProjectID';

        if(searchProjectId.length() >= 2 && searchProjectId.substring(0,2).toLowercase() == 'us') {
            searchField = 'FormattedID';
        }

        rallyUserStoriesByProjectId = new List<rallyUserStoryWrapper>();
        
        rallyCalloutUtility rs = new rallyCalloutUtility();
        rs.getEntireUS(searchField, searchProjectId, '=');
        
        for(integer i =0; i < rallyCalloutUtility.userstory.QueryResult.Results.size();i++) {
            if(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID!=null){
                
                //check to see if already exists in first list
                if(!associatedRallyIds.contains(rallyCalloutUtility.userstory.QueryResult.Results[i].FormattedID)) { 
                
                    string iteration = '';
                    string release = '';
                    string projectId = '';
                    
                    if(rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration!=null) {
                        iteration = rallyCalloutUtility.userstory.QueryResult.Results[i].Iteration.refObjectName;
                    }
                    
                    if(rallyCalloutUtility.userstory.QueryResult.Results[i].Release!=null) {
                        release = rallyCalloutUtility.userstory.QueryResult.Results[i].Release.refObjectName;
                    }

                    if(rallyCalloutUtility.userstory.QueryResult.Results[i].Project!=null) {
                        projectId = Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(rallyCalloutUtility.userstory.QueryResult.Results[i].Project.refObjectName).Rally_Project_Id__c:'';
                    }
                    
                    rallyUserStoriesByProjectId.add(new rallyUserStoryWrapper(false,
                                                                   rallyCalloutUtility.userstory.QueryResult.Results[i].FormattedID,
                                                                   string.valueOf(rallyCalloutUtility.userstory.QueryResult.Results[i].ObjectID),
                                                                   rallyCalloutUtility.userstory.QueryResult.Results[i].Name,
                                                                   rallyCalloutUtility.userstory.QueryResult.Results[i].ScheduleState,
                                                                   iteration, release, projectId));
                }
            }
        }
        
        searchListSize = rallyUserStoriesByProjectId.size();
    }
    
    public PageReference performUpdate() {
        
        updateJunctions();
        showNewUserStory = false;
        //queryJunctions(); 
        //return null;
        
         PageReference Pg = page.MigrationRequest;
         Pg.getParameters().put('id', mr.id);
         Pg.setRedirect(true);
         return Pg; 
   }
    
    public void updateJunctions() {
        
        List<Migration_Request_User_Story_Junction__c> deleteJunctions = new List<Migration_Request_User_Story_Junction__c>();
        List<Migration_Request_User_Story_Junction__c> insertJunctions = new List<Migration_Request_User_Story_Junction__c>();
        
        if(rallyUserStories != null) {

	        for(rallyUserStoryWrapper wrapper : rallyUserStories) {
	            
	            if(!wrapper.isSelected) {
	                
	                deleteJunctions.add(rallyUSIdMigrationRequestJunctionMap.get(wrapper.usId));
	            }
	        }
        }
        
        if(rallyUserStoriesByProjectId != null) {
	        for(rallyUserStoryWrapper wrapper : rallyUserStoriesByProjectId) {
	            
	            if(wrapper.isSelected) {
	                
	                Migration_Request_User_Story_Junction__c newMigrationRequestUserStoryJunction = new Migration_Request_User_Story_Junction__c();
	                newMigrationRequestUserStoryJunction.Migration_Request__c = mr.Id;
	                newMigrationRequestUserStoryJunction.Rally_User_Story_Id__c = wrapper.usId;
	                
	                insertJunctions.add(newMigrationRequestUserStoryJunction);
	            }
	        }
        }
        
        if(deleteJunctions.size() > 0) {
            
            try {

            	delete deleteJunctions;
            }
            catch(Exception e) {

        		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
            }
        }
        
        if(insertJunctions.size() > 0) {
            
            try {

            	insert insertJunctions;
            }
            catch(Exception e) {

        		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
            }
        }
    }
    
    
    public PageReference newUserStoryToggle() {
        
        if(showNewUserStory) {
            
            queryJunctions();
            showNewUserStory = false;
        }
        else {
            
            showNewUserStory = true;
            searchListSize = 0;
        }
        
        return null;
    }
    
    
    public class rallyUserStoryWrapper {
        
        public boolean isSelected {get;set;}
        public string usId {get;set;}
        public string usObjectId {get;set;}
        public string usName {get;set;}
        public string usStatus {get;set;}
        public string usIteration {get;set;}
        public string usRelease {get;set;}
        public string usProjectId {get;set;}
        
        public rallyUserStoryWrapper(boolean tmpIsSelected, string tmpUsId, string tmpUsObjectId, string tmpUsName, string tmpUsStatus, string tmpUsIteration, string tmpUsRelease, string tmpUsProjectId) {
            
            isSelected = tmpIsSelected;
            usId = tmpUsId;
            usObjectId = tmpUsObjectId;
            usName = tmpUsName;
            usStatus = tmpUsStatus;
            usIteration = tmpUsIteration;
            usRelease = tmpUsRelease;
            usProjectId = tmpUsProjectId;
        }
    } 
    
}