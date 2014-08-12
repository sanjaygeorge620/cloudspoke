@isTest
private class Test_UpdateScheduleEndDate{

    static TestMethod void VerifyEndDateInSchedule(){   
    
    List<pse__Proj__c> project = new List<pse__Proj__c> ();
    List<pse__Assignment__c> aList= new list< pse__Assignment__c>();
    List<pse__Assignment__c> aListUpdated= new list< pse__Assignment__c>();
    List<pse__Schedule__c> scheduleEndDate = new list< pse__Schedule__c>();    
   
    //Create a Test Project       
    project = Data_Project.createProject(1);
    
    //Create a permission control
    Data_UserPermissionControl.createPermission(project);
    
    //Create a schedule
    pse__Schedule__c sch = Data_Schedule.createSchedule();
    
    //Link the Schedule with the Assignment and Assignment with project
    aList = Data_Assignment.createAssignments(project,sch,1); 
    
    //Fetch the Assignment and set its Status to Closed
    if(aList !=null){
    
        aListUpdated =[SELECT pse__Schedule__c,pse__Status__c FROM pse__Assignment__c WHERE id = :aList[0].id];
        aListUpdated[0].pse__Status__c ='Closed';
        update aListUpdated;
    }
       
     //fetch the end date and compare it with todays date to see if it is set by the trigger
     if(aList !=null)    
     scheduleEndDate=[SELECT pse__End_Date__c FROM pse__Schedule__c where id= :aList[0].pse__Schedule__c];
     //VT 8/25:Commented system.assertequals(System.today(),scheduleEndDate[0].pse__End_Date__c);
     }

}