/*********************************************************************************
Name : LX_JavascriptRegroupProducts
Created By : Sumedha(Deloitte Offshore)
Created Date : 02-06-2014
Usages : Testclass for class LX_JavascriptRegroupProducts
*********************************************************************************/ 
@isTest(seeAllData=true)
private class LX_Test_LX_JavascriptRegroupProducts {
 static testMethod void testreGroup(){
        //Id accId = createAccount();
        Account acc = Data_Account.createAccount();
        id accid = acc.id;
        //create opportunity and relavant records for test
        List<Opportunity> opportunities = createOpportunities1(accId,2); 
        LX_JavascriptRegroupProducts.reGrouping(opportunities[0].id);
     	MPS_EmailAlert.MPSTask(opportunities[0].id);
 } 
 static List<Opportunity> createOpportunities1(Id accId,Integer size){
        
        List<Contact> contacts = new List<Contact>(); 
        /*contacts.add(new Contact(LastName = 'Test',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_contact__c=true));
        contacts.add(new Contact(LastName = 'Test1',AccountId = accId,Accounting_Contact__c = true,Email = 'a@b.com', Physical_Street_Address__c = 'abc', Physical_City__c = 'abc', Address_Edit_Countries__c = 'Afghanistan', FirstName = 'abc',License_contact__c=true));
        insert contacts;*/
        contacts = Data_Contact.createContacts(accId,2);
        
        //create opportunities for test
        List<Opportunity> opportunities = new List<Opportunity> ();
        
        for(Integer i = 0 ; i < size ; i++){
            Opportunity opp =  new Opportunity();
            opp.AccountId = accId;
            opp.Name = 'newOpp';
            opp.CloseDate = Date.today().addDays(10);
            opp.StageName = 'Negotiation';
            opp.Technology__c = true;
            opp.LX_Sales_Type__c = 'Add On';
            opp.QAStatus__c = 'New';
            opp.Ship_To__c  = contacts.get(0).Id;
            opp.Bill_To__c  = contacts.get(0).Id;
            opportunities.add(opp);
        }        
        insert opportunities;
        return opportunities;
    }
}