@isTest(seeAllData=true)
private class LX_AccountTriggerUtils_Test {

/*Description:This is the test method written to test LX_AccountTriggerUtils by passing test data for Account.
*Param:None
*Returns:VOID
*/ 
    static testmethod void m1(){
        Map<id,List<String>> retVal=new Map<id,List<String>>();
        list<Account> NewAccList = new list<Account>();
        list<Account> OldAccList = new list<Account>();
        
        Account acc1 = Data_account.createAccount3();
        acc1.LX_Sales_Team_Assigned__c='Retail';
        update acc1;
        
        Account acc2 = Data_account.createAccount3();
        acc2.LX_Sales_Team_Assigned__c='Manufacturing';
        update acc2;
        
        Account acc3 = Data_account.createAccount3();
        acc3.LX_Sales_Team_Assigned__c='Banking';
        update acc3;
        
        Account acc4 = Data_account.createAccount3();
        acc4.LX_Sales_Team_Assigned__c='Insurance';
        update acc4;
        
        Account acc5 = Data_account.createAccount3();
        acc5.LX_Sales_Team_Assigned__c='Healthcare';
        update acc5;
        
        Account acc6 = Data_account.createAccount3();
        acc6.LX_Sales_Team_Assigned__c='Education';
        update acc6;
        
        Account acc7 = Data_account.createAccount3();
        acc7.LX_Sales_Team_Assigned__c='National Government';
        update acc7;
        
        Account acc8 = Data_account.createAccount3();
        acc8.LX_Sales_Team_Assigned__c='State & Local Government';
        update acc8;
        
        NewAccList.add(acc1);
        NewAccList.add(acc2);
        NewAccList.add(acc3);
        NewAccList.add(acc4);
        NewAccList.add(acc5);
        NewAccList.add(acc6);
        NewAccList.add(acc7);
        NewAccList.add(acc8);
        
        LX_AccountTriggerUtils.updatedPrimaryISSSegment(NewAccList);
        retVal=LX_AccountTriggerUtils.RatingCalc(NewAccList);
           
    }
 }