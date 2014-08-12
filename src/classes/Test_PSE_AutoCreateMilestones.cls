/***************************************************************************
Class Name   : Test_PSE_AutoCreateMilestones
Created by   : Jennifer Dauernheim
Created Date : May 21, 2012
Purpose      : Test Class for Trigger PSE_AutoCreateMilesStoneMilestones
*****************************************************************************/
@isTest(Seealldata=true)
private class Test_PSE_AutoCreateMilestones 
{
    static ID userId ;
    static  Date todayDate ;
    
    static testMethod void testTrigger() {

        userId = UserInfo.getUserId();
        todayDate = Date.today();
        
         Account acc = Data_Account.createAccount();
      List<Contact> contacts = Data_Contact.createContacts(acc.Id,3);
      
      
      
        pse__Region__c pse_region = Data_PSE_Region.createRegion(); 
     system.assert(pse_region.Id != null);
        
     //Insert Practice
     pse__Practice__c pse_practice = Data_PSE_Practice.createPractice();
     system.assert(pse_practice.Id != null);
     
      Test.StartTest();

      List<pse__Proj__c> Projects2 = Data_Project.createProjects(1,Acc,contacts,pse_region,pse_practice);       
      System.assertEquals(Projects2.size(),1); 
             
        /* set the billing_type to 'Fixed Price' to fire the update trigger that creates Milestones and Misc. Adjustments */     
        for(pse__Proj__c proj1 : projects2)
        {
         proj1.pse__Billing_Type__c = 'T&M/Fixed';
        }    
        update projects2;        
         
        Test.stopTest();
    }
}