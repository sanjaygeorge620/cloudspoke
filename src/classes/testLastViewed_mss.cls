@isTest(seeAlldata=true) 
private class testLastViewed_mss{
    public static testmethod void m1(){
        
        Account acc = Data_account.createAccount();
        
        Migration_Services_Server__c obj = new Migration_Services_Server__c();
        obj.Name='Test MSS';
        obj.Account__c=acc.id;
        obj.Feature_Key__c='12345';
        obj.Date_Issued__c=System.Today();
        obj.Configured_By__c=UserInfo.getUserId();
        insert obj;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        lastViewed_mss mss = new lastViewed_mss(sc);
        mss.updateField();
    }
}