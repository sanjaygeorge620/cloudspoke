/**
* test class for CreateCRRecordFromProject
*/
@isTest
private class Test_CreateCRRecordFromProject {

Public Static List<pse__Proj__c> Projects = Data_Project.createProject(1); 

    static testMethod void testCreateChangeRequest() {
    
  Test.Starttest();
        
         pse__Proj__c testProject = Projects[0]; //createProject(testRegion.id,testPractice.id,testAccount.id,opportunity.id);
         CreateCRRecordFromProject ccrRecordFromProject = new CreateCRRecordFromProject(new ApexPages.Standardcontroller(testProject));
         ccrRecordFromProject.opportunity.StageName = 'Qualification';
         ccrRecordFromProject.budget.pse__Amount__c = 1000;
         ccrRecordFromProject.opportunity.Amount = 900;
         System.assertEquals(ccrRecordFromProject.getBudgetTypes().size(),4);
         ccrRecordFromProject.budget.pse__Type__c = 'Internal Budget';
         ccrRecordFromProject.Create();
         ccrRecordFromProject.opportunity.pse__Practice__c = testProject.pse__Practice__c; //testPractice.id;
         ccrRecordFromProject.opportunity.pse__Region__c = testProject.pse__Region__c;  //testRegion.id;
         ccrRecordFromProject.opportunity.Amount = 2000;
         ccrRecordFromProject.Create();
         List<Opportunity>  oppLists =  [select Id,Name from opportunity where pse__parent_Opportunity__c = :testProject.pse__Opportunity__c];//opportunity.id ];
         //system.assertEquals(oppLists.size(),1);
         ccrRecordFromProject.cancel();
         System.Debug('Check3' +Limits.GetQueries());
       Test.Stoptest(); 
    }
    
}