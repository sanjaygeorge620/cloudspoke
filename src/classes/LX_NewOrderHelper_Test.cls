@isTest(seeAllData=true)
private class LX_NewOrderHelper_Test{
    public static testmethod void m1(){
   // List<LX_New_Order_Request__c> testListNew = new List<LX_New_Order_Request__c>();
        Account acc =  Data_Account.createAccount();
        List<String> strList = new List<String>();
        strList.add('Open');
        strList.add('Closed Won');
        strList.add('Closed Lost');
        List<Opportunity> oppList = Data_Opportunity.createOpportunity(strList,3);
        
   }
}