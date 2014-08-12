/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_SetConversionDateOnOpp {

    static testMethod void testTriggerSetConverstionDateOpp() {
  //add account record
        User u = [Select id from User where isActive=true and Profile.name='System Administrator' limit 1];
        Account acctRec = new Account();
        acctRec.Name = 'testAccount';
        acctRec.Sector__c = 'State/Local';
        acctRec.Type = 'Customer';
        acctRec.BillingCountry = 'India';
        acctRec.Physical_Country__c = 'India' ;
        insert acctRec;

//get Acct to add value to account rec
        Account acct = [select id, name from Account where id = :acctRec.id limit 1];
        List<Contact> conlst = new List<Contact>();
//add contact record
        Contact contactRec = new Contact();
        contactRec.LastName = 'TestingLastName';
        contactRec.FirstName = 'TestingFirstName';
        contactRec.Region__c = 'NA';
        contactRec.Contact_Role__c = 'User';
        contactRec.License_Contact__c=true;
        contactRec.Email = 'testing@acme.com';
        contactRec.AccountId = acct.id;
         insert contactRec;  
        conlst.add(contactRec);
//get Campaign record
       Campaign campRec = Data_Campaign.createCampaign('Parent Campaign', '');  
       
//get recordtype for opportunity
       RecordType OppRecType = [select id, name from RecordType where sObjectType = 'Opportunity' and name = 'Expansion-Add On'];    
       
//get closedate so always in the future    
    Date test_CloseDate = system.today().addDays(3);
    
//create a map for a few new opportunities
    List<Opportunity> newOppMap = new list<Opportunity>();    

          System.runAs(u){
       
     Test.startTest();
        String [] stageList = new List<String>();
        stageList.add('Closed Won');
        stageList.add('Negotiation');
        stageList.add('Validation');
        stageList.add('Proposal');
        stageList.add('Presentation');
        List<Opportunity> test_opportunities = Data_Opportunity.createOpportunity3(stageList, 5,acct,conlst);   
   Test.stopTest();
        set<ID> oppsetID = new set<id>();
        for (Opportunity opp : test_Opportunities){
            oppsetID.add(opp.id);
        }
    
        List <Opportunity> insertedOpportunities = ([Select id, StageName, Name, Date_Qualification_Conv__c, Date_Presentation_Conversion__c,
                        Date_Proposal_Conv__c,Date_Validation_Conversion__c, Date_Negotiation_Conv__c, CloseDate from Opportunity where id in:oppsetID]);
        
        
    
        for (Opportunity newOppRec : insertedOpportunities) {
            if (newOppRec.Name == 'Presentation'){
               // system.assertEquals(newOppRec.Date_Presentation_Conversion__c, newOppRec.Date_Qualification_Conv__c);
            }
            if (newOppRec.Name == 'Proposal'){
               // system.assertEquals(newOppRec.Date_Proposal_Conv__c, newOppRec.Date_Presentation_Conversion__c);
            }
            
        }
        } 
    }
}