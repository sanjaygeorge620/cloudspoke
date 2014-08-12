/**********************************************************************************************

Name : Test_SetAccountType_Customer

Purpose : gives test coverage for SetAccountType_Customer

author : Jennifer Dauernheim

Date : July 15, 2009

************************************************************************************************/

@isTest

Private class Test_SetAccountType_Customer {

    /*
    @isTest

    static void testTriggerSetAccountType() {

    /

       create records for processing 

    /

        

    //add account record

        Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Sector__c = 'State/Local';
        acctRec.Type = 'Prospect';
        insert acctRec;

   //get Acct to add value to account rec
        Account acct = [select id, name from Account where id = :acctRec.id limit 1];
        
   //add contact record
      //add contact record
        Contact contactRec = new Contact();
        contactRec.LastName = 'TestingLastName';
        contactRec.FirstName = 'TestingFirstName';
        contactRec.Region__c = 'NA';
        contactRec.Contact_Role__c = 'User';
        contactRec.Email = 'testing@acme.com';
        contactRec.AccountId = acct.id;
         insert contactRec;     
        
   //get Campaign record
        Campaign campRec = [select id, name from Campaign limit 1]; 
        
   //get recordtype
        RecordType OppRecType = [select id, name from RecordType where sObjectType = 'Opportunity' and name = 'Expansion-Add On'];      
        
   //get closedate so always in the future    
    Date test_CloseDate = system.today().addDays(3);

    //add Opportunity Record
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'Testing Customer';
        oppRec.AccountID = acct.id;
        oppRec.Type = 'Expansion-Add On';
        oppRec.Sector__c = 'Federal';
        oppRec.CampaignID = campRec.id;
        oppRec.CloseDate = test_CloseDate;
        oppRec.Amount = 100.00;
        oppRec.StageName = 'Closed Won';
        OppRec.RecordTypeId = OppRecType.Id;
        OppRec.Partner_Referral_Fee_Applicable__c = 'No Partner Fee';
        OppRec.Primary_Competitor__c = 'Unknown';
        OppRec.Competitor_Installs__c = 'Testing';
        OppRec.CurrencyISOCode = 'USD';
        OppRec.License_Contact__c = contactRec.id;
        OppRec.Invoice_Contact__c = contactRec.id;
        OppRec.Top_3_Reason_for_Win__c = 'Testing';
        insert OppRec;

    /
        test records      
    /

    system.assertEquals('Customer',
        [select Type from Account where ID = :acct.ID limit 1].Type);

    }
*/
}