/* Class Name   : LXFO_RallyCalloutMappingUtility 
* Description   : This is a utility class to map fields and user names between Tracker and Rally
* Created By   : Sanjay George
* Created Date : 03-23-2013
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Sanjay George          03-26-2013                1000                 Initial Version

*/


public  class LXFO_RallyCalloutMappingUtility {

    public static list<Requirements__c> US_SFDC = new list<Requirements__c>();
    public static Requirements__c US_ups= new Requirements__c();
    public static map<string, Requirements__c> Map_ObjID_US = new map<string, Requirements__c>();
    public static list<Rally_Integration_Mapping_Settings__c> UserList;
    private static Rally_Integration_Mapping_Settings__c UserMap;
    private static integer calloutsize=0;
    /*
    Method - fetchUS_Rally
    Does a web callout and fetches query from Rally and Map it to User Stories in Tracker
    */
    
    
    @Future(callout=true)   
    public static void fetchUS_Rally(){
        LXFO_RallyCalloutUtility rs= new LXFO_RallyCalloutUtility();
        rs.getEntireUS();
        CreateUSMap(); 
        Requirements__c US_Instance; 
        //system.debug(LXFO_RallyCalloutUtility.userstry.QueryResult.Results);
        system.debug('Size:'+LXFO_RallyCalloutUtility.userstry.QueryResult.Results.size());
        String Descb,us_name;
        Double points ;
        for(integer i =0; i <LXFO_RallyCalloutUtility.userstry.QueryResult.Results.size();i++){
            if(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].ObjectID!=null){
                if(Map_ObjID_US.get(string.valueof(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].ObjectID))==null){
                    US_Instance = new Requirements__c();
                        // User Story ID
                    US_Instance.Rally_ID__c=LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].FormattedID;
                         // User Story ObjectID
                    US_Instance.Object_ID__c=string.valueof(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].ObjectID);
                } 
                else{
                    US_Instance = new Requirements__c(id=Map_ObjID_US.get(string.valueof(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].ObjectID)).id);
                }   
                    // mapping Starts
                        // User Story Name
                           us_name=LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Name;
                        us_name=us_name.substring(0,us_name.length()<254?us_name.length():254);
                    US_Instance.User_Story_Name__c=us_name; 
                    
                        // Scheduled State
                    US_Instance.State__c=   LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].ScheduleState;
                        // User Story Desciption
                        Descb=LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Description;
                    US_Instance.Detailed_User_Story__c = RemoveHTMLFields(Descb);
                        Descb=Descb.substring(0,Descb.length()<254?Descb.length():254);
                    //
                    // Updates made here.
                    US_Instance.Description__c=Descb;
                   
                        // User Story Owner
                    if(!Test.isRunningTest()){
                        if(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Owner!=null){
                            system.debug('Rally id: '+US_Instance.Rally_ID__c);
							US_Instance.Product_Owner__c=Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Owner.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Owner.refObjectName).SFDC_ID__c:Rally_Integration_Mapping_Settings__c.getvalues('Sanjay George').SFDC_ID__c; 
                        }
                        else{
                            US_Instance.Product_Owner__c=Rally_Integration_Mapping_Settings__c.getvalues('Sanjay George').SFDC_ID__c;
                        }
                   }
                   // Project Name
                   if(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Project!=null)
                        US_Instance.Project__c= Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Project.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Project.refObjectName).sfdc_id__c:null;
                   else
                        US_Instance.Project__c=null;
                   // Release Name
                    if(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Release!=null)
                        US_Instance.Release__c= Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Release.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Release.refObjectName).sfdc_id__c:null;
                    else
                        US_Instance.Release__c=null;
                    //Interation Name
                    if(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Iteration!=null)
                        US_Instance.Planned_Sprint_del__c = Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Iteration.refObjectName)!=null?Rally_Integration_Mapping_Settings__c.getvalues(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Iteration.refObjectName).sfdc_id__c:null;
                    else
                        US_Instance.Planned_Sprint_del__c=null;
                    // Workspace
                    US_Instance.Workspace__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Workspace!=null?LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Workspace.refObjectName:'';
                    //SFDC Points
                    if(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].PlanEstimate!=null)
                         points = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].PlanEstimate;
                        US_Instance.SFDC_Story_Points__c = points<1?'0':(points<2?'1':(points<3?'2':(points<5?'3':(points<8?'5':(points<13?'8':(points<21?'13':(points<34?'21':(points<41?'40':'40'))))))));
                    //capability                                
                    US_Instance.Capability__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Capability;
                    //subcapability                            
                    US_Instance.Subcapability__c= LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].SubCapability;
                    //usergroup                  
                    US_Instance.User_group__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].UserGroup;
                    //area  
                    US_Instance.Area__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Area;
                        //capabilityrank  
                    US_Instance.Capability_Rank__c= LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].CapabilityRank;
                        //functionalityevaluation
                    US_Instance.Functional_Evaluation__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].FunctionalityEvaluation;
                        //oldid 
                    US_Instance.Old_ID__c=LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].OldID;
                    //integration   
                    US_Instance.Integration__c= LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Integration;
                    //source  
                    US_Instance.Sources__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Source;
                    //acceptancecriteria
                    US_Instance.Acceptance_Criteria__c= LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].AcceptanceCriteria;
                    //ranking
                    US_Instance.ranking__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Rank!=null?string.valueof(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Rank):'';
                    //requester
                    US_Instance.requester__c = LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Requester;
                    //Attachment
                    if(LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Attachments!=null){
                      /*  String Attch = ' ', Attch1;
                        for(integer j =0; i<LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Attachments.size();i++){
                            Attch1= LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Attachments[j].ref+'/'+LXFO_RallyCalloutUtility.userstry.QueryResult.Results[i].Attachments[j].refObjectName;
                            Attch1 = Attch1.replace('webservice/1.41/','');
                            Attch += Attch1.replace('.js','')+' , ';
                        }
                        US_Instance.Attachment__c = Attch;
						*/
                    }
                   
                    US_SFDC.add(US_Instance);
            }
        }
        // Logic to control Trigger from updating Rally when Data fetch from rally is happening.
        Rally_Integration_Callout_Settings__c TrgCntrlSettings = Rally_Integration_Callout_Settings__c.getvalues('Rally');
        // Trigger Control to prevent Infinite Loop
        if(TrgCntrlSettings!=null)
        {
            TrgCntrlSettings.ScheduleRunning__c=false;
            update TrgCntrlSettings;
            upsert US_SFDC;
            TrgCntrlSettings.ScheduleRunning__c=true;
            update TrgCntrlSettings;
        } 
     
    } 


    /*
    Method -  upsertUS()
    Param - us_id - Usertory ID
    
    Inserts / Update User Story in Rally when Updated in Tracker
    */
    
    
    
    @Future(callout=true)
    public static void upsertUS(string us_id, string ObjectID, string UserSoryName, string ScheduledState, string owner, string Release, string Description, string Iteration, string Project, string PlanEstimate, 
                                string Capability, string SubCapability, string UserGroup, string Area, string CapabilityRank, string FunctionalEvaluation, string OldID, string integration, string Source,
                                string Rank, string requester){
        LXFO_RallyUserStoryJSONStubClass US_recv;
        list<string> result; 
        
        system.debug('qqq:'+us_id+ObjectID);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('HierarchicalRequirement');
        gen.writeStartObject();
        if(UserSoryName!=null)
            gen.writeStringField('Name', UserSoryName);
        if(ScheduledState!=null)
            gen.writeStringField('ScheduleState', ScheduledState);
        if(owner!=null)
            gen.writeStringField('Owner', (Rally_Integration_Mapping_Settings__c.getvalues(owner)!=null?Rally_Integration_Mapping_Settings__c.getvalues(owner).Rally_Field__c:''));
        if(Release!=null)
            gen.writeStringField('Release', (Rally_Integration_Mapping_Settings__c.getvalues(Release)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Release).Rally_Field__c:''));
        if(Description!=null)
            gen.writeStringField('Description', Description); 
        if(Iteration!=null)
            gen.writeStringField('Iteration', (Rally_Integration_Mapping_Settings__c.getvalues(Iteration)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Iteration).Rally_Field__c:''));
        if(Project!=null)
            gen.writeStringField('Project', (Rally_Integration_Mapping_Settings__c.getvalues(Project)!=null?Rally_Integration_Mapping_Settings__c.getvalues(Project).Rally_Field__c:''));
        if(PlanEstimate!=null)
            gen.writeNumberField('PlanEstimate', double.valueof(PlanEstimate));
        if(Capability!=null)
            gen.writeStringField('Capability', Capability);
        if(SubCapability!=null)
            gen.writeStringField('SubCapability', SubCapability);
        if(UserGroup!=null)
            gen.writeStringField('UserGroup', UserGroup);
        if(Area!=null)
            gen.writeStringField('Area', Area);
        if(CapabilityRank!=null)
            gen.writeStringField('CapabilityRank', CapabilityRank);
        if(FunctionalEvaluation!=null)
            gen.writeStringField('FunctionalityEvaluation', FunctionalEvaluation);
        if(OldID!=null)
            gen.writeStringField('OldID', OldID);
        if(integration!=null)
            gen.writeStringField('Integration', integration);
        if(Source!=null)
            gen.writeStringField('Source', Source);
        // Acceptance Criteria is a Readonly Field
        //gen.writeStringField('AcceptanceCriteria', UserStory.Acceptance_Criteria__c!=null?UserStory.Acceptance_Criteria__c:'');
        if(Rank!=null)
            gen.writeNumberField('Rank',double.valueof(Rank));
        if(requester!=null)
            gen.writeStringField('Requester', requester);
        gen.writeEndObject();
        gen.writeEndObject();
        if(ObjectID!=null){
                result = LXFO_RallyCalloutUtility.upsertUS(gen.getAsString(),ObjectID );
        }
        else{
            result = LXFO_RallyCalloutUtility.upsertUS( gen.getAsString(), null);
            if(result[0]!=null&&result[1]!=null){
                
                Requirements__c USInsert = new Requirements__c(id=us_id, Object_ID__c =result[0], Rally_ID__c= result[1]);
                Rally_Integration_Callout_Settings__c TrgCntrlSettings = Rally_Integration_Callout_Settings__c.getvalues('Rally');
                if(TrgCntrlSettings!=null){
                    TrgCntrlSettings.ScheduleRunning__c=false;
                    update TrgCntrlSettings;
                    upsert USInsert;
                    TrgCntrlSettings.ScheduleRunning__c=true;
                    update TrgCntrlSettings;
                }
            }
        }
    }
    /*
    Method - deleteUS()
    Param - us_Objid -> Object ID of User Story in Rally
    This Funtion deletes a user Story in Rally when deleted from Tracker
    */
    
    public static void deleteUS(string us_Objid){
        LXFO_RallyUserStoryJSONStubClass US_send,US_recv;
        string ObjID;
        calloutsize++;  
        if(US_ups.Object_ID__c!=null&&calloutsize<7){
            LXFO_RallyCalloutUtility.deleteUS(us_Objid); 
        }
        
    }
    
    /*
    Creates a map of Objectid --> User Story.
    It helps in identifying the User Stroy already exisitng in the org.
    */
    public static void CreateUSMap(){
        list<Requirements__c> USList = [select id , Object_ID__c from Requirements__c];
        
        for(Requirements__c US: USList ){
            Map_ObjID_US.put(US.Object_ID__c,US);
            
        } 
    }
    /*
    Creates a Custom Settings of User.Email --> User.ID.
    It helps in identifying the owner of the User Story
    */
    
     
    
    @future(callout=true)
    public static void CreateUserMap_Rally(){
        LXFO_RallyCalloutUtility rs= new LXFO_RallyCalloutUtility();
        LXFO_RallyCalloutUtility.getqueriesUsers();
        UserList = new list<Rally_Integration_Mapping_Settings__c>();
        Rally_Integration_Mapping_Settings__c Usr = new Rally_Integration_Mapping_Settings__c();
        for(integer i =0; i <LXFO_RallyCalloutUtility.UserList.QueryResult.Results.size();i++){
            Usr = new Rally_Integration_Mapping_Settings__c();
            Usr.Name= LXFO_RallyCalloutUtility.UserList.QueryResult.Results[i].refObjectName;
            Usr.Rally_Field__c= LXFO_RallyCalloutUtility.UserList.QueryResult.Results[i].EmailAddress;
            Usr.Type__c='Email';
            UserList.add(Usr);
        } 
        
        list<user> UserListSFDC = [select id, Email from User limit 1000];
        for(user users:UserListSFDC ){
            for(Rally_Integration_Mapping_Settings__c RallyUser: UserList){
                if(RallyUser.Rally_Field__c==users.email){
                    RallyUser.SFDC_ID__c= users.id;
                }
            }
        }
        insert UserList;    
    }


    public static String introduceSpace(String contString) {
                                
                                 String entryptedValueWithSpace = '';
                                Integer i;    
                     i = contString.length()/10;
                     for(integer x = 0; x < i; x++)
                     {
                                Integer startChar = 10*x;
                                Integer endChar = 10*(x+1);
                                entryptedValueWithSpace = entryptedValueWithSpace + contString.substring(startChar, endChar) + ' ';
                     }
                     entryptedValueWithSpace = entryptedValueWithSpace + contString.substring(10*i, contString.length());
                     
                     return entryptedValueWithSpace;
                }




/* Method Name - decryptField
  * Return Type - String
  * Function - This method decrypts the field passed as an argument and returns the actual value.
*/  
    public Static String decryptField(String encryptionKey,String fieldValue){
     try{
     Blob fieldValueBlobVar = EncodingUtil.base64Decode(fieldValue.replaceAll(' ', ''));
     Blob fieldValueDecryptedBlobVar = Crypto.decryptWithManagedIV('AES256', EncodingUtil.base64Decode(encryptionKey), fieldValueBlobVar);
    
     return fieldValueDecryptedBlobVar.toString().replaceAll('&#39;', '\'');
     }
     catch(Exception e){
                system.debug(e.getMessage());
                return '';
     }
    }

/* Method Name - encryptField
  * Return Type - String
  * Function - This method encrypts the field passed as an argument and returns the encrypted value.
*/     
    public Static String encryptField(String encryptionKey, String fieldValue){
     try{
     Blob fieldValueBlob = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64Decode(encryptionKey), Blob.ValueOf(fieldValue));
     system.debug('**ENCRYPT:'+LXFO_RallyCalloutMappingUtility.introduceSpace(EncodingUtil.base64Encode(fieldValueBlob)));
     //return EncodingUtil.base64Encode(fieldValueBlob);
    return LXFO_RallyCalloutMappingUtility.introduceSpace(EncodingUtil.base64Encode(fieldValueBlob));
     }
     catch(Exception e){
                system.debug(e.getMessage());
                return '';
     }
    }
    
/* Method Name - updateEncryptedCaseFields
  * Return Type - Case
  * Function - This method encrypts the Subject and Description fields of the case record which is passed as an argument.
*/    
    public Static string RemoveHTMLFields(string description){
    
            try{
            	Blob cryptoKey = Crypto.generateAesKey(256);

            if(description != NULL){
            description = LXFO_RallyCalloutMappingUtility.encryptField(EncodingUtil.base64Encode(cryptoKey),description);
            description = LXFO_RallyCalloutMappingUtility.decryptField(EncodingUtil.base64Encode(cryptoKey), description);
            }
           
            return description;
            }
            catch(Exception e){
                system.debug(e.getMessage());
                return description;
            }
    
    }



}