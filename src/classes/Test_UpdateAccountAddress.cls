@isTest
private class Test_UpdateAccountAddress {

    static testMethod void Test_UpdateAccountAddress() {
 /*       Account acctRec = Data_Account.createAccount();  
        
        Account AccountRec = [select BillingStreet
                                    , BillingCity
                                    , BillingState
                                    , BillingPostalCode
                                    , BillingCountry
                                    , Physical_Street_Address__c
                                    , Physical_City__c
                                    , Physical_State__c
                                    , Physical_Postal_Code__c
                                    , Physical_Country__c
                                    from Account
                                    where id = :acctRec.id];
        
        //update standard address fields
        AccountRec.BillingStreet = '12365 Street';
		AccountRec.BillingCity = 'TestingCity';
		AccountRec.BillingState = 'Alabama';
		AccountRec.BillingPostalCode = '12365';
		AccountRec.BillingCountry = 'United States';
		AccountRec.Type = 'Suspect';
		
		system.debug('AccountRec:' + AccountRec);
		test.startTest();
		update AccountRec;
		test.stopTest();
		
		system.AssertEquals('12365 Street',
			[select Physical_Street_Address__c from Account where id = :AccountRec.id].Physical_Street_Address__c);
			
		system.AssertEquals('TestingCity',
			[select Physical_City__c from Account where id = :AccountRec.id].Physical_City__c);

		system.AssertEquals('Alabama',
			[select Physical_State__c from Account where id = :AccountRec.id].Physical_State__c);
			
		system.AssertEquals('12365',
			[select Physical_Postal_Code__c from Account where id = :AccountRec.id].Physical_Postal_Code__c);	
		
		system.AssertEquals('United States',
			[select Physical_Country__c from Account where id = :AccountRec.id].Physical_Country__c);
		*/			        
    }
}