@isTest(seeAllData=true)
private class Test_PopulateBillingItem  {

static testMethod void testPopulateBillingItem (){
    
    
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    User u = new User(Alias = 'stand', Email='standarduser@lexmark.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', EmployeeNumber = '1234',
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='teststandarduser1248@lexmark.com', LX_Region__c= 'NE', LX_Ability_to_Create_Accounts__c = 'Yes',Legacy_Company__c='Lexmark');

    //Testing as a standard user.

    System.runAs(u) {
    
       List<String> stagesList = new List<String>();
       stagesList.add('Closed Won');
       List<Opportunity> oppty = new List<Opportunity>();
       oppty = Data_Opportunity.createOpportunity(stagesList,1);
       Test.startTest();
       List<pse__Proj__c> proj = new List<pse__Proj__c>();      
       proj = Data_Project.createProject(1);
       PopulateBillingItem.createBillingItem(oppty,oppty[0],proj[0]);
      
      }
        
        Test.stopTest();
    }
}