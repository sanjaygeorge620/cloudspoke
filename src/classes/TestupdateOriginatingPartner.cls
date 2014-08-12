@istest(seeAllData=true)
public class TestupdateOriginatingPartner
{
    public static testMethod void TestupdateOriginatingPartner()
    {
    
   
        Profile profile = [select id from profile where name LIKE '%Administrator%' limit 1];
        
        String userName= 'userName@test.com';
        User Objuser = new User(alias = 'standt', email='standarduser@lexmark.com',
                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                        localesidkey='en_US',profileId = profile.Id,                        
                        timezonesidkey='America/Los_Angeles', username=userName, LX_Region__c = 'NE',
                        Legacy_Company__c = 'Lexmark');
        
        insert Objuser;
        //comment by arun

        Id AccountRecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
        //Account.sObjectType.getDescribe().getRecordTypeInfosByName().get('Location Partner').getRecordTypeId();
    
        Account acnt = new Account(Name='Test Account Name', Phone='1222', Type='Prospect', RecordTypeId =AccountRecordTypeId,Physical_Country__c = 'USA', BillingCountry = 'USA');
        insert acnt;
        
        
        Account thisAccount = new Account(Name='Test Account Name1', Phone='5555555', Type='Prospect',RecordTypeId =AccountRecordTypeId, Physical_Country__c = 'USA', BillingCountry = 'USA');
        insert thisAccount;
        //VT:changed record type from 'Additional Services' to 'Expansion-Add On'
        RecordType oppRecType= [Select  r.Name, r.Id From RecordType r where r.SobjectType ='Opportunity' and  r.Name = 'Expansion-Add On'];
        //Opportunity opp = new Opportunity(StageName = 'Closed Won' ,RecordTypeId = oppRecType.Id,Primary_Partner__c = acnt.id, CloseDate = System.today(),Sector__c ='Cross Industry',Amount = 1222.0, Name = 'opportunityName', AccountId = thisAccount.id);
        Opportunity opp = new Opportunity(StageName = 'Qualifying' ,RecordTypeId = oppRecType.Id,Primary_Partner__c = acnt.id, CloseDate = System.today(),Sector__c ='Cross Industry',Amount = 1222.0, Name = 'opportunityName', AccountId = thisAccount.id,technology__c = true, LX_Sales_Type__c ='Channel');
        
        insert opp;
        thisAccount.Type ='Customer';
        update thisAccount;
      //  User u = [select id from User where id=:UserInfo.getUserId()];
        
        Account acc = [Select Id,Originating_Partner__c From Account where Id =: thisAccount.Id];
        //system.assertEquals(acc.Originating_Partner__c,acnt.Id);
        
    }
}