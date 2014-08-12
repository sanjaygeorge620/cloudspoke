public class quoteshare_controller {
	public Id qid {
		get;
		set;
	}
	public integer noOfRows {
		get;
		set;
	}
	public List < BigMachines__Quote__Share > qshMembers {
		get;
		set;
	}
	public boolean editmode {
		get;
		set;
	}
	public boolean addmorelimit {
		get;
		set;
	}
	public boolean hasDeleteAccess {
		get;
		set;
	}
	public list < qShWrap > newsharing {
		get;
		set;
	}
	private final BigMachines__Quote__c myQ {
		get;
		set;
	}
	public string SelecteduserId {
		get;
		set;
	}
	public string SelecteduserIdforedit {
		get;
		set;
	}
	string forwardstring {
		get;
		set;
	}
	public list < displayAccessWrapper > mainList {
		get;
		set;
	}
	public Set < ID > userSet {
		get;
		set;
	}
    
    public boolean useronoptyteam {
		get;
		set;
	}// US4138

	Set < ID > accessSet = new Set < ID > ();
	Set < ID > forwardSet = new Set < ID > ();
	Set < String > fwdString = new Set < String > ();
	Map < String, id > fwdmap = new Map < String, id > ();
	Map < id, String > username = new Map < id, String > ();
	String oppID;
    Id oppownerid ;
	public quoteshare_controller(ApexPages.StandardController controller) {
		forwardstring = '';
		mainList = new list < displayAccessWrapper > ();
		fwdString = new Set < String > ();
		forwardSet = new set < ID > ();
		accessSet = new set < ID > ();
		userSet = new set < ID > ();
		controller.addFields(new List < String > {
			'OwnerID', 'LX_Account__c', 'BigMachines__Transaction_Id__c', 'Forwarded_String__c', 'BigMachines__Opportunity__c'
		});
		this.myQ = (BigMachines__Quote__c) controller.getRecord();
		qid = controller.getId();

		oppID = myQ.BigMachines__Opportunity__c;
        System.debug('************ BigMachines__Opportunity__c: ************ ' + oppID);
		
		hasDeleteAccess = false;
		User loggedInUser = [Select id, profile.Name from User where id = : Userinfo.getUserId()];
		if (loggedInUser.profile.name.contains('System Admin')) {
			hasDeleteAccess = true;
		}
		init();
	}

	public void init() {
		if (string.isblank(forwardstring)) {
			forwardstring = myQ.Forwarded_String__c;
		}
		fwdString.clear();
		List < String > strlst = new list < String > ();
		if (String.isNotBlank(forwardstring)) {
			strlst = forwardstring.split('--');
		}
		if (!strlst.isEmpty()) {
			fwdString.addAll(strlst);
		}
		mainList.clear();
		addmorelimit = true;
		qshMembers = new List < BigMachines__Quote__Share > ();
		noOfRows = 50;
		qshMembers = [Select ID, UserOrGroupId, AccessLevel, parentID, RowCause from BigMachines__Quote__Share where ParentID = : qid and RowCause = 'Manual'];
		for (BigMachines__Quote__Share qsh: qshMembers) {
			userSet.add(qsh.UserOrGroupId);
		}

		for (User U: [Select ID, BigMachines__Login__c, BigMachines__User_Groups__c, BigMachines__Provisioned__c from user where id in : userset]) {
			fwdmap.put(U.BigMachines__Login__c, U.id);
			username.put(U.id, U.BigMachines__Login__c);
			if (String.isNOTBlank(U.BigMachines__Login__c) && String.isNOTBlank(U.BigMachines__User_Groups__c) && U.BigMachines__Provisioned__c) {
				accessSet.add(U.id);
			}
		}
		for (String st: fwdString) {
			if (fwdmap.containskey(st)) {
				forwardSet.add(fwdmap.get(st));
			}
		}
		system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXx' + forwardSet);
		for (BigMachines__Quote__Share bqs: qshMembers) {
			mainList.add(new displayAccessWrapper(bqs, accessSet.contains(bqs.UserorGroupID), forwardSet.contains(bqs.UserorGroupID)));
		}
		editmode = False;
	}

	public PageReference back() {
		PageReference redirect = new PageReference('/' + qid);
		redirect.setRedirect(true);
		return redirect;
	}

	public void Deletesharing() {
		try {
			BigMachines__Quote__Share qshrec = [Select ID, UserOrGroupId, ParentID from BigMachines__Quote__Share where id = : SelecteduserId];
			list < BigMachines__Quote__Share > TeamMembersToDelete = new list < BigMachines__Quote__Share > ();
			TeamMembersToDelete.add(qshrec);
			insertAuditTrail(TeamMembersToDelete, 'Quote Sharing Removal');
			delete qshrec;
			init();
		} catch (Exception ex) {
			LX_CommonUtilities.createExceptionLog(ex);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Delete failed :' + ex));
		}
	}

	public void Editsharing() {
		try {
			BigMachines__Quote__Share qshrec = [Select ID, UserOrGroupId, AccessLevel, ParentID from BigMachines__Quote__Share where id = : SelecteduserIdforedit];
			string access = qshrec.AccessLevel == 'Read' ? 'Edit' : 'Read';
			list < BigMachines__Quote__Share > TeamMembersToDelete = new list < BigMachines__Quote__Share > ();
			qshrec.AccessLevel = access;
			TeamMembersToDelete.add(qshrec);
			insertAuditTrail(TeamMembersToDelete, 'Quote Sharing Update');
			Update qshrec;
			init();
		} catch (Exception ex) {
			LX_CommonUtilities.createExceptionLog(ex);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Update failed :' + ex));
		}
	}

	private void insertAuditTrail(list < BigMachines__Quote__Share > TeamMembersToInsert, string insertedOrDeleted) {
		list < LX_Audit_Trail__c > auditlogList = new list < LX_Audit_Trail__c > ();
		for (BigMachines__Quote__Share acc: TeamMembersToInsert) {
			LX_Audit_Trail__c auditLog = new LX_Audit_Trail__c();
			auditLog.LX_Object__c = 'QuoteSharing';
			auditLog.Quote__c = acc.Parentid;
			auditLog.LX_Account__c = myQ.LX_Account__c;
			auditLog.LX_Modified_Date__c = system.now();
			auditLog.LX_New_Modified_By__c = Userinfo.getUserId();
			auditLog.Name = insertedOrDeleted;
			auditlog.LX_Team_Member__c = acc.UserorGroupId;
			if (insertedOrDeleted == 'Quote Sharing Update') {
				string old = acc.accesslevel == 'Read' ? 'Edit' : 'Read';
				auditlog.LX_New_Value_of_The_Field__c = acc.accesslevel;
				auditlog.LX_Old_Value_of_The_Field__c = old;
			}
			auditLogList.add(auditlog);
		}
		try {
			insert auditLogList;
		} catch (Exception ex) {
			LX_CommonUtilities.createExceptionLog(ex);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insert failed :' + ex));
		}

	}

	public List < selectOption > getQuoteAccessLevels() {
		List < selectOption > options = new List < selectOption > ();
		//  options.add(new selectOption('Read','Read Only')); 
		options.add(new selectOption('Edit', 'Read/Write'));
		return options;
	}


	//Wrapper class to hold the new Team Members
	public class qShWrap {
		public BigMachines__Quote__Share qshare {
			get;
			set;
		}
		public LX_Audit_trail__c audit {
			get;
			set;
		}
		public string quoteAccessLevel {
			get;
			set;
		}
		public qShWrap() {
			qshare = new BigMachines__Quote__Share();
			quoteAccessLevel = 'Edit';
			audit = new LX_Audit_Trail__c();
		}
	}


	public class displayAccessWrapper {
		public BigMachines__Quote__Share qShare {
			get;
			set;
		}
		public boolean DDAccess {
			get;
			set;
		}
		public boolean DDSynced {
			get;
			set;
		}

		public displayAccessWrapper(BigMachines__Quote__Share q, boolean dda, boolean dds) {
			qShare = q;
			DDAccess = dda;
			DDSynced = dds;
		}
	}

	public void showMore() {
		noOfRows = 1000;
	}

	public void syncwithBugMachines() //Not a Typo !!
	{
		list < displayAccessWrapper > mainListifsuccess = new list < displayAccessWrapper > ();
		string qnum = myQ.name;
		string transID = myQ.BigMachines__Transaction_Id__c;
		string usercsv = '';

		Set < ID > userid = new Set < ID > ();

		if (!qshMembers.isEmpty()) {
			for (BigMachines__Quote__Share qsr: qshMembers) {
				userid.add(qsr.userorGroupID);
			}

			for (displayAccessWrapper U: mainList) {
				if (username.containskey(U.qShare.UserOrGroupId) && U.DDAccess && !U.DDSynced) {
					usercsv = usercsv + ',' + username.get(U.qShare.UserOrGroupId);
					if (String.isblank(forwardstring)) {
						forwardstring = username.get(U.qShare.UserOrGroupId);
					} else {
						forwardstring = forwardstring + '--' + username.get(U.qShare.UserOrGroupId);
					}
				}
			}
		}
		BM_Quoteshare bmws = new BM_Quoteshare();
		List < String > DDresponse = bmws.doCallOut(qnum, transID, usercsv);


		if (!DDresponse.isEmpty()) {
			string message = '';
			boolean success = true;
			for (String st: DDresponse) {
				if (!st.contains('Successfully processed')) {
					success = false;
					message = message + '--------------' + st;
				} else if (success) {
					message = message + '--------------' + st;
				}
			}
			if (!success) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
			} else {
				try {
					BigMachines__Quote__c BQT = new BigMachines__Quote__c(id = myQ.id, Forwarded_String__c = forwardstring);
					update BQT;
					init();
				} catch (Exception ex) {
					LX_CommonUtilities.createExceptionLog(ex);
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insert failed :' + ex));
				}
				init();
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, message));
			}
		}
	}

	public void addNew() {
		editmode = True;
		newsharing = new List < qShWrap > ();

		for (integer i = 0; i < 5; i++) {
			qShWrap newMember = new qShWrap();
			newsharing.add(newMember);
		}
	}

	public void cancelEdit() {
		editmode = False;
		addmorelimit = true;
	}

	public void save() {
		Savepoint sp = Database.setSavepoint(); //Save point for rollback if DML fails.

		List < BigMachines__Quote__Share > toIns = new List < BigMachines__Quote__Share > ();

		boolean ownerpresent = false;
		
		try {
//US4138 starts
			System.debug('************ Dealdesk owner ID ************ ' + myQ.OwnerID);

            If (oppID != NULL){
                Opportunity opp = [SELECT Id, OwnerID FROM Opportunity where Id = : oppID limit 1];
                system.debug('inside oppty select');
            
            	System.debug('*****Opportunity selected ******* ' );
            	set<String> oppteamuserids = new set<String>(); 
				List < OpportunityTeamMember > results = [SELECT Id, OpportunityId, UserId, TeamMemberRole, OpportunityAccessLevel FROM OpportunityTeamMember where OpportunityId = : oppID];
            
				If (results.size() > 0)
            	{
                	for (OpportunityTeamMember oppteam: results) {
					oppteamuserids.add(oppteam.UserId);
					}
            	}
               
                system.debug('************ opp.OwnerId ************ ' + opp.OwnerId);	
                system.debug('************ oppteamuserids ************ ' + oppteamuserids);	
    
                System.debug('************ Opportunity ID ************ ' + oppID);
				for (qShWrap nqs: newsharing) {
                    useronoptyteam = False;
					For(integer i = 0; i < oppteamuserids.size();i++){
                        if (oppteamuserids.contains(nqs.audit.LX_Team_Member__c))
                        {
                        	useronoptyteam = True; 
                       	}
                        else{
                            useronoptyteam = False;
                        }
                      System.debug('************ nqs.audit.LX_Team_Member__c ************ ');
                    //    System.debug('************ oppteamuserids ************ ' + oppteamuserids);
                      }
                        if(!useronoptyteam && nqs.audit.LX_Team_Member__c != NULL){   
                          System.debug('************ Inside opptyteammember insert ************ ');
                            if( nqs.audit.LX_Team_Member__c != opp.OwnerId){                                
                            	OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();  //US4138
						        oppTeamMember.CurrencyIsoCode = 'USD';
                                oppTeamMember.OpportunityId = opp.Id;
                                oppTeamMember.TeamMemberRole = 'Quote Editor';
                                oppTeamMember.UserId = nqs.audit.LX_Team_Member__c;
                                insert oppTeamMember;
                                OpportunityShare oppshare = new OpportunityShare();
                                oppshare.OpportunityId = opp.Id;
                                oppshare.UserOrGroupId = nqs.audit.LX_Team_Member__c;
                                oppshare.OpportunityAccessLevel = 'Edit';
                                insert oppshare;
                            }		
                        }
					}

			}

            //US4138 ends
			for (qShWrap nqs: newsharing) {
				//
				if (nqs.audit.LX_Team_Member__c != null && nqs.quoteAccessLevel != null && nqs.quoteAccessLevel != null && nqs.audit.LX_Team_Member__c != myQ.OwnerID) {
					toIns.add(new BigMachines__Quote__Share(userorGroupID = nqs.audit.LX_Team_Member__c, parentid = qId, AccessLevel = nqs.quoteAccessLevel, RowCause = 'Manual'));
				} else if (nqs.audit.LX_Team_Member__c == myQ.OwnerID) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You cannot add the Owner of the Quote. Please remove and try again'));
					ownerpresent = true;
				}
			}
			if (!toIns.isEmpty() && !ownerpresent) {
				insertAuditTrail(toIns, 'Quote Sharing Insert');
				insert toIns;
				editmode = False;
				addmorelimit = true;
				init();
			} else if (toIns.isEmpty() && !ownerpresent) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Atleast one User should be selected'));
			}

		} catch (Exception ex) {
			LX_CommonUtilities.createExceptionLog(ex);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insert failed :' + ex));
			Database.rollback(sp);
		}
	}

	public void addMore() {
		if (newsharing.size() < 15) {
			for (integer i = 0; i < 5; i++) {
				qShWrap newMember = new qShWrap();
				newsharing.add(newMember);
			}
		} else if (newsharing.size() > 14) {
			addmorelimit = false;
		}
	}

}