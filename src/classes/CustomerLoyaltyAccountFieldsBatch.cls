global class CustomerLoyaltyAccountFieldsBatch implements Database.Batchable<sObject> {
	
	global final String query = 'SELECT Id, Sum_of_Promoter__c, Count_of_Net_Promoter_Scores__c, Sum_of_Detractor__c, Sum_of_Passive__c FROM Account WHERE RecordType.Developername = \'Lx_Location_Customer\' OR RecordType.Developername = \'Lx_Location_Partner\'';
	
	/* 
	execute once 
	CustomerLoyaltyAccountFieldsBatch j = new CustomerLoyaltyAccountFieldsBatch();
    Id jId = Database.executeBatch(j, 1);
	
	schedule recurring on 1st and 15th--
	string CRON_EXP = '0 0 22 1,15 * ?';
    CustomerLoyaltyAccountFields_Schdl b = new CustomerLoyaltyAccountFields_Schdl();
    system.schedule('Customer Loyalty Rollup Fields Batch Job', CRON_EXP, b);
	*/
	
	
	// Start
	global Database.QueryLocator start(Database.BatchableContext bc) {
		
		return Database.getQueryLocator(query);
	}
	
	// Execute
	global void execute(Database.Batchablecontext BC, List<Account> scope) {
		
		List<Account> updateAccounts = new List<Account>();
		Map<Id, List<Survey_MKT_Customer_Loyalty__c>> accountIdCustomerLoyaltySurveyMap = new Map<Id, List<Survey_MKT_Customer_Loyalty__c>>();
		
		//CreateMap
		for(Survey_MKT_Customer_Loyalty__c cls : [SELECT Id, Passive__c, Promoter__c, Detractor__c, Account_Name__c
												  FROM Survey_MKT_Customer_Loyalty__c
												  WHERE Account_Name__c IN :scope]) {
			
			if(accountIdCustomerLoyaltySurveyMap.containsKey(cls.Account_Name__c)) {
				
				accountIdCustomerLoyaltySurveyMap.get(cls.Account_Name__c).add(cls);
			}
			else {
				
				accountIdCustomerLoyaltySurveyMap.put(cls.Account_Name__c, new List<Survey_MKT_Customer_Loyalty__c>{cls});
			}
		}
		
		for(Account a : scope) {
			
			integer sumOfPromoter = 0;
			integer sumOfDetractor = 0;
			integer sumOfPassive = 0;
			integer countOfNetPromoterScores = 0; 
			
			//check to see if related Customer Loyalty Survey records exist
			if(accountIdCustomerLoyaltySurveyMap.get(a.Id) != null) {
			
				for(Survey_MKT_Customer_Loyalty__c cls : accountIdCustomerLoyaltySurveyMap.get(a.Id)) {
					
					countOfNetPromoterScores++;
				
					if(cls.Promoter__c == 1) {
						
						sumOfPromoter++;
					}
					
					if(cls.Detractor__c == 1) {
						
						sumOfDetractor++;
					}
					
					if(cls.Passive__c == 1) {
						
						sumOfPassive++;
					}
				}
			}
				
			Account updateAccount = a;
			updateAccount.Count_of_Net_Promoter_Scores__c = countOfNetPromoterScores;
			updateAccount.Sum_of_Promoter__c = sumOfPromoter;
			updateAccount.Sum_of_Detractor__c = sumOfDetractor;
			updateAccount.Sum_of_Passive__c = sumOfPassive;
			
			updateAccounts.add(updateAccount);
		}
		
		//peform update
		update updateAccounts;
	}
	
	// Finish
	global void finish(Database.Batchablecontext BC) { 
	
		
	}
}