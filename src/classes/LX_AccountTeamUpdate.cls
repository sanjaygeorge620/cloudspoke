/*Class Name    : LX_AccountTeamUpdate 
    * Description   : This class is an Extension for "LX_AddTeamMembers"page.
    * Created By    : Kapil Reddy Sama
    * Created Date  : 07-01-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Kapil Reddy Sama         07-01-2013           1000                   Initial Version
    * Kapil                    04/09/2013           1002                   Commented the debug log statements.
    * Kapil                    05/09/2013           1003                   Added the Contact Access Level for Account Team.
    */

public class LX_AccountTeamUpdate {

    //Account Team Member to edit
    public AccountTeamMember teamMember{get;set;}
    // Account Access Level
    public string AccountAccessLevel {get;set;}
    // Opportunity Access Level
    public string OpportunityAccessLevel {get;set;}
    // Case Access Level
    public string CaseAccessLevel {get;set;}
    // Contact Access Level
    public string ContactAccessLevel {get;set;}
    // Contact Access Level
    public string TeamMemberRole {get;set;}
    //Account share 
    public AccountShare accShare{get;set;}
    //team member role for comparision
    private string memberRole;
    //accountid to update the AccountTeam
    private final string AccountId;
    //UserId to update the Account Team
    private final string userId;
    //Account team member id
    private final string id = ApexPages.currentPage().getParameters().get('teamMemberID');    
    //Access Levels Map,needs to be moved to a custom setting
    private map<string,string> accessLevelMap = new map<string,string>();
    
    //Initialize all the variables
    public LX_AccountTeamUpdate(ApexPages.StandardController controller) {
        
        teamMember = [Select AccountAccessLevel,AccountId,IsDeleted,TeamMemberRole,UserId,User.Name from AccountTeammember where id = :id ];
        memberRole = teamMember.TeamMemberRole;
        AccountId = teamMember.AccountId;
        userId = teamMember.userId;      
        //System.debug('userId-->'+userId);
        accShare = [Select AccountAccessLevel,OpportunityAccessLevel,CaseAccessLevel,ContactAccessLevel,AccountId 
                           from AccountShare 
                           where UserOrGroupId = :userId and AccountId = :AccountId and rowCause = 'Team' ];
        AccountAccessLevel = accShare.AccountAccessLevel;
        OpportunityAccessLevel = accShare.OpportunityAccessLevel;
    //  ContactAccessLevel = accShare.ContactAccessLevel;
        CaseAccessLevel = accshare.CaseAccessLevel;
        TeamMemberRole = teamMember.TeamMemberRole;        
        accessLevelMap.put('None','Private');
        accessLevelMap.put('Read','Read Only');
        accessLevelMap.put('Edit','Read/Write');
    } 
    /* Description : Account Access levels for Account Team Member
    *  Param - 
    *  Returns :  List<selectOption>
    */    
    public List<selectOption> getAccountAccessLevels() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }
    /* Description : Opportunity Access levels for Account Team Member
    *  Param - 
    *  Returns :  List<selectOption>
    */    
    public List<selectOption> getOpportunityAccessLevels() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None','Private')); 
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }
    /* Description : Case Access levels for Account Team Member
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getCaseAccessLevels() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None','Private')); 
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }
    /* Description : Contact Access levels for Account Team Member
    *  Param - 
    *  Returns :  List<selectOption>
    */
    public List<selectOption> getContactAccessLevels() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('None','Private')); 
        options.add(new selectOption('Read','Read Only')); 
        options.add(new selectOption('Edit','Read/Write')); 
        return options;
    }    
    /* Description : Update Account Team Member and insert in to the Audit Trail.
    *  Param - 
    *  Returns :  pageRefernce
    */
    
    public pageReference UpdateTeamMember(){
        
        //Added by NJ 06/10/2014
        //This will invoke the Healthcare_Account_Snapshot__c triggers in order to create/update/delete sharing rules 
        try {
	        
	        List<Healthcare_Account_Snapshot__c> updateSnapshots = new List<Healthcare_Account_Snapshot__c>();
	        
	        for(Healthcare_Account_Snapshot__c has : [SELECT Id, Account__c
	        				   						  FROM Healthcare_Account_Snapshot__c
	    				   							  WHERE Account__c = :teamMember.AccountId]) {
	    		
	    		updateSnapshots.add(has);			   							  	
			}
			
			if(updateSnapshots.size() > 0) {
					
				update updateSnapshots;
			}
		}
		catch(Exception ex) {
			
			LX_CommonUtilities.createExceptionLog(ex);
		}
        
        try{
            AccountTeamMember teamMemberToUpdate = new AccountTeamMember();
            teamMemberToUpdate.AccountId = teamMember.AccountId;
            teamMemberToUpdate.UserId = teamMember.UserId;
            teamMemberToUpdate.TeamMemberRole = teamMember.TeamMemberRole;
            insert teamMemberToUpdate;        
            
            AccountShare acc = new AccountShare(AccountAccessLevel = AccountAccessLevel,
                                             // ContactAccessLevel = ContactAccessLevel,
                                                OpportunityAccessLevel = OpportunityAccessLevel,                                                
                                                CaseAccessLevel = CaseAccessLevel,
                                                AccountId = teamMember.AccountId,
                                                UserorgroupId = teamMember.UserId);
            
            insert acc;        
            
            //insert Audit Trail if team member is updated
            if(accShare.AccountAccessLevel != acc.AccountAccessLevel){
                insertAuditTrail('AccountAccessLevel',accessLevelMap.get(accShare.AccountAccessLevel),accessLevelMap.get(acc.AccountAccessLevel));        
            }        
            if(accShare.OpportunityAccessLevel != acc.OpportunityAccessLevel){
                insertAuditTrail('OpportunityAccessLevel',accessLevelMap.get(accShare.OpportunityAccessLevel),accessLevelMap.get(acc.OpportunityAccessLevel));        
            }       
                 
            if(accShare.CaseAccessLevel != acc.CaseAccessLevel){
                insertAuditTrail('CaseAccessLevel',accessLevelMap.get(accShare.CaseAccessLevel),accessLevelMap.get(acc.CaseAccessLevel));        
            }
        /*    if(accShare.ContactAccessLevel != acc.ContactAccessLevel)
            {
                insertAuditTrail('ContactAccessLevel',accessLevelMap.get(accShare.ContactAccessLevel),accessLevelMap.get(acc.ContactAccessLevel));        
            }   */
            //system.debug('memberRole-->'+memberRole);
            //system.debug('teamMemberToUpdate.TeamMemberRole-->'+teamMemberToUpdate.TeamMemberRole);
            if(teamMemberToUpdate.TeamMemberRole != memberRole){
                insertAuditTrail('TeamMemberRole',memberRole,teamMemberToUpdate.TeamMemberRole);        
            }        
        }
        catch(Exception ex){
            LX_CommonUtilities.createExceptionLog(ex);
        }
        return new pageReference('/'+teamMember.AccountId);
        
    }
    /* Description : Cancel the update,redirect to the Account detail page.
    *  Param - 
    *  Returns :  pageRefernce
    */
    
    public pageReference cancel(){
        return new Pagereference('/'+teamMember.AccountId);
    }
    /* Description : insert the Audit trail record.
    *  Param - string field: Updated Account Team field , string oldvalue : Old value of the field, string newvalue: new value of the field 
    *  Returns :  void
    */
    
    private void insertAuditTrail(string field,string oldvalue, string newvalue){
     LX_Audit_Trail__c auditLog = new LX_Audit_Trail__c();
     auditLog.LX_Object__c = 'AccountTeamMember';
     auditLog.LX_Account__c = AccountId;
     auditLog.LX_Modified_Date__c = system.now();
     auditLog.LX_New_Modified_By__c = Userinfo.getUserId();
     auditLog.Name =  field;
     auditLog.LX_New_Value_of_The_Field__c = newvalue;
     auditlog.LX_Old_Value_of_The_Field__c = oldvalue;
     auditlog.LX_Team_Member__c = userId;
     try{
        insert auditLog;     
     }catch(Exception ex){
     LX_CommonUtilities.createExceptionLog(ex);
     }     
    }

}