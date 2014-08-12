/***************************************************************************************************
 * Apex Class Name      : Controller_PlanningPoker
 * Version              : 1.0
 * Created By           : Frank Neezen  (frneezen@deloitte.co.uk)
 * Date Created         : 27/09/2012
 * Function             : Controller for the planning poker page
 * 
 * Modification Log :
 * -------------------------------------------------------------------------------------------------
 * Developer            Date                Description 
 * -------------------------------------------------------------------------------------------------
 * Frank Neezen         27/09/2012          Created
***************************************************************************************************/

public class Controller_PlanningPoker {
    
    //Variables used in this class

    public Id                                       user        {get; set;}             //ID of the current user
    public Id                                       leader      {get; set;}             //ID of the session leader
    public String                                   leaderName  {get; set;}             //Name of the leader
    
    public Planning_Poker_Session__c                session     {get; set;}
    public List<Planning_Poker_Session_Content__c>  content     {get; set;}
    
    public User     currentLeader   { get; set;}



    /* Constructor name :   Controller_PlanningPoker
     * @description    Initializes the set of variables used in the class and sets up the session.
     */
    public Controller_PlanningPoker(){
        
        //Get the id of the session
        String idSession = ApexPages.currentPage().getParameters().get('id');
        
        //If there is an ID
        if(idSession != null){
            
            //Find the session
            this.session = [    Select  Id, 
                                        Leader__c,
                                        Leader__r.Name,
                                        Title__c
                                From    Planning_Poker_Session__c 
                                Where   Id =: idSession 
                                Limit   1];
            
            //Find the content related to this session                  
            this.content = [    Select  Id,
                                        User_Story__c, 
                                        User_Story__r.Name, 
                                        User_Story__r.User_Story__c,
                                        User_Story__r.SFDC_Story_Points__c, 
                                        User_Story__r.Story_Points_SAP__c,
                                        User_Story__r.Story_points__c
                                From    Planning_Poker_Session_Content__c 
                                Where   Planning_Poker_Session__c =: idSession ];
            
            
            //Setup some internal variables so we can access them on the page
            
            this.user   = UserInfo.getUserId();
            this.leader = session.Leader__c;
            this.leaderName = this.session.Leader__r.Name;
        
        }
         
    }
    
    
     /* Method name :   setScore
      * @description    Sets the score for a specific technology on a user story.
      * @param          idSession   The id of this session as a string.
      * @param          strPoints   The number of points for this technology as a string
      * @param          strTech     The technology for which these points are set as a string
      * @return         void
      */
      
    @RemoteAction 
    public static void setScore(String idSession, String strPoints, String strTech, String strMessage){
        
        
        
        //Get a reference to the content record
        List<Planning_Poker_Session_Content__c> lContent ;
        
    if(!test.isRunningTest()){
        lContent = [    Select  User_Story__c
                                                                From    Planning_Poker_Session_Content__c
                                                                Where   Planning_Poker_Session__c =: idSession
                                                                And     System_Is_Selected__c = true ];
                                                                }else{
lContent = [    Select  User_Story__c
                                                                From    Planning_Poker_Session_Content__c
                                                                Where   Planning_Poker_Session__c =: idSession
                                                                And     System_Is_Selected__c = true 
                                                                LIMIT : Limits.getLimitQueryRows() - Limits.getQueryRows()
                                                                ];
                                                                }                                                                
                                                                
                                                                
        
        
        
        //If there is a record (should always be 1)
        if(lContent.size()==1){
            
            //Get the user story linked to this content record
            List<Requirements__c> lUserStory = [    Select  Id, 
                                                            SFDC_Story_Points__c, 
                                                            Story_Points_SAP__c,
                                                            Story_points__c
                                                    From    Requirements__c
                                                    Where   Id =: lContent[0].User_Story__c ];
            
            
                
            //if we find a record                   
            if(lUserStory.size()==1){
                 
                 //if the technology is SFDC, set points to SFDC
                if(strTech=='SFDC')
                    lUserStory[0].SFDC_Story_Points__c = strPoints;
            
                 //if the technology is SAP, set points to SAP
                if(strTech=='SAP')
                    lUserStory[0].Story_Points_SAP__c = strPoints;
                
                //if the technology is Other, set points to Other   
                if(strTech=='Other')
                    lUserStory[0].Story_points__c = strPoints;
                
            
            
                //Update the user story
                Database.update(lUserStory);        
                
                //If there is a chatter message, add it onto the estimation
                If(strMessage != ''){
                    FeedItem oNewItem = new FeedItem();
                    oNewItem.Body = 'Planning Poker Note:' + strMessage;
                    oNewItem.ParentId = lUserStory[0].Id;
                    Database.insert(oNewItem);  
                }
            }
                
            //clear the previous votes
            List<Planning_Poker_Votes__c> lVotes = [    Select  Id
                                                            From    Planning_Poker_Votes__c
                                                            Where   Planning_Poker_Session_Content__c =: lContent[0].Id ];
                
            //delete the votes
            Database.delete(lVotes);
            
                        
        } 
        
        
    }
    
    
      /* Method name :   getData
      * @description    Returns all data required for this session to the client.
      * @param          idSession   The id of this session as a string.
      * @return         PlanningPokerData
      */
    
    @RemoteAction 
    public static PlanningPokerData getData(String idSession){
        
        //Get the current session including the users that are in the session
        Planning_Poker_Session__c oSession = [  Select  Id, 
                                                        Leader__c, 
                                                        Title__c, 
                                                        (   Select User_Name__c 
                                                            From Planning_Poker_Session_Users1__r ) 
                                                From    Planning_Poker_Session__c
                                                Where   Id =: idSession 
                                                Limit   1 ];
                                                
        //Get the currently selected user story (content) and its votes
        List<Planning_Poker_Session_Content__c> lContent = [    Select  Id,
                                                                        User_Story__c, 
                                                                        User_Story_Title__c,
                                                                        User_Story__r.Name,
                                                                        System_Is_Selected__c,
                                                                        LastModifiedDate,
                                                                        (   Select  Id,
                                                                                    User__r.Name,
                                                                                    Vote__c
                                                                            From    Planning_Poker_Votes__r
                                                                            Order By LastModifiedDate
                                                                        )   
                                                                From    Planning_Poker_Session_Content__c 
                                                                Where   Planning_Poker_Session__c =: idSession
                                                                And     System_Is_Selected__c = true 
                                                                Limit   1 ];
        
        
        //create a new data object (JSON)                                           
        PlanningPokerData oData = new PlanningPokerData();
        
        //for all users, add this to the list
        for(Planning_Poker_Session_User__c oUser : oSession.Planning_Poker_Session_Users1__r)
            oData.Users.add(oUser.User_Name__c);
            
        //if we have a selected user story
        if(lContent.size()==1){
            
            //get the user story (content)
            Planning_Poker_Session_Content__c oContent = lContent[0];
            
            //for all users, add all votes to the list and send these back to the client
            for(Planning_Poker_Votes__c oVote : oContent.Planning_Poker_Votes__r){
                UserVote oUserVote = new UserVote();
                oUserVote.UserName = oVote.User__r.Name;
                oUserVote.UserVote = Integer.valueOf(oVote.Vote__c);
                oData.Votes.add(oUserVote);
            }
            
            //set the story and the votes
            oData.Story = oContent.User_Story_Title__c;
            oData.StoryID = oContent.User_Story__c;
            oData.StoryName = oContent.User_Story__r.Name;
            oData.LastModifiedDate = oContent.LastModifiedDate;     //note: this is simply used as a flag for re-estimation.
            
        }   
        
      
        //return data (JSON object)
        return oData;
        
    }
    
    
     /* Method name :   reEstimate
      * @description    Flags the story to be re-estimated. 
      * @param          idSession   The id of this session as a string.
      * @return         void
      */
      
    @RemoteAction 
    public static void reEstimate(String idSession){
        
        //Get the currently selected user story (content) and its votes
        List<Planning_Poker_Session_Content__c> lContent = [    Select  Id,
                                                                        User_Story__c, 
                                                                        User_Story_Title__c,
                                                                        System_Is_Selected__c,
                                                                        LastModifiedDate
                                                                From    Planning_Poker_Session_Content__c 
                                                                Where   Planning_Poker_Session__c =: idSession
                                                                And     System_Is_Selected__c = true 
                                                                Limit   1 ];
        
        if(lContent.size()==1){
            //clear the previous votes
            List<Planning_Poker_Votes__c> lVotes = [    Select  Id
                                                        From    Planning_Poker_Votes__c
                                                        Where   Planning_Poker_Session_Content__c =: lContent[0].Id ];
            
            //delete the votes
            Database.delete(lVotes);
            
            //change last modified date
            Database.update(lContent);
        }
    }
    
     /* Method name :   enterSession
      * @description    Function that runs when the page opens. Sets up the session for the user.
      * @return         void
      */
      
    public void enterSession(){
        
        
        //Select the record of the current user from the session user object
        List<Planning_Poker_Session_User__c> lUsers = [ Select  Id 
                                                        From    Planning_Poker_Session_User__c 
                                                        Where   Planning_Poker_Session__c =: this.session.Id 
                                                        And     User__c =: UserInfo.getUserId() 
                                                        Limit   1 ];
                                                        
        //if i am not yet in this ession
        If(lUsers.size()==0){
            
            //create a new poker/user object
            Planning_Poker_Session_User__c oSessionUser = new Planning_Poker_Session_User__c();
            oSessionUser.Planning_Poker_Session__c = this.session.Id;   //this session
            oSessionUser.User__c = UserInfo.getUserId();                //iam the user
            Database.insert(oSessionUser);                              //insert into the DB
        }
        
    }

     /* Method name :   generateSession
      * @description    Function that parses the set of user story IDs and creates a session.
      * @return         PageReference
      */
      
    public PageReference generateSession(){
    
        //Get the list of user story ids
        String idUserStories = ApexPages.currentPage().getParameters().get('generateSession');
        
        //Create variables
        List<Planning_Poker_Session_Content__c> lContent = new List<Planning_Poker_Session_Content__c>();
        Planning_Poker_Session__c oSession = new Planning_Poker_Session__c();
        
        //Current user by default will be the leader
        oSession.Leader__c = UserInfo.getUserId();
        
        //Create the session (insert into DB)
        Database.insert(oSession);
        
        String[] strIDArray = idUserStories.split(',');
        
        //for each user story, create a content object
        for(String strId : strIDArray){
            Planning_Poker_Session_Content__c oContent = new Planning_Poker_Session_Content__c();
            oContent.User_Story__c = strId;
            oContent.Planning_Poker_Session__c = oSession.Id;
            lContent.add(oContent);
        }
        
        //Insert the session content
        Database.insert(lContent);
                
        PageReference prSession = new PageReference('/' + oSession.Id);
        return prSession.setRedirect(true);
    }
    
     /* Method name :   setStory
      * @description    Marks a given story as the currently selected user story for estimation.
      * @param          idStory     The id of the user story that needs to be flagged to be estimated
      * @return         void
      */
      
    @RemoteAction
    public static void setStory(String idStory){
        
        //clear the previous votes
        List<Planning_Poker_Votes__c> lVotes = [    Select  Id
                                                    From    Planning_Poker_Votes__c
                                                    Where   Planning_Poker_Session_Content__c =: idStory ];
        
        //delete the votes
        Database.delete(lVotes);
        
        //Select single record - this record will be the newly selected story
        Planning_Poker_Session_Content__c oContent = [  Select  Id,
                                                                User_Story__c, 
                                                                User_Story_Title__c,
                                                                System_Is_Selected__c,
                                                                Planning_Poker_Session__c
                                                        From    Planning_Poker_Session_Content__c 
                                                        Where   Id =: idStory 
                                                        Limit   1 ];
        
        //fetch all content - need to reset selected story
        List<Planning_Poker_Session_Content__c> lContentsAll = [    Select  Id,
                                                                            System_Is_Selected__c
                                                                    From    Planning_Poker_Session_Content__c
                                                                    Where   Planning_Poker_Session__c =: oContent.Planning_Poker_Session__c ];  
        
        //for all stories, revert selected flag to false
        for(Planning_Poker_Session_Content__c oContentStory : lContentsAll)
            oContentStory.System_Is_Selected__c = false;
        
        //update the list
        Database.update(lContentsAll);
        
        //select the newly selected story by flagging it
        oContent.System_Is_Selected__c = true;
        
        //update the record
        Database.update(oContent);
        
        

    }
    
     /* Method name :   kickUser
      * @description    Removes a given user from this session.
      * @param          idSession   The id of this session as a string
      * @param          strName     The name of the user as a string
      * @return         void
      */
      
    @RemoteAction
    public static void kickUser(String strName, String idSession) {
        
        //Select the user assigned to this session given its name
        List<Planning_Poker_Session_User__c> lUser = [  Select  Id
                                                        From    Planning_Poker_Session_User__c
                                                        Where   Planning_Poker_Session__c =: idSession 
                                                        And     User__r.Name  =: strName  ];
        
        //Remove the user from the session
        if(lUser.size()>0)
            Database.delete(lUser[0]);
        
    }
    
    
     /* Method name :   vote
      * @description    Sets a vote for a given user story
      * @param          idSession   The id of this session as a string
      * @param          strVote     The number (vote) for the selected user story as a string
      * @return         void
      */
    @RemoteAction
    public static void vote(String strVote, String idSession) {
        
        //Select single record - this record will be the newly selected story
        Planning_Poker_Session_Content__c oContent = [  Select  Id,
                                                                User_Story__c, 
                                                                User_Story_Title__c,
                                                                Planning_Poker_Session__c
                                                        From    Planning_Poker_Session_Content__c 
                                                        Where   Planning_Poker_Session__c =: idSession
                                                        And     System_Is_Selected__c = true
                                                        Limit   1 ];
       
       List<Planning_Poker_Votes__c> lVotes = [ Select      Id,
                                                            Planning_Poker_Session_Content__c,
                                                            User__c,
                                                            Vote__c 
                                                From        Planning_Poker_Votes__c
                                                Where       User__c =: UserInfo.getUserId()
                                                And         Planning_Poker_Session_Content__c =: oContent.Id 
                                                Limit       1   ];
                                                
       Planning_Poker_Votes__c oVote = new Planning_Poker_Votes__c();
         
       if(lVotes.size()>0){
            oVote = lVotes[0];
       }else{
            oVote.Planning_Poker_Session_Content__c = oContent.Id;
       }
        
       oVote.User__c =UserInfo.getUserId();
       oVote.Vote__c = Integer.valueOf(strVote);
       
        
       Database.upsert(oVote);
                                            
       
    }
    
    
    
    /*****
     *  Note: since we don't use dynamic binding (all functions are webservices) we need wrapper classes to return JSON results.
     */
    
    /************
     *
     *  Class UserVote
     *  @description    Used as a wrapper between user name and vote. Returns as a JSON Object.
     */
     
    public class UserVote {
        public  String  UserName    {get;set;}
        public  Integer UserVote    {get;set;}
    }
    
     /************
     *
     *  Class PlanningPokerData
     *  @description    Used as a wrapper to store all planning poker data
     */
    
    public class PlanningPokerData {
        
        public String                               Story               {get; set;}     //Currently selected story
        public String                               StoryName           {get; set;}     //Name of currently selected story
        public String                               StoryID             {get; set;}     //ID of currently selected story
        public List<String>                         Users               {get; set;}     //List of users connected to the session
        public List<UserVote>                       Votes               {get; set;}     //List of current votes for the selected user story
        public DateTime                             LastModifiedDate    {get; set;}     //Last modified date of the user story, used for flagging re-estimation
        
        
         /* Constructor name :   PlanningPokerData
          * @description    Initializes the set of variables used in the class.
          */
        public PlanningPokerData(){     
            this.Users = new List<String>();
            this.Votes = new List<UserVote>();
        }
    }
    
    public class voteWrapper {
        
    
    }
    
 
}