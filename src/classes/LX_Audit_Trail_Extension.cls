/* Class Name   : LX_Audit_Trail_Extension 
    * Description  : This class is an Extension for "LX_AccountTeamEdit" and "LX_Account_Team_Audit_Trail" pages.
    * Created By   : Kapil
    * Created Date : 07/01/2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Kapil                 07/01/2013              1000                   Initial Version
    * Kapil                  04/09/2013             1002                   Commented the debug log statements.
    * Kapil                  05/09/2013             1003                   Added the Contact Access Level for Account Team.
    */

 public class LX_Audit_Trail_Extension {
    //store all the new team members info
    public list<teamWrapper> newMemberList {get;set;}
    //Selected team member
    public string SelectedTeamMeberId {get;set;}
    //Account Id
    public string id;        
    //list of Account Team Members
    public list<AccountTeamMember> accountTeamMembers {get;set;}    
    public boolean addTeammember{get;set;}
    
    /* Description : Get the Account Access levels on Account Team
    *  Param - 
    *  Returns :  list<selectOption>
    */
    public List<selectOption> getAccountAccessLevels() {
        List<selectOption> options = new List<selectOption>();        
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }
    //variable to control the Account Team display
    public boolean displayAccountTeam {get;set;}
    //display access wrapper list
    public list<displayAccessWrapper> displayAccessList {get;set;}
    
    /* Description : Get the Opportunity Access levels on Account Team
    *  Param - 
    *  Returns :  list<selectOption>
    */
    public List<selectOption> getOpportunityAccessLevels() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None','Private')); 
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }
    
    /* Description : Get the Case Access levels on Account Team
    *  Param - 
    *  Returns :  list<selectOption>
    */
    public List<selectOption> getCaseAccessLevels() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None','Private')); 
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }
    
    /* Description : Get the Contact Access levels on Account Team
    *  Param - 
    *  Returns :  list<selectOption>
    */
    public List<selectOption> getContactAccessLevels() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None','Private')); 
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }
    //No of rows to display
    public integer noOfRows{get;set;}
    
    //Constructor
    public LX_Audit_Trail_Extension(ApexPages.StandardController controller) {
        noOfRows = 3;
        id = ApexPages.currentPage().getParameters().get('id');        
        User loggedInUser  = [Select id,profile.Name from User where id = :Userinfo.getUserId()];
        accountTeamMembers = [Select AccountAccessLevel,AccountId,IsDeleted,TeamMemberRole,UserId,User.Profile.Name,User.Name from AccountTeammember where AccountId = :id and AccountAccessLevel != 'None']; 
        string displayAccess = ApexPages.currentPage().getParameters().get('displayAccess');
       
        list<AccountShare> accountShareList = new list<AccountShare>([Select id,AccountAccessLevel,ContactAccessLevel,CaseAccessLevel,OpportunityAccessLevel,AccountId,RowCause,UserOrGroupId from AccountShare                                where AccountID = :id  and ((RowCause = 'Owner') or ( UserOrGroupId = :UserInfo.getUserId() and (AccountAccessLevel = 'Edit' OR AccountAccessLevel = 'All')))]);
        if((accountShareList != null && accountShareList.size() > 0) || loggedInUser.profile.Name == 'System Administrator' ){
            displayAccountTeam = true;        
        }else 
            displayAccountTeam = false;            
        
    }
    
    /* Description : Get all the Account Team Members from selected Account.
    *  Param - 
    *  Returns :  list<AccountTeamMember>
    */
    public list<AccountTeamMember> getaccountTeamMembers(){
        accountTeamMembers = new list<AccountTeamMember>([Select AccountAccessLevel,AccountId,IsDeleted,TeamMemberRole,UserId,User.Name,User.Profile.Name from AccountTeammember where AccountId = :id and AccountAccessLevel != 'None']);
        return accountTeamMembers;    
    }
    
    /* Description : Delete all the team members from Account Team
    *  Param - 
    *  Returns :  void
    */
    public void deleteAll(){
        Savepoint sp = Database.setSavepoint();
        try{
            insertAuditTrail(accountTeamMembers, 'Account Team Member Removed');
            delete accountTeamMembers ;            
        }catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Delete failed :'+ex)); 
            Database.rollback(sp);
        }
    } 
    
    /* Description : Add default team members to the team.
    *  Param - 
    *  Returns :  void
    */
    public void addDefaultTeam(){
        Savepoint sp = Database.setSavepoint();
        list<AccountTeamMember> TeamMembersToInsert = new list<AccountTeamMember>();
        list<AccountShare> AccountSharesToInsert = new list<AccountShare>();
        for(UserAccountTeamMember teamMember : [Select AccountAccessLevel,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel,OwnerId,TeamMemberRole,UserId 
                                                from UserAccountTeamMember 
                                                where OwnerId =:Userinfo.getUserId()]){
            AccountTeamMember teamMemberToUpdate = new AccountTeamMember();
            teamMemberToUpdate.AccountId = id;
            teamMemberToUpdate.UserId = teamMember.UserId;
            teamMemberToUpdate.TeamMemberRole = teamMember.TeamMemberRole;
            TeamMembersToInsert.add(teamMemberToUpdate);                    
            
            AccountShare acc = new AccountShare(AccountAccessLevel = teamMember.AccountAccessLevel,
                                              //ContactAccessLevel = teamMember.ContactAccessLevel,
                                                OpportunityAccessLevel = teamMember.OpportunityAccessLevel,
                                                CaseAccessLevel = teamMember.CaseAccessLevel,
                                                AccountId = id,
                                                UserorgroupId = teamMember.UserId);
            AccountSharesToInsert.add(acc);
        
        }       
        try{    
            insert TeamMembersToInsert;
            insert AccountSharesToInsert; 
            insertAuditTrail(TeamMembersToInsert,'Account Team Member Added');                          
        }catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+ex)); 
            Database.rollback(sp);
        }       
        
    }
    
    /* Description : Display the Account Team Access
    *  Param - 
    *  Returns :  void
    */
       
    public void displayAccess(){
        noOfRows = 3;    
        map<string,string> accessMap = new map<string,string>();
        accessMap.put('Read', 'Read Only');
        accessMap.put('Edit','Read Write');
        accessMap.put('None','Private');  
        accessMap.put('All','Full Access');     
        displayAccessList = new list<displayAccessWrapper>();
        //system.debug('accountTeamMembers-->'+accountTeamMembers);
        map<id,AccountTeammember> userProfileMap = new map<id,AccountTeammember>();
        for(AccountTeamMember accTeamMember : accountTeamMembers){
                //system.debug('-->'+accTeamMember.User.Profile.Name);
                userProfileMap.put(accTeamMember.userId,accTeamMember);
        }
        for(AccountShare accShare : [Select id,AccountId,AccountAccessLevel,ContactAccessLevel,CaseAccessLevel,OpportunityAccessLevel,UserOrGroupId,rowCause
                                            from AccountShare 
                                            where AccountId = :id and rowCause in  ('Team','Owner') ]){
            if(userProfileMap.containsKey(accShare.UserOrGroupId)){
                    displayAccessWrapper wrp = new displayAccessWrapper();                      
                    wrp.teamMemberId = userProfileMap.get(accShare.UserOrGroupId).UserId;
                    wrp.teammemberName = userProfileMap.get(accShare.UserOrGroupId).User.Name;
                    wrp.accounTeamMemberId = userProfileMap.get(accShare.UserOrGroupId).id;
                    wrp.teamMemberRole = userProfileMap.get(accShare.UserOrGroupId).TeamMemberRole;
                    if(userProfileMap.get(accShare.UserOrGroupId).User.Profile.Name == 'System Administrator'){
                        wrp.accountAccessLevel = 'Full Access';
                        wrp.caseAccessLevel = 'Full Access';
                        wrp.opportunityAccessLevel = 'Full Access';
                 //     wrp.ContactAccessLevel = 'Full Access';
                    }                                                                         
                    else
                    {
                        wrp.accountAccessLevel = accessMap.get(accShare.AccountAccessLevel);
                //      wrp.contactAccessLevel = accessMap.get(accShare.ContactAccessLevel);
                        wrp.caseAccessLevel = accessMap.get(accShare.CaseAccessLevel);
                        wrp.opportunityAccessLevel = accessMap.get(accShare.OpportunityAccessLevel);
                    }
                    displayAccessList.add(wrp);
            }
        }           
    }
    /* Description : Add team members to the wrapper.
    *  Param - 
    *  Returns :  void
    */
    
    public void addTeamMembers(){
        newMemberList = new List<teamWrapper>();
        for(integer i = 0 ; i<5;i ++){
           teamWrapper newMember = new teamWrapper(); 
           newMemberList.add(newMember);
        }
    }
    
    /* Description : Delete the selected Account team member.
    *  Param - 
    *  Returns :  void
    */    
    
    public void DeleteAccount(){
        try{
            AccountTeamMember accTeamMember = new AccountTeamMember();
            accTeamMember = [Select id,AccountAccessLevel,AccountId,IsDeleted,TeamMemberRole,UserId from AccountTeamMember where id = :SelectedTeamMeberId];
            list<AccountTeamMember> TeamMembersToDelete = new list<AccountTeamMember>();
            TeamMembersToDelete.add(accTeamMember);
            insertAuditTrail(TeamMembersToDelete,'Account Team Member Removed');  
            delete accTeamMember ;
            
        }catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Delete failed :'+ex)); 
        }
    }
    
    /* Description : Insert the Account Team Members 
    *  Param - 
    *  Returns :  PageReference
    */
    
    public pageReference insertTeamMembers()
    {
        Savepoint sp = Database.setSavepoint();//Save point for rollback if DML fails.
        list<AccountTeamMember> TeamMembersToInsert = new list<AccountTeamMember>();
        list<AccountShare> AccountSharesToInsert = new list<AccountShare>();
        for(teamWrapper wrp : newMemberList){
            if(wrp.audit.LX_New_Modified_By__c != null && wrp.member.TeamMemberRole != null && wrp.member.TeamMemberRole != ''){
                AccountTeamMember teamMemberToUpdate = new AccountTeamMember();
                teamMemberToUpdate.AccountId = id;
                teamMemberToUpdate.UserId = wrp.audit.LX_New_Modified_By__c;
                teamMemberToUpdate.TeamMemberRole = wrp.member.TeamMemberRole;
                TeamMembersToInsert.add(teamMemberToUpdate);                    

                AccountShare acc = new AccountShare(AccountAccessLevel = wrp.AccountAccessLevel,
                                                    OpportunityAccessLevel = wrp.OpportunityAccessLevel,                                                        
                                                    CaseAccessLevel = wrp.CaseAccessLevel,
                                                  //contactAccessLevel = wrp.contactAccessLevel,
                                                    AccountId = id,
                                                    UserorgroupId = wrp.audit.LX_New_Modified_By__c);
                AccountSharesToInsert.add(acc);
            }
            else if((wrp.audit.LX_New_Modified_By__c == null && wrp.member.TeamMemberRole != null && wrp.member.TeamMemberRole != '') )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Team Member not entered.'));
                return null;
            }else if(wrp.audit.LX_New_Modified_By__c != null && (wrp.member.TeamMemberRole == null || wrp.member.TeamMemberRole == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Role not entered.'));
                return null;    
            }
        }
        
        
        //Added by NJ 06/10/2014
        //This will invoke the Healthcare_Account_Snapshot__c triggers in order to create/update/delete sharing rules 
        try {
	        
	        List<Healthcare_Account_Snapshot__c> updateSnapshots = new List<Healthcare_Account_Snapshot__c>();
	        
	        for(Healthcare_Account_Snapshot__c has : [SELECT Id, Account__c
	        				   						  FROM Healthcare_Account_Snapshot__c
	    				   							  WHERE Account__c = :id]) {
	    		
	    		updateSnapshots.add(has);			   							  	
			}
			
			if(updateSnapshots.size() > 0) {
					
				update updateSnapshots;
			}
		}
		catch(Exception ex) {
			
			LX_CommonUtilities.createExceptionLog(ex);
		}
				   
          
        try
        {    
            insert TeamMembersToInsert;
            insert AccountSharesToInsert; 
            insertAuditTrail(TeamMembersToInsert,'Account Team Member Added'); 
            system.debug('Account Team Member Added');
            system.debug('XXXXXXXXXX' +id);                         
        }
        catch(Exception ex){                       
            LX_CommonUtilities.createExceptionLog(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insert failed :'+ex)); 
            Database.rollback(sp); 
            return null;
        }
        return new Pagereference('/'+id);      
        }
    
    /* Description : Insert the Audit Trail for each Insert,Update or delete of Account Team
    *  Param - list<AccountTeamMember> :List of team members to insert,string: To store the Insert and Delete operation 
    *  Returns :  Void
    */
        
    private void insertAuditTrail(list<AccountTeamMember> TeamMembersToInsert,string insertedOrDeleted){
        list<LX_Audit_Trail__c> auditlogList = new list<LX_Audit_Trail__c>();       
        for(AccountTeamMember acc:TeamMembersToInsert){
         LX_Audit_Trail__c auditLog = new LX_Audit_Trail__c();
         auditLog.LX_Object__c = 'AccountTeamMember';
         auditLog.LX_Account__c = id;
         auditLog.LX_Modified_Date__c = system.now();
         auditLog.LX_New_Modified_By__c = Userinfo.getUserId();
         auditLog.Name = insertedOrDeleted;   
         auditlog.LX_Team_Member__c = acc.UserId;
         auditLogList.add(auditlog);
        }
        try{        
            insert auditLogList;     
         }catch(Exception ex){
         LX_CommonUtilities.createExceptionLog(ex);
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insert failed :'+ex)); 
         }

    }
    /* Description : Cancel method to redirect to Account detail page
    *  Param - 
    *  Returns :  PageReference
    */
    
    public Pagereference cancel(){
        return new Pagereference('/'+id);    
    }
    
    //Wrapper class to hold the new Team Members
    public class teamWrapper{
        
        // Account Access Level
        public string AccountAccessLevel {get;set;}
        // Opportunity Access Level
        public string OpportunityAccessLevel {get;set;}
        // Case Access Level
        public string CaseAccessLevel {get;set;}
        // Contact Access Levelo
        public string ContactAccessLevel {get;set;}
        // Team member role 
        public string TeamMemberRole {get;set;}
        //Audit Trail     
        public LX_Audit_trail__c audit {get;set;}
        // Team Member 
        public AccountTeamMember member{get;set;}
        //constructor
        public teamWrapper(){
            member = new AccountTeamMember();
            audit  = new LX_Audit_Trail__c();                 
        }
    }
    
    
    //Wrapper class to hold the new Team Members
    public class displayAccessWrapper{
        public string caseAccessLevel {get;set;}
        public string contactAccessLevel {get;set;}
        public string opportunityAccessLevel {get;set;}
        public string teamMemberId {get;set;}
        public string teamMemberName {get;set;}
        public string accountAccessLevel {get;set;}
        public string teamMemberRole {get;set;}
        public id accounTeamMemberId {get;set;}        
        public displayAccessWrapper(){
                
        }
    }
    
    /* Description : Show more Account Team Members
    *  Param - 
    *  Returns :  Void
    */
    public void showMore(){
     noOfRows = 1000;     
    }
    /* Description : Display Account Team Access
    *  Param - 
    *  Returns :  Void
    */
    
    public void showAccessList(){
     noOfRows = 1000;        
    }
    
    
    
}