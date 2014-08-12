@istest(seealldata=true)

private class LX_Test_CommonUtilities{

    public static testmethod void m1 () {
    
        try{
            Account acc = new Account();
            insert acc;
        }
        catch(Exception e){
            LX_CommonUtilities.createExceptionLog(e);
            LX_CommonUtilities.createExceptionLog(e+'');
        }
        
        LX_CommonUtilities.GetRecordTypeId('Expansion-Add On');
        
        
        RecordType rec = [Select id from Recordtype where name='Database Services' and SobjecttYpe='pse__Proj__c'];
        pse__Proj__c proj = new pse__Proj__c();
        proj.recordtypeId = rec.Id;
        proj.Name = 'test';
        proj.CurrencyIsoCode= 'USD';
        proj.LX_Region__c = 'data';
        proj.LX_Practice__c='testing';
        proj.LX_Group__c = 'grouping';
        insert proj;
        
        Account acc = Data_Account.createAccount();
        List<Contact> contacts = Data_Contact.createContacts(acc.Id,1); 
        
        
        Profile adminProfile = [select id from profile where name= 'System Administrator']; 
        User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = adminProfile.Id,Legacy_Company__c = 'Lexmark', 
        timezonesidkey='America/Los_Angeles', username='sastasandasarasduasser@testorgasdf1.com',LX_Region__c = 'NE');
        Insert adminUser;
        
        LX_CommonUtilities.createPermissionCont(new set<id>{contacts[0].id},new set<Id>{proj.id},adminUser.Id);
    }


}