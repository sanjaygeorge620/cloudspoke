/**************************************************************
Class Name   : Data_UserPermissionControl
Created by   : Srikanth Seela
Created Date : May 13, 2011
Modified By : 
Modified Date : 
Purpose      : Give a user permission control
***************************************************************/
@IsTest
public class Data_UserPermissionControl{


public static void createPermission(List<pse__Proj__c> prj){
     List<pse__Proj__c> projects = prj;
     List<pse__Permission_Control__c> perControlList = new List<pse__Permission_Control__c>();
     
     for(integer i=0;i<projects.size();i++){
             pse__Permission_Control__c perControl;
            //pse__Permission_Control__c perControl = new pse__Permission_Control__c();
            // perControl.pse__User__c = userInfo.getUserId();          
             //perControl.pse__Resource__c = Projects[i].Accounting_Contact__c;
            // perControl.pse__Start_Date__c = System.today();
             //perControl.pse__End_Date__c = System.today()+10;
            // perControl.pse__Staffing__c
              // = perControl.pse__Expense_Entry__c
             //  = perControl.pse__Expense_Ops_Edit__c
               //= perControl.pse__Timecard_Entry__c
               //= perControl.pse__Timecard_Ops_Edit__c
               //= perControl.pse__Billing__c
               //= perControl.pse__Invoicing__c
               //= true;
             //perControlList.add(perControl);
             
             perControl = new pse__Permission_Control__c();
             perControl.pse__User__c = userInfo.getUserId();
             perControl.pse__Project__c = projects[i].Id;
             perControl.pse__Start_Date__c = System.today();
             perControl.pse__End_Date__c = System.today()+10;
             perControl.pse__Staffing__c = perControl.pse__Expense_Entry__c;
              // = perControl.pse__Expense_Ops_Edit__c
             //  = perControl.pse__Timecard_Entry__c
             //  = perControl.pse__Timecard_Ops_Edit__c
             //  = perControl.pse__Billing__c
             //  = perControl.pse__Invoicing__c
             //  = true;
            // perControlList.add(perControl); 
             
             perControl = new pse__Permission_Control__c();
             perControl.pse__User__c = userInfo.getUserId();
             perControl.pse__Region__c = Projects[i].pse__Region__c;
             perControl.pse__Start_Date__c = System.today();
             perControl.pse__End_Date__c = System.today()+10;
             perControl.pse__Staffing__c
               = perControl.pse__Expense_Entry__c
               = perControl.pse__Expense_Ops_Edit__c
               = perControl.pse__Timecard_Entry__c
               = perControl.pse__Timecard_Ops_Edit__c
               = perControl.pse__Billing__c
               = perControl.pse__Invoicing__c
               = true;
             perControlList.add(perControl);                  
       }
        insert perControlList;
        System.debug('Permission Controls :'+perControlList);
 } 
static testMethod void testUserPermissionControl(){
    
    List<pse__Proj__c> project = Data_Project.createProject(1);
    
    Data_UserPermissionControl.createPermission(project);    
 }        
}