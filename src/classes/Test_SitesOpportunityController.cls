/* test class for SitesOpportunityController*/
@isTest(seeAlldata=true)
private class Test_SitesOpportunityController{
   
    static testMethod void testSitesOpptyCon(){
    
         Profile adminProfile = [select id from profile where name = 'System Administrator' limit 1]; 
         User adminUser = new User(alias = 'standt', email='cstandarduser@lexmark.com', 
         emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
         localesidkey='en_US', profileid = adminProfile.Id, 
         timezonesidkey='America/Los_Angeles', username='stsdadndarduser@testorg1.com',
         LX_Region__C='NE',Legacy_Company__c = 'Acuo');
         Insert adminUser;
         Order__c testOrder = new Order__C();
         List<String> stageList = new List<String>();
         stageList.add('Negotiation');
         stageList.add('Negotiation');
         
         
        system.runas(adminUser)
    { 
        SitesOpportunityController siteOpptyCon = new SitesOpportunityController();
        
         siteOpptyCon.Site_Account = Data_account.createAccount();
         List<Opportunity> opptyList = Data_Opportunity.createOpportunity(stageList,2);
         opptyList[0].Primary_Partner__c = siteOpptyCon.Site_Account.Id;
         update opptyList[0];
         testOrder.Opportunity__c = opptyList[0].id;
         //testOrder.Opportunity__r.Primary_Partner__c = siteOpptyCon.Site_Account.Id;
         insert testOrder;
         test.starttest();
         list<Order__c> testOrderList = siteOpptyCon.getOpportunities('Pipeline');
         //Order__c ordTest = 

        try{
                siteOpptyCon.getOpportunityDetails();
                siteOpptyCon.getOpportunityLineItems();
                }
                catch(exception e){}
                try{
                //siteOpptyCon.getOpportunityDetails();
                // Rahul commented
                siteOpptyCon.getOpportunityLineItems();
                siteOpptyCon.getOppty_pipeline();
                siteOpptyCon.getOppty_BestCase();
                siteOpptyCon.getOppty_Commit();
                siteOpptyCon.getOppty_Closed();
                siteOpptyCon.getOppty_Omitted();
               
               
                }
                catch(exception e){}
                try{
                siteOpptyCon.editOpp();
                }
                catch(exception e){}
                try{
                 siteOpptyCon.SubmitOpp();
                }
                catch(exception e){}
       // siteOpptyCon.editOpp();
        
         test.stoptest();
    }
}
}