public with sharing class handler_HealthcareAccountSnapshot {
	
	public static void preventDeleteAccesss(List<Healthcare_Account_Snapshot__c> deletedHCAcctSnapshots) {
		
		boolean DeleteAccess = LX_UserAccess__c.getInstance(userinfo.getuserid()).HealthcareAccountSnapshot_Deletion__c;
	    //Prevent unauthorized users from deleting Healthcare_Account_Snapshot__c
	    for(Healthcare_Account_Snapshot__c has : deletedHCAcctSnapshots){
	         
	         if(!DeleteAccess) {
	             has.adderror('Insufficient Delete Permissions');
	         }
	    }
	}
	
	//AfterInsert 
	public static void prepareToCreateSharingRules(List<Healthcare_Account_Snapshot__c> newHCAcctSnapshots) {
		
		Set<Id> accountIds = new Set<Id>();
		Map<Id, List<AccountTeamMember>> acctIdAcctTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
		
		for(Healthcare_Account_Snapshot__c has : newHCAcctSnapshots) {
			
			accountIds.add(has.Account__c);
		}

		Map<Id, Id> accountIdOwnerIdMap = new Map<Id, Id>();

		for(Account a : [SELECT Id, OwnerId
						 FROM Account
						 WHERE Id IN :accountIds]) {

			accountIdOwnerIdMap.put(a.Id, a.OwnerId);
		}
		
		for(AccountTeamMember atm : [SELECT AccountAccessLevel, AccountId, UserId 
									 FROM AccountTeamMember 
									 WHERE AccountId IN :accountIds 
									 AND AccountAccessLevel != 'None'
									 AND AccountAccessLevel != 'Read']) {
			
			if(acctIdAcctTeamMembersMap.containsKey(atm.AccountId)) {

				acctIdAcctTeamMembersMap.get(atm.AccountId).add(atm);
			}
			else {
			
				acctIdAcctTeamMembersMap.put(atm.AccountId, new List<AccountTeamMember>{atm});
			}						 	
		}
		
		createNewAccountOwnerSharingRules(newHCAcctSnapshots, accountIdOwnerIdMap);
		createNewAccountTeamMemberSharingRules(newHCAcctSnapshots, acctIdAcctTeamMembersMap);
	}
	
	//After Update
	public static void checkforAccountTeamMemberChanges(List<Healthcare_Account_Snapshot__c> hcAcctSnapshots, Map<Id, Healthcare_Account_Snapshot__c> hcAcctSnapshotMap) {
		
		Set<Id> accountIds = new Set<Id>();
		Map<Id, Id> ownerIdAccountIdMap = new Map<Id, Id>();
		
		for(Healthcare_Account_Snapshot__c has : hcAcctSnapshots) {
			
			accountIds.add(has.Account__c);
		}

		for(Account a : [SELECT Id, OwnerId
						 FROM Account
						 WHERE Id IN :accountIds]) {

			ownerIdAccountIdMap.put(a.OwnerId, a.Id);
		}
		
		Map<Id,Id> userIdAcountTeamMemberIdMap = new Map<Id,Id>();
		Map<Id, AccountTeamMember> atmIdAccountTeamMemberMap = new Map<Id, AccountTeamMember>();
		
		for(AccountTeamMember atm : [SELECT Id, AccountAccessLevel, AccountId, UserId 
									 FROM AccountTeamMember 
									 WHERE AccountId IN :accountIds 
									 AND AccountAccessLevel != 'None'
									 AND AccountAccessLevel != 'Read']) {
			
			userIdAcountTeamMemberIdMap.put(atm.UserId, atm.Id);	
			atmIdAccountTeamMemberMap.put(atm.Id, atm);						 	
		}
		
		List<Healthcare_Account_Snapshot__Share> deleteSharingRules = new List<Healthcare_Account_Snapshot__Share>();
		
		for(Healthcare_Account_Snapshot__Share has : [SELECT Id, UserOrGroupId, ParentId, RowCause, AccessLevel
									 				  FROM Healthcare_Account_Snapshot__Share 
									 				  WHERE ParentId IN :hcAcctSnapshotMap.keyset()
									 				  AND RowCause = 'Manual']) {
			
			system.debug('Bazinga... ' + has.UserOrGroupId + ' ... ' + has.RowCause + ' ... ' + has.AccessLevel);
			
			if(userIdAcountTeamMemberIdMap.keyset().contains(has.UserOrGroupId)) {
				
				userIdAcountTeamMemberIdMap.remove(has.UserOrGroupId);
			}
			else if(ownerIdAccountIdMap.keyset().contains(has.UserOrGroupId)) {

				ownerIdAccountIdMap.remove(has.UserOrGroupId);
			}
			else {
				
				//make sure not deleting a group Id related to a custom sharing rule
				//if(string.valueOf(has.UserOrGroupId).substring(0,3) != '00G') {
					
					//delete this sharing rule
					deleteSharingRules.add(has);
				//}
			}
		}
		
		Map<Id, List<AccountTeamMember>> acctIdAcctTeamMembersMap = new Map<Id, List<AccountTeamMember>>();
		
		//check to add new accountTeamMember sharing rules
		if(userIdAcountTeamMemberIdMap.size() > 0) {
			
			for(Id userId : userIdAcountTeamMemberIdMap.keyset()) {
				
				if(acctIdAcctTeamMembersMap.containsKey(atmIdAccountTeamMemberMap.get(userIdAcountTeamMemberIdMap.get(userId)).AccountId)) {

					acctIdAcctTeamMembersMap.get(atmIdAccountTeamMemberMap.get(userIdAcountTeamMemberIdMap.get(userId)).AccountId).add(atmIdAccountTeamMemberMap.get(userIdAcountTeamMemberIdMap.get(userId)));
				}
				else {
				
					acctIdAcctTeamMembersMap.put(atmIdAccountTeamMemberMap.get(userIdAcountTeamMemberIdMap.get(userId)).AccountId, new List<AccountTeamMember>{atmIdAccountTeamMemberMap.get(userIdAcountTeamMemberIdMap.get(userId))});
				}
			}
		}

		Map<Id, Id> accountIdOwnerIdMap = new Map<Id, Id>();
		//check to add new accountOwner sharing rules
		if(ownerIdAccountIdMap.size() > 0) {

			for(Id userId : ownerIdAccountIdMap.keyset()) {

				accountIdOwnerIdMap.put(ownerIdAccountIdMap.get(userId), userId);
			}
		}
		
		if(accountIdOwnerIdMap.size() > 0) {

			createNewAccountOwnerSharingRules(hcAcctSnapshots, accountIdOwnerIdMap);
		}

		if(acctIdAcctTeamMembersMap.size() > 0) {
			
			createNewAccountTeamMemberSharingRules(hcAcctSnapshots, acctIdAcctTeamMembersMap);
		}
		
		if(deleteSharingRules.size() > 0) {
			
			delete deleteSharingRules;
		}
	}
	
	public static void createNewAccountOwnerSharingRules(List<Healthcare_Account_Snapshot__c> hcAcctSnapshots, Map<Id, Id> accountIdOwnerIdMap) {

		List<Healthcare_Account_Snapshot__Share> newUserSharingRules = new List<Healthcare_Account_Snapshot__Share>();
		
		for(Healthcare_Account_Snapshot__c has : hcAcctSnapshots) {

			if(accountIdOwnerIdMap.get(has.Account__c) != null) {

				Healthcare_Account_Snapshot__Share newHCAcctSnapshotShare = new Healthcare_Account_Snapshot__Share();
				newHCAcctSnapshotShare.UserOrGroupId = accountIdOwnerIdMap.get(has.Account__c);
				newHCAcctSnapshotShare.ParentId = has.Id;
				newHCAcctSnapshotShare.AccessLevel = 'Edit';
					
				newUserSharingRules.add(newHCAcctSnapshotShare);
			}
		}

		if(newUserSharingRules.size() > 0) {
			
			insert newUserSharingRules;
		}
	}

	//Create and Insert New Sharing Rules
	public static void createNewAccountTeamMemberSharingRules(List<Healthcare_Account_Snapshot__c> hcAcctSnapshots, Map<Id, List<AccountTeamMember>> acctIdAcctTeamMembersMap) {
		
		List<Healthcare_Account_Snapshot__Share> newUserSharingRules = new List<Healthcare_Account_Snapshot__Share>();
		
		for(Healthcare_Account_Snapshot__c has : hcAcctSnapshots) {
			
			if(acctIdAcctTeamMembersMap.get(has.Account__c) != null) {
				
				for(AccountTeamMember atm : acctIdAcctTeamMembersMap.get(has.Account__c)) {
					
					Healthcare_Account_Snapshot__Share newHCAcctSnapshotShare = new Healthcare_Account_Snapshot__Share();
					newHCAcctSnapshotShare.UserOrGroupId = atm.UserId;
					newHCAcctSnapshotShare.ParentId = has.Id;
					newHCAcctSnapshotShare.AccessLevel = 'Edit';
					
					newUserSharingRules.add(newHCAcctSnapshotShare);
				}
			}
		}
		
		if(newUserSharingRules.size() > 0) {
			
			insert newUserSharingRules;
		}
	}
	
}