@isTest
private class Test_SetAssignmentStatus{

    static TestMethod void VerifyAssignmentStatus(){
 /*       List<pse__proj__c> prjList = new List<pse__proj__c>();
        List<pse__proj__c> prjList_updated = new List<pse__proj__c>();
        List<pse__Assignment__c> aList = new List<pse__Assignment__c>();
         
        prjList = Data_Project.createProject(1);
        
        System.debug('Project created are: '+prjList);
        
        Data_UserPermissionControl.createPermission(prjList);
        
        pse__Schedule__c sch = Data_Schedule.createSchedule();
        System.debug('Schedule created: '+sch);
        
        aList= Data_Assignment.createAssignments(prjList,sch,1);
        System.debug('Assignmets created for the project(s): '+aList);        

        PrjList_updated = [select id from pse__Proj__c where id = :prjList[0].id];
        PrjList_updated[0].pse__Project_Phase__c = 'Void';
        update PrjList_updated;
        
        System.debug('Before new assignments in aList: '+aList);
        aList=[SELECT pse__Status__c,id FROM pse__Assignment__c where pse__project__c =:prjList[0].id];
        System.debug('After new assignemtns in aList: '+aList);        
        System.debug('assginment 1 status :'+aList[0].pse__Status__c);        
        
        update aList;
               
        For(pse__Assignment__c a:aList)
        system.assertequals(a.pse__Status__c,'Closed');       
  */   
    }
}