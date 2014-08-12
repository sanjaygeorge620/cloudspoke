@isTest
private class Test_AccountSharing {

    static testMethod void myUnitTest() {

       
            Account acc = Data_Account.createAccount(); 
            
            
            Account accReseller = Data_Account.createPartnerAccount();
           RecordType recType= [SELECT Name, Id FROM RecordType
                                             WHERE SobjectType = 'Account' limit 1];
                                       
            accReseller.RecordTypeID = recType.Id;
            update accReseller ;
            
            
            acc.Reseller_ID__c = accReseller.id;
            update acc;
            

    }
}