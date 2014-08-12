@isTest
public class LX_Test_leadConvertTaskRemCompCtrl{
   
    static testMethod void insertNewTask() {
       
           
    Task taskToCreate = new Task();
     
    LIST<User> Owners = [SELECT ID from User where Name = 'Lakshmi Sheshadri'];
      
    taskToCreate.Subject = 'Email';
    taskToCreate.OwnerId  = Owners.get(0).Id ;
    taskToCreate.Status = 'In Progress';    
    taskToCreate.Priority = 'High';
    //taskId.IsReminderSet = true;
    test.startTest();
    insert taskToCreate;
  
        
    string taskId = taskToCreate.Id;         
    leadConvertTaskRemindComponentController a = new leadConvertTaskRemindComponentController();
    System.Debug(a.taskId);
        
  leadConvertTaskRemindComponentController b = new leadConvertTaskRemindComponentController();
        System.Debug(b.ReminderTimeOption);

       leadConvertTaskRemindComponentController c = new leadConvertTaskRemindComponentController();
        System.Debug(c.reminderTime);
         
        leadConvertTaskRemindComponentController d= new leadConvertTaskRemindComponentController();
        System.debug(d.disabledActivityDate);
      test.stopTest();
}

}